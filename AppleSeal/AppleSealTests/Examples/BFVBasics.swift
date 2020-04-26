//
//  BFVBasics.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-04-23.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class BFVBasics: XCTestCase {
    func testBasic() throws {
        print("Example: BFV Basics")
        
        /*
         In this example, we demonstrate performing simple computations (a polynomial
         evaluation) on encrypted integers using the BFV encryption scheme.
         
         The first task is to set up an instance of the EncryptionParameters class.
         It is critical to understand how the different parameters behave, how they
         affect the encryption scheme, performance, and the security level. There are
         three encryption parameters that are necessary to set:
         
         - PolyModulusDegree (degree of polynomial modulus)
         - CoeffModulus ([ciphertext] coefficient modulus)
         - PlainModulus (plaintext modulus only for the BFV scheme).
         
         The BFV scheme cannot perform arbitrary computations on encrypted data.
         Instead, each ciphertext has a specific quantity called the `invariant noise
         budget' -- or `noise budget' for short -- measured in bits. The noise budget
         in a freshly encrypted ciphertext (initial noise budget) is determined by
         the encryption parameters. Homomorphic operations consume the noise budget
         at a rate also determined by the encryption parameters. In BFV the two basic
         operations allowed on encrypted data are additions and multiplications, of
         which additions can generally be thought of as being nearly free in terms of
         noise budget consumption compared to multiplications. Since noise budget
         consumption compounds in sequential multiplications, the most significant
         factor in choosing appropriate encryption parameters is the multiplicative
         depth of the arithmetic circuit that the user wants to evaluate on encrypted
         data. Once the noise budget of a ciphertext reaches zero it becomes too
         corrupted to be decrypted. Thus, it is essential to choose the parameters to
         be large enough to support the desired computation otherwise the result is
         impossible to make sense of even with the secret key.
         */
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        
        /*
         The first parameter we set is the degree of the `polynomial modulus'. This
         must be a positive power of 2, representing the degree of a power-of-two
         cyclotomic polynomial it is not necessary to understand what this means.
         
         Larger PolyModulusDegree makes ciphertext sizes larger and all operations
         slower, but enables more complicated encrypted computations. Recommended
         values are 1024, 2048, 4096, 8192, 16384, 32768, but it is also possible
         to go beyond this range.
         
         In this example we use a relatively small polynomial modulus. Anything
         smaller than this will enable only very restricted encrypted computations.
         */
        let polyModulusDegree = 4096
        try parms.setPolynomialModulusDegree(polyModulusDegree)
        
        /*
         Next we set the [ciphertext] `coefficient modulus' (CoeffModulus). This
         parameter is a large integer, which is a product of distinct prime numbers,
         numbers, each represented by an instance of the SmallModulus class. The
         bit-length of CoeffModulus means the sum of the bit-lengths of its prime
         factors.
         
         A larger CoeffModulus implies a larger noise budget, hence more encrypted
         computation capabilities. However, an upper bound for the total bit-length
         of the CoeffModulus is determined by the PolyModulusDegree, as follows:
         
         +----------------------------------------------------+
         | PolyModulusDegree   | max CoeffModulus bit-length  |
         +---------------------+------------------------------+
         | 1024                | 27                           |
         | 2048                | 54                           |
         | 4096                | 109                          |
         | 8192                | 218                          |
         | 16384               | 438                          |
         | 32768               | 881                          |
         +---------------------+------------------------------+
         
         These numbers can also be found in native/src/seal/util/hestdparms.h encoded
         in the function SEAL_HE_STD_PARMS_128_TC, and can also be obtained from the
         function
         
         CoeffModulus.MaxBitCount(polyModulusDegree).
         
         For example, if PolyModulusDegree is 4096, the coeff_modulus could consist
         of three 36-bit primes (108 bits).
         
         Microsoft SEAL comes with helper functions for selecting the CoeffModulus.
         For new users the easiest way is to simply use
         
         CoeffModulus.BFVDefault(polyModulusDegree),
         
         which returns NSArray<ASLSmallModulus *> consisting of a generally good choice
         for the given PolyModulusDegree.
         */
        try parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        
        /*
         The plaintext modulus can be any positive integer, even though here we take
         it to be a power of two. In fact, in many cases one might instead want it
         to be a prime number we will see this in later examples. The plaintext
         modulus determines the size of the plaintext data type and the consumption
         of noise budget in multiplications. Thus, it is essential to try to keep the
         plaintext data type as small as possible for best performance. The noise
         budget in a freshly encrypted ciphertext is
         
         ~ log2(CoeffModulus/PlainModulus) (bits)
         
         and the noise budget consumption in a homomorphic multiplication is of the
         form log2(PlainModulus) + (other terms).
         
         The plaintext modulus is specific to the BFV scheme, and cannot be set when
         using the CKKS scheme.
         */
        try parms.setPlainModulus(ASLSmallModulus(value: 1024))
        
        /*
         Now that all parameters are set, we are ready to construct a SEALContext
         object. This is a heavy class that checks the validity and properties of the
         parameters we just set.
         */
        let context = try ASLSealContext(parms)
        
        /*
         Print the parameters that we have chosen.
         */
        print()
        print("Set encryption parameters and print")
        // TODO - add custom string convertable here
        print(context)
        
        print()
        print("~~~~~~ A naive way to calculate 4(x^2+1)(x+1)^2. ~~~~~~")
        
        /*
         The encryption schemes in Microsoft SEAL are public key encryption schemes.
         For users unfamiliar with this terminology, a public key encryption scheme
         has a separate public key for encrypting data, and a separate secret key for
         decrypting data. This way multiple parties can encrypt data using the same
         shared public key, but only the proper recipient of the data can decrypt it
         with the secret key.
         
         We are now ready to generate the secret and public keys. For this purpose
         we need an instance of the KeyGenerator class. Constructing a KeyGenerator
         automatically generates the public and secret key, which can immediately be
         read to local variables.
         */
        let keygen = try ASLKeyGenerator(context: context)
        let publicKey = keygen.publicKey
        let secretKey = keygen.secretKey
        
        /*
         To be able to encrypt we need to construct an instance of Encryptor. Note
         that the Encryptor only requires the public key, as expected.
         */
        let encryptor = try ASLEncryptor(context: context, publicKey: publicKey)
        
        /*
         Computations on the ciphertexts are performed with the Evaluator class. In
         a real use-case the Evaluator would not be constructed by the same party
         that holds the secret key.
         */
        let evaluator = try ASLEvaluator(context)
        
        /*
         We will of course want to decrypt our results to verify that everything worked,
         so we need to also construct an instance of Decryptor. Note that the Decryptor
         requires the secret key.
         */
        let decryptor = try ASLDecryptor(context: context, secretKey: secretKey)
        
        /*
         As an example, we evaluate the degree 4 polynomial
         
         4x^4 + 8x^3 + 8x^2 + 8x + 4
         
         over an encrypted x = 6. The coefficients of the polynomial can be considered
         as plaintext inputs, as we will see below. The computation is done modulo the
         plain_modulus 1024.
         
         While this examples is simple and easy to understand, it does not have much
         practical value. In later examples we will demonstrate how to compute more
         efficiently on encrypted integers and real or complex numbers.
         
         Plaintexts in the BFV scheme are polynomials of degree less than the degree
         of the polynomial modulus, and coefficients integers modulo the plaintext
         modulus. For readers with background in ring theory, the plaintext space is
         the polynomial quotient ring Z_T[X]/(X^N + 1), where N is PolyModulusDegree
         and T is PlainModulus.
         
         To get started, we create a plaintext containing the constant 6. For the
         plaintext element we use a constructor that takes the desired polynomial as
         a string with coefficients represented as hexadecimal numbers.
         */
        print()
        let x = 6
        let xPlain = try ASLPlainText(polynomialString: "\(x)")
        print("Express x = {\(x)} as a plaintext polynomial 0x{\(xPlain)}.")
        
        /*
         We then encrypt the plaintext, producing a ciphertext.
         */
        print()
        let xEncrypted = ASLCipherText()
        print("Encrypt xPlain to xEncrypted.")
        try encryptor.encrypt(with: xPlain, cipherText: xEncrypted)
        
        /*
         In Microsoft SEAL, a valid ciphertext consists of two or more polynomials
         whose coefficients are integers modulo the product of the primes in the
         coeff_modulus. The number of polynomials in a ciphertext is called its `size'
         and is given by Ciphertext.Size. A freshly encrypted ciphertext always has
         size 2.
         */
        print("    + size of freshly encrypted x: {\(xEncrypted.size)}")
        
        /*
         There is plenty of noise budget left in this freshly encrypted ciphertext.
         */
        print("    + noise budget in freshly encrypted x: {\(try decryptor.invariantNoiseBudget(xEncrypted))} bits")
        
        /*
         We decrypt the ciphertext and print the resulting plaintext in order to
         demonstrate correctness of the encryption.
         */
        let xDecrypted = ASLPlainText()
        print("    + decryption of encrypted_x: \(try decryptor.decrypt(xEncrypted, destination: xDecrypted)) 0x{\(xDecrypted)} ...... Correct.")
        
        /*
         When using Microsoft SEAL, it is typically advantageous to compute in a way
         that minimizes the longest chain of sequential multiplications. In other
         words, encrypted computations are best evaluated in a way that minimizes
         the multiplicative depth of the computation, because the total noise budget
         consumption is proportional to the multiplicative depth. For example, for
         our example computation it is advantageous to factorize the polynomial as
         
         4x^4 + 8x^3 + 8x^2 + 8x + 4 = 4(x + 1)^2 * (x^2 + 1)
         
         to obtain a simple depth 2 representation. Thus, we compute (x + 1)^2 and
         (x^2 + 1) separately, before multiplying them, and multiplying by 4.
         
         First, we compute x^2 and add a plaintext "1". We can clearly see from the
         print-out that multiplication has consumed a lot of noise budget. The user
         can vary the plain_modulus parameter to see its effect on the rate of noise
         budget consumption.
         */
        print()
        print("Compute xSqPlusOne (x^2+1).")
        let xSqPlusOne = ASLCipherText()
        try evaluator.square(xEncrypted, destination: xSqPlusOne)
        let plainOne = try ASLPlainText(polynomialString: "1")
        try evaluator.addPlainInplace(xSqPlusOne, plain: plainOne)
        
        /*
         Encrypted multiplication results in the output ciphertext growing in size.
         More precisely, if the input ciphertexts have size M and N, then the output
         ciphertext after homomorphic multiplication will have size M+N-1. In this
         case we perform a squaring, and observe both size growth and noise budget
         consumption.
         */
        print("    + size of xSqPlusOne: {\(xSqPlusOne.size)}")
        print("    + noise budget in xSqPlusOne: {\(try decryptor.invariantNoiseBudget(xSqPlusOne))} bits")
        
        /*
         Even though the size has grown, decryption works as usual as long as noise
         budget has not reached 0.
         */
        let decryptedResult = ASLPlainText()
        print("    + decryption of xSqPlusOne: ")
        try decryptor.decrypt(xSqPlusOne, destination: decryptedResult)
        print("0x{\(decryptedResult)} ...... Correct.")
        
        /*
         Next, we compute (x + 1)^2.
         */
        print()
        print("Compute xPlusOneSq ((x+1)^2).")
        let xPlusOneSq = ASLCipherText()
        try evaluator.addPlain(xEncrypted, plain: plainOne, destination: xPlusOneSq)
        try evaluator.squareInplace(xPlusOneSq)
        print("    + size of xPlusOneSq: {xPlusOneSq.Size}")
        print("    + noise budget in xPlusOneSq: {0} bits",
              try decryptor.invariantNoiseBudget(xPlusOneSq))
        print("    + decryption of xPlusOneSq: ")
        try decryptor.decrypt(xPlusOneSq, destination: decryptedResult)
        print("0x{\(decryptedResult)} ...... Correct.")
        
        /*
         Finally, we multiply (x^2 + 1) * (x + 1)^2 * 4.
         */
        print()
        print("Compute encryptedResult (4(x^2+1)(x+1)^2).")
        let encryptedResult = ASLCipherText()
        let plainFour = try ASLPlainText(polynomialString: "4")
        try evaluator.multiplyPlainInplace(xSqPlusOne, plain: plainFour)
        try evaluator.multiply(xSqPlusOne, encrypted2: xPlusOneSq, destination: encryptedResult)
        print("    + size of encrypted_result: {\(encryptedResult.size)}")
        print("    + noise budget in encrypted_result: {\(try decryptor.invariantNoiseBudget(encryptedResult)))} bits")
        print("NOTE: Decryption can be incorrect if noise budget is zero.")
        
        print()
        print("~~~~~~ A better way to calculate 4(x^2+1)(x+1)^2. ~~~~~~")
        
        /*
         Noise budget has reached 0, which means that decryption cannot be expected
         to give the correct result. This is because both ciphertexts xSqPlusOne and
         xPlusOneSq consist of 3 polynomials due to the previous squaring operations,
         and homomorphic operations on large ciphertexts consume much more noise budget
         than computations on small ciphertexts. Computing on smaller ciphertexts is
         also computationally significantly cheaper.
         
         `Relinearization' is an operation that reduces the size of a ciphertext after
         multiplication back to the initial size, 2. Thus, relinearizing one or both
         input ciphertexts before the next multiplication can have a huge positive
         impact on both noise growth and performance, even though relinearization has
         a significant computational cost itself. It is only possible to relinearize
         size 3 ciphertexts down to size 2, so often the user would want to relinearize
         after each multiplication to keep the ciphertext sizes at 2.
         
         Relinearization requires special `relinearization keys', which can be thought
         of as a kind of public key. Relinearization keys can easily be created with
         the KeyGenerator.
         
         Relinearization is used similarly in both the BFV and the CKKS schemes, but
         in this example we continue using BFV. We repeat our computation from before,
         but this time relinearize after every multiplication.
         
         We use KeyGenerator.RelinKeys() to create relinearization keys.
         */
        print()
        print("Generate relinearization keys.")
        let relinKeys = try keygen.relinearizationKeys()
        
        /*
         We now repeat the computation relinearizing after each multiplication.
         */
        print()
        print("Compute and relinearize xSquared (x^2) then compute xSqPlusOne (x^2+1)")
        let xSquared = ASLCipherText()
        try evaluator.square(xEncrypted, destination: xSquared)
        print("    + size of xSquared: {\(xSquared.size)}")
        try evaluator.relinearizeInplace(xSquared, relinearizationKeys: relinKeys)
        print("    + size of xSquared (after relinearization): {\(xSquared.size)}")
        try evaluator.addPlain(xSquared, plain: plainOne, destination: xSqPlusOne)
        print("    + noise budget in xSqPlusOne: {\(try decryptor.invariantNoiseBudget(xSqPlusOne))} bits")
        print("    + decryption of xSqPlusOne: ")
        try decryptor.decrypt(xSqPlusOne, destination: decryptedResult)
        print("0x{\(decryptedResult)} ...... Correct.")
        
        print()
        let xPlusOne = ASLCipherText()
        print("Compute xPlusOne (x+1), 12 then compute and relinearize xPlusOneSq ((x+1)^2).")
        try evaluator.addPlain(xEncrypted, plain: plainOne, destination: xPlusOne)
        try evaluator.square(xPlusOne, destination: xPlusOneSq)
        print("    + size of xPlusOneSq: {\(xPlusOneSq.size)}")
        try evaluator.relinearizeInplace(xPlusOneSq, relinearizationKeys: relinKeys)
        print("    + noise budget in xPlusOneSq: {\(try decryptor.invariantNoiseBudget(xPlusOneSq))} bits")
        print("    + decryption of xPlusOneSq: ")
        try decryptor.decrypt(xPlusOneSq, destination: decryptedResult)
        print("0x{\(decryptedResult)} ...... Correct.")
        
        print()
        print("Compute and relinearize encryptedResult (4(x^2+1)(x+1)^2).")
        try evaluator.multiplyPlainInplace(xSqPlusOne, plain: plainFour)
        try evaluator.multiply(xSqPlusOne, encrypted2: xPlusOneSq, destination: encryptedResult)
        print("    + size of encryptedResult: {\(encryptedResult.size)}")
        try evaluator.relinearizeInplace(encryptedResult, relinearizationKeys: relinKeys)
        print("    + size of encryptedResult (after relinearization): {\(encryptedResult.size)}")
        print("    + noise budget in encryptedResult: {\(try decryptor.invariantNoiseBudget(encryptedResult))} bits")
        
        print()
        print("NOTE: Notice the increase in remaining noise budget.")
        
        /*
         Relinearization clearly improved our noise consumption. We have still plenty
         of noise budget left, so we can expect the correct answer when decrypting.
         */
        print()
        print("Decrypt encrypted_result (4(x^2+1)(x+1)^2).")
        try decryptor.decrypt(encryptedResult, destination: decryptedResult)
        print("    + decryption of 4(x^2+1)(x+1)^2 = 0x{\(decryptedResult)} ...... Correct.")
        
        /*
         For x=6, 4(x^2+1)(x+1)^2 = 7252. Since the plaintext modulus is set to 1024,
         this result is computed in integers modulo 1024. Therefore the expected output
         should be 7252 % 1024 == 84, or 0x54 in hexadecimal.
         */
    }
}