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
    
    var decryptor: ASLDecryptor! = nil
    var encryptor: ASLEncryptor! = nil
    
    override func setUp() {
        super.setUp()
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        let polyModulusDegree = 4096
        try! parms.setPolynomialModulusDegree(polyModulusDegree)
        
        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        
        try! parms.setPlainModulus(ASLSmallModulus(value: 1024))
     
        let context = try! ASLSealContext(parms)
        
        let keygen = try! ASLKeyGenerator(context: context)
        let publicKey = keygen.publicKey
        let secretKey = keygen.secretKey
        
        decryptor = try! ASLDecryptor(context: context, secretKey: secretKey)
        encryptor = try! ASLEncryptor(context: context, publicKey: publicKey)
        
    }
    
    override func tearDown() {
        super.tearDown()
        decryptor = nil
    }
    
    // MARK: - Tests
    
    func testCreateWithInvalidContext() throws {
        let params = ASLEncryptionParameters(schemeType: .CKKS)
        try params.setPolynomialModulusDegree(8192)
        let context = try ASLSealContext(encrytionParameters: params, expandModChain: true, securityLevel: .None, memoryPoolHandle: ASLMemoryPoolHandle(clearOnDestruction: true))
        
        XCTAssertThrowsError(_ = try ASLDecryptor(context: context, secretKey: ASLSecretKey()))
    }
    
    func testInvariantNoiseBudget() throws {
        let xPlain = try ASLPlainText(polynomialString: "\(1)")
        let xEncrypted = try encryptor.encrypt(with: xPlain, destination: ASLCipherText())
        
        let invariantNoiseBudget = try decryptor.invariantNoiseBudget(xEncrypted)
        
        XCTAssertNotNil(invariantNoiseBudget)
        XCTAssertEqual(invariantNoiseBudget, 55)
    }
}
