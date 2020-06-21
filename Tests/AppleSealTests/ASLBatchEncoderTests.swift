//
//  ASLBatchEncoderTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-03-14.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

final class ASLBatchEncoderTests: XCTestCase {
    
    private var batchEncoder: ASLBatchEncoder!
    private var encryptor: ASLEncryptor!
    private var decryptor: ASLDecryptor!
    
    override func setUp() {
        super.setUp()
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        
        let polyModulusDegree = 8192
        try! parms.setPolynomialModulusDegree(polyModulusDegree)
        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try! parms.setPlainModulus(ASLPlainModulus.batching(polyModulusDegree, bitSize: 20))
        
        let context = try! ASLSealContext(parms)
        let keygen = try! ASLKeyGenerator(context: context)
        let publicKey = keygen.publicKey
        let secretKey = keygen.secretKey
        
        encryptor = try! ASLEncryptor(context: context, publicKey: publicKey)
        decryptor = try! ASLDecryptor(context: context, secretKey: secretKey)
        batchEncoder = try! ASLBatchEncoder(context: context)
    }
    
    override func tearDown() {
        super.tearDown()
        batchEncoder = nil
        encryptor = nil
        decryptor = nil
    }
    
    // MARK: - Tests
    
    func testSlotCount() throws {
        XCTAssertEqual(batchEncoder.slotCount, 8192)
    }
    
    func testEncodeWithUnsignedValues() throws {
        let podMatrix: [NSNumber] = [ 0, 1, 2, 3, 4, 5, 6, 7 ]
        let encodedPlainText = try batchEncoder.encode(withUnsignedValues: podMatrix)
        let decoded = try batchEncoder.decodeUnsignedValues(with: encodedPlainText)
        
        podMatrix.forEach { entry in
            if !decoded.contains(entry) {
                XCTFail("Missing decoded value")
            }
        }
    }
    
    func testEncodeWithSignedValues() throws {
        let encodedPlainText = try batchEncoder.encode(withSignedValues: [NSNumber(4)])
        let decoded = try batchEncoder.decodeSignedValues(with: encodedPlainText)
        XCTAssertTrue(decoded.contains(NSNumber(4)))
    }
    
    func testEncoderWithPlainText() throws {
        let encodedPlainText = try batchEncoder.encode(withSignedValues: [NSNumber(4)])
        let encoded = try batchEncoder.encode(with: encodedPlainText)
        let decodedPlainText = try batchEncoder.decode(with: encoded)
        let decodedValues = try batchEncoder.decodeSignedValues(with: decodedPlainText)
        XCTAssertTrue(decodedValues.contains(NSNumber(4)))
    }
    
    func testEncodeWithPlainTextAndPool() throws {
        let plainText = try ASLPlainText(coefficientCount: 2)
        let encoded = try batchEncoder.encode(with: plainText, pool: ASLMemoryPoolHandle.global())
        let decoded = try batchEncoder.decodeSignedValues(with: encoded)
        let value = try XCTUnwrap(decoded.first)
        XCTAssertEqual(NSNumber(0), value)
    }
    
    func testUnsignedIntArray() throws {
        let encodedPlainText = try batchEncoder.encode(withUnsignedValues: [NSNumber(4)])
        let decoded = try batchEncoder.decodeUnsignedValues(with: encodedPlainText)
        let value = try XCTUnwrap(decoded.first)
        XCTAssertEqual(NSNumber(4), value)
    }
    
    func testDecodeWithPlainText() throws {
        let encodedPlainText = try batchEncoder.encode(with: ASLPlainText(coefficientCount: 2))
        
        let decoded = try batchEncoder.decode(with: encodedPlainText)
        XCTAssertEqual(try ASLPlainText(coefficientCount: 2), decoded)
    }
    
    func testDecodeWithPlainTextAndPool() throws {
        let encodedPlainText = try batchEncoder.encode(with: ASLPlainText(coefficientCount: 2))
        
        let decoded = try batchEncoder.decode(with: encodedPlainText, pool: ASLMemoryPoolHandle.global())
        XCTAssertEqual(try ASLPlainText(coefficientCount: 2), decoded)
    }
}
