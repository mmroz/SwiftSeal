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
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        let polyModulusDegree = 4096
        try! parms.setPolynomialModulusDegree(polyModulusDegree)
        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try! parms.setPlainModulus(ASLSmallModulus(value: 1024))
        let context = try! ASLSealContext(parms)
        self.keyGenerator = try! ASLKeyGenerator(context: context)
    }
    
    override func tearDown() {
        super.tearDown()
        keyGenerator = nil
    }
    
    func testCreateKeyGenerator() throws {
        XCTAssertNoThrow(try ASLKeyGenerator(context: .bfvDefault()))
    }
    
    func testCreateKeyGeneratorWithSecretKeyAndPublicKey() throws {
        XCTAssertNoThrow(try ASLKeyGenerator(context: .bfvDefault(), secretKey: keyGenerator.secretKey, publicKey: keyGenerator.publicKey))
    }
    
    func testKeyGeneratorWithSecretKey() throws {
        XCTAssertNoThrow(try ASLKeyGenerator(context: .bfvDefault(), secretKey: keyGenerator.secretKey))
    }
    
    func testPublicKey() throws {
        XCTAssertNoThrow(keyGenerator.secretKey)
    }
    
    func testSecretKey() throws {
        XCTAssertNoThrow(keyGenerator.publicKey)
    }
    
    func testRelinearizationKeys() throws {
        XCTAssertNoThrow(try keyGenerator.relinearizationKeys())
    }
    
    func testGaloisKeys() throws {
       let keygen = galoisKeyGenerator()
        
        XCTAssertNoThrow(try keygen.galoisKeys())
    }
    
    func testGaloisKeysWithElements() throws {
        let keygen = galoisKeyGenerator()
        
        XCTAssertNoThrow(try keygen.galoisKeys(withGaloisElements: []))
    }
    
    func testGaloisKeysWithSteps() throws {
        let keygen = galoisKeyGenerator()
        
        XCTAssertNoThrow(try keygen.galoisKeys(withSteps: [1]))
    }
    
    func testRelinearizationKeysSave() throws {
        let keyGenerator = try ASLKeyGenerator(context: .bfvDefault())
        let data = try keyGenerator.relinearizationKeysSave()
        let _ = try ASLRelinearizationKeys(data: data, context: .bfvDefault())
    }
    
    func testGaloisKeysSave() throws {
        let keyGenerator = galoisKeyGenerator()
        let data = try keyGenerator.galoisKeysSave()
        let _ = try ASLGaloisKeys(data: data, context: galoisContext())
    }
    
    func testGaloisKeysSaveWithSteps() throws {
        let keyGenerator = galoisKeyGenerator()
        let data = try keyGenerator.galoisKeysSave(withSteps: [1])
        let _ = try ASLGaloisKeys(data: data, context: galoisContext())
    }
    
    func testGaloisKeysSaveWithElements() throws {
        let keyGenerator = galoisKeyGenerator()
        let data = try keyGenerator.galoisKeysSave(withElements: [1])
        let _ = try ASLGaloisKeys(data: data, context: galoisContext())
    }
    
    private func galoisContext() -> ASLSealContext {
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        let polyModulusDegree = 8192
        try! parms.setPolynomialModulusDegree(polyModulusDegree)
        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try! parms.setPlainModulus(ASLPlainModulus.batching(polyModulusDegree, bitSize: 20))
        return try! ASLSealContext(parms)
    }
    
    private func galoisKeyGenerator() -> ASLKeyGenerator {
        return try! ASLKeyGenerator(context: galoisContext())
    }
}
