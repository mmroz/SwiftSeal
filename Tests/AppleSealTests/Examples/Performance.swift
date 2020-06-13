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
    func testBFVWith4096And8192And16384() throws {
        print("BFV Performance Test with Degrees: 4096, 8192, and 16384")
        
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        var polyModulusDegree = 4096
        try parms.setPolynomialModulusDegree(polyModulusDegree)
        try parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try parms.setPlainModulus(ASLModulus(value: 786433))
        
        try bfvTest(context: try ASLSealContext(parms))
        
        print()
       polyModulusDegree = 8192
       try parms.setPolynomialModulusDegree(polyModulusDegree)
        try parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try parms.setPlainModulus(ASLModulus(value: 786433))
        try bfvTest(context: try ASLSealContext(parms))
       
       print()
       polyModulusDegree = 16384
       try parms.setPolynomialModulusDegree(polyModulusDegree)
        try parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try parms.setPlainModulus(ASLModulus(value: 786433))
        try bfvTest(context: try ASLSealContext(parms))
    }
    
    func testCKKSWith4096And8192And16384() throws {
        print("CKKS Performance Test with Degrees: 4096, 8192, and 16384")
        
        // It is not recommended to use BFVDefault primes in CKKS. However, for performance
        // test, BFVDefault primes are good enough.
        let parms = ASLEncryptionParameters(schemeType: .CKKS)
        var polyModulusDegree = 4096
        try parms.setPolynomialModulusDegree(polyModulusDegree)
        try parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try ckksTest(context: ASLSealContext(parms))
        
        print()
        polyModulusDegree = 8192
        try parms.setPolynomialModulusDegree(polyModulusDegree)
        try parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try ckksTest(context: ASLSealContext(parms))
        
        print()
        polyModulusDegree = 16384
        try parms.setPolynomialModulusDegree(polyModulusDegree)
        try parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try ckksTest(context: ASLSealContext(parms))
        
        /*
         Comment out the following to run the biggest example.
         */
        //print()
        //polyModulusDegree = 32768
        //try parms.setPolynomialModulusDegree(polyModulusDegree)
        //parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        //CKKSPerformanceTest(new SEALContext(parms))
    }
    
    private func timedEvent(_ event: () throws -> Void) rethrows {
        let eventStartTime = Date()
        try event()
        let elapsedTime = Date().timeIntervalSince(eventStartTime)
        print("Completed in \(elapsedTime)")
    }
    
    private func bfvTest(context: ASLSealContext) throws {
        print(context)
        print()
        
        let parms = context.firstContextData.encryptionParameters
        let plainModulus = parms.plainModulus
        let polyModulusDegree = parms.polynomialModulusDegree
        
        print("Generating secret/public keys: ")
        let keygen = try ASLKeyGenerator(context: context)
        print("Done")
        
        let secretKey = keygen.secretKey
        let publicKey = keygen.publicKey
        
        var relinKeys: ASLRelinearizationKeys? = nil
        var galKeys: ASLGaloisKeys? = nil
        if (context.isAllowedKeySwitching)
        {
            /*
             Generate relinearization keys.
             */
            print("Generating relinearization keys: ")
            try timedEvent {
                try relinKeys = keygen.relinearizationKeysLocal()
            }
            
            if (!context.keyContextData.qualifiers.isUsingBatching)
            {
                print("Given encryption parameters do not support batching.")
                return
            }
            
            /*
             Generate Galois keys. In larger examples the Galois keys can use a lot of
             memory, which can be a problem in constrained systems. The user should
             try some of the larger runs of the test and observe their effect on the
             memory pool allocation size. The key generation can also take a long time,
             as can be observed from the print-out.
             */
            print("Generating Galois keys: ")
            try timedEvent {
                try galKeys = keygen.galoisKeysLocal()
            }
        }
        
        let encryptor = try ASLEncryptor(context: context, publicKey: publicKey)
        let decryptor = try ASLDecryptor(context: context, secretKey: secretKey)
        let evaluator = try ASLEvaluator(context)
        let batchEncoder = try ASLBatchEncoder(context: context)
        let encoder = try ASLIntegerEncoder(context: context)
        
        
        /*
         How many times to run the test?
         */
        let count = 10
        
        /*
         Populate a vector of values to batch.
         */
        let slotCount = batchEncoder.slotCount
        var podValues = Array(repeating: NSNumber(0), count: slotCount)
        for i in 0..<batchEncoder.slotCount {
            podValues[i] = NSNumber(value: UInt64(CGFloat.random(in: 1...10)) % plainModulus.uint64Value)
        }
        
        print("Running tests ")
        for i in 0..<count {
            /*
             [Batching]
             There is nothing unusual here. We batch our random plaintext matrix
             into the polynomial. Note how the plaintext we create is of the exactly
             right size so unnecessary reallocations are avoided.
             */
            let plain = try ASLPlainText(capacity: parms.polynomialModulusDegree, coefficientCount: 0)
            try timedEvent {
                try batchEncoder.encode(withUnsignedValues: podValues)
            }
            
            /*
             [Unbatching]
             We unbatch what we just batched.
             */
            
            let podList = Array(repeating: NSNumber(0), count: slotCount)
            try timedEvent {
                try batchEncoder.decode(with: plain)
            }
            
//            XCTAssertEqual(podList, podValues)
            
            /*
             [Encryption]
             We make sure our ciphertext is already allocated and large enough
             to hold the encryption with these encryption parameters. We encrypt
             our random batched matrix here.
             */
            let encrypted = try ASLCipherText(context: context)
            try timedEvent {
                try encryptor.encrypt(with: plain)
            }
            
            /*
             [Decryption]
             We decrypt what we just encrypted.
             */
            let plain2 = try ASLPlainText(capacity: polyModulusDegree, coefficientCount: 0)
            try timedEvent {
                try decryptor.decrypt(encrypted)
            }
            XCTAssertEqual(plain2, plain)
            
            /*
             [Add]
             We create two ciphertexts and perform a few additions with them.
             */
            var encrypted1 = try ASLCipherText(context: context)
            encrypted1 = try encryptor.encrypt(with:  encoder.encodeInt32Value(Int32(i)))
            var encrypted2 = try ASLCipherText(context: context)
            encrypted2 = try encryptor.encrypt(with: encoder.encodeInt32Value(Int32(i) + 1))
            
            try timedEvent {
                try evaluator.addInplace(encrypted1, encrypted2: encrypted1)
                try evaluator.addInplace(encrypted2, encrypted2: encrypted2)
                try evaluator.addInplace(encrypted1, encrypted2: encrypted2)
            }
            
            /*
             [Multiply]
             We multiply two ciphertexts. Since the size of the result will be 3,
             and will overwrite the first argument, we reserve first enough memory
             to avoid reallocating during multiplication.
             */
            try encrypted1.reserve(3)
            try timedEvent {
                try evaluator.multiplyInplace(encrypted1, encrypted2: encrypted2)
            }
            
            /*
             [Multiply Plain]
             We multiply a ciphertext with a random plaintext. Recall that
             MultiplyPlain does not change the size of the ciphertext so we use
             encrypted2 here.
             */
            try timedEvent {
                try evaluator.multiplyPlainInplace(encrypted2, plain: plain)
            }
            
            /*
             [Square]
             We continue to use encrypted2. Now we square it this should be
             faster than generic homomorphic multiplication.
             */
            try timedEvent {
                try evaluator.squareInplace(encrypted2)
            }
            
            if (context.isAllowedKeySwitching)
            {
                /*
                 [Relinearize]
                 Time to get back to encrypted1. We now relinearize it back
                 to size 2. Since the allocation is currently big enough to
                 contain a ciphertext of size 3, no costly reallocations are
                 needed in the process.
                 */
                try timedEvent {
                    try evaluator.relinearizeInplace(encrypted1, relinearizationKeys: relinKeys!)
                }
                
                /*
                 [Rotate Rows One Step]
                 We rotate matrix rows by one step left and measure the time.
                 */
                try timedEvent {
                    try evaluator.rotateRowsInplace(encrypted, steps: 1, galoisKey: galKeys!)
                    try evaluator.rotateRowsInplace(encrypted, steps: -1, galoisKey: galKeys!)
                }
                
                /*
                 [Rotate Rows Random]
                 We rotate matrix rows by a random number of steps. This is much more
                 expensive than rotating by just one step.
                 */
                let rowSize = batchEncoder.slotCount / 2
                let randomRotation = Int.random(in: 0..<10) % rowSize
                try timedEvent {
                    try evaluator.rotateRowsInplace(encrypted, steps: Int32(randomRotation), galoisKey: galKeys!)
                }
                
                /*
                 [Rotate Columns]
                 Nothing surprising here.
                 */
                try timedEvent {
                    try evaluator.rotateColumnsInplace(encrypted, galoisKey: galKeys!)
                }
            }
            
            
            /*
             Print a dot to indicate progress.
             */
            print(".")
        }
        print(" Done")
    }
    
    private func ckksTest(context: ASLSealContext) throws {
        print(context)
        print()
        
        let parms = context.firstContextData.encryptionParameters
        let polyModulusDegree = parms.polynomialModulusDegree
        
        print("Generating secret/public keys: ")
        let keygen = try ASLKeyGenerator(context: context)
        print("Done")
        
        let secretKey = keygen.secretKey
        let publicKey = keygen.publicKey
        
        let relinKeys: ASLRelinearizationKeys? = nil
        var galKeys: ASLGaloisKeys? = nil
        if (context.isAllowedKeySwitching)
        {
            /*
             Generate relinearization keys.
             */
            print("Generating relinearization keys: ")
            try timedEvent {
                let _ = try keygen.relinearizationKeysLocal()
            }
            
            if (!context.keyContextData.qualifiers.isUsingBatching)
            {
                print("Given encryption parameters do not support batching.")
                return
            }
            
            /*
             Generate Galois keys. In larger examples the Galois keys can use a lot of
             memory, which can be a problem in constrained systems. The user should
             try some of the larger runs of the test and observe their effect on the
             memory pool allocation size. The key generation can also take a long time,
             as can be observed from the print-out.
             */
            print("Generating Galois keys: ")
            try timedEvent {
                galKeys = try keygen.galoisKeysLocal()
            }
        }
        
        let encryptor = try ASLEncryptor(context: context, publicKey: publicKey)
        let decryptor = try ASLDecryptor(context: context, secretKey: secretKey)
        let evaluator = try ASLEvaluator(context)
        let ckksEncoder = try ASLCKKSEncoder(context: context)
        
        /*
         How many times to run the test?
         */
        let count = 10
        
        /*
         Populate a vector of floating-point values to batch.
         */
        let slotCount = ckksEncoder.slotCount
        var podValues = Array(repeating: NSNumber(0), count: slotCount)
        for i in 0..<slotCount {
            podValues[i] = NSNumber(value: 1.001 * Double(i))
        }
        
        print("Running tests ")
        for i in 0..<count {
            /*
             [Encoding]
             For scale we use the square root of the last CoeffModulus prime
             from parms.
             */
            let lastValue = (parms.coefficientModulus.lastObject as? ASLModulus)!.uint64Value
            let scale = sqrt(NSNumber(value: lastValue).floatValue)
            let plain = try ASLPlainText(capacity: parms.polynomialModulusDegree * parms.coefficientModulus.count, coefficientCount: 0)
            try timedEvent {
                try ckksEncoder.encode(withDoubleValues: podValues, scale: Double(scale))
            }
            
            /*
             [Decoding]
             */
            try timedEvent {
                let podValues = try ckksEncoder.decodeDoubleValues(plain)
            }
            
            /*
             [Encryption]
             */
            let encrypted = try ASLCipherText(context: context)
            try timedEvent {
                try encryptor.encrypt(with: plain)
            }
            
            /*
             [Decryption]
             */
            let plain2 = try ASLPlainText(capacity: polyModulusDegree, coefficientCount: 0)
            try timedEvent {
                try decryptor.decrypt(encrypted)
            }
            
            /*
             [Add]
             */
            var encrypted1 = try ASLCipherText(context: context)
            try ckksEncoder.encode(withLongValue: NSDecimalNumber(integerLiteral: i + 1))
            encrypted1 = try encryptor.encrypt(with: plain)
            var encrypted2 = try ASLCipherText(context: context)
            try ckksEncoder.encode(withLongValue: NSDecimalNumber(integerLiteral: i + 1))
            encrypted2 = try encryptor.encrypt(with: plain2)
            try timedEvent {
                try evaluator.addInplace(encrypted1, encrypted2: encrypted2)
                try evaluator.addInplace(encrypted2, encrypted2: encrypted2)
                try evaluator.addInplace(encrypted1, encrypted2: encrypted2)
            }
            
            /*
             [Multiply]
             */
            try encrypted1.reserve(3)
            try timedEvent {
                try evaluator.multiplyInplace(encrypted1, encrypted2: encrypted2)
            }
            
            /*
             [Multiply Plain]
             */
            try timedEvent {
                try evaluator.multiplyPlainInplace(encrypted2, plain: plain)
            }
            
            /*
             [Square]
             */
            try timedEvent {
                try evaluator.squareInplace(encrypted2)
            }
            
            if (context.isAllowedKeySwitching)
            {
                /*
                 [Relinearize]
                 */
                try timedEvent {
                    try evaluator.relinearizeInplace(encrypted1, relinearizationKeys: relinKeys!)
                }
                
                /*
                 [Rescale]
                 */
                try timedEvent {
                    try evaluator.rescale(toNextInplace: encrypted1)
                }
                
                /*
                 [Rotate Vector]
                 */
                try timedEvent {
                    try evaluator.rotateVectorInplace(encrypted, steps: 1, galoisKey: galKeys!)
                    try evaluator.rotateVectorInplace(encrypted, steps: -1, galoisKey: galKeys!)
                }
                
                /*
                 [Rotate Vector Random]
                 */
                let randomRotation = Int.random(in: 0...10) % ckksEncoder.slotCount
                try timedEvent {
                    try evaluator.rotateVectorInplace(encrypted, steps: Int32(randomRotation), galoisKey: galKeys!)
                }
                
                /*
                 [Complex Conjugate]
                 */
                try timedEvent {
                    try evaluator.complexConjugateInplace(encrypted, galoisKey: galKeys!)
                }
            }
            
            /*
             Print a dot to indicate progress.
             */
            print(".")
        }
        
        print(" Done")
    }
}
