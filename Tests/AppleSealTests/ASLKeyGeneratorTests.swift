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
    
    var keyGenerator: ASLKeyGenerator! = nil
    
    override func setUp() {
        super.setUp()
        let context = ASLSealContext.bfvDefault()
        self.keyGenerator = try! ASLKeyGenerator(context: context)
    }
    
    override func tearDown() {
        super.tearDown()
        keyGenerator = nil
    }
    
    func testCreateWithSecretKey() throws {
        let context = ASLSealContext.bfvDefault()
        let keyGenerator = try! ASLKeyGenerator(context: context)
        let secretKey = keyGenerator.secretKey
        
        XCTAssertNoThrow(try ASLKeyGenerator(context: context, secretKey: secretKey))
    }
    
    func testPublicKey() throws {
        XCTAssertNoThrow(keyGenerator.publicKey)
    }
    
    func testSecretKey() throws {
        XCTAssertNoThrow(keyGenerator.secretKey)
    }
    
    func testRelinearizationKeysLocal() throws {
        XCTAssertNoThrow(try keyGenerator.relinearizationKeysLocal())
    }
    
    func testRelinearizationKeys() throws {
        XCTAssertNoThrow( try keyGenerator.relinearizationKeys())
    }
    
    func testGaloisKeysLocalWithGaloisElements() throws {
        let params = ASLEncryptionParameters(schemeType: .BFV)
        let plainModulus = try ASLModulus(value: 257)
        try params.setPolynomialModulusDegree(8)
        try params.setPlainModulus(plainModulus)
        try params.setCoefficientModulus(ASLCoefficientModulus.create(8, bitSizes: [40, 40]))
        let context = try ASLSealContext(encrytionParameters: params, expandModChain: false, securityLevel: .None, memoryPoolHandle: .global())
        let result = try ASLKeyGenerator(context: context).galoisKeysLocal(withGaloisElements: [1, 3, 5, 15])
        XCTAssertEqual(try result.getIndex(3), 1)
    }
    
    func testGaloisKeysWithGaloisElements() throws {
        let params = ASLEncryptionParameters(schemeType: .BFV)
        let plainModulus = try ASLModulus(value: 257)
        try params.setPolynomialModulusDegree(8)
        try params.setPlainModulus(plainModulus)
        try params.setCoefficientModulus(ASLCoefficientModulus.create(8, bitSizes: [40, 40]))
        let context = try ASLSealContext(encrytionParameters: params, expandModChain: false, securityLevel: .None, memoryPoolHandle: .global())
        XCTAssertNoThrow(try ASLKeyGenerator(context: context).galoisKeys(withGaloisElements: [1, 3, 5, 15]))
    }
    
    func testGaloisKeysLocalWithSteps() throws {
        let params = ASLEncryptionParameters(schemeType: .BFV)
        let plainModulus = try ASLModulus(value: 257)
        try params.setPolynomialModulusDegree(8)
        try params.setPlainModulus(plainModulus)
        try params.setCoefficientModulus(ASLCoefficientModulus.create(8, bitSizes: [40, 40]))
        let context = try ASLSealContext(encrytionParameters: params, expandModChain: false, securityLevel: .None, memoryPoolHandle: .global())
        let result = try ASLKeyGenerator(context: context).galoisKeysLocal(withSteps: [1, 3])
        XCTAssertEqual(try result.getIndex(3), 1)
        
    }
    
    func testGaloisKeysWithSteps() throws {
        let params = ASLEncryptionParameters(schemeType: .BFV)
        let plainModulus = try ASLModulus(value: 257)
        try params.setPolynomialModulusDegree(8)
        try params.setPlainModulus(plainModulus)
        try params.setCoefficientModulus(ASLCoefficientModulus.create(8, bitSizes: [40, 40]))
        let context = try ASLSealContext(encrytionParameters: params, expandModChain: false, securityLevel: .None, memoryPoolHandle: .global())
        XCTAssertNoThrow(try ASLKeyGenerator(context: context).galoisKeys(withSteps: [1, 3]))
    }
    
    func testGaloisKeys() throws {
        let params = ASLEncryptionParameters(schemeType: .BFV)
        let plainModulus = try ASLModulus(value: 257)
        try params.setPolynomialModulusDegree(8)
        try params.setPlainModulus(plainModulus)
        try params.setCoefficientModulus(ASLCoefficientModulus.create(8, bitSizes: [40, 40]))
        let context = try ASLSealContext(encrytionParameters: params, expandModChain: false, securityLevel: .None, memoryPoolHandle: .global())
        XCTAssertNoThrow(try ASLKeyGenerator(context: context).galoisKeys())
    }
    
    func testGaloisKeysWithLocal() throws {
        let params = ASLEncryptionParameters(schemeType: .BFV)
        let plainModulus = try ASLModulus(value: 257)
        try params.setPolynomialModulusDegree(8)
        try params.setPlainModulus(plainModulus)
        try params.setCoefficientModulus(ASLCoefficientModulus.create(8, bitSizes: [40, 40]))
        let context = try ASLSealContext(encrytionParameters: params, expandModChain: false, securityLevel: .None, memoryPoolHandle: .global())
        XCTAssertNoThrow(try ASLKeyGenerator(context: context).galoisKeysLocal())
    }
}
