//
//  ASLBaseConverterTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-04-22.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import Foundation

import AppleSeal
import XCTest

final class ASLBaseConverterTests: XCTestCase {
    
    func testCreate() throws {
        let modulus = try ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40])
        let iBase = ASLRnsBase(moduluses: modulus, pool: .global())
        let oBase = ASLRnsBase(moduluses: modulus, pool: .global())
        XCTAssertNoThrow(try ASLBaseConverter(pool: .global(), iBase: iBase, oBase: oBase))
    }
    
    func testIBase() throws {
        let modulus = try ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40])
        let iBase = ASLRnsBase(moduluses: modulus, pool: .global())
        let oBase = ASLRnsBase(moduluses: modulus, pool: .global())
        let converter: ASLBaseConverter = try ASLBaseConverter(pool: .global(), iBase: iBase, oBase: oBase)
        
        XCTAssertEqual(converter.iBase.base, iBase.base)
    }
    
    func testOBase() throws {
        let modulus = try ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40])
        let iBase = ASLRnsBase(moduluses: modulus, pool: .global())
        let oBase = ASLRnsBase(moduluses: modulus, pool: .global())
        let converter: ASLBaseConverter = try ASLBaseConverter(pool: .global(), iBase: iBase, oBase: oBase)
        
        XCTAssertEqual(converter.oBase.base, oBase.base)
    }
    
    
    
    func testIBaseSize() throws {
        let modulus = try ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40])
        let iBase = ASLRnsBase(moduluses: modulus, pool: .global())
        let oBase = ASLRnsBase(moduluses: modulus, pool: .global())
        let converter: ASLBaseConverter = try ASLBaseConverter(pool: .global(), iBase: iBase, oBase: oBase)
        
        XCTAssertEqual(converter.iBaseSize, 5)
    }
    
    func testOBaseSize() throws {
        let modulus = try ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40])
        let iBase = ASLRnsBase(moduluses: modulus, pool: .global())
        let oBase = ASLRnsBase(moduluses: modulus, pool: .global())
        let converter: ASLBaseConverter = try ASLBaseConverter(pool: .global(), iBase: iBase, oBase: oBase)
        
        XCTAssertEqual(converter.iBaseSize, 5)
    }
    
    
    func testFastConvert() throws {
        let modulus = try ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40])
        let iBase = ASLRnsBase(moduluses: modulus, pool: .global())
        let oBase = ASLRnsBase(moduluses: modulus, pool: .global())
        let converter: ASLBaseConverter = try ASLBaseConverter(pool: .global(), iBase: iBase, oBase: oBase)
        
        let result = converter.fastConvert(10, pool: .global())
        XCTAssertEqual(result, 10)
    }
    
    func testFastConvertArray() throws {
        let modulus = try ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40])
        let iBase = ASLRnsBase(moduluses: modulus, pool: .global())
        let oBase = ASLRnsBase(moduluses: modulus, pool: .global())
        let converter: ASLBaseConverter = try ASLBaseConverter(pool: .global(), iBase: iBase, oBase: oBase)
        
        let result = converter.fastConvertArray(1024224, size: 2, pool: .global())
        XCTAssertEqual(result, 1024224)
    }
}
