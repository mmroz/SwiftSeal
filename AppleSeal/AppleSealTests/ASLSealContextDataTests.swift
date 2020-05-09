//
//  ASLSealContextDataTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-01-05.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//
import AppleSeal
import XCTest

class ASLSealContextDataTests: XCTestCase {
	
	func testChainIndex() {
		let data = contextData()
		XCTAssertEqual(data.chainIndex, 0)
	}
	
	func testParametersId() {
		let data = contextData()
		XCTAssertEqual(data.parametersId, ASLParametersIdType(block: (18066650271355507441, 12390381042028728861, 2300535169702335606, 8907756561119861190)))
	}
	
	func testTotalCoefficientModulus() {
		//let data = contextData(.none)
		// TODO - fix this
		//XCTAssertEqual(data.totalCoefficientModulus, uint64Pointer())
	}
	
	func testTotalCoefficientModulusBitCount() {
		let data = contextData()
		XCTAssertEqual(data.totalCoefficientModulusBitCount, 3)
	}
	
	func testCoefficientDividedPlainModulus() {
		//let data = contextData()
		// TODO - fix this
		//XCTAssertEqual(data.coefficientDividedPlainModulus, uint64Pointer())
	}
	
	func testPlainUpperHalfThreshold() {
		let data = contextData()
		XCTAssertEqual(data.plainUpperHalfThreshold, 0)
	}
	
	func testPlainUpperHalfIncrement() {
		//let data = contextData()
		// TODO - fix this
		//XCTAssertEqual(data.plainUpperHalfIncrement, uint64Pointer())
	}
	
	func testNextContext() {
		// TODO - fix these
		let data = contextData()
		XCTAssertEqual(data.chainIndex, 0)
//		let nextData = data.next
//		XCTAssertEqual(nextData.chainIndex, 2)
//		XCTAssertEqual(data, nextData)
	}
	
	func testPreviousContext() {
		// TODO - fix these
		let data = contextData()
		XCTAssertEqual(data.chainIndex, 0)
//		let previousData = data.next
//		XCTAssertEqual(previousData.chainIndex, 2)
//		XCTAssertEqual(data, previousData)
	}
    
    func testQualifiers() {
        let data = contextData()
        XCTAssertEqual(data.qualifiers, ASLEncryptionParameterQualifiers(isParametersSet: false, isUsingFFT: false, isUsingNNT: false, isUsingBatching: false, isUsingFastPlainLift: false, isUsingDescendingModulusChain: false, securityLevel: .None))
    }
   
    // TODO
//    func testSmallNttTables() {
//        let data = contextData()
//        XCTAssertEqual(data.smallNttTables.coefficentCount, 4)
//    }
    
    // TODO
//    func testPlainNttTables() {
//        let data = contextData()
//        XCTAssertEqual(data.plainNttTables.coefficentCount, 4)
//    }
    
    func testBaseConverter() {
        let data = contextData()
        XCTAssertNoThrow(data.baseConverter)
    }
	
	// MARK: - Test Helpers
	
	private func contextData(_ schemeType: ASLSchemeType = .CKKS) -> ASLSealContextData {
		let encryptionParameters = ASLEncryptionParameters(schemeType: schemeType)
        
        try! encryptionParameters.setCoefficientModulus([ASLSmallModulus(value: 4)])
        
        let context = try? ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true, securityLevel: .TC128, memoryPoolHandle: ASLMemoryPoolHandle(clearOnDestruction: true))
    
		return context!.keyContextData
	}
	
	private func uint64Pointer(_ bytes: [UInt64] = [39, 77, 111, 111, 102, 33, 39, 0]) -> UnsafeMutablePointer<UInt64> {
		var bytes: [UInt64] = bytes
		let uint64Pointer = UnsafeMutablePointer<UInt64>.allocate(capacity: 8)
		uint64Pointer.initialize(from: &bytes, count: 8)
		return uint64Pointer
	}
}
