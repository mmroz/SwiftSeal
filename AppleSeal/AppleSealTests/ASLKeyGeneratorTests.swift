//
//  ASLKeyGeneratorTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-03-28.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLKeyGeneratorTests: XCTestCase {
    func testCreateKeyGenerator() throws {
        XCTAssertNoThrow(try ASLKeyGenerator(context: .bfvDefault))
    }
    
    func createKeyGeneratorWithSecretKeyAndPublicKey() throws {
        let keyGenerator = try ASLKeyGenerator(context: .bfvDefault)
        
        XCTAssertNoThrow(try ASLKeyGenerator(context: .bfvDefault, secretKey: keyGenerator.secretKey, publicKey: keyGenerator.publicKey))
    }
    
    func testKeyGeneratorWithSecretKey() throws {
        let keyGenerator = try ASLKeyGenerator(context: .bfvDefault)
        
        XCTAssertNoThrow(try ASLKeyGenerator(context: .bfvDefault, secretKey: keyGenerator.secretKey))
    }
    
    func testPublicKey() throws {
        let keyGenerator = try ASLKeyGenerator(context: .bfvDefault)
        
        let otherKeyGenerator = try ASLKeyGenerator(context: .bfvDefault, secretKey: keyGenerator.secretKey)
        
        XCTAssertEqual(keyGenerator.secretKey, otherKeyGenerator.secretKey)
    }
    
    func testSecretKey() throws {
        let keyGenerator = try ASLKeyGenerator(context: .bfvDefault)
        
        let otherKeyGenerator = try ASLKeyGenerator(context: .bfvDefault, secretKey: keyGenerator.secretKey)
        
        XCTAssertEqual(keyGenerator.publicKey, otherKeyGenerator.publicKey)
    }
    
    func testRelinearizationKeys() throws {
        let keyGenerator = try ASLKeyGenerator(context: .bfvDefault)
        
        XCTAssertNoThrow(try keyGenerator.relinearizationKeys())
    }
    
    func testGaloisKeys() throws {
        let keyGenerator = try ASLKeyGenerator(context: .bfvDefault)
        
        XCTAssertNoThrow(try keyGenerator.galoisKeys())
    }
    
    func testGaloisKeysWithElements() throws {
        let keyGenerator = try ASLKeyGenerator(context: .bfvDefault)
       XCTAssertNoThrow(try keyGenerator.galoisKeys(withGaloisElements: [0,1,2]))
    }
    
    func testGaloisKeysWithSteps() throws {
        let keyGenerator = try ASLKeyGenerator(context: .bfvDefault)
        XCTAssertNoThrow(try keyGenerator.galoisKeys(withSteps: [1]))
    }
    
    func testRelinearizationKeysSave() throws {
        let keyGenerator = try ASLKeyGenerator(context: .bfvDefault)
        let data = try keyGenerator.relinearizationKeysSave()
        let _ = try ASLRelinearizationKeys(data: data, context: .bfvDefault)
    }
    
    func testGaloisKeysSave() throws {
        let keyGenerator = try ASLKeyGenerator(context: .bfvDefault)
        let data = try keyGenerator.galoisKeysSave()
        let _ = try ASLGaloisKeys(data: data, context: .bfvDefault)
    }
    
    func testGaloisKeysSaveWithSteps() throws {
        let keyGenerator = try ASLKeyGenerator(context: .bfvDefault)
        let data = try keyGenerator.galoisKeysSave(withSteps: [1])
        let _ = try ASLGaloisKeys(data: data, context: .bfvDefault)
    }
    
    func testGaloisKeysSaveWithElements() throws {
        let keyGenerator = try ASLKeyGenerator(context: .bfvDefault)
        let data = try keyGenerator.galoisKeysSave(withElements: [1])
        let _ = try ASLGaloisKeys(data: data, context: .bfvDefault)
    }
    
    
}
