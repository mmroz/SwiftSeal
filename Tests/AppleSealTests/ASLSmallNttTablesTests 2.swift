//
//  ASLNttTablesTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-04-21.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLNttTablesTests: XCTestCase {
    func testWithCoefficentCountPowerAndModulus() throws {
        XCTAssertNoThrow(ASLNttTables(coefficentCountPower: 8, modulus: try ASLModulus(value: 1024)))
    }
    
    func testWithCoefficentCountPowerAndModulusAndPool() {
        XCTAssertNoThrow(ASLNttTables(coefficentCountPower: 8, modulus: try ASLModulus(value: 1024), pool: .global()))
    }
    
    func testCreateWithCoefficentCountPower() throws {
        let polyModulusDegree = 8192
        let modulus = try ASLCoefficientModulus.create(polyModulusDegree, bitSizes: [40, 40, 40, 40, 40])
        let otherTable = ASLNttTables(coefficentCountPower: 8, modulus: try ASLModulus(value: 1024))
        
        XCTAssertNoThrow(try ASLNttTables.create(withCoefficentCountPower: 4, modulus: modulus, tables: otherTable, pool: .global()))
    }
    
    func testNttNegacyclicHarveyLazyWithOperand() throws {
        let otherTable = ASLNttTables(coefficentCountPower: 8, modulus: try ASLModulus(value: 1024))
        
        XCTAssertNoThrow(ASLNttTables.nttNegacyclicHarvey(withOperand: 4, tables: otherTable))
    }
    
    func testNttNegacyclicHarveyWithOperand() throws {
        let otherTable = ASLNttTables(coefficentCountPower: 8, modulus: try ASLModulus(value: 1024))
        
        XCTAssertNoThrow(ASLNttTables.nttNegacyclicHarvey(withOperand: 4, tables: otherTable))
    }
    
    func testInverseNttNegacyclicHarveyLazyWithOperand() throws {
        let otherTable = ASLNttTables(coefficentCountPower: 8, modulus: try ASLModulus(value: 1024))
        XCTAssertNoThrow(ASLNttTables.inverseNttNegacyclicHarveyLazy(withOperand: 4, tables: otherTable))
    }
    
    func testInverseNttNegacyclicHarveyWithOperand() throws {
        let otherTable = ASLNttTables(coefficentCountPower: 8, modulus: try ASLModulus(value: 1024))
        XCTAssertNoThrow(ASLNttTables.inverseNttNegacyclicHarvey(withOperand: 4, tables: otherTable))
    }
    
    func testGetFromRootPowersWithIndex() throws {
        let tables = ASLNttTables(coefficentCountPower: 8, modulus: try ASLModulus(value: 1024))
        let result = tables.getFromRootPowers(withIndex: 0)
        XCTAssertEqual(result, 0)
    }
    
    func testGetFromScaledRootPowersWithIndex() throws {
        let tables = ASLNttTables(coefficentCountPower: 8, modulus: try ASLModulus(value: 1024))
        let result = tables.getFromScaledRootPowers(withIndex: 0)
        XCTAssertEqual(result, 0)
    }
    
    func testGetFromInverseRootPowersWithIndex() throws {
        let tables = ASLNttTables(coefficentCountPower: 8, modulus: try ASLModulus(value: 1024))
        let result = tables.getFromInverseRootPowers(withIndex: 0)
        XCTAssertEqual(result, 0)
    }
    
    func testGetFromScaledInverseRootPowersWithIndex() throws {
        let tables = ASLNttTables(coefficentCountPower: 8, modulus: try ASLModulus(value: 1024))
        let result = tables.getFromScaledInverseRootPowers(withIndex: 0)
        XCTAssertEqual(result, 0)
    }
    
    func testGetInverseDegreeModulo() throws {
        let tables = ASLNttTables(coefficentCountPower: 8, modulus: try ASLModulus(value: 1024))
        let result = tables.getInverseDegreeModulo()
        XCTAssertEqual(result, 0)
    }
    
    func testRoot() throws {
        let tables = ASLNttTables(coefficentCountPower: 8, modulus: try ASLModulus(value: 1024))
        let result = tables.root
        XCTAssertEqual(result, 0)
    }
    
    func testModulus() throws {
        let modulus = try ASLModulus(value: 1024)
        let tables = ASLNttTables(coefficentCountPower: 8, modulus: modulus)
        let result = tables.modulus
        XCTAssertEqual(result, modulus)
    }
    
    func testCoefficentCountPower() throws {
        let tables = ASLNttTables(coefficentCountPower: 8, modulus: try ASLModulus(value: 1024))
        let result = tables.coefficentCountPower
        XCTAssertEqual(result, 0)
    }
    
    func testCoefficentCount() throws {
        let tables = ASLNttTables(coefficentCountPower: 8, modulus: try ASLModulus(value: 1024))
        let result = tables.coefficentCount
        XCTAssertEqual(result, 0)
    }
}
