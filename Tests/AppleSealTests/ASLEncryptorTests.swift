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
        XCTAssertNoThrow(try encryptor.encrypt(with: plainText))
    }
    
    func testEncryptWithPlainTextAndPool() throws {
        let plainText = try ASLPlainText(coefficientCount: 2)
        XCTAssertNoThrow(try encryptor.encrypt(with: plainText, pool: ASLMemoryPoolHandle.global()))
    }
    
    func testEncryptZeroWithCipherText() throws {
        let encryptedText = try ASLCipherText(context: ASLSealContext.bfvDefault())
        XCTAssertNoThrow(try encryptor.encryptZero(with: encryptedText))
    }
    
    func testEncryptZeroWithCipherTextAndPool() throws {
        let encryptedText = try ASLCipherText(context: ASLSealContext.bfvDefault())
        XCTAssertNoThrow(try encryptor.encryptZero(with: encryptedText, pool: ASLMemoryPoolHandle.global()))
    }
    
    func testEncryptZeroWithParametersId() throws {
        let params = ASLSealContext.bfvDefault().firstParameterIds
        XCTAssertNoThrow(try encryptor.encryptZero(with: params))
    }
    
    func testEncryptZeroWithParametersIdWithPool() throws {
        let encryptedText = try ASLCipherText(context: ASLSealContext.bfvDefault())
        XCTAssertNoThrow(try encryptor.encryptZeroSymmetric(with: encryptedText, pool: .global()))
    }
    
    func testEncryptZeroSymmetricWithParametersId() throws {
        let params = ASLSealContext.bfvDefault().firstParameterIds
        XCTAssertNoThrow(try encryptor.encryptZeroSymmetric(withPool: params, pool: .global()))
    }
    
    func testEncryptSerializableSymmetric() throws {
        XCTAssertNoThrow(try encryptor.encryptSerializableSymmetric(withPlain: ASLPlainText(), pool: .global()))
    }
    
    func testEncryptSymmetricWithPlain() throws {
        XCTAssertNoThrow(try encryptor.encryptSymmetric(with: ASLPlainText()))
    }
    
    func testEncryptSymmetricWithParametersAndPool() throws {
        XCTAssertNoThrow(try encryptor.encryptSymmetric(with: ASLPlainText(), pool: .global()))
    }
    
    func testSerializableEncryptZero() {
        XCTAssertNoThrow(try encryptor.encryptSerializableZeroSymmetric())
    }
    
    func testSetPublicKey() {
        let otherPublicKey: ASLPublicKey = {
            let context = ASLSealContext.bfvDefault()
            let keygen = try! ASLKeyGenerator(context: context)
            return keygen.publicKey
        }()
        
        XCTAssertNoThrow(try encryptor.setPublicKey(otherPublicKey))
    }
    
    func testSetSecretKey() {
        let otherSecretKey: ASLSecretKey = {
            let context = ASLSealContext.bfvDefault()
            let keygen = try! ASLKeyGenerator(context: context)
            return keygen.secretKey
        }()
        
        XCTAssertNoThrow(try encryptor.setSecretKey(otherSecretKey))
    }
    
    private func createEncryptor() -> ASLEncryptor {
        let context = ASLSealContext.bfvDefault()
        let keygen = try! ASLKeyGenerator(context: context)
        let publicKey = keygen.publicKey
        let secretKey = keygen.secretKey
        return try! ASLEncryptor(context: context, publicKey: publicKey, secretKey: secretKey)
    }
}
