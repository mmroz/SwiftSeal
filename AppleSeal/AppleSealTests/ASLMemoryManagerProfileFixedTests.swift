//
//  ASLMemoryManagerProfileFixedTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2019-12-31.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLMemoryManagerProfileFixedTests: XCTestCase {

	// MARK: - Tests
	
	func testCreationWithPoolInitializer() {
		XCTAssertNoThrow(try ASLMemoryManagerProfileFixed(pool: ASLMemoryPoolHandle.createNew(false)))
	}
	
	func testMemoryPoolHandle() {
		let profile = try! ASLMemoryManagerProfileFixed(pool: ASLMemoryPoolHandle.createNew(false))
		XCTAssertNotNil(profile.memoryPoolHandle)
	}
}
