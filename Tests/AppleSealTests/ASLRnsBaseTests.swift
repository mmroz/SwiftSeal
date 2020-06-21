//
//  ASLRnsBaseTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-05-15.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

final class ASLRnsBaseTests: XCTestCase {
    
    var rnsBase: ASLRnsBase!
    
    override func setUp() {
        rnsBase = try! ASLRnsBase(moduluses: ASLCoefficientModulus.bfvDefault(1024), pool: .global())
    }
    
    override func tearDown() {
        rnsBase = nil
    }
    
    func testCreateWithModuluses() throws {
        XCTAssertNoThrow(try ASLRnsBase(moduluses: ASLCoefficientModulus.bfvDefault(1024), pool: .global()))
    }
    
    func testGetAtIndex() {
        XCTAssertNoThrow(rnsBase.getAt(0))
    }
    
    func testSubscripting() {
        XCTAssertNoThrow(rnsBase[0])
    }
    
    func testContains() throws {
        XCTAssertTrue(rnsBase.contains(try ASLModulus(value: 132120577)))
        XCTAssertFalse(rnsBase.contains(try ASLModulus(value: 2)))
    }
    
    func testIsSubBaseOf() throws {
        let otherBase = try ASLRnsBase(moduluses: ASLCoefficientModulus.bfvDefault(1024), pool: .global())
        
        XCTAssertTrue(rnsBase.isSubBase(of: otherBase))
    }
    
    func testIsSuperBaseOf() throws {
        let otherBase = try ASLRnsBase(moduluses: ASLCoefficientModulus.bfvDefault(1024), pool: .global())
        
        XCTAssertTrue(rnsBase.isSuperBase(of: otherBase))
    }
    
    func testIsProperSubBaseOf() throws {
        let otherBase = try ASLRnsBase(moduluses: ASLCoefficientModulus.bfvDefault(1024), pool: .global())
        XCTAssertFalse(rnsBase.isProperSubBase(of: otherBase))
    }
    
    func testIsProperSuperBaseOf() throws {
        let otherBase = try ASLRnsBase(moduluses: ASLCoefficientModulus.bfvDefault(1024), pool: .global())
        XCTAssertTrue(rnsBase.isProperSuperBase(of: otherBase))
    }
    
    func testExtendWithModulus() throws {
        XCTAssertNoThrow(rnsBase.extend(with: try ASLModulus(value: 20)))
    }
    
    func testExtendWithRnsBase() throws {
        let otherBase = try ASLRnsBase(moduluses: ASLCoefficientModulus.bfvDefault(8192), pool: .global())
        XCTAssertNoThrow(try rnsBase.extend(with: otherBase))
    }
    
    func testDropWithModulus() throws {
        rnsBase = try! ASLRnsBase(moduluses: ASLCoefficientModulus.bfvDefault(8192), pool: .global())
        XCTAssertThrowsError(try rnsBase.drop(with: try ASLModulus(value: 132120577)))
        XCTAssertNoThrow(try rnsBase.drop(with: try ASLModulus(value: 8796092858369)))
    }
    
    func testDrop() throws {
         rnsBase = try! ASLRnsBase(moduluses: ASLCoefficientModulus.bfvDefault(8192), pool: .global())
        XCTAssertNoThrow(try rnsBase.dropAll())
    }
    
    func testDecomposeValue() throws {
        XCTAssertEqual(rnsBase.decomposeValue(5, pool: .global()), 5)
    }
    
    func testDecomposeArrayValue() throws {
        XCTAssertEqual(rnsBase.decomposeArrayValue(5, count: 2, pool: .global()), 5)
    }
    
    func testComposeValue() throws {
        let composedValue = rnsBase.composeValue(5, pool: .global())
        XCTAssertEqual(composedValue, 5)
    }
    
    func testComposeArrayValue() throws {
        let composedValue = rnsBase.composeArrayValue(5, count: 2, pool: .global())
        XCTAssertEqual(composedValue, 5)
    }
    
    func testSize() throws {
        XCTAssertEqual(rnsBase.size, 1)
    }
    
    func testBase() throws {
        XCTAssertEqual(rnsBase.base,  try ASLModulus(value: 132120577))
    }
    
    func testBaseProd() throws {
        XCTAssertEqual(rnsBase.baseProd, 132120577)
    }
    
    func testPuncturedProdArray() throws {
        XCTAssertEqual(rnsBase.puncturedProdArray, 1)
    }
    
    func testInversePuncturedProdModulusBaseArray() throws {
        XCTAssertEqual(rnsBase.inversePuncturedProdModulusBaseArray, 1)
    }
}
