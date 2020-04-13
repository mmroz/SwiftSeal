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
    
    func testEncoding() {
        let bigUInt = ASLSecretKey()
        
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        archiver.encode(bigUInt, forKey: "testObject")
        let data = archiver.encodedData

        let unarchiver = try! NSKeyedUnarchiver(forReadingFrom: data)
        unarchiver.requiresSecureCoding = false
        let decodedBigUInt = unarchiver.decodeObject(of: ASLSecretKey.self, forKey: "testObject")!

        XCTAssertEqual(bigUInt, decodedBigUInt)
    }
}
