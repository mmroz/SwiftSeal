//
//  ASLPlainModulusTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-01-19.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLPlainModulusTests: XCTestCase {
	func testBatching() throws {
		let modulus = try ASLPlainModulus.batching(8192, bitSize: 20)
		XCTAssertNotNil(modulus)
		XCTAssertEqual(try ASLModulus(value: 1032193), modulus)
	}
	
	func testBatchingWithBitSizes() throws {
		let modulus = try ASLPlainModulus.batching(8192, bitSizes: [20])
		XCTAssertNotNil(modulus)
		XCTAssertEqual([try ASLModulus(value: 1032193)], modulus)
	}
	
}
