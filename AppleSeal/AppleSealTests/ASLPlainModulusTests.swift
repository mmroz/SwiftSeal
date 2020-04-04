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
		let smallModulus = try ASLPlainModulus.batching(1, bitSize: 2)
		XCTAssertNotNil(smallModulus)
		XCTAssertEqual(ASLSmallModulus(), smallModulus)
	}
	
	func testBatchingWithBitSizes() throws {
		let smallModulus = try ASLPlainModulus.batching(1, bitSizes: [1])
		XCTAssertNotNil(smallModulus)
		XCTAssertEqual([ASLSmallModulus](), smallModulus)
	}
	
}
