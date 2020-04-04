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
        XCTAssertNoThrow(try ASLKeyGenerator(context: bfvDefaultContext()))
    }
    
    func createKeyGeneratorWithSecretKeyAndPublicKey() throws {
        let keyGenerator = try ASLKeyGenerator(context: bfvDefaultContext())
        
        XCTAssertNoThrow(try ASLKeyGenerator(context: bfvDefaultContext(), secretKey: keyGenerator.secretKey, publicKey: keyGenerator.publicKey))
    }
    
    func testKeyGeneratorWithSecretKey() throws {
        let keyGenerator = try ASLKeyGenerator(context: bfvDefaultContext())
        
        XCTAssertNoThrow(try ASLKeyGenerator(context: bfvDefaultContext(), secretKey: keyGenerator.secretKey))
    }
    
    func testPublicKey() throws {
        let keyGenerator = try ASLKeyGenerator(context: bfvDefaultContext())
        
        let otherKeyGenerator = try ASLKeyGenerator(context: bfvDefaultContext(), secretKey: keyGenerator.secretKey)
        
        XCTAssertEqual(keyGenerator.secretKey, otherKeyGenerator.secretKey)
    }
    
    func testSecretKey() throws {
        let keyGenerator = try ASLKeyGenerator(context: bfvDefaultContext())
        
        let otherKeyGenerator = try ASLKeyGenerator(context: bfvDefaultContext(), secretKey: keyGenerator.secretKey)
        
        XCTAssertEqual(keyGenerator.publicKey, otherKeyGenerator.publicKey)
    }
    
    func testRelinearizationKeys() throws {
        let keyGenerator = try ASLKeyGenerator(context: bfvDefaultContext())
        
        XCTAssertNoThrow(try keyGenerator.relinearizationKeys())
    }
    
    func testGaloisKeys() throws {
        let keyGenerator = try ASLKeyGenerator(context: bfvDefaultContext())
        
        XCTAssertNoThrow(try keyGenerator.galoisKeys())
    }
    
    func testGaloisKeysWithElements() throws {
        let keyGenerator = try ASLKeyGenerator(context: bfvDefaultContext())
       XCTAssertNoThrow(try keyGenerator.galoisKeys(withGaloisElements: [0,1,2]))
    }
    
    func testGaloisKeysWithSteps() throws {
        let keyGenerator = try ASLKeyGenerator(context: bfvDefaultContext())
        XCTAssertNoThrow(try keyGenerator.galoisKeys(withSteps: [1]))
    }
}

public func bfvDefaultContext() throws -> ASLSealContext {
    let params = ASLEncryptionParameters(schemeType: .BFV)
    try params.setPolynomialModulusDegree(8192)
    try params.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(8192))
    try params.setPlainModulusWithInteger(65537)
    return try ASLSealContext(encrytionParameters: params)
}
