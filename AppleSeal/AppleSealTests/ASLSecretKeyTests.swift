//
//  ASLSecretKeyTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-01-11.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLSecretKeyTests: XCTestCase {
	
	func testDefaultInitializer() {
		let _ = ASLSecretKey()
	}
	
	func testSecretKeyParameters() {
		let secretKey = ASLSecretKey()
		XCTAssertEqual(secretKey.parametersId, ASLParametersIdType(block: (0,0,0,0)))
	}
	
	func testSecretKeyMemoryPoolHandle() {
		let secretKey = ASLSecretKey()
		XCTAssertEqual(secretKey.plainTextData, ASLPlainText())
	}
}