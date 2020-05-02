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
        
        var podMatrix = Array(repeating: NSNumber(0), count: slotCount)
        podMatrix.insert(0, at: 0)
        podMatrix.insert(1, at: 1)
        podMatrix.insert(2, at: 2)
        podMatrix.insert(3, at: 3)
        podMatrix.insert(4, at: rowSize)
        podMatrix.insert(5, at: rowSize + 1)
        podMatrix.insert(6, at: rowSize + 2)
        podMatrix.insert(7, at: rowSize + 3)
        
        print("Input plaintext matrix: \(podMatrix)")
        print()
        
        /*
         First we use BatchEncoder to encode the matrix into a plaintext. We encrypt
         the plaintext as usual.
         */
        print()
        
        print("Encode and encrypt.")
        let plainMatrix = try batchEncoder.encode(withUnsignedValues: podMatrix, destination: ASLPlainText())
        var encryptedMatrix = try encryptor.encrypt(with: plainMatrix, cipherText: ASLCipherText())
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
        encryptedMatrix = try evaluator.rotateRowsInplace(encryptedMatrix, steps: 3, galoisKey: galKeys)
        print("    + Noise budget after rotation: {\(try decryptor.invariantNoiseBudget(encryptedMatrix))} bits")
        var plainResult = try decryptor.decrypt(encryptedMatrix, destination: ASLPlainText())
        var podResult = try batchEncoder.decode(with: plainResult, unsignedDestination: [NSNumber]())
        
        print("    + Decrypt and decode \(podResult) ...... Correct.")
        
        /*
         We can also rotate the columns, i.e., swap the rows.
         */
        print()
        print("Rotate columns.")
        encryptedMatrix = try evaluator.rotateColumnsInplace(encryptedMatrix, galoisKey: galKeys)
        plainResult = try decryptor.decrypt(encryptedMatrix, destination: plainResult)
        podResult = try batchEncoder.decode(with: plainResult, unsignedDestination: podResult)
        print("    + Noise budget after rotation: {\(try decryptor.invariantNoiseBudget(encryptedMatrix))} bits")
        print("    + Decrypt and decode \(podResult) ...... Correct.")
        
        /*
         Finally, we rotate the rows 4 steps to the right, decrypt, decode, and print.
         */
        print()
        print("Rotate rows 4 steps right.")
        encryptedMatrix = try evaluator.rotateRowsInplace(encryptedMatrix, steps: -4, galoisKey: galKeys)
        plainResult = try decryptor.decrypt(encryptedMatrix, destination: plainResult)
        podResult = try batchEncoder.decode(with: plainResult, unsignedDestination: podResult)
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
        
        stride(from: Double(0), to: slotCount, by: stepSize).forEach({ input.append(NSNumber(value: $0))  })
        
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
