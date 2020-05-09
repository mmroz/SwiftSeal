//
//  ASLCKKSEncoderTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-01-10.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLCKKSEncoderTests: XCTestCase {
    
    // MARK: - Tests
    
    func testCreationWithDefaultInitializer() {
        let _ = ASLCKKSEncoder()
    }
    
    func testCreateWithValidContext() throws {
        let params = ASLEncryptionParameters(schemeType: .CKKS)
        try params.setPolynomialModulusDegree(8192)
        try params.setCoefficientModulus(ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40]))
        let context  = try ASLSealContext(encrytionParameters: params, expandModChain: true, securityLevel: .TC128, memoryPoolHandle: ASLMemoryPoolHandle(clearOnDestruction: true))
        
        XCTAssertNoThrow(_ = try ASLCKKSEncoder(context: context))
    }
    
    func testCreateWithBFVContextThrows() throws {
        let params = ASLEncryptionParameters(schemeType: .BFV)
        
        let context  = try ASLSealContext(encrytionParameters: params, expandModChain: true, securityLevel: .TC128, memoryPoolHandle: ASLMemoryPoolHandle(clearOnDestruction: true))
        
        XCTAssertThrowsError(try ASLCKKSEncoder(context: context))
    }
    
    func testSlotCount() throws {
        let encoder = try createEncoder()
        XCTAssertEqual(encoder.slotCount, 4096)
    }
    
    func testEncodeWithComplexValues() throws {
        let encoder = try createEncoder()
        
        let values = [ASLComplexType(real: 2, imaginary: 2)]
        let params = ASLParametersIdType(block: (40, 40, 40, 40))
        let destimation = try ASLPlainText(capacity: 2, coefficientCount: 2)
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        XCTAssertNoThrow(try encoder.encode(withComplexValues: values, parametersId: params, scale: 2.0, destination: destimation, pool: pool))
        
        XCTAssertNoThrow(try encoder.encode(withComplexValues: values, parametersId: params, scale: 2.0, destination: destimation))
        
        XCTAssertNoThrow(try encoder.encode(withComplexValues: values, scale: 2.0, destination: destimation, pool: pool))
        
        XCTAssertNoThrow(try encoder.encode(withComplexValues: values, scale: 2.0, destination: destimation))
        
    }
    
    func testEncodeComplexValue() throws {
        let encoder = try createEncoder()
        
        let value = ASLComplexType(real: 2, imaginary: 1)
        let destination = try ASLPlainText(capacity: 2, coefficientCount: 2)
        
        XCTAssertNoThrow(try encoder.encode(withComplexValue: value, scale: 2.0, destination: destination))
    }
    
    func testEncodeComplexValueWithPool() throws {
        let encoder = try createEncoder()
        
        let value = ASLComplexType(real: 2, imaginary: 1)
        let destination = try ASLPlainText(capacity: 2, coefficientCount: 2)
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        XCTAssertNoThrow(try encoder.encode(withComplexValue: value, scale: 2.0, destination: destination, pool: pool))
    }
    
    func testEncodeDoubleValue() throws {
        let encoder = try createEncoder()
        
        let value = 2.0
        let destination = try ASLPlainText(capacity: 2, coefficientCount: 2)
        
        XCTAssertNoThrow(try encoder.encode(withDoubleValue: value, scale: 2.0, destination: destination))
    }
    
    func testEncodeDoubleValueWithPool() throws {
        let encoder = try createEncoder()
        
        let value = 2.0
        let destination = try ASLPlainText(capacity: 2, coefficientCount: 2)
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        XCTAssertNoThrow(try encoder.encode(withDoubleValue: value, scale: 2.0, destination: destination, pool: pool))
    }
    
    func testEncodeComplexValueWithParams() throws {
        let encoder = try createEncoder()
        
        let complexValue = ASLComplexType(real: 2.0, imaginary: 2.0)
        let params = ASLParametersIdType(block: (16, 16, 16, 16))
        let scale = 2.0
        let destination = try ASLPlainText(capacity: 2, coefficientCount: 2)
        
        XCTAssertNoThrow(try encoder.encode(withComplexValue: complexValue, parametersId: params, scale: scale, destination: destination))
    }
    
    func testEncodeComplexValueWithParamsAndPool() throws {
        let encoder = try createEncoder()
        
        let complexValue = ASLComplexType(real: 2.0, imaginary: 2.0)
        let params = ASLParametersIdType(block: (16, 16, 16, 16))
        let scale = 2.0
        let destination = try ASLPlainText(capacity: 2, coefficientCount: 2)
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        XCTAssertNoThrow(try encoder.encode(withComplexValue: complexValue, parametersId: params, scale: scale, destination: destination, pool: pool))
    }
    
    func testEncodeDoubleValuesWithParams() throws {
        let encoder = try createEncoder()
        
        let doubleValues: [NSNumber] = [4.0, 8.0]
        let params = ASLParametersIdType(block: (4, 4, 4, 4))
        let scale = 2.0
        let destination = try ASLPlainText(capacity: 2, coefficientCount: 2)
        
        XCTAssertThrowsError(try encoder.encode(withDoubleValues: doubleValues, parametersId: params, scale: scale, destination: destination))
    }
    
    func testEncodeDoubleValuesWithParamsAndPool() throws {
        let encoder = try createEncoder()
        
        let doubleValues: [NSNumber] = [4.0, 8.0]
        let params = ASLParametersIdType(block: (4, 4, 4, 4))
        let scale = 2.0
        let destination = try ASLPlainText(capacity: 2, coefficientCount: 2)
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        XCTAssertThrowsError(try encoder.encode(withDoubleValues: doubleValues, parametersId: params, scale: scale, destination: destination, pool: pool))
    }
    
    func testEncodeDoubleValues() throws {
        let encoder = try createEncoder()
        
        let doubleValues: [NSNumber] = [4.0, 8.0]
        let scale = 2.0
        let destination = try ASLPlainText(capacity: 2, coefficientCount: 2)
        
        XCTAssertThrowsError(try encoder.encode(withDoubleValues: doubleValues, scale: scale, destination: destination))
    }
    
    func testEncodeDoubleValuesWithPool() throws {
        let encoder = try createEncoder()
        
        let doubleValues: [NSNumber] = [4.0, 8.0]
        let scale = 2.0
        let destination = try ASLPlainText(capacity: 2, coefficientCount: 2)
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        XCTAssertThrowsError(try encoder.encode(withDoubleValues: doubleValues, scale: scale, destination: destination, pool: pool))
    }
    
    func testEncodeLongValueWithParams() throws {
        let encoder = try createEncoder()
        
        let params = ASLParametersIdType(block: (4, 4, 4, 4))
        let destination = try ASLPlainText(capacity: 2, coefficientCount: 2)
        
        XCTAssertThrowsError(try encoder.encode(withLongValue: 2.0, parametersId: params, destination: destination))
    }
    
    func testEncodeLongValue() throws {
        let encoder = try createEncoder()
        
        let destination = try ASLPlainText(capacity: 2, coefficientCount: 2)
        
        XCTAssertThrowsError(try encoder.encode(withLongValue: 2.0, destination: destination))
    }
    
    func testDecode() throws {
        let encoder = try createEncoder()
        
        let plainText = try ASLPlainText(capacity: 2, coefficientCount: 2)
        
        try encoder.encode(withLongValue: 2.0, destination: plainText)
        
        let resuls = [NSNumber]()
        XCTAssertNoThrow(try encoder.decode(plainText, destination: resuls))
        
        XCTAssertEqual(resuls, [2.0])
    }
    
    func testDecodeWithPool() throws {
        let encoder = try createEncoder()
        
        let plainText = try ASLPlainText(capacity: 2, coefficientCount: 2)
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        try encoder.encode(withLongValue: 2.0, destination: plainText)
        
        let resuls = [NSNumber]()
        XCTAssertNoThrow(try encoder.decode(plainText, destination: resuls, pool: pool))
        
        XCTAssertEqual(resuls, [2.0])
    }
    
    func createEncoder() throws -> ASLCKKSEncoder {
        let params = ASLEncryptionParameters(schemeType: .CKKS)
        try params.setPolynomialModulusDegree(8192)
        try params.setCoefficientModulus(ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40]))
        let context = try ASLSealContext(encrytionParameters: params, expandModChain: true, securityLevel: .None, memoryPoolHandle: ASLMemoryPoolHandle(clearOnDestruction: true))
        return try ASLCKKSEncoder(context: context)
    }
}
