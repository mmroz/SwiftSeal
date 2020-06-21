//
//  Rotation.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-04-25.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class Rotation: XCTestCase {
    /*
     Both the BFV scheme (with BatchEncoder) as well as the CKKS scheme support native
     vectorized computations on encrypted numbers. In addition to computing slot-wise,
     it is possible to rotate the encrypted vectors cyclically.
     */
    func testExampleRotationBFV() throws {
        print("Example: Rotation / Rotation in BFV")
        
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        
        let polyModulusDegree = 8192
        try parms.setPolynomialModulusDegree(polyModulusDegree)
        try parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try parms.setPlainModulus(ASLPlainModulus.batching(polyModulusDegree, bitSize: 20))
        
        let context = try ASLSealContext(parms)
        print(context)
        print()
        
        let keygen = try ASLKeyGenerator(context: context)
        let publicKey = keygen.publicKey
        let secretKey = keygen.secretKey
        let encryptor = try ASLEncryptor(context: context, publicKey: publicKey)
        let evaluator = try ASLEvaluator(context)
        let decryptor = try ASLDecryptor(context: context, secretKey: secretKey)
        
        let batchEncoder = try ASLBatchEncoder(context: context)
        let slotCount = batchEncoder.slotCount
        let rowSize = slotCount / 2
        print("let matrix row size: {\(rowSize)}")
        
        var podMatrix = Array(repeating: NSNumber(value: 0), count: slotCount)
        let replacedValues: [NSNumber] = [.init(value: 0), .init(value: 1), .init(value: 2), .init(value: 3), NSNumber(value: rowSize), .init(value: rowSize + 1), .init(value: rowSize + 2), .init(value: rowSize + 3)]
        podMatrix.replaceSubrange(0...7, with: replacedValues)
        
        print("Input plaintext matrix: \(podMatrix)")
        print()
        
        /*
         First we use BatchEncoder to encode the matrix into a plaintext. We encrypt
         the plaintext as usual.
         */
        print()
        
        print("Encode and encrypt.")
        let plainMatrix = try batchEncoder.encode(withUnsignedValues: podMatrix)
        var encryptedMatrix = try encryptor.encrypt(with: plainMatrix)
        print("    + Noise budget in fresh encryption: {\(try decryptor.invariantNoiseBudget(encryptedMatrix)))} bits")
        print()
        
        /*
         Rotations require yet another type of special key called `Galois keys'. These
         are easily obtained from the KeyGenerator.
         */
        let galKeys = try keygen.galoisKeysLocal()
        
        /*
         Now rotate both matrix rows 3 steps to the left, decrypt, decode, and print.
         */
        print()
        print("Rotate rows 3 steps left.")
        encryptedMatrix = try evaluator.rotateRowsInplace(encryptedMatrix, steps: 3, galoisKey: galKeys)
        print("    + Noise budget after rotation: {\(try decryptor.invariantNoiseBudget(encryptedMatrix))} bits")
        var plainResult = try decryptor.decrypt(encryptedMatrix)
        var podResult = try batchEncoder.decodeUnsignedValues(with: plainResult)
        
        
        print("    + Decrypt and decode \(podResult) ...... Correct.")
        
        /*
         We can also rotate the columns, i.e., swap the rows.
         */
        print()
        print("Rotate columns.")
        encryptedMatrix = try evaluator.rotateColumnsInplace(encryptedMatrix, galoisKey: galKeys)
        plainResult = try decryptor.decrypt(encryptedMatrix)
        podResult = try batchEncoder.decodeUnsignedValues(with: plainResult)
        print("    + Noise budget after rotation: {\(try decryptor.invariantNoiseBudget(encryptedMatrix))} bits")
        print("    + Decrypt and decode \(podResult) ...... Correct.")
        
        /*
         Finally, we rotate the rows 4 steps to the right, decrypt, decode, and print.
         */
        print()
        print("Rotate rows 4 steps right.")
        encryptedMatrix = try evaluator.rotateRowsInplace(encryptedMatrix, steps: -4, galoisKey: galKeys)
        plainResult = try decryptor.decrypt(encryptedMatrix)
        podResult = try batchEncoder.decodeUnsignedValues(with: plainResult)
        print("    + Noise budget after rotation: {\(try decryptor.invariantNoiseBudget(encryptedMatrix))} bits")
        print("    + Decrypt and decode \(podResult) ...... Correct.")
        
        /*
         Note that rotations do not consume any noise budget. However, this is only
         the case when the special prime is at least as large as the other primes. The
         same holds for relinearization. Microsoft SEAL does not require that the
         special prime is of any particular size, so ensuring this is the case is left
         for the user to do.
         */
    }
    
    func testExampleRotationCKKS() throws {
        print("Example: Rotation / Rotation in CKKS");

        /*
        Rotations in the CKKS scheme work very similarly to rotations in BFV.
        */
        let parms = ASLEncryptionParameters(schemeType: .CKKS)
        let polyModulusDegree = 8192
        try parms.setPolynomialModulusDegree(polyModulusDegree)
        try parms.setCoefficientModulus(ASLCoefficientModulus.create(polyModulusDegree, bitSizes: [40, 40, 40, 40, 40]))

        let context = try ASLSealContext(parms)
        print(context)
        
        let keygen = try ASLKeyGenerator(context: context);
        let publicKey = keygen.publicKey;
        let secretKey = keygen.secretKey;
        let galKeys = try keygen.galoisKeysLocal()
        let encryptor = try ASLEncryptor(context: context, publicKey: publicKey)
        let evaluator = try ASLEvaluator(context)
        let decryptor = try ASLDecryptor(context: context, secretKey: secretKey)

        let ckksEncoder = try ASLCKKSEncoder(context: context);

        let slotCount = ckksEncoder.slotCount;
        print("Number of slots: \(slotCount)")
        
        let stepSize = 1.0 / Double(slotCount - 1)
        let input: [NSNumber] = (0..<slotCount).map({
            return NSNumber(value: Double($0) * stepSize)
        })
        
        print("Input vector: \(input[3..<7])")
        
        let scale = pow(2.0, 50.0)

        print("Encode and encrypt.")
        var plain = try ckksEncoder.encode(withDoubleValues: input, scale: scale)
        let encrypted = try encryptor.encrypt(with: plain)

        print("Rotate 2 steps left.")
        let rotated = try evaluator.rotateVector(encrypted, steps: 2, galoisKey: galKeys);
        print("    + Decrypt and decode ...... Correct.")
        plain = try decryptor.decrypt(rotated)
        let result = try ckksEncoder.decodeDoubleValues(plain)
        print(result[3..<7])

        /*
        With the CKKS scheme it is also possible to evaluate a complex conjugation on
        a vector of encrypted complex numbers, using Evaluator::complex_conjugate.
        This is in fact a kind of rotation, and requires also Galois keys.
        */
    }
}
