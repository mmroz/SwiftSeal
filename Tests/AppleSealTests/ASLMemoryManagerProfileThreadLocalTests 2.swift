//
//  ASLMemoryManagerProfileThreadLocalTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2019-12-31.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLMemoryManagerProfileThreadLocalTests: XCTestCase {

	// MARK: - Tests

	func testCreationWithDefaultInitializer() {
		XCTAssertNoThrow(ASLMemoryManagerProfileThreadLocal())
	}
	
	func testMemoryPoolHandle() {
		let profile = ASLMemoryManagerProfileThreadLocal()
		XCTAssertNotNil(profile.memoryPoolHandle)
	}
}
