//
//  ASLCipherTextTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-01-04.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//
import AppleSeal
import XCTest

class ASLCipherTextTests: XCTestCase {

	// MARK: - Tests

	func testCreationWithDefaultInitializer() {
		let _ = ASLCipherText()
		
	}
	
	func testCreationWithInvliadContext() {
		XCTAssertThrowsError(try ASLCipherText(context: context()))
	}
	
	func testCreateWithContextAndPool() {
		XCTAssertThrowsError(try ASLCipherText(context: context(), pool: memoryPoolHandle()))
	}
	
	func testeCreateWithParameterType() {
		XCTAssertThrowsError(try ASLCipherText(context: context(), parametersId: parameterTypePointer()))
	}
	
	func testCreateWithParametersAndPool() {
		XCTAssertThrowsError(try ASLCipherText(context: context(), parametersId: parameterTypePointer(), pool: memoryPoolHandle()))
	}
	
	func testCreateWithParametersSizeAndPool() {
		XCTAssertThrowsError(try ASLCipherText(context: context(), parametersId: parameterTypePointer(), sizeCapacity: -1, pool: memoryPoolHandle()))
		XCTAssertThrowsError(try ASLCipherText(context: context(), parametersId: parameterTypePointer(), sizeCapacity: 0, pool: memoryPoolHandle()))
		XCTAssertThrowsError(try ASLCipherText(context: context(), parametersId: parameterTypePointer(), sizeCapacity: 1, pool: memoryPoolHandle()))
		XCTAssertThrowsError(try ASLCipherText(context: context(), parametersId: parameterTypePointer(), sizeCapacity: .max, pool: memoryPoolHandle()))
	}
	
	func testCreateWithSizeCapazityParameters() {
		XCTAssertThrowsError(try ASLCipherText(context: context(), sizeCapacity: -1, parametersId: parameterTypePointer()))
		XCTAssertThrowsError(try ASLCipherText(context: context(), sizeCapacity: 0, parametersId: parameterTypePointer()))
		XCTAssertThrowsError(try ASLCipherText(context: context(), sizeCapacity: 1, parametersId: parameterTypePointer()))
		XCTAssertThrowsError(try ASLCipherText(context: context(), sizeCapacity: 2, parametersId: parameterTypePointer()))
		XCTAssertThrowsError(try ASLCipherText(context: context(), sizeCapacity: 3, parametersId: parameterTypePointer()))
		XCTAssertThrowsError(try ASLCipherText(context: context(), sizeCapacity: .max, parametersId: parameterTypePointer()))
	}
    
    func testSize() throws {
        let cipherText = ASLCipherText()
        XCTAssertEqual(cipherText.size, 0)
    }
    
    func testReturnToPool() {
        let cipherText = ASLCipherText()
        cipherText.returnMemoryToPool()
    }
    
    func testCorefficentAtIndex() throws {
        // TODO
//        let cipherText = ASLCipherText()
//        try cipherText.polynomialCoefficient(at: 0)
    }
	
    func testIntArray() {
        // TODO
    }
    
    func testCoefficientModulusCount() {
        let cipherText = ASLCipherText()
        XCTAssertEqual(cipherText.coefficientModulusCount, 0)
    }
    
    func testPolynomialModulusCount() {
        let cipherText = ASLCipherText()
        XCTAssertEqual(cipherText.polynomialModulusDegree, 0)
    }
    
    func testSizeCapacity() {
        let cipherText = ASLCipherText()
        XCTAssertEqual(cipherText.sizeCapacity, 0)
    }
    
    func testTransparent() {
        let cipherText = ASLCipherText()
        XCTAssertTrue(cipherText.isTransparent)
    }
    
    func testNNTForm() {
        let cipherText = ASLCipherText()
        XCTAssertFalse(cipherText.isNntForm)
    }
    
    func testParametersId() {
        let cipherText = ASLCipherText()
        XCTAssertEqual(cipherText.parametersId, ASLParametersIdType(block: (0, 0, 0, 0)))
    }
    
    func testScale() {
        let cipherText = ASLCipherText()
        XCTAssertEqual(cipherText.scale, 1.0)
    }
    
    func testPool() {
        let cipherText = ASLCipherText()
        XCTAssertEqual(cipherText.pool, ASLMemoryPoolHandle.global())
    }
    
	func testCreateWithCopy() {
//		let otherCipherText = try! ASLCipherText(context: context(), sizeCapacity: -1, parametersId: parameterTypePointer())
//		XCTAssertThrowsError(try ASLCipherText(cipherText: otherCipherText, pool: memoryPoolHandle()))
	}
	
	// TODO - finish testing the rest of the properties when I figure out how to create one
	
	
	// MARK: - Test Helper
	
	private func memoryPoolHandle() -> ASLMemoryPoolHandle {
		return ASLMemoryPoolHandle.createNew(true)
	}
	
	private func context() -> ASLSealContext {
		return ASLSealContext()
	}

	private func parameterTypePointer() -> UnsafeMutablePointer<ASLParametersIdType> {
		var parameterIds = ASLParametersIdType(block: (2,2,2,2))
		let uint64Pointer = UnsafeMutablePointer<ASLParametersIdType>.allocate(capacity: 8)
		uint64Pointer.initialize(from: &parameterIds, count: 8)
		return uint64Pointer
	}
}


