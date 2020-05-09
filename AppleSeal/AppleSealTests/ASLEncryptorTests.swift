//
//  ASLEncryptorTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-03-22.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLEncryptorTests: XCTestCase {
    
    var encryptor: ASLEncryptor!
    
    override func setUp() {
        super.setUp()
        encryptor = createEncryptor()
    }
    
    override func tearDown() {
        encryptor = nil
    }
    
    func testEncryptWithPlainText() throws {
        let plainText = try ASLPlainText(coefficientCount: 2)
        XCTAssertNoThrow(try encryptor.encrypt(with: plainText, destination: ASLCipherText()))
    }
    
    func testEncryptWithPlainTextAndPool() throws {
        let plainText = try ASLPlainText(coefficientCount: 2)
        XCTAssertNoThrow(try encryptor.encrypt(with: plainText, destination: ASLCipherText(), pool: ASLMemoryPoolHandle.global()))
    }
    
    func testEncryptZeroWithCipherText() throws {
        let encryptedText = try ASLCipherText(context: createValidContext())
        XCTAssertNoThrow(try encryptor.encryptZero(with: encryptedText))
    }
    
    func testEncryptZeroWithCipherTextAndPool() throws {
        let encryptedText = try ASLCipherText(context: createValidContext())
        XCTAssertNoThrow(try encryptor.encryptZero(with: encryptedText, pool: ASLMemoryPoolHandle.global()))
    }
    
    func testEncryptZeroWithParametersId() throws {
        let encryptedText = try ASLCipherText(context: .bfvDefault())
        XCTAssertNoThrow(try encryptor.encryptZero(with: ASLParametersIdType(block: (40, 40, 40, 40)), cipherText: encryptedText))
    }
    
    func testEncryptZeroWithParametersIdWithPool() throws {
        let encryptedText = try ASLCipherText(context: createValidContext())
        XCTAssertNoThrow(try encryptor.encryptZeroSymmetric(with: encryptedText, pool: .global()))
    }
    
    func testEncryptZeroSymmetricWithParametersId() throws {
        XCTAssertNoThrow(try encryptor.encryptZeroSymmetric(withPool: ASLParametersIdType(block: (4, 4, 4, 4)), destination: ASLCipherText(), pool: .global()))
    }
    
    func testSetPublicKey() {
        XCTAssertNoThrow(try encryptor.setPublicKey(ASLPublicKey()))
    }
    
    func testSetSecretKey() {
        XCTAssertNoThrow(try encryptor.setSecretKey(ASLSecretKey()))
    }
    
    func testEncryptSymmetricSaveWithPlainText() throws {
       let data = try encryptor.encryptSymmetricSave(with: ASLPlainText())
       XCTAssertNoThrow(try ASLPlainText(data: data, context: createValidContext()))
    }
    
    func testEncryptZeroSymmetricSaveWithParamsId() throws {
        let data = try encryptor.encryptZeroSymmetricSave(withParamsId: ASLParametersIdType(block: (4, 4, 4, 4)))
       try ASLPlainText(data: data, context: createValidContext())
    }
    
    private func createValidContext() -> ASLSealContext {
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        let polyModulusDegree = 4096
        try! parms.setPolynomialModulusDegree(polyModulusDegree)
        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try! parms.setPlainModulus(ASLSmallModulus(value: 1024))
        return try! ASLSealContext(parms)
    }
    
    private func createEncryptor() -> ASLEncryptor {
        let context = createValidContext()
        let keygen = try! ASLKeyGenerator(context: context)
        let publicKey = keygen.publicKey
        let secretKey = keygen.secretKey
        return try! ASLEncryptor(context: context, publicKey: publicKey)
    }
}
