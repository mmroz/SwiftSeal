//
//  ASLComplexTypeTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-01-10.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLComplexTypeTests: XCTestCase {

	// MARK: - Tests

	func testCreationWithRealAndImaginaryDoubles() {
		let complexType = ASLComplexType(real: 5.0, imaginary: 5.0)
		XCTAssertEqual(complexType.real, 5.0)
		XCTAssertEqual(complexType.imaginary, 5.0)
	}
}
