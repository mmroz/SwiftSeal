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
    
    func testCreateWithPublicKey() throws {
        XCTAssertNoThrow(_ = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey()))
    }
    
    func testCreateWithSecretKey() throws {
        XCTAssertNoThrow(_ = try ASLEncryptor(context: createValidContext(), secretKey: ASLSecretKey()))
    }
    
    func testCreateWithPublicAndSecretKey() throws {
        XCTAssertNoThrow(_ = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey(), secretKey: ASLSecretKey()))
    }
    
    func testEncryptWithPlainTextAndCipherText() throws {
        let encryptor = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey(), secretKey: ASLSecretKey())
        
        let plainText = ASLPlainText()
        let cipherText = ASLCipherText()
        
        XCTAssertNoThrow(try encryptor.encrypt(with: plainText, cipherText: cipherText))
    }
    
    func testEncryptWithPlainTextAndCipherTextAndPool() throws {
        let encryptor = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey(), secretKey: ASLSecretKey())
        
        let plainText = ASLPlainText()
        let cipherText = ASLCipherText()
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        XCTAssertNoThrow(try encryptor.encrypt(with: plainText, cipherText: cipherText, pool: pool))
    }
    
    func testEncryptZero() throws {
        let encryptor = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey(), secretKey: ASLSecretKey())
        
        let cipherText = ASLCipherText()
        
        XCTAssertNoThrow(try encryptor.encryptZero(with: cipherText))
    }
    
    func testEncryptZeroWithPool() throws {
        let encryptor = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey(), secretKey: ASLSecretKey())
        
        let cipherText = ASLCipherText()
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        XCTAssertNoThrow(try encryptor.encryptZero(with: cipherText, pool: pool))
    }
    
    func testEncryptZeroWithParams() throws {
        let encryptor = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey(), secretKey: ASLSecretKey())
        
        let cipherText = ASLCipherText()
        
        XCTAssertNoThrow(try  encryptor.encryptZero(with: ASLParametersIdType(block: (4,4,4,4)), cipherText: cipherText))
    }
    
    func testEncryptZeroWithParamsWithPool() throws {
        let encryptor = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey(), secretKey: ASLSecretKey())
        
        let cipherText = ASLCipherText()
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        XCTAssertNoThrow(try  encryptor.encryptZero(with: ASLParametersIdType(block: (4,4,4,4)), cipherText: cipherText, pool: pool))
    }
    
    func testEncryptSymmetric() throws {
        let encryptor = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey(), secretKey: ASLSecretKey())
        
        let cipherText = ASLCipherText()
        let plainText = ASLPlainText()
        
        XCTAssertNoThrow(try encryptor.encryptSymmetric(with: plainText, cipherText: cipherText))
    }
    
    func testEncryptSymmetricWithPool() throws {
        let encryptor = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey(), secretKey: ASLSecretKey())
        
        let cipherText = ASLCipherText()
        let plainText = ASLPlainText()
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        XCTAssertNoThrow(try encryptor.encryptSymmetric(with: plainText, cipherText: cipherText, pool: pool))
    }
    
    func testEncryptZeroSymmetric() throws {
        let encryptor = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey(), secretKey: ASLSecretKey())
        
        let cipherText = ASLCipherText()
        
        XCTAssertNoThrow(try encryptor.encryptZeroSymmetric(with: cipherText))
    }
    
    func testEncryptZeroSymmetricWithPool() throws {
        let encryptor = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey(), secretKey: ASLSecretKey())
        
        let cipherText = ASLCipherText()
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        XCTAssertNoThrow(try encryptor.encryptZeroSymmetric(with: cipherText, pool: pool))
    }
    
    func testEncryptZeroSymmetricWithParams() throws {
        let encryptor = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey(), secretKey: ASLSecretKey())
        
        let cipherText = ASLCipherText()
        let params = ASLParametersIdType(block: (4,4,4,4))
        
        
        XCTAssertNoThrow(try encryptor.encryptZeroSymmetric(with: params, destination: cipherText))
    }
    
    func testEncryptZeroSymmetricWithParamsWithPool() throws {
        let encryptor = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey(), secretKey: ASLSecretKey())
        
        let cipherText = ASLCipherText()
        let params = ASLParametersIdType(block: (4,4,4,4))
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        XCTAssertNoThrow(try encryptor.encryptZeroSymmetric(with: params, destination: cipherText, pool: pool))
    }
    
    func testSetPublicKey() throws {
        let encryptor = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey(), secretKey: ASLSecretKey())
        
        let publicKey = ASLPublicKey()
        
        XCTAssertNoThrow(try encryptor.setPublicKey(publicKey))
    }
    
    func testSetSecretKey() throws {
        let encryptor = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey(), secretKey: ASLSecretKey())
        
        let secretKey = ASLSecretKey()
        
        XCTAssertNoThrow(try encryptor.setSecretKey(secretKey))
    }
    
    func testSymmetricSave() throws {
        let encryptor = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey(), secretKey: ASLSecretKey())
        let plainText = ASLPlainText()
        let data = try encryptor.encryptSymmetricSave(with: plainText)
        let decodedPlainText = try ASLPlainText(data: data, context: createValidContext())
        XCTAssertEqual(decodedPlainText, plainText)
    }
    
    func testEncryptSymmetricSave() throws {
        let encryptor = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey(), secretKey: ASLSecretKey())
        
        let plainText = ASLPlainText()
        let data = try encryptor.encryptSymmetricSave(with: plainText)
        
        let decodedPlainText = try ASLPlainText(data: data, context: createValidContext())
        
        XCTAssertEqual(plainText, decodedPlainText)
    }
    
    func testEncryptZeroSymmetricSave() throws {
        let encryptor = try ASLEncryptor(context: createValidContext(), publicKey: ASLPublicKey(), secretKey: ASLSecretKey())
        
        let plainText = ASLPlainText()
        let data = try encryptor.encryptZeroSymmetricSave(withParamsId: ASLParametersIdType(block: (2,2,2,2)))
        
        let decodedPlainText = try ASLPlainText(data: data, context: createValidContext())
        
        XCTAssertEqual(plainText, decodedPlainText)
    }
    
    private func createValidContext() throws -> ASLSealContext {
        let params = ASLEncryptionParameters(schemeType: .BFV)
        try params.setPolynomialModulusDegree(8192)
        return try ASLSealContext(encrytionParameters: params, expandModChain: true, securityLevel: .TC128, memoryPoolHandle: ASLMemoryPoolHandle(clearOnDestruction: true))
    }
}
