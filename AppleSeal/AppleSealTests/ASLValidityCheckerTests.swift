//
//  ASLValidityCheckerTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-01-19.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLValidityCheckerTests: XCTestCase {
    
    
    func testValidMetaDataWithPlainText() {
        XCTAssertTrue(ASLValidityChecker.isMetaDataValid(for: try ASLPlainText(polynomialString: "\(6)"), context: bfvContext(4096)))
        XCTAssertTrue(ASLValidityChecker.isMetaDataValid(for: try ASLPlainText(polynomialString: "\(6)"), context: bfvContext(1024)))
    }
    
    func testIsMetaDataValidForPlainTextWithPureKeyLevel() {
        XCTAssertTrue(ASLValidityChecker.isMetaDataValid(for: try ASLPlainText(polynomialString: "\(6)"), context: bfvContext(4096), allowPureKeyLevel: true))
        XCTAssertTrue(ASLValidityChecker.isMetaDataValid(for: try ASLPlainText(polynomialString: "\(6)"), context: bfvContext(1024), allowPureKeyLevel: true))
    }
    
    func testIsMetaDataValidForCipherText() {
        XCTAssertTrue(ASLValidityChecker.isMetaDataValid(for: encodeInt32(4, context: bfvContext(4096)), context: bfvContext(4096)))
        XCTAssertFalse(ASLValidityChecker.isMetaDataValid(for: encodeInt32(4, context: bfvContext(4096)), context: bfvContext(1024)))
    }
    
    func testIsMetaDataValidForCipherTextWithPureKeyLevels() {
        XCTAssertTrue(ASLValidityChecker.isMetaDataValid(for: encodeInt32(4, context: bfvContext(4096)), context: bfvContext(4096), allowPureKeyLevel: true))
        XCTAssertFalse(ASLValidityChecker.isMetaDataValid(for: encodeInt32(4, context: bfvContext(4096)), context: bfvContext(1024), allowPureKeyLevel: true))
    }
    
    func testIsMetaDataValidForSecretKey() {
        XCTAssertTrue(ASLValidityChecker.isMetaDataValid(for: keyGen(bfvContext(1024)).secretKey, context: bfvContext(1024)))
        XCTAssertFalse(ASLValidityChecker.isMetaDataValid(for: keyGen(bfvContext(4096)).secretKey, context: bfvContext(1024)))
    }
    
    func testIsMetaDataValidForPublicKey() {
        XCTAssertTrue(ASLValidityChecker.isMetaDataValid(for: keyGen(bfvContext(1024)).publicKey, context: bfvContext(1024)))
        XCTAssertFalse(ASLValidityChecker.isMetaDataValid(for: keyGen(bfvContext(4096)).publicKey, context: bfvContext(1024)))
    }
    
    func testIsMetaDataValidForKSwitchKeys() {
        XCTAssertFalse(ASLValidityChecker.isMetaDataValid(for: ASLKSwitchKeys(), context: bfvContext(1024)))
    }
    
    func testIsMetaDataValidForRelinearizationKeys() {
        XCTAssertTrue(ASLValidityChecker.isMetaDataValid(for: try keyGen(bfvContext(1024)).relinearizationKeys(), context: bfvContext(1024)))
        XCTAssertFalse(ASLValidityChecker.isMetaDataValid(for: try keyGen(bfvContext(4096)).relinearizationKeys(), context: bfvContext(1024)))
    }
    
    func testIsMetaDataValidForGaloisKeys() {
        XCTAssertTrue(ASLValidityChecker.isMetaDataValid(for: try keyGen(bfvContext(1024)).galoisKeys(), context: bfvContext(1024)))
        XCTAssertFalse(ASLValidityChecker.isMetaDataValid(for: try keyGen(bfvContext(4096)).galoisKeys(), context: bfvContext(1024)))
    }
    
    func testIsBufferValidForCipherText() throws {
        XCTAssertTrue(ASLValidityChecker.isBufferValid(for: encodeInt32(4, context: bfvContext(4096))))
        XCTAssertTrue(ASLValidityChecker.isBufferValid(for: encodeInt32(4, context: bfvContext(1024))))
    }
    
    func testIsBufferValidForSecretKey() throws {
        XCTAssertTrue(ASLValidityChecker.isBufferValid(for: keyGen(bfvContext(4096)).secretKey))
    }
    
    func testIsBufferValidForPublicKey() throws {
        XCTAssertTrue(ASLValidityChecker.isBufferValid(for: keyGen(bfvContext(4096)).publicKey))
    }
    
    func testIsBufferValidForKSwitchKey() throws {
        XCTAssertTrue(ASLValidityChecker.isBufferValid(for: ASLKSwitchKeys()))
    }
    
    func testIsBufferValidForRelinearizationKeys() throws {
        XCTAssertTrue(ASLValidityChecker.isBufferValid(for: try keyGen(bfvContext(4096)).relinearizationKeys()))
    }
    
    func testIsBufferValidForGaloisKeys() throws {
        XCTAssertTrue(ASLValidityChecker.isBufferValid(for: try keyGen(bfvContext(4096)).galoisKeys()))
    }
    
    func testIsDataValidForPlainText() throws {
        XCTAssertTrue(ASLValidityChecker.isDataValid(for: try ASLPlainText(polynomialString: "\(6)"), context: bfvContext(4096)))
    }
    
    func testIsDataValidForCipherText() throws {
        XCTAssertTrue(ASLValidityChecker.isDataValid(for: encodeInt32(4, context: bfvContext(4096)), context: bfvContext(4096)))
        XCTAssertFalse(ASLValidityChecker.isDataValid(for: encodeInt32(4, context: bfvContext(1024)), context: bfvContext(4096)))
    }
    
    func testIsDataValidForSecretKey() throws {
        XCTAssertTrue(ASLValidityChecker.isDataValid(for: keyGen(bfvContext(4096)).secretKey, context: bfvContext(4096)))
        XCTAssertTrue(ASLValidityChecker.isDataValid(for: keyGen(bfvContext(1024)).secretKey, context: bfvContext(4096)))
    }
    
    func testIsDataValidForPublicKey() throws {
        XCTAssertTrue(ASLValidityChecker.isDataValid(for: keyGen(bfvContext(4096)).publicKey, context: bfvContext(4096)))
        XCTAssertTrue(ASLValidityChecker.isDataValid(for: keyGen(bfvContext(1024)).publicKey, context: bfvContext(4096)))
    }
    
    func testIsDataValidForKSwitchKeys() throws {
        XCTAssertTrue(ASLValidityChecker.isDataValid(for: ASLKSwitchKeys(), context: bfvContext(4096)))
        XCTAssertTrue(ASLValidityChecker.isDataValid(for: ASLKSwitchKeys(), context: bfvContext(4096)))
    }
    
    func testIsDataValidForRelinearizationKeys() throws {
        XCTAssertTrue(ASLValidityChecker.isDataValid(for: try keyGen(bfvContext(4096)).relinearizationKeys(), context: bfvContext(4096)))
        XCTAssertTrue(ASLValidityChecker.isDataValid(for: try keyGen(bfvContext(1024)).relinearizationKeys(), context: bfvContext(4096)))
    }
    
    func testIsDataValidForGaloisKeys() throws {
        XCTAssertTrue(ASLValidityChecker.isDataValid(for: try keyGen(bfvContext(4096)).galoisKeys(), context: bfvContext(4096)))
        XCTAssertTrue(ASLValidityChecker.isDataValid(for: try keyGen(bfvContext(1024)).galoisKeys(), context: bfvContext(4096)))
    }
    
    func testIsValidForPlainText() throws {
        XCTAssertTrue(ASLValidityChecker.isValid(for: try ASLPlainText(polynomialString: "\(6)"), context: bfvContext(4096)))
    }
    
    func testIsValidForCipherText() throws {
        XCTAssertTrue(ASLValidityChecker.isValid(for: encodeInt32(4, context: bfvContext(4096)), context: bfvContext(4096)))
        XCTAssertFalse(ASLValidityChecker.isValid(for: encodeInt32(4, context: bfvContext(1024)), context: bfvContext(4096)))
    }
    
    func testIsValidForSecretKey() throws {
        XCTAssertTrue(ASLValidityChecker.isValid(for: keyGen(bfvContext(4096)).secretKey, context: bfvContext(4096)))
        XCTAssertFalse(ASLValidityChecker.isValid(for: keyGen(bfvContext(1024)).secretKey, context: bfvContext(4096)))
    }
    
    func testIsValidForPublicKey() throws {
        XCTAssertTrue(ASLValidityChecker.isValid(for: keyGen(bfvContext(4096)).publicKey, context: bfvContext(4096)))
        XCTAssertFalse(ASLValidityChecker.isValid(for: keyGen(bfvContext(1024)).publicKey, context: bfvContext(4096)))
    }
    
    func testIsValidForKSwitchKeys() throws {
        XCTAssertFalse(ASLValidityChecker.isValid(for: ASLKSwitchKeys(), context: bfvContext(4096)))
    }
    
    func testIsValidForRelinearizationKeys() throws {
         XCTAssertTrue(ASLValidityChecker.isValid(for: try keyGen(bfvContext(4096)).relinearizationKeys(), context: bfvContext(4096)))
    }
    
    func testIsValidForGaloisKeys() throws {
         XCTAssertTrue(ASLValidityChecker.isValid(for: try keyGen(bfvContext(4096)).galoisKeys(), context: bfvContext(4096)))
    }
    
    private func bfvContext(_ polyModulusDegree: Int) -> ASLSealContext {
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        try! parms.setPolynomialModulusDegree(polyModulusDegree)
        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try! parms.setPlainModulus(ASLSmallModulus(value: 1024))
        return try! ASLSealContext(parms)
    }
    
    private func keyGen(_ context: ASLSealContext) -> ASLKeyGenerator {
        try! ASLKeyGenerator(context: context)
    }
    
    private func encodeInt32(_ value: Int32, context: ASLSealContext) -> ASLCipherText {
        let keygen = keyGen(context)
        let publicKey = keygen.publicKey
        let encryptor = try! ASLEncryptor(context: context, publicKey: publicKey)
        let encoder = try! ASLIntegerEncoder(context: context)
        let plain = encoder.encodeInt32Value(value)
        return try! encryptor.encrypt(with: plain, destination: ASLCipherText())
    }
    
}
