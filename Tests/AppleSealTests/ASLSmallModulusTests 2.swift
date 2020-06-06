//
//  ASLModulusTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLModulusTests: XCTestCase {
	// MARK: - Tests

	func testCreationWithDefaultInitializer() {
		let _ = ASLModulus()
	}
	
	func testCreationWithValueInitializer() {
		XCTAssertNoThrow(try! ASLModulus(value: 2))
	}
	
	func testCreationWithInvalidValue() {
		XCTAssertThrowsError(try ASLModulus(value: 1))
	//	XCTAssertThrowsError(try ASLModulus(value: 63))
	}
	
	func testBitCount() {
		let modulus = try! ASLModulus(value: 2)
		XCTAssertEqual(modulus.bitCount, 2)
	}
	
	func testUint64Count() {
		let modulus =  try! ASLModulus(value: 2)
		XCTAssertEqual(modulus.uint64Count, 1)
	}
	
	func testData() {
//		let modulus =  try! ASLModulus(value: 2)
//		modulus.data
//		XCTAssertTrue(false)
	}
	
	func testUInt64Value() {
		let modulus =  try! ASLModulus(value: 2)
		XCTAssertEqual(modulus.uint64Value, 2)
	}
	
	func testIsZero() {
		let modulus = try! ASLModulus(value: 2)
		XCTAssertFalse(modulus.isZero)
	}
	
	func testIsPrime() {
		let modulus = try! ASLModulus(value: 4)
		XCTAssertFalse(modulus.isPrime)
	}
	
	func testConstRatio() {
		let constRation = try! ASLModulus(value: 2).constRatio()
		
		XCTAssertEqual(constRation.floor, 0)
		XCTAssertEqual(constRation.remainder, 0)
		XCTAssertEqual(constRation.value, 9223372036854775808)
	}
	
	func testEncoding() {
		let modulus = try! ASLModulus(value: 2)
		
		let archiver = NSKeyedArchiver(requiringSecureCoding: false)
		archiver.encode(modulus, forKey: "testObject")
		let data = archiver.encodedData

		let unarchiver = try! NSKeyedUnarchiver(forReadingFrom: data)
		unarchiver.requiresSecureCoding = false
		let decodedModulus = unarchiver.decodeObject(of: ASLModulus.self, forKey: "testObject")!

		XCTAssertEqual(modulus, decodedModulus)
	}
}
