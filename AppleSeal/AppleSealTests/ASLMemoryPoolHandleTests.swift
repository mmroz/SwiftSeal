//
//  ASLMemoryPoolHandleTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2019-12-30.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLMemoryPoolHandleTests: XCTestCase {

	// MARK: - Tests
	
	func testGlobal() {
		XCTAssertNoThrow(ASLMemoryPoolHandle.global)
	}
	
	func testThreadLocal() {
		XCTAssertNoThrow(ASLMemoryPoolHandle.threadLocal)
	}
	
	func testCreateNew() {
		XCTAssertNoThrow(ASLMemoryPoolHandle.createNew(true))
		XCTAssertNoThrow(ASLMemoryPoolHandle.createNew(false))
	}
	
	func testIsInitialized() {
		XCTAssertTrue(ASLMemoryPoolHandle.createNew(true).isInitialized)
		XCTAssertTrue(ASLMemoryPoolHandle.createNew(false).isInitialized)
	}
	
}
