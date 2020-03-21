//
//  ASLDecryptorTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-03-21.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLDecryptorTests: XCTestCase {
    
    // MARK: - Tests
    
    func testCreateWithDefaultParameters() {
        let _ = ASLDecryptor()
    }
    
    func testCreateWithContextAndSecreyKey() throws {
        let params = ASLEncryptionParameters(schemeType: .BFV)
        try params.setPolynomialModulusDegree(8192)
        let context = try ASLSealContext(encrytionParameters: params)
        
        XCTAssertNoThrow(_ = try ASLDecryptor(context: context, secretKey: ASLSecretKey()))
    }
    
    func testCreateWithInvalidContext() throws {
        let params = ASLEncryptionParameters(schemeType: .CKKS)
        try params.setPolynomialModulusDegree(8192)
        let context = try ASLSealContext(encrytionParameters: params)
        
        XCTAssertThrowsError(_ = try ASLDecryptor(context: context, secretKey: ASLSecretKey()))
    }
    
    func testInvariantNoiseBudget() throws {
        let params = ASLEncryptionParameters(schemeType: .BFV)
        try params.setPolynomialModulusDegree(8192)
        let context = try ASLSealContext(encrytionParameters: params)
    
        let decryptor = try ASLDecryptor(context: context, secretKey: ASLSecretKey())
        let invariantNoiseBudget = try decryptor.invariantNoiseBudget(ASLCipherText(context: context))
        
        XCTAssertNotNil(invariantNoiseBudget)
        XCTAssertEqual(invariantNoiseBudget, 1)
    }
}
