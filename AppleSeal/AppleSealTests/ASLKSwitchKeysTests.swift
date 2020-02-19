//
//  ASLKSwitchKeysTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLKSwitchKeysTests: XCTestCase {
	
	func testDefaultInitializer() {
		let _ = ASLKSwitchKeys()
	}
	
	func testSize() {
		let kSwitchKeys = ASLKSwitchKeys()
		XCTAssertEqual(kSwitchKeys.size, 0)
	}
	
	func testData() {
		let kSwitchKeys = ASLKSwitchKeys()
		let matrix: [[ASLPublicKey]] = Array(repeating: Array(repeating: ASLPublicKey(), count: 0), count: 0)
		let dataMatrix: [[ASLPublicKey]] = kSwitchKeys.data as! [[ASLPublicKey]]
		XCTAssertEqual(dataMatrix, matrix)
	}
	
	func testParameterIdool() {
		let kSwitchKeys = ASLKSwitchKeys()
		XCTAssertEqual(kSwitchKeys.parametersId, ASLParametersIdType(block: (0,0,0,0)))
	}
	
	func testPool() {
		let kSwitchKeys = ASLKSwitchKeys()
		XCTAssertNoThrow(kSwitchKeys.pool)
	}
	
	// TODO - add coding tests
}
