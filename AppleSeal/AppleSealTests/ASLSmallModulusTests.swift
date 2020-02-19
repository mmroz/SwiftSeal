//
//  ASLSmallModulusTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLSmallModulusTests: XCTestCase {
	// MARK: - Tests

	func testCreationWithDefaultInitializer() {
		let _ = ASLSmallModulus()
	}
	
	func testCreationWithValueInitializer() {
		XCTAssertNoThrow(try! ASLSmallModulus(value: 2))
	}
	
	func testCreationWithInvalidValue() {
		XCTAssertThrowsError(try ASLSmallModulus(value: 1))
	//	XCTAssertThrowsError(try ASLSmallModulus(value: 63))
	}
	
	func testBitCount() {
		let smallModulus = try! ASLSmallModulus(value: 2)
		XCTAssertEqual(smallModulus.bitCount, 2)
	}
	
	func testUint64Count() {
		let smallModulus =  try! ASLSmallModulus(value: 2)
		XCTAssertEqual(smallModulus.uint64Count, 1)
	}
	
	func testData() {
//		let smallModulus =  try! ASLSmallModulus(value: 2)
//		smallModulus.data
//		XCTAssertTrue(false)
	}
	
	func testUInt64Value() {
		let smallModulus =  try! ASLSmallModulus(value: 2)
		XCTAssertEqual(smallModulus.uint64Value, 2)
	}
	
	func testIsZero() {
		let smallModulus = try! ASLSmallModulus(value: 2)
		XCTAssertFalse(smallModulus.isZero)
	}
	
	func testIsPrime() {
		let smallModulus = try! ASLSmallModulus(value: 4)
		XCTAssertFalse(smallModulus.isPrime)
	}
	
	func testConstRatio() {
		let constRation = try! ASLSmallModulus(value: 2).constRatio()
		
		XCTAssertEqual(constRation.floor, 0)
		XCTAssertEqual(constRation.remainder, 0)
		XCTAssertEqual(constRation.value, 9223372036854775808)
	}
	
	func testEncoding() {
		let smallModulus = try! ASLSmallModulus(value: 2)
		
		let archiver = NSKeyedArchiver(requiringSecureCoding: false)
		archiver.encode(smallModulus, forKey: "testObject")
		let data = archiver.encodedData

		let unarchiver = try! NSKeyedUnarchiver(forReadingFrom: data)
		unarchiver.requiresSecureCoding = false
		let decodedSmallModulus = unarchiver.decodeObject(of: ASLSmallModulus.self, forKey: "testObject")!

		XCTAssertEqual(smallModulus, decodedSmallModulus)
	}
}
