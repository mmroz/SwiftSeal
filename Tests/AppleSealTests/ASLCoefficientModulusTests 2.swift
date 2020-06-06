//
//  ASLCoefficientModulusTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLCoefficientModulusTests: XCTestCase {
    
    func testMaxBitCount() {
        XCTAssertEqual(0, ASLCoefficientModulus.maxBitCount(8))
    }
    
    func testMaxBitCountWithSecurtityLevels() {
        XCTAssertEqual(2147483647, ASLCoefficientModulus.maxBitCount(5, securityLevel: .None))
        XCTAssertEqual(0, ASLCoefficientModulus.maxBitCount(256, securityLevel: .TC128))
        XCTAssertEqual(0, ASLCoefficientModulus.maxBitCount(256, securityLevel: .TC192))
        XCTAssertEqual(0, ASLCoefficientModulus.maxBitCount(256, securityLevel: .TC256))
    }
    
    func testBFVDefaults() throws {
        let expectedResults = [
            try ASLModulus(value: 8796092858369),
            try ASLModulus(value: 8796092792833),
            try ASLModulus(value: 17592186028033),
            try ASLModulus(value: 17592185438209),
            try ASLModulus(value: 17592184717313)
        ]
        
        XCTAssertEqual(expectedResults, try ASLCoefficientModulus.bfvDefault(8192))
    }
    
    func testBFVDefaultWithInvalidSecurityLevel() throws {
        XCTAssertThrowsError(try ASLCoefficientModulus.bfvDefault(8192, securityLevel: .None))
    }
    
    func testBFVDefaultsWithSecurityLevel() throws {
        let expectedTC128Results = [
            try ASLModulus(value: 8796092858369),
            try ASLModulus(value: 8796092792833),
            try ASLModulus(value: 17592186028033),
            try ASLModulus(value: 17592185438209),
            try ASLModulus(value: 17592184717313)
        ]
        
        XCTAssertEqual(expectedTC128Results, try ASLCoefficientModulus.bfvDefault(8192, securityLevel: .TC128))
        
        let expectedTC192Results = [
            try ASLModulus(value: 274877562881),
            try ASLModulus(value: 274877202433),
            try ASLModulus(value: 274877153281),
            try ASLModulus(value: 274877022209)
        ]
        
        
        XCTAssertEqual(expectedTC192Results, try ASLCoefficientModulus.bfvDefault(8192, securityLevel: .TC192))
        
        let expectedTC256Results = [
            try ASLModulus(value: 549755731969),
            try ASLModulus(value: 549755486209),
            try ASLModulus(value: 1099511480321)
        ]
        
        XCTAssertEqual(expectedTC256Results, try ASLCoefficientModulus.bfvDefault(8192, securityLevel: .TC256))
    }
    
    func testBFVDefaultThrowsWithNonStandardDegree() throws {
        XCTAssertThrowsError(try ASLCoefficientModulus.bfvDefault(5))
    }
    
    func testCreate() throws {
        XCTAssertEqual([], try ASLCoefficientModulus.create(8192, bitSizes: []))
    }
    
    func testCreateWithInvalidValue() throws {
        XCTAssertThrowsError(try ASLCoefficientModulus.create(5, bitSizes: []))
    }
    
    func testCreateWithInvalidBitSizes() throws {
        XCTAssertThrowsError(try ASLCoefficientModulus.create(8192, bitSizes: [100]))
    }
}
