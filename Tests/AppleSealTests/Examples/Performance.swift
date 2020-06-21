//
//  Performance.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-04-25.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class Performance: XCTestCase {
    func testBfvPerformance4096() throws {
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        let polyModulusDegree = 4096
        try! parms.setPolynomialModulusDegree(polyModulusDegree)
        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try! parms.setPlainModulusWithInteger(786433)
        try! bfvTest(ASLSealContext(parms))
    }
    
    func testBfvPerformance8192() throws {
//        let parms = ASLEncryptionParameters(schemeType: .BFV)
//        let polyModulusDegree = 8192
//        try! parms.setPolynomialModulusDegree(polyModulusDegree)
//        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
//        try! parms.setPlainModulusWithInteger(786433)
//        try! bfvTest(ASLSealContext(parms))
    }
    
    func testBfvPerformance16384() throws {
//        let parms = ASLEncryptionParameters(schemeType: .BFV)
//        let polyModulusDegree = 16384
//        try! parms.setPolynomialModulusDegree(polyModulusDegree)
//        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
//        try! parms.setPlainModulusWithInteger(786433)
//        try! bfvTest(ASLSealContext(parms))
    }
    
    func testCkksPerformance4096() throws {
        let parms = ASLEncryptionParameters(schemeType: .CKKS)
        let polyModulusDegree = 4096
        try parms.setPolynomialModulusDegree(polyModulusDegree)
        try parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        let context = try ASLSealContext(parms)
        try ckksTest(context)
    }
    
    func testCkksPerformance8192() throws {
//        let parms = ASLEncryptionParameters(schemeType: .CKKS)
//        let polyModulusDegree = 8192
//        try parms.setPolynomialModulusDegree(polyModulusDegree)
//        try parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
//        let context = try ASLSealContext(parms)
//        try ckksTest(context)
    }
    
    func testCkksPerformance16384() throws {
//        let parms = ASLEncryptionParameters(schemeType: .CKKS)
//        let polyModulusDegree = 16384
//        try parms.setPolynomialModulusDegree(polyModulusDegree)
//        try parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
//        let context = try ASLSealContext(parms)
//        try ckksTest(context)
    }
    
    private func ckksTest(_ context: ASLSealContext) throws {
        let parms = context.firstContextData.encryptionParameters
        let keygen = try ASLKeyGenerator(context: context)
        
        let secretKey = keygen.secretKey
        let publicKey = keygen.publicKey
        let galoisKey = try keygen.galoisKeysLocal()
        
        let encryptor = try ASLEncryptor(context: context, publicKey: publicKey)
        let decryptor = try ASLDecryptor(context: context, secretKey: secretKey)
        let evaluator = try ASLEvaluator(context)
        let ckksEncoder = try ASLCKKSEncoder(context: context)
        
        let podVector = (0..<ckksEncoder.slotCount).map { i in
            NSNumber(value: 1.001 * Double(i))
        }
        
        let modulusValue: Double = Double(bitPattern: (parms.coefficientModulus.lastObject as? ASLModulus)?.uint64Value ?? .zero)
        let scale = sqrt(modulusValue)
        
        measure {
            /*
             [Encoding]
             For scale we use the square root of the last coeff_modulus prime
             from parms.
             */
            
            var plain = try! ckksEncoder.encode(withDoubleValues: podVector, scale: scale)
            
            /*
             [Decoding]
             */
            
            try! ckksEncoder.decodeDoubleValues(plain)
            
            /*
             [Encryption]
             */
            var encrypted = try! encryptor.encrypt(with: plain)
            
            /*
             [Decryption]
             */
            _ = try! decryptor.decrypt(encrypted)
            
            /*
             [Add]
             */
            var encrypted1 = try! ASLCipherText(context: context)
            plain = try! ckksEncoder.encode(withLongValue: 1)
            encrypted1 = try! encryptor.encrypt(with: plain)
            var encrypted2 = try! ASLCipherText(context: context)
            let plain2 = try! ckksEncoder.encode(withLongValue: 1)
            encrypted2 = try! encryptor.encrypt(with: plain2)
            encrypted1 = try! evaluator.addInplace(encrypted1, encrypted2: encrypted1)
            encrypted2 = try! evaluator.addInplace(encrypted2, encrypted2: encrypted2)
            encrypted1 = try! evaluator.addInplace(encrypted1, encrypted2: encrypted2)
            
            /*
             [Multiply]
             */
            try! encrypted1.resize(3)
            encrypted1 = try! evaluator.multiplyInplace(encrypted1, encrypted2: encrypted2)
            
            /*
             [Multiply Plain]
             */
            encrypted2 = try! evaluator.multiplyPlainInplace(encrypted2, plain: plain)
            
            /*
             [Square]
             */
            encrypted2 = try! evaluator.squareInplace(encrypted2)
            
            if context.isAllowedKeySwitching {
                /*
                 [Relinearize]
                 */
                // TODO
                //encrypted1 = try! evaluator.relinearizeInplace(encrypted1, relinearizationKeys: keygen.relinearizationKeysLocal())
                
                /*
                 [Rescale]
                 */
                encrypted1 = try! evaluator.rescale(toNextInplace: encrypted1)
                
                /*
                 [Rotate Vector]
                 */
                encrypted = try! evaluator.rotateVector(encrypted, steps: 1, galoisKey: galoisKey)
                encrypted = try! evaluator.rotateVector(encrypted, steps: -1, galoisKey: galoisKey)
                
                /*
                 [Rotate Vector Random]
                 */
                let randomRotation = Int32(Int.random(in: 0..<ckksEncoder.slotCount))
                encrypted = try! evaluator.rotateVectorInplace(encrypted, steps: randomRotation, galoisKey: galoisKey)
                
                /*
                 [Complex Conjugate]
                 */
                try! evaluator.complexConjugateInplace(encrypted, galoisKey: galoisKey)
            }
        }
    }
    
    private func bfvTest(_ context: ASLSealContext) throws {
        print(context)
        let parms = context.firstContextData.encryptionParameters
        let plainModulus = parms.plainModulus
        let _ = parms.polynomialModulusDegree

        let keygen = try ASLKeyGenerator(context: context);
        
        let secretKey = keygen.secretKey
        let publicKey = keygen.publicKey
        
        let _ = try! keygen.relinearizationKeysLocal();
        let galKeys = try! keygen.galoisKeysLocal();
        
        let encryptor = try ASLEncryptor(context: context, publicKey: publicKey)
        let decryptor = try ASLDecryptor(context: context, secretKey: secretKey)
        let evaluator = try ASLEvaluator(context)
        let batchEncoder = try ASLBatchEncoder(context: context)
        let encoder = try! ASLIntegerEncoder(context: context)
         
        let podVector = (0..<batchEncoder.slotCount).map { i in
            NSNumber(value: Int.random(in: 0..<10) % Int(truncatingIfNeeded: plainModulus.uint64Value))
        }
        
        let modulusValue: Double = Double(bitPattern: (parms.coefficientModulus.lastObject as? ASLModulus)?.uint64Value ?? .zero)
        let _ = sqrt(modulusValue)
        
        measure {
            /*
            [Batching]
            There is nothing unusual here. We batch our random plaintext matrix
            into the polynomial. Note how the plaintext we create is of the exactly
            right size so unnecessary reallocations are avoided.
            */
            let plain = try! batchEncoder.encode(withUnsignedValues: podVector)
            
            /*
            [Unbatching]
            We unbatch what we just batched.
            */
            let decoded = try! batchEncoder.decodeUnsignedValues(with: plain)
            
            XCTAssertEqual(podVector, decoded)
            
            /*
            [Encryption]
            We make sure our ciphertext is already allocated and large enough
            to hold the encryption with these encryption parameters. We encrypt
            our random batched matrix here.
            */
            let encrypted = try! encryptor.encrypt(with: plain)
            
            /*
            [Decryption]
            We decrypt what we just encrypted.
            */
            let plain2 = try! decryptor.decrypt(encrypted)
            
            XCTAssertEqual(plain2, plain)
            
            /*
            [Add]
            We create two ciphertexts and perform a few additions with them.
            */
            var encrypted1 = try! encryptor.encrypt(with: encoder.encodeInt32Value(2))
            var encrypted2 = try! encryptor.encrypt(with: encoder.encodeInt32Value(2))
            encrypted1 = try! evaluator.addInplace(encrypted1, encrypted2: encrypted1)
            encrypted2 = try! evaluator.addInplace(encrypted2, encrypted2: encrypted2)
            encrypted1 = try! evaluator.addInplace(encrypted1, encrypted2: encrypted2)
            
            /*
            [Multiply]
            We multiply two ciphertexts. Since the size of the result will be 3,
            and will overwrite the first argument, we reserve first enough memory
            to avoid reallocating during multiplication.
            */
            try! encrypted1.resize(3)
            encrypted1 = try! evaluator.multiplyInplace(encrypted1, encrypted2: encrypted2)
            
            /*
            [Multiply Plain]
            We multiply a ciphertext with a random plaintext. Recall that
            multiply_plain does not change the size of the ciphertext so we use
            encrypted2 here.
            */
            encrypted2 = try! evaluator.multiplyPlainInplace(encrypted2, plain: plain)
            
            /*
            [Square]
            We continue to use encrypted2. Now we square it; this should be
            faster than generic homomorphic multiplication.
            */
            encrypted2 = try! evaluator.squareInplace(encrypted2)
            
            if context.isAllowedKeySwitching {
                /*
                [Relinearize]
                Time to get back to encrypted1. We now relinearize it back
                to size 2. Since the allocation is currently big enough to
                contain a ciphertext of size 3, no costly reallocations are
                needed in the process.
                */
                // TODO
                //encrypted1 = try! evaluator.relinearizeInplace(encrypted1, relinearizationKeys: keygen.relinearizationKeysLocal());
                
                /*
                [Rotate Rows One Step]
                We rotate matrix rows by one step left and measure the time.
                */
                var encrypted = try! evaluator.rotateRowsInplace(encrypted, steps: 1, galoisKey: galKeys)
                encrypted = try! evaluator.rotateRowsInplace(encrypted, steps: -1, galoisKey: galKeys);
                
                /*
                [Rotate Rows Random]
                We rotate matrix rows by a random number of steps. This is much more
                expensive than rotating by just one step.
                */
                let rowSize = batchEncoder.slotCount / 2
                let randomRotation = Int.random(in: 0..<10000) % rowSize
                encrypted = try! evaluator.rotateRowsInplace(encrypted, steps: Int32(randomRotation), galoisKey: galKeys);
                
                /*
                [Rotate Columns]
                Nothing surprising here.
                */
   
                encrypted = try! evaluator.rotateColumnsInplace(encrypted, galoisKey: galKeys)
                
                /*
                [Rotate Columns]
                Nothing surprising here.
                */
                encrypted = try! evaluator.rotateColumnsInplace(encrypted, galoisKey: galKeys);
            }
        }
    }
}
