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
		XCTAssertThrowsError(try ASLCipherText(context: .bfvDefault))
	}
	
	func testCreateWithContextAndPool() {
		XCTAssertThrowsError(try ASLCipherText(context: .bfvDefault, pool: memoryPoolHandle()))
	}
	
	func testeCreateWithParameterType() {
		XCTAssertThrowsError(try ASLCipherText(context: .bfvDefault, parametersId: ASLParametersIdType(block: (2,2,2,2))))
	}
	
	func testCreateWithParametersAndPool() {
		XCTAssertThrowsError(try ASLCipherText(context: .bfvDefault, parametersId: ASLParametersIdType(block: (2,2,2,2)), pool: memoryPoolHandle()))
	}
	
	func testCreateWithParametersSizeAndPool() {
		XCTAssertThrowsError(try ASLCipherText(context: .bfvDefault, parametersId: ASLParametersIdType(block: (2,2,2,2)), sizeCapacity: -1, pool: memoryPoolHandle()))
		XCTAssertThrowsError(try ASLCipherText(context: .bfvDefault, parametersId: ASLParametersIdType(block: (2,2,2,2)), sizeCapacity: 0, pool: memoryPoolHandle()))
		XCTAssertThrowsError(try ASLCipherText(context: .bfvDefault, parametersId: ASLParametersIdType(block: (2,2,2,2)), sizeCapacity: 1, pool: memoryPoolHandle()))
		XCTAssertThrowsError(try ASLCipherText(context: .bfvDefault, parametersId: ASLParametersIdType(block: (2,2,2,2)), sizeCapacity: .max, pool: memoryPoolHandle()))
	}
	
	func testCreateWithSizeCapazityParameters() {
		XCTAssertThrowsError(try ASLCipherText(context: .bfvDefault, sizeCapacity: -1, parametersId: ASLParametersIdType(block: (2,2,2,2))))
		XCTAssertThrowsError(try ASLCipherText(context: .bfvDefault, sizeCapacity: 0, parametersId: ASLParametersIdType(block: (2,2,2,2))))
		XCTAssertThrowsError(try ASLCipherText(context: .bfvDefault, sizeCapacity: 1, parametersId: ASLParametersIdType(block: (2,2,2,2))))
		XCTAssertThrowsError(try ASLCipherText(context: .bfvDefault, sizeCapacity: 2, parametersId: ASLParametersIdType(block: (2,2,2,2))))
		XCTAssertThrowsError(try ASLCipherText(context: .bfvDefault, sizeCapacity: 3, parametersId: ASLParametersIdType(block: (2,2,2,2))))
		XCTAssertThrowsError(try ASLCipherText(context: .bfvDefault, sizeCapacity: .max, parametersId: ASLParametersIdType(block: (2,2,2,2))))
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
//		let otherCipherText = try! ASLCipherText(context: .bfvDefault, sizeCapacity: -1, parametersId: parameterTypePointer())
//		XCTAssertThrowsError(try ASLCipherText(cipherText: otherCipherText, pool: memoryPoolHandle()))
	}
	
	// TODO - finish testing the rest of the properties when I figure out how to create one
	
    func testCoding() throws {
        let cipherText = ASLCipherText()
        
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        archiver.encode(cipherText, forKey: "testObject")
        let data = archiver.encodedData
        
        let decodedCipherText = try ASLCipherText(data: data, context: .bfvDefault)

        XCTAssertEqual(cipherText, decodedCipherText)
    }
	
	// MARK: - Test Helper
	
	private func memoryPoolHandle() -> ASLMemoryPoolHandle {
		return ASLMemoryPoolHandle(clearOnDestruction: true)
	}
}


