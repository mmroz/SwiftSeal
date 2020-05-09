//
//  ASLBatchEncoderTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-03-14.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLBatchEncoderTests: XCTestCase {
    
    var batchEncoder: ASLBatchEncoder!
    
    override func setUp() {
        super.setUp()
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        let polyModulusDegree = 8192
        try! parms.setPolynomialModulusDegree(polyModulusDegree)
        
        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try! parms.setPlainModulus(ASLPlainModulus.batching(polyModulusDegree, bitSize: 20))
        
        let context = try! ASLSealContext(parms)
        self.batchEncoder = try! ASLBatchEncoder(context: context)
        
    }
    
    override func tearDown() {
        super.tearDown()
        batchEncoder = nil
    }
    
    // MARK: - Tests
    
    func testSlotCount() throws {
        XCTAssertEqual(batchEncoder.slotCount, 0)
    }
    
    func testEncodeWithUnsignedValues() throws {
        let encodedPlainText = try batchEncoder.encode(withUnsignedValues: [NSNumber(4)], destination: ASLPlainText())
        let decoded = try batchEncoder.decode(with: encodedPlainText, unsignedDestination: [])
        let value = try XCTUnwrap(decoded.first)
        XCTAssertEqual(NSNumber(4), value)
    }
    
    func testEncodeWithSignedValues() throws {
        let encodedPlainText = try batchEncoder.encode(withSignedValues: [NSNumber(4)], destination: ASLPlainText())
        let decoded = try batchEncoder.decode(with: encodedPlainText, unsignedDestination: [])
        let value = try XCTUnwrap(decoded.first)
        XCTAssertEqual(NSNumber(4), value)
    }
    
    func testEncoderWithPlainText() throws {
        let plainText = try ASLPlainText(coefficientCount: 2)
        let encoded = try batchEncoder.encode(with: plainText)
        let decoded = try batchEncoder.decode(with: encoded, unsignedDestination: [])
        let value = try XCTUnwrap(decoded.first)
        XCTAssertEqual(NSNumber(0), value)
    }
    
    func testEncodeWithPlainTextAndPool() throws {
        let plainText = try ASLPlainText(coefficientCount: 2)
        let encoded = try batchEncoder.encode(with: plainText, pool: ASLMemoryPoolHandle.global())
        let decoded = try batchEncoder.decode(with: encoded, unsignedDestination: [])
        let value = try XCTUnwrap(decoded.first)
        XCTAssertEqual(NSNumber(0), value)
    }
    
    func testUnsignedIntArray() throws {
        let encodedPlainText = try batchEncoder.encode(withUnsignedValues: [NSNumber(4)], destination: ASLPlainText())
        let decoded = try batchEncoder.decode(with: encodedPlainText, unsignedDestination: [])
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
