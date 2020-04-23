//
//  ASLSealContextDataTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-01-05.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//
import AppleSeal
import XCTest


extension ASLEncryptionParameterQualifiers: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return ASLEncryptionParameterQualifiersIsEqual(lhs, rhs)
    }
    
    var aslSecurityLevel: ASLSecurityLevel {
        return ASLSecurityLevel(rawValue: Int(securityLevel))!
    }
    
    init(isParametersSet: Bool, isUsingFFT: Bool, isUsingNNT: Bool, isUsingBatching: Bool, isUsingFastPlainLift: Bool, isUsingDescendingModulusChain: Bool, securityLevel: ASLSecurityLevel) {
        self.init()
        self.isParametersSet = isParametersSet
        self.isUsingFFT = isUsingFFT
        self.isUsingNNT = isUsingNNT
        self.isUsingBatching = isUsingBatching
        self.isUsingDescendingModulusChain = isUsingDescendingModulusChain
        self.securityLevel = Int32(securityLevel.rawValue)
    }
}

class ASLSealContextDataTests: XCTestCase {
	
	func testChainIndex() {
		let data = contextData()
		XCTAssertEqual(data.chainIndex, 0)
	}
	
	func testParametersId() {
		let data = contextData()
		XCTAssertEqual(data.parametersId, ASLParametersIdType(block: (6098622831356892554, 15014073027091944544, 2882531263419799060, 6777358453269558412)))
	}
	
	func testTotalCoefficientModulus() {
		//let data = contextData(.none)
		// TODO - fix this
		//XCTAssertEqual(data.totalCoefficientModulus, uint64Pointer())
	}
	
	func testTotalCoefficientModulusBitCount() {
		let data = contextData()
		XCTAssertEqual(data.totalCoefficientModulusBitCount, 0)
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
    
    func testSmallNttTables() {
        let data = contextData()
        XCTAssertEqual(data.smallNttTables.coefficentCount, 4)
    }
    
    func testPlainNttTables() {
        let data = contextData()
        XCTAssertEqual(data.plainNttTables.coefficentCount, 4)
    }
    
    func testBaseConverter() {
        let data = contextData()
        XCTAssertEqual(data.baseConverter, ASLBaseConverter(pool: ASLMemoryPoolHandle.createNew(true)))
    }
	
	// MARK: - Test Helpers
	
	private func contextData(_ schemeType: ASLSchemeType = .CKKS) -> ASLSealContextData {
		let encryptionParameters = ASLEncryptionParameters(schemeType: schemeType)
        
        let context = try? ASLSealContext(encrytionParameters: encryptionParameters, expandModChain: true, securityLevel: .TC128, memoryPoolHandle: ASLMemoryPoolHandle.createNew(true))
    
		return context!.keyContextData
	}
	
	private func uint64Pointer(_ bytes: [UInt64] = [39, 77, 111, 111, 102, 33, 39, 0]) -> UnsafeMutablePointer<UInt64> {
		var bytes: [UInt64] = bytes
		let uint64Pointer = UnsafeMutablePointer<UInt64>.allocate(capacity: 8)
		uint64Pointer.initialize(from: &bytes, count: 8)
		return uint64Pointer
	}
}
