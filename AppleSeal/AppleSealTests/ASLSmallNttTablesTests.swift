//
//  ASLSmallNttTablesTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-04-21.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLSmallNttTablesTests: XCTestCase {
    
    func testCreateWithDefaultInitializers() {
        _ = ASLSmallNttTables()
    }
    
    func testCreateWithPool() throws {
        _ = ASLSmallNttTables(pool: .createNew(true))
    }
    
    func testCreateWithPower() throws {
        _ = ASLSmallNttTables(coefficentCountPower: 2, smallModulus: try ASLSmallModulus(value: 5))
    }
    
    func testCreateWithPowerWithPool() throws {
           _ = ASLSmallNttTables(coefficentCountPower: 2, smallModulus: try ASLSmallModulus(value: 5), pool: .createNew(true))
    }
    
    func testGenerateReturnsTrueWhenSuccessful() throws {
        let  tables = ASLSmallNttTables(pool: .createNew(true))
        XCTAssertTrue(tables.generate(2, smallModulus: try ASLSmallModulus(value: 5)))
    }
    
    func testResetClearsData() throws {
         let  tables = ASLSmallNttTables(pool: .createNew(true))
        
        tables.reset()
    }
    
    func testGetFromRootPowersWithIndex() {
         let  tables = ASLSmallNttTables(pool: .createNew(true))
        XCTAssertEqual(1, tables.getFromRootPowers(withIndex: 1))
    }
    
    func testGetFromScaledRootPowersWithIndex() {
         let  tables = ASLSmallNttTables(pool: .createNew(true))
        XCTAssertEqual(1, tables.getFromScaledRootPowers(withIndex: 1))
    }
    
    func testGetFromInverseRootPowersWithIndex() {
         let  tables = ASLSmallNttTables(pool: .createNew(true))
        XCTAssertEqual(1, tables.getFromInverseRootPowers(withIndex: 1))
    }
    
    func testGetFromScaledInverseRootPowersWithIndex() {
         let  tables = ASLSmallNttTables(pool: .createNew(true))
        XCTAssertEqual(1, tables.getFromScaledInverseRootPowers(withIndex: 1))
    }
    
    
    func testGetFromScaledInverseRootPowersDividedByTwoWithIndex() {
         let  tables = ASLSmallNttTables(pool: .createNew(true))
        XCTAssertEqual(1, tables.getFromScaledInverseRootPowersDividedByTwo(withIndex: 1))
    }
    
    func testGetFromInverseRootPowersDividedByTwoWithIndex() {
         let  tables = ASLSmallNttTables(pool: .createNew(true))
        return XCTAssertEqual(1, tables.getFromInverseRootPowersDividedByTwo(withIndex: 1))
    }
    
    func testGetInverseDegreeModulo() {
         let  tables = ASLSmallNttTables(pool: .createNew(true))
        XCTAssertEqual(1, tables.getInverseDegreeModulo())
    }
    
    func testRoot() {
         let  tables = ASLSmallNttTables(pool: .createNew(true))
         XCTAssertEqual(1, tables.root)
    }
    
    func testModulus() {
         let  tables = ASLSmallNttTables(pool: .createNew(true))
         XCTAssertEqual(try ASLSmallModulus(value: 5), tables.modulus)
    }
    
    func testCoefficentCountPower() {
         let  tables = ASLSmallNttTables(pool: .createNew(true))
         XCTAssertEqual(1, tables.coefficentCountPower)
    }
    
    func testCoefficentCount() {
         let  tables = ASLSmallNttTables(pool: .createNew(true))
         XCTAssertEqual(1, tables.coefficentCount)
    }
}
