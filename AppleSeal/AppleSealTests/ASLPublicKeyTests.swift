//
//  ASLPublicKeyTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-01-11.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLPublicKeyTests: XCTestCase {
	
	func testDefaultInitializer() {
		let _ = ASLPublicKey()
	}
	
	func testSecretKeyParameters() {
		let publicKey = ASLPublicKey()
		XCTAssertEqual(publicKey.parametersId, ASLParametersIdType(block: (0,0,0,0)))
	}
	
	func testSecretKeyMemoryPoolHandle() {
		let publicKey = ASLPublicKey()
		XCTAssertNoThrow(publicKey.cipherTextData)
	}
}
