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
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        XCTAssertThrowsError(try encoder.encode(withComplexValues: values, parametersId: params, scale: 2.0, pool: pool))
        
        XCTAssertThrowsError(try encoder.encode(withComplexValues: values, parametersId: params, scale: 2.0))
        
        XCTAssertNoThrow(try encoder.encode(withComplexValues: values, scale: 2.0, pool: pool))
        
        XCTAssertNoThrow(try encoder.encode(withComplexValues: values, scale: 2.0))
        
    }
    
    func testEncodeComplexValue() throws {
        let encoder = try createEncoder()
        
        let value = ASLComplexType(real: 2, imaginary: 1)
        
        XCTAssertNoThrow(try encoder.encode(withComplexValue: value, scale: 2.0))
    }
    
    func testEncodeComplexValueWithPool() throws {
        let encoder = try createEncoder()
        
        let value = ASLComplexType(real: 2, imaginary: 1)
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        XCTAssertNoThrow(try encoder.encode(withComplexValue: value, scale: 2.0, pool: pool))
    }
    
    func testEncodeDoubleValue() throws {
        let encoder = try createEncoder()
        let value = 2.0
        XCTAssertNoThrow(try encoder.encode(withDoubleValue: value, scale: 2.0))
    }
    
    func testEncodeDoubleValueWithPool() throws {
        let encoder = try createEncoder()
        
        let value = 2.0
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        XCTAssertNoThrow(try encoder.encode(withDoubleValue: value, scale: 2.0, pool: pool))
    }
    
    func testEncodeComplexValueWithParams() throws {
        let encoder = try createEncoder()
        
        let complexValue = ASLComplexType(real: 2.0, imaginary: 2.0)
        let params = ASLParametersIdType(block: (16, 16, 16, 16))
        let scale = 2.0
        
        XCTAssertThrowsError(try encoder.encode(withComplexValue: complexValue, parametersId: params, scale: scale))
    }
    
    func testEncodeComplexValueWithParamsAndPool() throws {
        let encoder = try createEncoder()
        
        let complexValue = ASLComplexType(real: 2.0, imaginary: 2.0)
        let params = ASLParametersIdType(block: (16, 16, 16, 16))
        let scale = 2.0
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        XCTAssertThrowsError(try encoder.encode(withComplexValue: complexValue, parametersId: params, scale: scale, pool: pool))
    }
    
    func testEncodeDoubleValuesWithParams() throws {
        let encoder = try createEncoder()
        
        let doubleValues: [NSNumber] = [4.0, 8.0]
        let params = ASLParametersIdType(block: (4, 4, 4, 4))
        let scale = 2.0
        
        XCTAssertThrowsError(try encoder.encode(withDoubleValues: doubleValues, parametersId: params, scale: scale))
    }
    
    func testEncodeDoubleValuesWithParamsAndPool() throws {
        let encoder = try createEncoder()
        
        let doubleValues: [NSNumber] = [4.0, 8.0]
        let params = ASLParametersIdType(block: (4, 4, 4, 4))
        let scale = 2.0
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        XCTAssertThrowsError(try encoder.encode(withDoubleValues: doubleValues, parametersId: params, scale: scale, pool: pool))
    }
    
    func testEncodeDoubleValues() throws {
        let encoder = try createEncoder()
        
        let doubleValues: [NSNumber] = [4.0, 8.0]
        let scale = 2.0
        
        XCTAssertNoThrow(try encoder.encode(withDoubleValues: doubleValues, scale: scale))
    }
    
    func testEncodeDoubleValuesWithPool() throws {
        let encoder = try createEncoder()
        
        let doubleValues: [NSNumber] = [4.0, 8.0]
        let scale = 2.0
        let pool = ASLMemoryPoolHandle(clearOnDestruction: true)
        
        XCTAssertNoThrow(try encoder.encode(withDoubleValues: doubleValues, scale: scale, pool: pool))
    }
    
    func testEncodeLongValueWithParams() throws {
        let encoder = try createEncoder()
        let params = ASLParametersIdType(block: (4, 4, 4, 4))
        XCTAssertThrowsError(try encoder.encode(withLongValue: 2.0, parametersId: params))
    }
    
    func testEncodeLongValue() throws {
        let encoder = try createEncoder()
        XCTAssertNoThrow(try encoder.encode(withLongValue: 2.0))
    }
    
    func testDecode() throws {
        let encoder = try createEncoder()
        let scale = Double(pow((2.0), 30))
        let plain = try encoder.encode(withDoubleValues: [0.0, 1.1, 2.2, 3.3], scale: scale)

        let result = try XCTUnwrap(encoder.decodeDoubleValues(plain))
        
        XCTAssertEqual(result[0].doubleValue, 0.0, accuracy: 0.0000001);
        XCTAssertEqual(result[1].doubleValue, 1.1, accuracy: 0.0000001);
        XCTAssertEqual(result[2].doubleValue, 2.2, accuracy: 0.0000001);
        XCTAssertEqual(result[3].doubleValue, 3.3, accuracy: 0.0000001);

        for value in result[4 ..< result.endIndex] {
            XCTAssertEqual(value.doubleValue, 0.0, accuracy: 0.0000001);
        }
    }

    func testDecodeWithPool() throws {
        let encoder = try createEncoder()
        let plain = try XCTUnwrap(encoder.encode(withDoubleValues: [1.1, 1.2], scale: 2))
        let results = try XCTUnwrap(try encoder.decodeDoubleValues(plain, pool: .global()))
        XCTAssertEqual(results, [2.0])
    }
    
    func createEncoder() throws -> ASLCKKSEncoder {
        let params = ASLEncryptionParameters(schemeType: .CKKS)
        try params.setPolynomialModulusDegree(8192)
        try params.setCoefficientModulus(ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40]))
        let context = try ASLSealContext(encrytionParameters: params, expandModChain: true, securityLevel: .None, memoryPoolHandle: ASLMemoryPoolHandle(clearOnDestruction: true))
        return try ASLCKKSEncoder(context: context)
    }
}
