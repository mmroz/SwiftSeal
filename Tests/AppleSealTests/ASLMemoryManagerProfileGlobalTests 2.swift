//
//  ASLMemoryManagerProfileGlobalTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2019-12-30.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLMemoryManagerProfileGlobalTests: XCTestCase {

	// MARK: - Tests

	func testCreationWithDefaultInitializer() {
		let _ = ASLMemoryManagerProfileGlobal()
	}
	
	func testMemoryPoolHandle() {
		let profile = ASLMemoryManagerProfileGlobal()
		XCTAssertNotNil(profile.memoryPoolHandle)
	}
}
