//
//  ASLPlainTextTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-01-01.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLPlainTextTests: XCTestCase {

	// MARK: - Tests

	func testCreationWithDefaultInitializer() {
		let _ = ASLPlainText()
	}
	
	func testCreateWithMemoryPoolHandle() {
		let _ = ASLPlainText(pool: ASLMemoryPoolHandle.createNew(true))
	}
	
	func testCreateWithCoefficentCount() {
		XCTAssertNoThrow(try ASLPlainText(coefficientCount: 2))
		XCTAssertNoThrow(try ASLPlainText(coefficientCount: 2, pool: ASLMemoryPoolHandle.createNew(true)))
		
		XCTAssertThrowsError(try ASLPlainText(coefficientCount: -1))
		XCTAssertThrowsError(try ASLPlainText(coefficientCount: -1, pool: ASLMemoryPoolHandle.createNew(true)))
	}
	
	func testCreateWithCapacity() {
		XCTAssertNoThrow(try ASLPlainText(capacity: 1, coefficientCount: 1))
		XCTAssertNoThrow(try ASLPlainText(capacity: 1, coefficientCount: 1, pool: ASLMemoryPoolHandle.createNew(true)))
		
		XCTAssertThrowsError(try ASLPlainText(capacity: -1, coefficientCount: 1))
		XCTAssertThrowsError(try ASLPlainText(capacity: 1, coefficientCount: -1))
		XCTAssertThrowsError(try ASLPlainText(capacity: -1, coefficientCount: -1))
	}
	
	func testCreateWithPolynomial() {
		XCTAssertNoThrow(try ASLPlainText(polynomialString: ""))
		XCTAssertNoThrow(try ASLPlainText(polynomialString: "1"))
		XCTAssertNoThrow(try ASLPlainText(polynomialString: "a"))
		XCTAssertNoThrow(try ASLPlainText(polynomialString: "a", pool: ASLMemoryPoolHandle.createNew(true)))
	}
	
	func testZero() {
		let plainText = try! ASLPlainText(capacity: 2, coefficientCount: 2)
		XCTAssertTrue(plainText.isZero)
		
		XCTAssertThrowsError(try plainText.setZero(5))
		XCTAssertTrue(plainText.isZero)
		
		XCTAssertNoThrow(try plainText.setZero(1))
		XCTAssertTrue(plainText.isZero)
		
		XCTAssertNoThrow(try plainText.setZero(0, length: 2))
		XCTAssertTrue(plainText.isZero)
	}
	
	func testCapacity() {
		let plainText = try! ASLPlainText(capacity: 2, coefficientCount: 2)
		XCTAssertEqual(plainText.capacity, 2)
	}
	
	func testCoefficientCount() {
		let plainText = try! ASLPlainText(capacity: 2, coefficientCount: 2)
		XCTAssertEqual(plainText.coefficientCount, 2)
	}
	
	func testNonZeroCoefficientCount() {
		let plainText = try! ASLPlainText(capacity: 2, coefficientCount: 2)
		XCTAssertEqual(plainText.nonZeroCoefficientCount, 0)
	}
	
	func testParamaterIds() {
		let plainText = try! ASLPlainText(capacity: 2, coefficientCount: 2)
		XCTAssertEqual(plainText.parametersId, ASLParametersIdType(block: (0,0,0,0)))
	}
	
	func testScale() {
		let plainText = try! ASLPlainText(capacity: 2, coefficientCount: 2)
		XCTAssertEqual(plainText.scale, 1.0)
		
	}
	
	func testPool() {
		let plainText = try! ASLPlainText(capacity: 2, coefficientCount: 2)
		XCTAssertNoThrow(plainText.pool)
	}
	
	func testStringValue() {
		let plainText = try! ASLPlainText(capacity: 2, coefficientCount: 2)
		XCTAssertEqual(plainText.stringValue, "0")
	}
	
	func testReserve() {
		let plainText = try! ASLPlainText(capacity: 2, coefficientCount: 2)
		XCTAssertNoThrow(try plainText.reserve(2))
		XCTAssertThrowsError(try plainText.reserve(-1))
	}
	
	func testShrinkToFit() {
		let plainText = try! ASLPlainText(capacity: 2, coefficientCount: 2)
		XCTAssertNoThrow(plainText.shrinkToFit())
	}
	
	func testReturnToMemoryPool() {
		let plainText = try! ASLPlainText(capacity: 2, coefficientCount: 2)
		XCTAssertNoThrow(plainText.returnMemoryToPool())
	}
	
	func testResize() {
		let plainText = try! ASLPlainText(capacity: 2, coefficientCount: 2)
		XCTAssertNoThrow(try plainText.resize(5))
		XCTAssertThrowsError(try plainText.resize(-1))
	}
	
	func testEncoding() {
		// TODO
	}
}