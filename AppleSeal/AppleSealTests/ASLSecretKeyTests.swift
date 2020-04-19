//
//  ASLSecretKeyTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-01-11.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLSecretKeyTests: XCTestCase {
	
	func testDefaultInitializer() {
		let _ = ASLSecretKey()
	}
	
	func testSecretKeyParameters() {
		let secretKey = ASLSecretKey()
		XCTAssertEqual(secretKey.parametersId, ASLParametersIdType(block: (0,0,0,0)))
	}
	
	func testSecretKeyMemoryPoolHandle() {
		let secretKey = ASLSecretKey()
		XCTAssertEqual(secretKey.plainTextData, ASLPlainText())
	}
    
    func testCoding() throws {
        let secretKey = ASLSecretKey()
        
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        archiver.encode(secretKey, forKey: "testObject")
        let data = archiver.encodedData
        
        let decodedSecretKey = try ASLSecretKey(data: data, context: ASLSealContext())

        XCTAssertEqual(secretKey, decodedSecretKey)
    }
}
