//
//  ASLMemoryManagerTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2019-12-31.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLMemoryManagerTests: XCTestCase {

	// MARK: - Tests

	func testCreationWithDefaultInitializer() {
		let _ = ASLMemoryManager()
	}

	func testSwitchProfile() {
		let manager = ASLMemoryManager()
		manager.switch(ASLMemoryManagerProfileGlobal())
		manager.switch(try! ASLMemoryManagerProfileFixed(pool: ASLMemoryPoolHandle(clearOnDestruction: true)))
		manager.switch(ASLMemoryManagerProfileThreadLocal())
	}
	
	func testMemoryPool() {
		let manager = ASLMemoryManager()
		manager.memoryPoolHandle(with: .Default, clearOnDestruction: true)
		manager.memoryPoolHandle(with: .ForcedGlobal, clearOnDestruction: true)
		manager.memoryPoolHandle(with: .ForceNew, clearOnDestruction: true)
		manager.memoryPoolHandle(with: .ForceThreadLocal, clearOnDestruction: true)
		
		manager.memoryPoolHandle(with: .Default, clearOnDestruction: false)
		manager.memoryPoolHandle(with: .ForcedGlobal, clearOnDestruction: false)
		manager.memoryPoolHandle(with: .ForceNew, clearOnDestruction: false)
		manager.memoryPoolHandle(with: .ForceThreadLocal, clearOnDestruction: false)
	}
}
