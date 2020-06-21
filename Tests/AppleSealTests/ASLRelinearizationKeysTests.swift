//
//  ASLRelinearizationKeysTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLRelinearizationKeysTests: XCTestCase {
	
	func testDefaultInitializer() {
		let _ = ASLRelinearizationKeys()
	}
	
	func testHasKey() {
		let relinearizationKeys = ASLRelinearizationKeys()
        XCTAssertFalse(try relinearizationKeys.hasKey(5) as! Bool)
	}
	
	func testGetIndex() {
		let relinearizationKeys = ASLRelinearizationKeys()
		XCTAssertEqual(try relinearizationKeys.getIndex(5), 3)
	}
	
	func testKey() {
		let relinearizationKeys = ASLRelinearizationKeys()
		let keys: [ASLPublicKey] = Array(repeating: ASLPublicKey(), count: 0)
		
		let relinearizationData: [ASLPublicKey] = relinearizationKeys.data as! [ASLPublicKey]
		XCTAssertEqual(relinearizationData, keys)
	}
	
	func testSize() {
		let relinearizationKeys = ASLRelinearizationKeys()
		XCTAssertEqual(relinearizationKeys.size, 0)
	}
	
	func testData() {
		let relinearizationKeys = ASLRelinearizationKeys()
		let matrix: [[ASLPublicKey]] = Array(repeating: Array(repeating: ASLPublicKey(), count: 0), count: 0)
		let dataMatrix: [[ASLPublicKey]] = relinearizationKeys.data as! [[ASLPublicKey]]
		XCTAssertEqual(dataMatrix, matrix)
	}
	
	func testParameterId() {
		let relinearizationKeys = ASLRelinearizationKeys()
		XCTAssertEqual(relinearizationKeys.parametersId, ASLParametersIdType(block: (0,0,0,0)))
	}
	
	func testPool() {
		let relinearizationKeys = ASLRelinearizationKeys()
		XCTAssertNoThrow(relinearizationKeys.pool)
	}
}

