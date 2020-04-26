//
//  CKKSBasics.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-04-25.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class CKKSBasics: XCTestCase {
    func testExampleCKKSBasics() throws {
        print("Example: CKKS Basics")
        
        /*
         In this example we demonstrate evaluating a polynomial function
         
         PI*x^3 + 0.4*x + 1
         
         on encrypted floating-point input data x for a set of 4096 equidistant points
         in the interval [0, 1]. This example demonstrates many of the main features
         of the CKKS scheme, but also the challenges in using it.
         
         We start by setting up the CKKS scheme.
         */
        let parms = ASLEncryptionParameters(schemeType: .CKKS)
        
        /*
         We saw in `2_Encoders.cs' that multiplication in CKKS causes scales in
         ciphertexts to grow. The scale of any ciphertext must not get too close to
         the total size of CoeffModulus, or else the ciphertext simply runs out of
         room to store the scaled-up plaintext. The CKKS scheme provides a `rescale'
         functionality that can reduce the scale, and stabilize the scale expansion.
         
         Rescaling is a kind of modulus switch operation (recall `3_Levels.cs').
         As modulus switching, it removes the last of the primes from CoeffModulus,
         but as a side-effect it scales down the ciphertext by the removed prime.
         Usually we want to have perfect control over how the scales are changed,
         which is why for the CKKS scheme it is more common to use carefully selected
         primes for the CoeffModulus.
         
         More precisely, suppose that the scale in a CKKS ciphertext is S, and the
         last prime in the current CoeffModulus (for the ciphertext) is P. Rescaling
         to the next level changes the scale to S/P, and removes the prime P from the
         CoeffModulus, as usual in modulus switching. The number of primes limits
         how many rescalings can be done, and thus limits the multiplicative depth of
         the computation.
         
         It is possible to choose the initial scale freely. One good strategy can be
         to is to set the initial scale S and primes P_i in the CoeffModulus to be
         very close to each other. If ciphertexts have scale S before multiplication,
         they have scale S^2 after multiplication, and S^2/P_i after rescaling. If all
         P_i are close to S, then S^2/P_i is close to S again. This way we stabilize the
         scales to be close to S throughout the computation. Generally, for a circuit
         of depth D, we need to rescale D times, i.e., we need to be able to remove D
         primes from the coefficient modulus. Once we have only one prime left in the
         coeff_modulus, the remaining prime must be larger than S by a few bits to
         preserve the pre-decimal-point value of the plaintext.
         
         Therefore, a generally good strategy is to choose parameters for the CKKS
         scheme as follows:
         
         (1) Choose a 60-bit prime as the first prime in CoeffModulus. This will
         give the highest precision when decrypting
         (2) Choose another 60-bit prime as the last element of CoeffModulus, as
         this will be used as the special prime and should be as large as the
         largest of the other primes
         (3) Choose the intermediate primes to be close to each other.
         
         We use CoeffModulus.Create to generate primes of the appropriate size. Note
         that our CoeffModulus is 200 bits total, which is below the bound for our
         PolyModulusDegree: CoeffModulus.MaxBitCount(8192) returns 218.
         */
        let polyModulusDegree = 8192
        try parms.setPolynomialModulusDegree(polyModulusDegree)
        try parms.setCoefficientModulus(ASLCoefficientModulus.create(polyModulusDegree, bitSizes: [60, 40, 40, 60]))
        
        /*
         We choose the initial scale to be 2^40. At the last level, this leaves us
         60-40=20 bits of precision before the decimal point, and enough (roughly
         10-20 bits) of precision after the decimal point. Since our intermediate
         primes are 40 bits (in fact, they are very close to 2^40), we can achieve
         scale stabilization as described above.
         */
        let scale: Double = pow(2.0, 40)
        
        
        
        let context = try ASLSealContext(parms)
        print(context)
        print()
        
        let keygen = try ASLKeyGenerator(context: context)
        let publicKey = keygen.publicKey
        let secretKey = keygen.secretKey
        let relinKeys = try keygen.relinearizationKeys()
        let encryptor = try ASLEncryptor(context: context, publicKey: publicKey)
        let evaluator = try ASLEvaluator(context)
        let decryptor = try ASLDecryptor(context: context, secretKey: secretKey)
        
        let encoder = try ASLCKKSEncoder(context: context)
        let slotCount: Double = Double(encoder.slotCount)
        print("Number of slots: {slotCount}")
        
        var input = Array(repeating: NSNumber(0), count: Int(slotCount))
        let currPoint: Double = 0
        let stepSize = Double(1.0) / Double(slotCount - 1)
        
        for i in stride(from: Double(0), to: slotCount, by: stepSize) {
            input.append(NSNumber(value: currPoint))
        }
        
        print("Input vector:")
        print(input[3...7])
        
        print("Evaluating polynomial PI*x^3 + 0.4x + 1 ...")
        
        /*
         We create plaintexts for PI, 0.4, and 1 using an overload of CKKSEncoder.Encode
         that encodes the given floating-point value to every slot in the vector.
         */
        var plainCoeff3 = ASLPlainText()
        var plainCoeff1 = ASLPlainText()
        var plainCoeff0 = ASLPlainText()
        try encoder.encode(withDoubleValue: 3.14159265, scale: scale, destination: plainCoeff3)
        try encoder.encode(withDoubleValue: 0.4, scale: scale, destination: plainCoeff1)
        try encoder.encode(withDoubleValue: 1.0, scale: scale, destination: plainCoeff0)
        
        let xPlain = ASLPlainText()
        print()
        print("Encode input vectors.")
        try encoder.encode(withDoubleValues: input, scale: scale, destination: xPlain)
        let x1Encrypted = ASLCipherText()
        try encryptor.encrypt(with: xPlain, cipherText: x1Encrypted)
        
        /*
         To compute x^3 we first compute x^2 and relinearize. However, the scale has
         now grown to 2^80.
         */
        let x3Encrypted = ASLCipherText()
        print()
        print("Compute x^2 and relinearize:")
        try evaluator.square(x1Encrypted, destination: x3Encrypted)
        try evaluator.relinearizeInplace(x3Encrypted, relinearizationKeys: relinKeys)
        print("    + scale of x^2 before rescale: {\(log(x3Encrypted.scale))} bits")
        
        /*
         Now rescale in addition to a modulus switch, the scale is reduced down by
         a factor equal to the prime that was switched away (40-bit prime). Hence, the
         ASLscale should be close to 2^40. Note, however, that the scale is not equal
         to 2^40: this is because the 40-bit prime is only close to 2^40.
         */
        print()
        print("Rescale x^2.")
        try evaluator.rescale(toNextInplace: x3Encrypted)
        print("    + scale of x^2 after rescale: {\(log(x3Encrypted.scale))} bits")
        
        /*
         Now x3Encrypted is at a different level than x1Encrypted, which prevents us
         from multiplying them to compute x^3. We could simply switch x1Encrypted to
         the next parameters in the modulus switching chain. However, since we still
         need to multiply the x^3 term with PI (plainCoeff3), we instead compute PI*x
         first and multiply that with x^2 to obtain PI*x^3. To this end, we compute
         PI*x and rescale it back from scale 2^80 to something close to 2^40.
         */
        print()
        print("Compute and rescale PI*x.")
        let x1EncryptedCoeff3 = ASLCipherText()
        try evaluator.multiplyPlain(x1Encrypted, plain: plainCoeff3, destination: x1EncryptedCoeff3)
        print("    + scale of PI*x before rescale: {\(log(x1Encrypted.scale))} bits")
        try evaluator.rescale(toNextInplace: x1EncryptedCoeff3)
        print("    + scale of PI*x after rescale: {\(log(x1Encrypted.scale))} bits")
        
        /*
         Since x3Encrypted and x1EncryptedCoeff3 have the same exact scale and use
         the same encryption parameters, we can multiply them together. We write the
         result to x3Encrypted, relinearize, and rescale. Note that again the scale
         is something close to 2^40, but not exactly 2^40 due to yet another scaling
         by a prime. We are down to the last level in the modulus switching chain.
         */
        print()
        print("Compute, relinearize, and rescale (PI*x)*x^2.")
        try evaluator.multiplyInplace(x3Encrypted, encrypted2: x1EncryptedCoeff3)
        try evaluator.relinearizeInplace(x3Encrypted, relinearizationKeys: relinKeys)
        print("    + scale of PI*x^3 before rescale: {\(log(x3Encrypted.scale))} bits")
        try evaluator.rescale(toNextInplace: x3Encrypted)
        print("    + scale of PI*x^3 after rescale: {\(log(x3Encrypted.scale))} bits")
        
        /*
         Next we compute the degree one term. All this requires is one MultiplyPlain
         with plainCoeff1. We overwrite x1Encrypted with the result.
         */
        print()
        print("Compute and rescale 0.4*x.")
        try evaluator.multiplyPlainInplace(x1Encrypted, plain: plainCoeff1)
        print("    + scale of 0.4*x before rescale: {\(x1Encrypted.scale)} bits")
        try evaluator.rescale(toNextInplace: x1Encrypted)
        print("    + scale of 0.4*x after rescale: {\(x1Encrypted.scale)} bits")
        
        /*
         Now we would hope to compute the sum of all three terms. However, there is
         a serious problem: the encryption parameters used by all three terms are
         different due to modulus switching from rescaling.
         
         Encrypted addition and subtraction require that the scales of the inputs are
         the same, and also that the encryption parameters (ParmsId) match. If there
         is a mismatch, Evaluator will throw an exception.
         */
        print()
        print()
        print("Parameters used by all three terms are different:")
        print("    + Modulus chain index for x3Encrypted: {\(try context.contextData(x3Encrypted.parametersId).chainIndex)}")
        print("    + Modulus chain index for x1Encrypted: {\(try context.contextData(x1Encrypted.parametersId).chainIndex)}")
        print("    + Modulus chain index for plainCoeff0: {\(try context.contextData(plainCoeff0.parametersId).chainIndex)}")
        print()
        
        /*
         Let us carefully consider what the scales are at this point. We denote the
         primes in coeff_modulus as P_0, P_1, P_2, P_3, in this order. P_3 is used as
         the special modulus and is not involved in rescalings. After the computations
         above the scales in ciphertexts are:
         
         - Product x^2 has scale 2^80 and is at level 2
         - Product PI*x has scale 2^80 and is at level 2
         - We rescaled both down to scale 2^80/P2 and level 1
         - Product PI*x^3 has scale (2^80/P_2)^2
         - We rescaled it down to scale (2^80/P_2)^2/P_1 and level 0
         - Product 0.4*x has scale 2^80
         - We rescaled it down to scale 2^80/P_2 and level 1
         - The contant term 1 has scale 2^40 and is at level 2.
         
         Although the scales of all three terms are approximately 2^40, their exact
         values are different, hence they cannot be added together.
         */
        print()
        print("The exact scales of all three terms are different:")
        print("    + Exact scale in PI*x^3: {0:0.0000000000}", x3Encrypted.scale)
        print("    + Exact scale in  0.4*x: {0:0.0000000000}", x1Encrypted.scale)
        print("    + Exact scale in      1: {0:0.0000000000}", plainCoeff0.scale)
        print()
        
        /*
         There are many ways to fix this problem. Since P_2 and P_1 are really close
         to 2^40, we can simply "lie" to Microsoft SEAL and set the scales to be the
         same. For example, changing the scale of PI*x^3 to 2^40 simply means that we
         scale the value of PI*x^3 by 2^120/(P_2^2*P_1), which is very close to 1.
         This should not result in any noticeable error.
         
         Another option would be to encode 1 with scale 2^80/P_2, do a MultiplyPlain
         with 0.4*x, and finally rescale. In this case we would need to additionally
         make sure to encode 1 with appropriate encryption parameters (ParmsId).
         
         In this example we will use the first (simplest) approach and simply change
         the scale of PI*x^3 and 0.4*x to 2^40.
         */
        print()
        print("Normalize scales to 2^40.")
        x3Encrypted.setScale(NSNumber(value: pow(2.0, 40)))
        x1Encrypted.setScale(NSNumber(value: pow(2.0, 40)))
        
        /*
         We still have a problem with mismatching encryption parameters. This is easy
         to fix by using traditional modulus switching (no rescaling). CKKS supports
         modulus switching just like the BFV scheme, allowing us to switch away parts
         of the coefficient modulus when it is simply not needed.
         */
        print()
        print("Normalize encryption parameters to the lowest level.")
        let lastParmsId = x3Encrypted.parametersId
        try evaluator.modSwitch(toInplace: x1Encrypted, parametersId: lastParmsId)
        try evaluator.modSwitchToInplace(withPlain: plainCoeff0, parametersId: lastParmsId)
        
        /*
         All three ciphertexts are now compatible and can be added.
         */
        print()
        print("Compute PI*x^3 + 0.4*x + 1.")
        let encryptedResult = ASLCipherText()
        try evaluator.add(x3Encrypted, encrypted2: x1Encrypted, destination: encryptedResult)
        try evaluator.addPlainInplace(encryptedResult, plain: plainCoeff0)
        
        /*
         First print the true result.
         */
        let plainResult = ASLPlainText()
        print()
        print("Decrypt and decode PI * x ^ 3 + 0.4x + 1.")
        print("    + Expected result:")
        var trueResult = Array(repeating: Decimal(0), count: input.count)
        input.forEach { x in
            let parenthesized: Decimal = Decimal(3.14159265) * x.decimalValue * x.decimalValue + Decimal(0.4)
            let intemediateValue = parenthesized * x.decimalValue
            let value = intemediateValue + Decimal(1.0)
            trueResult.append(value)
        }
        print(trueResult[3...7])
        
        /*
         We decrypt, decode, and print the result.
         */
        try decryptor.decrypt(encryptedResult, destination: plainResult)
        let result = [NSNumber]()
        try encoder.decode(plainResult, destination: result)
        print("    + Computed result ...... Correct.")
        print(result[3...7])
        
        /*
         While we did not show any computations on complex numbers in these examples,
         the CKKSEncoder would allow us to have done that just as easily. Additions
         and multiplications of complex numbers behave just as one would expect.
         */
    }
}
