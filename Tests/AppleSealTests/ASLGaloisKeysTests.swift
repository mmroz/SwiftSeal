//
//  ASLGaloisKeysTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLGaloisKeysTests: XCTestCase {
	
	func testDefaultInitializer() {
		let _ = ASLGaloisKeys()
	}
	
	func testHasKey() {
		let galoisKeys = ASLGaloisKeys()
        XCTAssertFalse(try galoisKeys.hasKey(3))
	}
	
	func testGetIndex() throws {
		let galoisKeys = ASLGaloisKeys()
		XCTAssertEqual(try galoisKeys.getIndex(5), 2)
	}
	
	func testKey() {
		let galoisKeys = ASLGaloisKeys()
		let keys: [ASLPublicKey] = Array(repeating: ASLPublicKey(), count: 0)
		
		let galoisData: [ASLPublicKey] = galoisKeys.data as! [ASLPublicKey]
		XCTAssertEqual(galoisData, keys)
	}
	
	func testSize() {
		let galoisKeys = ASLGaloisKeys()
		XCTAssertEqual(galoisKeys.size, 0)
	}
	
	func testData() {
		let galoisKeys = ASLGaloisKeys()
		let matrix: [[ASLPublicKey]] = Array(repeating: Array(repeating: ASLPublicKey(), count: 0), count: 0)
		let dataMatrix: [[ASLPublicKey]] = galoisKeys.data as! [[ASLPublicKey]]
		XCTAssertEqual(dataMatrix, matrix)
	}
	
	func testParameterIdool() {
		let galoisKeys = ASLGaloisKeys()
		XCTAssertEqual(galoisKeys.parametersId, ASLParametersIdType(block: (0,0,0,0)))
	}
	
	func testPool() {
		let galoisKeys = ASLGaloisKeys()
		XCTAssertNoThrow(galoisKeys.pool)
	}
}
