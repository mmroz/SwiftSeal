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
    
    func testEncoding() throws {
        let secretKey = ASLPublicKey()
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        XCTAssertNoThrow(archiver.encode(secretKey, forKey: "testObject"))
    }
    
    func testCoding() throws {
        let secretKey = ASLPublicKey()
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        archiver.encode(secretKey, forKey: "testObject")
        let data = archiver.encodedData
        let decodedSecretKey = try ASLPublicKey(data: data, context: .bfvDefault())
        XCTAssertEqual(secretKey, decodedSecretKey)
    }
    
    func context() throws -> ASLSealContext {
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        let polyModulusDegree = 4096
        try parms.setPolynomialModulusDegree(polyModulusDegree)
        try parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try parms.setPlainModulus(ASLModulus(value: 1024))
        return try ASLSealContext(parms)
    }
}
