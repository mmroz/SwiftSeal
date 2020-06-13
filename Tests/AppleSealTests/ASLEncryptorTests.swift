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
        let encryptedText = try encryptor.encrypt(with: ASLPlainText(polynomialString: "4"))
        XCTAssertNoThrow(try encryptor.encryptZero(with: params, cipherText: encryptedText))
    }
    
    // TODO - crashing?
    func testEncryptZeroWithParametersIdWithPool() throws {
        //        let encryptedText = try ASLCipherText(context: ASLSealContext.bfvDefault())
        //        XCTAssertNoThrow(try encryptor.encryptZeroSymmetric(with: encryptedText, pool: .global()))
    }
    
    // TODO - crashing?
    func testEncryptZeroSymmetricWithParametersId() throws {
        //        XCTAssertNoThrow(try encryptor.encryptZeroSymmetric(withPool: ASLParametersIdType(block: (4, 4, 4, 4)), destination: ASLCipherText(), pool: .global()))
    }
    
    // TODO - crashing?
    func testEncryptSymmetricWithPlainAndPool() throws {
//        let encyrpted = try encryptor.encryptSymmetric(withPlain: ASLPlainText(), pool: .global())
//        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
//        archiver.encode(encyrpted, forKey: "testObject")
//        let data = archiver.encodedData
//
//        let unarchiver = try! NSKeyedUnarchiver(forReadingFrom: data)
//        unarchiver.requiresSecureCoding = false
//
//        XCTAssertNotNil(unarchiver.decodeObject(of: ASLCipherText.self, forKey: "testObject"))
    }
    
    func testEncryptSymmetricWithPlain() throws {
        // TODO - fix this
//        let encyrpted = try encryptor.encryptSymmetric(withPlain: ASLPlainText())
//        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
//        archiver.encode(encyrpted, forKey: "testObject")
//        let data = archiver.encodedData
//        XCTAssertNoThrow(try ASLCipherText(data: data, context: .bfvDefault()))
    }
    
    func testEncryptSymmetricWithParametersAndPool() throws {
        // TODO - fix this
//        let params = ASLSealContext.bfvDefault().firstParameterIds
//        let encyrpted = try encryptor.encryptZeroSymmetric(with: params, pool: .global())
//        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
//        archiver.encode(encyrpted, forKey: "testObject")
//        let data = archiver.encodedData
//        XCTAssertNoThrow(try ASLCipherText(data: data, context: .bfvDefault()))
    }
    
    func testEncryptSymmetricWithParameters() throws {
        let params = ASLSealContext.bfvDefault().firstParameterIds
        let encyrpted = try encryptor.encryptZeroSymmetric(with: params)
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        archiver.encode(encyrpted, forKey: "testObject")
        let data = archiver.encodedData
        XCTAssertNoThrow(try ASLCipherText(data: data, context: .bfvDefault()))
    }
    
    // TODO - crashing?
    func testEncryptSymmetricWithPool() throws {
        //        let encyrpted = try encryptor.encryptZeroSymmetric(withPool: .global())
        //        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        //        archiver.encode(encyrpted, forKey: "testObject")
        //        let data = archiver.encodedData
        //
        //        let unarchiver = try! NSKeyedUnarchiver(forReadingFrom: data)
        //        unarchiver.requiresSecureCoding = false
        //
        //        XCTAssertNotNil(unarchiver.decodeObject(of: ASLCipherText.self, forKey: "testObject"))
    }
    
    // TODO - crashing?
    func testEncryptSymmetric() throws {
        //        let encyrpted = try encryptor.encryptZeroSymmetric()
        //        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        //        archiver.encode(encyrpted, forKey: "testObject")
        //        let data = archiver.encodedData
        //
        //        let unarchiver = try! NSKeyedUnarchiver(forReadingFrom: data)
        //        unarchiver.requiresSecureCoding = false
        //
        //        XCTAssertNotNil(unarchiver.decodeObject(of: ASLCipherText.self, forKey: "testObject"))
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
