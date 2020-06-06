//
//  ASLIntegerEncoderTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-03-27.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//
import AppleSeal
import XCTest

final class ASLIntegerEncoderTests: XCTestCase {
    private var encoder: ASLIntegerEncoder! = nil
    
    override func setUp() {
        super.setUp()
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        let polyModulusDegree = 4096
        try! parms.setPolynomialModulusDegree(polyModulusDegree)
        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try! parms.setPlainModulus(ASLModulus(value: 512))
        let context = try! ASLSealContext(parms)
        encoder = try! ASLIntegerEncoder(context: context)
    }
    
    override func tearDown() {
        super.tearDown()
        encoder = nil
    }
    
    func testEncodeUInt64() throws {
        let plain = encoder.encodeUInt64Value(4)
        XCTAssertEqual(plain, try ASLPlainText(polynomialString: "1x^2"))
    }
    
    func testEncodeUInt64WithDestination() throws {
        let plain = encoder.encodeUInt64Value(4, destination: ASLPlainText())
        XCTAssertEqual(plain, try ASLPlainText(polynomialString: "1x^2"))
    }
    
    func testDecodeUInt32() throws {
        let plain = encoder.encodeUInt64Value(4)
        let result = try encoder.decodeUInt32(withPlain: plain)
        
        XCTAssertEqual(4, result)
    }
    
    func testDecodeUInt64() throws {
        let plain = encoder.encodeUInt64Value(4)
        let result = try encoder.decodeUInt64(withPlain: plain)
        
        XCTAssertEqual(4, result)
    }
    
    func testEncodeInt64() throws {
        let plain = encoder.encodeInt64Value(4)
        let result = try encoder.decodeInt64(withPlain: plain)
        
        XCTAssertEqual(4, result)
    }
    
    func testEncodeInt64WithDestination() throws {
        let plain = encoder.encodeInt64Value(4, destination: ASLPlainText())
        let result = try encoder.decodeInt64(withPlain: plain)
        
        XCTAssertEqual(4, result)
    }
    
    func testEncodeBigUInt() throws {
        let bigUInt = ASLBigUInt()
        let plain = encoder.encode(bigUInt)
        let result = try encoder.decodeBigUInt(withPlain: plain)
        
        XCTAssertEqual(bigUInt, result)
    }
    
    func testEncodeInt32() throws {
        let plain = encoder.encodeInt32Value(4)
        let result = try encoder.decodeInt32(withPlain: plain)
        
        XCTAssertEqual(4, result)
    }
    
    func testEncodeUInt32ValueWithDestination() throws {
        let plain = encoder.encodeUInt32Value(4, destination: ASLPlainText())
        let result = try encoder.decodeUInt32(withPlain: plain)
        XCTAssertEqual(4, result)
    }
    
    func testEncodeInt32Value() throws {
           let plain = encoder.encodeInt32Value(4)
           let result = try encoder.decodeInt32(withPlain: plain)
           XCTAssertEqual(4, result)
       }
    
    func testEncodeInt32ValueWithDestination() throws {
        let plain = encoder.encodeInt32Value(4, destination: ASLPlainText())
        let result = try encoder.decodeInt32(withPlain: plain)
        XCTAssertEqual(4, result)
    }
    
}



