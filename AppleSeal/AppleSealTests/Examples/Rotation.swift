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
    func textExampleRotationBFV() throws {
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
        let relinKeys = try keygen.relinearizationKeys()
        let encryptor = try ASLEncryptor(context: context, publicKey: publicKey)
        let evaluator = try ASLEvaluator(context)
        let decryptor = try ASLDecryptor(context: context, secretKey: secretKey)
        
        let batchEncoder = try ASLBatchEncoder(context: context)
        let slotCount = batchEncoder.slotCount
        let rowSize = slotCount / 2
        print("let matrix row size: {\(rowSize)}")
        
        var podMatrix = Array(repeating: NSNumber(0), count: slotCount)
        podMatrix[0] = 0
        podMatrix[1] = 1
        podMatrix[2] = 2
        podMatrix[3] = 3
        podMatrix[rowSize] = 4
        podMatrix[rowSize + 1] = 5
        podMatrix[rowSize + 2] = 6
        podMatrix[rowSize + 3] = 7
        
        print("Input plaintext matrix:")
        print(podMatrix)
        print()
        
        /*
         First we use BatchEncoder to encode the matrix into a plaintext. We encrypt
         the plaintext as usual.
         */
        print()
        let plainMatrix = ASLPlainText()
        print("Encode and encrypt.")
        try batchEncoder.encode(withUnsignedValues: podMatrix, destination: plainMatrix)
        let encryptedMatrix = ASLCipherText()
        try encryptor.encrypt(with: plainMatrix, cipherText: encryptedMatrix)
        print("    + Noise budget in fresh encryption: {\(try decryptor.invariantNoiseBudget(encryptedMatrix)))} bits")
        print()
        
        /*
         Rotations require yet another type of special key called `Galois keys'. These
         are easily obtained from the KeyGenerator.
         */
        let galKeys = try keygen.galoisKeys()
        
        /*
         Now rotate both matrix rows 3 steps to the left, decrypt, decode, and print.
         */
        print()
        print("Rotate rows 3 steps left.")
        try evaluator.rotateRowsInplace(encryptedMatrix, steps: 3, galoisKey: galKeys)
        let plainResult = ASLPlainText()
        print("    + Noise budget after rotation: {\(try decryptor.invariantNoiseBudget(encryptedMatrix))} bits")
        print("    + Decrypt and decode ...... Correct.")
        try decryptor.decrypt(encryptedMatrix, destination: plainResult)
        let podResult = [NSNumber]()
        try batchEncoder.decode(with: plainResult, unsignedDestination: podResult)
        print(podResult)
        
        /*
         We can also rotate the columns, i.e., swap the rows.
         */
        print()
        print("Rotate columns.")
        try evaluator.rotateColumnsInplace(encryptedMatrix, galoisKey: galKeys)
        print("    + Noise budget after rotation: {\(try decryptor.invariantNoiseBudget(encryptedMatrix))} bits")
        print("    + Decrypt and decode ...... Correct.")
        try decryptor.decrypt(encryptedMatrix, destination: plainResult)
        try batchEncoder.decode(with: plainResult, unsignedDestination: podResult)
        print(podResult)
        
        /*
         Finally, we rotate the rows 4 steps to the right, decrypt, decode, and print.
         */
        print()
        print("Rotate rows 4 steps right.")
        try evaluator.rotateRowsInplace(encryptedMatrix, steps: -4, galoisKey: galKeys)
        print("    + Noise budget after rotation: {\(try decryptor.invariantNoiseBudget(encryptedMatrix))} bits")
        print("    + Decrypt and decode ...... Correct.")
        try decryptor.decrypt(encryptedMatrix, destination: plainResult)
        try batchEncoder.decode(with: plainResult, unsignedDestination: podResult)
        print(podResult)
        
        /*
         Note that rotations do not consume any noise budget. However, this is only
         the case when the special prime is at least as large as the other primes. The
         same holds for relinearization. Microsoft SEAL does not require that the
         special prime is of any particular size, so ensuring this is the case is left
         for the user to do.
         */
    }
    
    func testExampleRotationCKKS() throws {
        print("Example: Rotation / Rotation in CKKS")
        
        let parms = ASLEncryptionParameters(schemeType: .CKKS)
        
        let polyModulusDegree = 8192
        try parms.setPolynomialModulusDegree(polyModulusDegree)
        try parms.setCoefficientModulus(ASLCoefficientModulus.create(polyModulusDegree, bitSizes: [40, 40, 40, 40, 40]))
        
        let context = try ASLSealContext(parms)
        print(context)
        print()
        
        let keygen = try ASLKeyGenerator(context: context)
        let publicKey = keygen.publicKey
        let secretKey = keygen.secretKey
        let relinKeys = try keygen.relinearizationKeys()
        let galKeys = try keygen.galoisKeys()
        let encryptor = try ASLEncryptor(context: context, publicKey: publicKey)
        let evaluator = try ASLEvaluator(context)
        let decryptor = try ASLDecryptor(context: context, secretKey: secretKey)
        
        let ckksEncoder = try ASLCKKSEncoder(context: context)
        
        let slotCount: Double = Double(ckksEncoder.slotCount)
        print("Number of slots: {\(slotCount)}")
        
        var input = Array(repeating: NSNumber(0), count: Int(slotCount))
        let currPoint: Double = 0
        let stepSize = Double(1.0) / Double(slotCount - 1)
        
        for i in stride(from: Double(0), to: slotCount, by: stepSize) {
            input.append(NSNumber(value: currPoint))
        }
        
        print("Input vector:")
        print(input[3...7])
        
        let scale: Double = pow(2.0, 50)
        
        print()
        print("Encode and encrypt.")
        let plain = ASLPlainText()
        try ckksEncoder.encode(withDoubleValues: input, scale: scale, destination: plain)
        let encrypted = ASLCipherText()
        try encryptor.encrypt(with: plain, cipherText: encrypted)
        
        let rotated = ASLCipherText()
        print()
        print("Rotate 2 steps left.")
        try evaluator.rotateVector(encrypted, steps: 2, galoisKey: galKeys, destination: rotated)
        print("    + Decrypt and decode ...... Correct.")
        try decryptor.decrypt(encrypted, destination: plain)
        let result = [NSNumber]()
        try ckksEncoder.decode(plain, destination: result)
        print(result[3...7])
        
        /*
         With the CKKS scheme it is also possible to evaluate a complex conjugation on
         a vector of encrypted complex numbers, using Evaluator.ComplexConjugate. This
         is in fact a kind of rotation, and requires also Galois keys.
         */
    }
}
