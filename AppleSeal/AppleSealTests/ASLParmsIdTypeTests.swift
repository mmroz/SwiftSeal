//
//  ASLParmsIdTypeTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2019-12-31.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

extension ASLParametersIdType: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		return ASLParametersIdTypeIsEqual(lhs, rhs)
	}
}

class ASLParmsIdTypeTests: XCTestCase {

	// MARK: - Tests

	func testCreationWithDefaultInitializer() {
		let _ = ASLParametersIdType()
	}
	
	func testCreateWithValue() {
		let _ = ASLParametersIdType(block: (0,0,0,0))
	}
	
	func testEquality() {
		let first = ASLParametersIdType(block: (0,0,0,0))
		let second = ASLParametersIdType(block: (0,0,0,0))
		
		XCTAssertEqual(first, second)
		
		let third = ASLParametersIdType(block: (2,0,0,0))
		let fourth = ASLParametersIdType(block: (0,2,0,0))
		
		XCTAssertNotEqual(third, fourth)
	}
}
