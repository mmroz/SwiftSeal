//
//  Encoders.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-04-25.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class Encoders: XCTestCase {
    func testIntegerEncoder() throws {
        print("Example: Encoders / Integer Encoder")
        
        /*
         [IntegerEncoder] (For BFV scheme only)
         
         The IntegerEncoder encodes integers to BFV plaintext polynomials as follows.
         First, a binary expansion of the integer is computed. Next, a polynomial is
         created with the bits as coefficients. For example, the integer
         
         26 = 2^4 + 2^3 + 2^1
         
         is encoded as the polynomial 1x^4 + 1x^3 + 1x^1. Conversely, plaintext
         polynomials are decoded by evaluating them at x=2. For negative numbers the
         IntegerEncoder simply stores all coefficients as either 0 or -1, where -1 is
         represented by the unsigned integer PlainModulus - 1 in memory.
         
         Since encrypted computations operate on the polynomials rather than on the
         encoded integers themselves, the polynomial coefficients will grow in the
         course of such computations. For example, computing the sum of the encrypted
         encoded integer 26 with itself will result in an encrypted polynomial with
         larger coefficients: 2x^4 + 2x^3 + 2x^1. Squaring the encrypted encoded
         integer 26 results also in increased coefficients due to cross-terms, namely,
         
         (1x^4 + 1x^3 + 1x^1)^2 = 1x^8 + 2x^7 + 1x^6 + 2x^5 + 2x^4 + 1x^2
         
         further computations will quickly increase the coefficients much more.
         Decoding will still work correctly in this case (evaluating the polynomial
         at x=2), but since the coefficients of plaintext polynomials are really
         integers modulo plain_modulus, implicit reduction modulo plain_modulus may
         yield unexpected results. For example, adding 1x^4 + 1x^3 + 1x^1 to itself
         plain_modulus many times will result in the constant polynomial 0, which is
         clearly not equal to 26 * plain_modulus. It can be difficult to predict when
         such overflow will take place especially when computing several sequential
         multiplications.
         
         The IntegerEncoder is easy to understand and use for simple computations,
         and can be a good tool to experiment with for usersto Microsoft SEAL.
         However, advanced users will probably prefer more efficient approaches,
         such as the BatchEncoder or the CKKSEncoder.
         */
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        let polyModulusDegree = 4096
        try parms.setPolynomialModulusDegree(polyModulusDegree)
        try parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        
        /*
         There is no hidden logic behind our choice of the plain_modulus. The only
         thing that matters is that the plaintext polynomial coefficients will not
         exceed this value at any point during our computation otherwise the result
         will be incorrect.
         */
        try parms.setPlainModulus(ASLSmallModulus(value: 512))
        let context = try ASLSealContext(parms)
        print(context)
        print()
        
        let keygen = try ASLKeyGenerator(context: context)
        let publicKey = keygen.publicKey
        let secretKey = keygen.secretKey
        let encryptor = try ASLEncryptor(context: context, publicKey: publicKey)
        let evaluator = try ASLEvaluator(context)
        let decryptor = try ASLDecryptor(context: context, secretKey: secretKey)
        
        /*
         We create an IntegerEncoder.
         */
        let encoder = try ASLIntegerEncoder(context: context)
        
        /*
         First, we encode two integers as plaintext polynomials. Note that encoding
         is not encryption: at this point nothing is encrypted.
         */
        let value1 = Int64(5)
        let plain1 = encoder.encodeInt64Value(value1)
        print()
        print("Encode {value1: \(value1)} as polynomial {plain1: \(plain1)}")
        
        let value2 = Int64(-7)
        let plain2 = encoder.encodeInt64Value(value2)
        print()
        print("Encode {value2: \(value2)} as polynomial {plain2: \(plain2)}")
        
        /*
         Now we can encrypt the plaintext polynomials.
         */
        print()
        print("Encrypt plain1 to encrypted1 and plain2 to encrypted2.")
        let encrypted1 = try encryptor.encrypt(with: plain1, cipherText: ASLCipherText())
        var encrypted2 = try encryptor.encrypt(with: plain2, cipherText: ASLCipherText())
        print("Noise budget in encrypted1: {\(try decryptor.invariantNoiseBudget(encrypted1))} bits")
        print("Noise budget in encrypted2: {\(try decryptor.invariantNoiseBudget(encrypted2))} bits")
        
        /*
         As a simple example, we compute (-encrypted1 + encrypted2) * encrypted2.
         */
        encrypted2 = try encryptor.encrypt(with: plain2, cipherText: encrypted2)
        print()
        print("Compute encrypted_result = (-encrypted1 + encrypted2) * encrypted2.")
        var encryptedResult = try evaluator.negate(encrypted1, detination: ASLCipherText())
        encryptedResult = try evaluator.addInplace(encryptedResult, encrypted2: encrypted2)
        encryptedResult = try evaluator.multiplyInplace(encryptedResult, encrypted2: encrypted2)
        print("Noise budget in encryptedResult: {\(try decryptor.invariantNoiseBudget(encryptedResult))} bits")
        
        print()
        print("Decrypt encrypted_result to plain_result.")
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        
        /*
         Print the result plaintext polynomial. The coefficients are not even close
         to exceeding our plainModulus, 512.
         */
        print("let polynomial: {\(plainResult)}")
        
        /*
         Decode to obtain an integer result.
         */
        print()
        print("Decode plain_result. Decoded integer: {\(try encoder.decodeInt32(withPlain: plainResult))} ...... Correct.")
    }
    
    func testBatchEncoder() throws {
        print("Example: Encoders / Batch Encoder")
        
        /*
         [BatchEncoder] (For BFV scheme only)
         
         Let N denote the PolyModulusDegree and T denote the PlainModulus. Batching
         allows the BFV plaintext polynomials to be viewed as 2-by-(N/2) matrices, with
         each element an integer modulo T. In the matrix view, encrypted operations act
         element-wise on encrypted matrices, allowing the user to obtain speeds-ups of
         several orders of magnitude in fully vectorizable computations. Thus, in all
         but the simplest computations, batching should be the preferred method to use
         with BFV, and when used properly will result in implementations outperforming
         anything done with the IntegerEncoder.
         */
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        let polyModulusDegree = 8192
        try parms.setPolynomialModulusDegree(polyModulusDegree)
        try parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        
        /*
         To enable batching, we need to set the plain_modulus to be a prime number
         congruent to 1 modulo 2*PolyModulusDegree. Microsoft SEAL provides a helper
         method for finding such a prime. In this example we create a 20-bit prime
         that supports batching.
         */
        try parms.setPlainModulus(ASLPlainModulus.batching(polyModulusDegree, bitSize: 20))
        
        let context = try ASLSealContext(parms)
        print(context)
        print()
        
        /*
         We can verify that batching is indeed enabled by looking at the encryption
         parameter qualifiers created by SEALContext.
         */
        let qualifiers = context.firstContextData.qualifiers
        print("Batching enabled: {\(qualifiers.isUsingBatching)}")
        
        let keygen = try ASLKeyGenerator(context: context)
        let publicKey = keygen.publicKey
        let secretKey = keygen.secretKey
        let relinKeys = try keygen.relinearizationKeys()
        let encryptor = try ASLEncryptor(context: context, publicKey: publicKey)
        let evaluator = try ASLEvaluator(context)
        let decryptor = try ASLDecryptor(context: context, secretKey: secretKey)
        
        /*
         Batching is done through an instance of the BatchEncoder class.
         */
        let batchEncoder = try ASLBatchEncoder(context: context)
        
        /*
         The total number of batching `slots' equals the PolyModulusDegree, N, and
         these slots are organized into 2-by-(N/2) matrices that can be encrypted and
         computed on. Each slot contains an integer modulo PlainModulus.
         */
        let slotCount = batchEncoder.slotCount
        let rowSize = slotCount / 2
        print("let matrix row size: {\(rowSize)}")
        
        /*
         The matrix plaintext is simply given to BatchEncoder as a flattened vector
         of numbers. The first `rowSize' many numbers form the first row, and the
         rest form the second row. Here we create the following matrix:
         
         [ 0,  1,  2,  3,  0,  0, ...,  0 ]
         [ 4,  5,  6,  7,  0,  0, ...,  0 ]
         */
        var podMatrix: [NSNumber] = Array(repeating: 0, count: slotCount)
        podMatrix.insert(0, at: 0)
        podMatrix.insert(1, at: 1)
        podMatrix.insert(2, at: 2)
        podMatrix.insert(3, at: 3)
        podMatrix.insert(4, at: rowSize)
        podMatrix.insert(5, at: rowSize + 1)
        podMatrix.insert(6, at: rowSize + 2)
        podMatrix.insert(7, at: rowSize + 3)
        
        print("Input plaintext matrix:")
        print(podMatrix)
        
        /*
         First we use BatchEncoder to encode the matrix into a plaintext polynomial.
         */
        print()
        print("Encode plaintext matrix:")
        let plainMatrix = try batchEncoder.encode(withUnsignedValues: podMatrix, destination: ASLPlainText())
        
        /*
         We can instantly decode to verify correctness of the encoding. Note that no
         encryption or decryption has yet taken place.
         */
        var podResult: [NSNumber]  = []
        podResult = try batchEncoder.decode(with: plainMatrix, unsignedDestination: podResult)
        print("    + Decode plaintext matrix \(podResult) ...... Correct.")
        
        /*
         Next we encrypt the encoded plaintext.
         */
       
        print()
        print("Encrypt plainMatrix to encryptedMatrix.")
        var encryptedMatrix = try encryptor.encrypt(with: plainMatrix, cipherText: ASLCipherText())
        print("    + Noise budget in encryptedMatrix: {\(try decryptor.invariantNoiseBudget(encryptedMatrix))} bits")
        
        /*
         Operating on the ciphertext results in homomorphic operations being performed
         simultaneously in all 8192 slots (matrix elements). To illustrate this, we
         form another plaintext matrix
         
         [ 1,  2,  1,  2,  1,  2, ..., 2 ]
         [ 1,  2,  1,  2,  1,  2, ..., 2 ]
         
         and encode it into a plaintext.
         */
        var podMatrix2 = Array(repeating: NSNumber(0), count: slotCount)
        for i in 0..<slotCount
        {
            podMatrix2[i] = NSNumber(value: (i % 2) + 1)
        }

        let plainMatrix2 = try batchEncoder.encode(withSignedValues: podMatrix2, destination: ASLPlainText())
        print()
        print("Second input plaintext matrix: \(podMatrix2)")
        
        /*
         We now add the second (plaintext) matrix to the encrypted matrix, and square
         the sum.
         */
        print()
        print("Sum, square, and relinearize.")
        encryptedMatrix = try evaluator.addPlainInplace(encryptedMatrix, plain: plainMatrix2)
        encryptedMatrix = try evaluator.squareInplace(encryptedMatrix)
        encryptedMatrix = try evaluator.relinearizeInplace(encryptedMatrix, relinearizationKeys: relinKeys)
        
        /*
         How much noise budget do we have left?
         */
        print("    + Noise budget in result: {\(try decryptor.invariantNoiseBudget(encryptedMatrix))} bits")
        
        /*
         We decrypt and decompose the plaintext to recover the result as a matrix.
         */
       
        print()
        print("Decrypt and decode result.")
        let plainResult = try decryptor.decrypt(encryptedMatrix, destination: ASLPlainText())
        podResult = try batchEncoder.decode(with: plainResult, unsignedDestination: podResult)
        print("    + Result plaintext matrix \(podResult) ...... Correct.")
        
        /*
         Batching allows us to efficiently use the full plaintext polynomial when the
         desired encrypted computation is highly parallelizable. However, it has not
         solved the other problem mentioned in the beginning of this file: each slot
         holds only an integer modulo plain_modulus, and unless plain_modulus is very
         large, we can quickly encounter data type overflow and get unexpected results
         when integer computations are desired. Note that overflow cannot be detected
         in encrypted form. The CKKS scheme (and the CKKSEncoder) addresses the data
         type overflow issue, but at the cost of yielding only approximate results.
         */
    }
    
    func testCKKSEncoder() throws {
        print("Example: Encoders / CKKS Encoder")
        
        /*
         [CKKSEncoder] (For CKKS scheme only)
         
         In this example we demonstrate the Cheon-Kim-Kim-Song (CKKS) scheme for
         computing on encrypted real or complex numbers. We start by creating
         encryption parameters for the CKKS scheme. There are two important
         differences compared to the BFV scheme:
         
         (1) CKKS does not use the PlainModulus encryption parameter
         (2) Selecting the CoeffModulus in a specific way can be very important
         when using the CKKS scheme. We will explain this further in the file
         `CKKS_Basics.cs'. In this example we use CoeffModulus.Create to
         generate 5 40-bit prime numbers.
         */
        let parms = ASLEncryptionParameters(schemeType: .CKKS)
        
        let polyModulusDegree = 8192
        try parms.setPolynomialModulusDegree(polyModulusDegree)
        try parms.setCoefficientModulus(ASLCoefficientModulus.create(polyModulusDegree, bitSizes: [40, 40, 40, 40, 40]))
        
        /*
         We create the SEALContext as usual and print the parameters.
         */
        let context = try ASLSealContext(parms)
        print(context)
        print()
        
        /*
         Keys are created the same way as for the BFV scheme.
         */
        let keygen = try ASLKeyGenerator(context: context)
        let publicKey = keygen.publicKey
        let secretKey = keygen.secretKey
        let relinKeys = try keygen.relinearizationKeys()
        
        /*
         We also set up an Encryptor, Evaluator, and Decryptor as usual.
         */
        let encryptor = try ASLEncryptor(context: context, publicKey: publicKey)
        let evaluator = try ASLEvaluator(context)
        let decryptor = try ASLDecryptor(context: context, secretKey: secretKey)
        
        /*
         To create CKKS plaintexts we need a special encoder: there is no other way
         to create them. The IntegerEncoder and BatchEncoder cannot be used with the
         CKKS scheme. The CKKSEncoder encodes vectors of real or complex numbers into
         let objects, which can subsequently be encrypted. At a high level this
         looks a lot like what BatchEncoder does for the BFV scheme, but the theory
         behind it is completely different.
         */
        let encoder = try ASLCKKSEncoder(context: context)
        
        /*
         In CKKS the number of slots is PolyModulusDegree / 2 and each slot encodes
         one real or complex number. This should be contrasted with BatchEncoder in
         the BFV scheme, where the number of slots is equal to PolyModulusDegree
         and they are arranged into a matrix with two rows.
         */
        let slotCount = encoder.slotCount
        print("Number of slots: {\(slotCount)}")
        
        /*
         We create a small vector to encode the CKKSEncoder will implicitly pad it
         with zeros to full size (PolyModulusDegree / 2) when encoding.
         */
        let input: [NSNumber] = [0.0, 1.1, 2.2, 3.3]
        print("Input vector: ")
        print(input)
        
        /*
         Now we encode it with CKKSEncoder. The floating-point coefficients of `input'
         will be scaled up by the parameter `scale'. This is necessary since even in
         the CKKS scheme the plaintext elements are fundamentally polynomials with
         integer coefficients. It is instructive to think of the scale as determining
         the bit-precision of the encoding naturally it will affect the precision of
         the result.
         
         In CKKS the message is stored modulo CoeffModulus (in BFV it is stored modulo
         PlainModulus), so the scaled message must not get too close to the total size
         of CoeffModulus. In this case our CoeffModulus is quite large (200 bits) so
         we have little to worry about in this regard. For this simple example a 30-bit
         scale is more than enough.
         */
        let scale = Double(pow((2.0), 30))
        print()
        print("Encode input vector.")
        var plain = try encoder.encode(withDoubleValues: input, scale: scale, destination: ASLPlainText())
        
        /*
         We can instantly decode to check the correctness of encoding.
         */
        var output = try encoder.decode(plain, destination: [NSNumber]())
        print("    + Decode input vector \(output) ...... Correct.")
        
        /*
         The vector is encrypted the same was as in BFV.
         */
        print()
        print("Encrypt input vector, square, and relinearize.")
        var encrypted = try encryptor.encrypt(with: plain, cipherText: ASLCipherText())
        
        /*
         Basic operations on the ciphertexts are still easy to do. Here we square
         the ciphertext, decrypt, decode, and print the result. We note also that
         decoding returns a vector of full size (PolyModulusDegree / 2) this is
         because of the implicit zero-padding mentioned above.
         */
        encrypted = try evaluator.squareInplace(encrypted)
        encrypted = try evaluator.relinearizeInplace(encrypted, relinearizationKeys: relinKeys)
        
        /*
         We notice that the scale in the result has increased. In fact, it is now
         the square of the original scale: 2^60.
         */
        print("    + scale in squared input: {\(encrypted.scale)} ({\(log(encrypted.scale).rounded(.up))} bits)")
        print()
        print("Decrypt and decode.")
        plain = try decryptor.decrypt(encrypted, destination: plain)
        output = try encoder.decode(plain, destination: output)
        print("    + Result vector \(output) ...... Correct.")
        
        /*
         The CKKS scheme allows the scale to be reduced between encrypted computations.
         This is a fundamental and critical feature that makes CKKS very powerful and
         flexible. We will discuss it in great detail in `3_Levels.cs' and later in
         `4_CKKS_Basics.cs'.
         */
    }
}






