//
//  ASLValidityCheckerTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-01-19.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLValidityCheckerTests: XCTestCase {
	
	func testValidMetaDataWithPlainText() {
		let plain = try! ASLPlainText(capacity: 2, coefficientCount: 2)
		
		XCTAssertFalse(ASLValidityChecker.isMetaDataValid(for: plain, context: createContext(), allowPureKeyLevel: true))
		
		XCTAssertFalse(ASLValidityChecker.isMetaDataValid(for: plain, context: createContext()))
	}
	
	// TODO - add the remaining tests
	
	func createContext() -> ASLSealContext {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .CKKS)
		let context = try! ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true, securityLevel: .None, memoryPoolHandle: ASLMemoryPoolHandle(clearOnDestruction: true))
		return context
	}
	
}
