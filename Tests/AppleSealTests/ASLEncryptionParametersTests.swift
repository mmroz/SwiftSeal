//
//  ASLEncryptionParametersTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2019-12-30.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLEncryptionParametersTests: XCTestCase {

	// MARK: - Tests
	
	func testCreationWithDefaultInitializer() {
		let _ = ASLEncryptionParameters()
	}
	
	func testCreationWithSchemeTypeInitializer() {
		let _ = ASLEncryptionParameters(schemeType: .none)
		let _ = ASLEncryptionParameters(schemeType: .BFV)
		let _ = ASLEncryptionParameters(schemeType: .CKKS)
	}
	
	func testCreationWithSchemeInitializer() {
		XCTAssertNoThrow(try ASLEncryptionParameters(scheme: 0))
		XCTAssertNoThrow(try ASLEncryptionParameters(scheme: 1))
		XCTAssertNoThrow(try ASLEncryptionParameters(scheme: 2))
		XCTAssertThrowsError(try ASLEncryptionParameters(scheme: 3))
		XCTAssertThrowsError(try ASLEncryptionParameters(scheme: .max))
	}
	
	func testSchemes() {
		let none = ASLEncryptionParameters(schemeType: .none)
		XCTAssertEqual(none.scheme, ASLSchemeType.none)
		let bfv = ASLEncryptionParameters(schemeType: .BFV)
		XCTAssertEqual(bfv.scheme, ASLSchemeType.BFV)
		let ckks = ASLEncryptionParameters(schemeType: .CKKS)
		XCTAssertEqual(ckks.scheme, ASLSchemeType.CKKS)
	}
	
	func testPolyModulus() {
		let bfv = ASLEncryptionParameters(schemeType: .BFV)
		XCTAssertEqual(bfv.polynomialModulusDegree, 0)
		XCTAssertNoThrow(try bfv.setPolynomialModulusDegree(1024))
		
		let ckks = ASLEncryptionParameters(schemeType: .CKKS)
		XCTAssertEqual(ckks.polynomialModulusDegree, 0)
		XCTAssertNoThrow(try ckks.setPolynomialModulusDegree(1024))
		
		let none = ASLEncryptionParameters(schemeType: .none)
		XCTAssertEqual(none.polynomialModulusDegree, 0)
		XCTAssertThrowsError(try none.setPolynomialModulusDegree(1024))
	}
	
	func testPlainModulus() {
		let bfv = ASLEncryptionParameters(schemeType: .BFV)
		XCTAssertEqual(bfv.plainModulus, try! ASLModulus(value: 0))
		XCTAssertNoThrow(try bfv.setPlainModulus(try! ASLModulus(value: 1024)))
		XCTAssertEqual(bfv.plainModulus, try! ASLModulus(value: 1024))
		
		let ckks = ASLEncryptionParameters(schemeType: .CKKS)
		XCTAssertEqual(ckks.plainModulus, try! ASLModulus(value: 0))
		XCTAssertThrowsError(try ckks.setPlainModulus(try! ASLModulus(value: 1024)))
		XCTAssertEqual(ckks.plainModulus, try! ASLModulus(value: 0))
		
		let none = ASLEncryptionParameters(schemeType: .none)
		XCTAssertEqual(none.plainModulus, try! ASLModulus(value: 0))
		XCTAssertThrowsError(try none.setPlainModulus(try! ASLModulus(value: 1024)))
		XCTAssertEqual(none.plainModulus, try! ASLModulus(value: 0))
	}
	
	func testSetPlainModulusWithInteger() {
		let bfv = ASLEncryptionParameters(schemeType: .BFV)
		XCTAssertEqual(bfv.plainModulus, try! ASLModulus(value: 0))
		XCTAssertNoThrow(try bfv.setPlainModulusWithInteger(1024))
		XCTAssertEqual(bfv.plainModulus, try! ASLModulus(value: 1024))
		
		let ckks = ASLEncryptionParameters(schemeType: .CKKS)
		XCTAssertEqual(ckks.plainModulus, try! ASLModulus(value: 0))
		XCTAssertNoThrow(try ckks.setPlainModulusWithInteger(0))
		XCTAssertEqual(ckks.plainModulus, try! ASLModulus(value: 0))
		
		let none = ASLEncryptionParameters(schemeType: .none)
		XCTAssertEqual(none.plainModulus, try! ASLModulus(value: 0))
		XCTAssertNoThrow(try none.setPlainModulusWithInteger(0))
		XCTAssertEqual(none.plainModulus, try! ASLModulus(value: 0))
	}
	
	func testCoefficientModulus() {
		let bfv = ASLEncryptionParameters(schemeType: .BFV)
		XCTAssertEqual(bfv.coefficientModulus, NSArray())
		XCTAssertNoThrow(try bfv.setCoefficientModulus([try! ASLModulus(value: 0)]))
		XCTAssertEqual(bfv.coefficientModulus, NSArray(objects: try! ASLModulus(value: 0)))
		
		let ckks = ASLEncryptionParameters(schemeType: .CKKS)
		XCTAssertEqual(ckks.coefficientModulus, NSArray())
		XCTAssertNoThrow(try ckks.setCoefficientModulus([try! ASLModulus(value: 0)]))
		XCTAssertEqual(ckks.coefficientModulus, NSArray(objects: try! ASLModulus(value: 0)))
		
		let none = ASLEncryptionParameters(schemeType: .none)
		XCTAssertEqual(none.coefficientModulus, NSArray())
		XCTAssertThrowsError(try none.setCoefficientModulus([try! ASLModulus(value: 0)]))
		XCTAssertEqual(none.coefficientModulus, NSArray())
	}
	
	func testEncoding() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .CKKS)
		try! encryptionParameters.setCoefficientModulus([try! ASLModulus(value: 0)])
		
		let archiver = NSKeyedArchiver(requiringSecureCoding: false)
		archiver.encode(encryptionParameters, forKey: "testObject")
		let data = archiver.encodedData

		let unarchiver = try! NSKeyedUnarchiver(forReadingFrom: data)
		unarchiver.requiresSecureCoding = false
		let decodedEncryptionParameters = unarchiver.decodeObject(of: ASLEncryptionParameters.self, forKey: "testObject")!

		XCTAssertEqual(encryptionParameters, decodedEncryptionParameters)
	}
}
