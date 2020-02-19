//
//  ASLSealContextTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2019-12-30.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLSealContextTests: XCTestCase {

	// MARK: - Tests

	func testCreationWithDefaultInitializer() {
		XCTAssertNoThrow(ASLSealContext())
	}
	
	func testCreateWithEncryptionParams() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .CKKS)
		XCTAssertNoThrow(try ASLSealContext(encrytionParameters: encryptionParameters))
	}
	
	func testCreateWithExpandModChain() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .CKKS)
		XCTAssertNoThrow(try ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true))
		XCTAssertNoThrow(try ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: false))
	}
	
	func  testCreateWithSecurityLevel() {
		XCTAssertNoThrow(try ASLSealContext(encrytionParameters: createEncryptionParameters(), expandModChain: true, securityLevel: .None))
		XCTAssertNoThrow(try ASLSealContext(encrytionParameters: createEncryptionParameters(), expandModChain: true, securityLevel: .TC128))
		XCTAssertNoThrow(try ASLSealContext(encrytionParameters: createEncryptionParameters(), expandModChain: true, securityLevel: .TC192))
		XCTAssertNoThrow(try ASLSealContext(encrytionParameters: createEncryptionParameters(), expandModChain: true, securityLevel: .TC256))
	}
	
	func testWithParametersAndSecurityLevel() {
		XCTAssertNoThrow(try ASLSealContext(encrytionParameters: createEncryptionParameters(), securityLevel: .TC128))
		XCTAssertNoThrow(try ASLSealContext(encrytionParameters: createEncryptionParameters(), securityLevel: .TC192))
		XCTAssertNoThrow(try ASLSealContext(encrytionParameters: createEncryptionParameters(), securityLevel: .TC256))
		XCTAssertNoThrow(try ASLSealContext(encrytionParameters: createEncryptionParameters(), securityLevel: .None))
	}
	
	func testKeyContextData() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .CKKS)
		let context  = try! ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true)
		
		XCTAssertNoThrow(context.keyContextData)
	}
	
	func testFirstContext() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .CKKS)
		let context  = try! ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true)
		
		XCTAssertNoThrow(context.firstContextData)
	}
	
	func testLastContext() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .CKKS)
		let context  = try! ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true)
		
		XCTAssertNoThrow(context.lastContextData)
	}
	
	func testKeyParametersId() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .CKKS)
		let context  = try! ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true)
		
		XCTAssertNoThrow(context.keyContextData)
	}
	
	func testFirstParametersId() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .CKKS)
		let context  = try! ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true)
		
		XCTAssertEqual(context.firstParameterIds, ASLParametersIdType(block: (6098622831356892554, 15014073027091944544, 2882531263419799060, 6777358453269558412)))
		
		XCTAssertEqual(context.firstParameterIds, context.lastParameterIds)
	}
	
	func testLastParametersId() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .BFV)
		let context  = try! ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true)
		
		XCTAssertEqual(context.firstParameterIds, ASLParametersIdType(block: (3233990958110595687, 6540418720804205283, 7565231121574662035, 6360663316903180079)))
		
		XCTAssertEqual(context.firstParameterIds, context.lastParameterIds)
	}
	
	func testIsAllowedKeySwitching() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .none)
		let context  = try! ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true)
		
		XCTAssertFalse(context.isAllowedKeySwitching)
	}
	
	func testValidParameters() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .CKKS)
		let context  = try! ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true)
		
		XCTAssertFalse(context.isValidEncrytionParameters)
		
		let invalidContext  = try! ASLSealContext(encrytionParameters: ASLEncryptionParameters(schemeType: .BFV), expandModChain: false, securityLevel: .TC192)
		
		XCTAssertFalse(invalidContext.isValidEncrytionParameters)
		
		// TODO - test a valid one here
	}
	
	// MARK: - Test Helpers
	
	private func createEncryptionParameters() -> ASLEncryptionParameters {
		return ASLEncryptionParameters(schemeType: .CKKS)
	}
	
}
