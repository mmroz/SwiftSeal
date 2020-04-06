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
	
	func testCreateWithEncryptionParams() throws {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .CKKS)
        
		XCTAssertNoThrow(try ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true, securityLevel: .TC128, memoryPoolHandle: ASLMemoryPoolHandle.createNew(true)))
	}
	
	func testCreateWithExpandModChain() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .CKKS)
		XCTAssertNoThrow(try ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true, securityLevel: .TC128, memoryPoolHandle: ASLMemoryPoolHandle.createNew(true)))
		XCTAssertNoThrow(try ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: false, securityLevel: .TC128, memoryPoolHandle: ASLMemoryPoolHandle.createNew(true)))
	}
	
	func  testCreateWithSecurityLevel() {
        XCTAssertNoThrow(try ASLSealContext(encrytionParameters: createEncryptionParameters(), expandModChain: true, securityLevel: .None, memoryPoolHandle: ASLMemoryPoolHandle.createNew(true)))
        XCTAssertNoThrow(try ASLSealContext(encrytionParameters: createEncryptionParameters(), expandModChain: true, securityLevel: .TC128, memoryPoolHandle: ASLMemoryPoolHandle.createNew(true)))
        XCTAssertNoThrow(try ASLSealContext(encrytionParameters: createEncryptionParameters(), expandModChain: true, securityLevel: .TC192, memoryPoolHandle: ASLMemoryPoolHandle.createNew(true)))
        XCTAssertNoThrow(try ASLSealContext(encrytionParameters: createEncryptionParameters(), expandModChain: true, securityLevel: .TC256, memoryPoolHandle: ASLMemoryPoolHandle.createNew(true)))
	}
		
	func testKeyContextData() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .CKKS)
		let context = try! ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true, securityLevel: .None, memoryPoolHandle: ASLMemoryPoolHandle.createNew(true))
		
		XCTAssertNoThrow(context.keyContextData)
	}
	
	func testFirstContext() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .CKKS)
		let context = try! ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true, securityLevel: .None, memoryPoolHandle: ASLMemoryPoolHandle.createNew(true))
		
		XCTAssertNoThrow(context.firstContextData)
	}
	
	func testLastContext() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .CKKS)
		let context  = try!  ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true, securityLevel: .None, memoryPoolHandle: ASLMemoryPoolHandle.createNew(true))
		
		XCTAssertNoThrow(context.lastContextData)
	}
	
	func testKeyParametersId() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .CKKS)
		let context  = try! ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true, securityLevel: .None, memoryPoolHandle: ASLMemoryPoolHandle.createNew(true))
		
		XCTAssertNoThrow(context.keyContextData)
	}
	
	func testFirstParametersId() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .CKKS)
		let context  = try!  ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true, securityLevel: .None, memoryPoolHandle: ASLMemoryPoolHandle.createNew(true))
		
		XCTAssertEqual(context.firstParameterIds, ASLParametersIdType(block: (6098622831356892554, 15014073027091944544, 2882531263419799060, 6777358453269558412)))
		
		XCTAssertEqual(context.firstParameterIds, context.lastParameterIds)
	}
	
	func testLastParametersId() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .BFV)
		let context  = try! ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true, securityLevel: .None, memoryPoolHandle: ASLMemoryPoolHandle.createNew(true))
		
		XCTAssertEqual(context.firstParameterIds, ASLParametersIdType(block: (3233990958110595687, 6540418720804205283, 7565231121574662035, 6360663316903180079)))
		
		XCTAssertEqual(context.firstParameterIds, context.lastParameterIds)
	}
	
	func testIsAllowedKeySwitching() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .none)
		let context  = try! ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true, securityLevel: .None, memoryPoolHandle: ASLMemoryPoolHandle.createNew(true))
		
		XCTAssertFalse(context.isAllowedKeySwitching)
	}
	
	func testValidParameters() {
		let encryptionParameters = ASLEncryptionParameters(schemeType: .CKKS)
		let context  = try!  ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true, securityLevel: .None, memoryPoolHandle: ASLMemoryPoolHandle.createNew(true))
		
		XCTAssertFalse(context.isValidEncrytionParameters)
		
		let invalidContext  = try!  ASLSealContext(encrytionParameters: createEncryptionParameters(), expandModChain: true, securityLevel: .None, memoryPoolHandle: ASLMemoryPoolHandle.createNew(true))
		
		XCTAssertFalse(invalidContext.isValidEncrytionParameters)
		
		// TODO - test a valid one here
	}
	
	// MARK: - Test Helpers
	
	private func createEncryptionParameters() -> ASLEncryptionParameters {
		return ASLEncryptionParameters(schemeType: .CKKS)
	}
	
}
