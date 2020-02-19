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
	
	func testBFVDefaults() {
//		XCTAssertEqual([try! ASLSmallModulus(value: 2)], ASLCoefficientModulus.bfvDefault(2))
	}
	
	func testBFVDefaultsWithSecurityLevel() {
//		XCTAssertEqual([ASLSmallModulus()], ASLCoefficientModulus.bfvDefault(5, securityLevel: .None))
//		XCTAssertEqual([ASLSmallModulus()], ASLCoefficientModulus.bfvDefault(5, securityLevel: .TC128))
//		XCTAssertEqual([ASLSmallModulus()], ASLCoefficientModulus.bfvDefault(5, securityLevel: .TC192))
//		XCTAssertEqual([ASLSmallModulus()], ASLCoefficientModulus.bfvDefault(5, securityLevel: .TC256))
	}
	
	func testCreate() {
//		XCTAssertEqual([ASLSmallModulus()], ASLCoefficientModulus.create(2, bitSizes: [2]))
	}
}
