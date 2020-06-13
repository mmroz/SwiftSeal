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
        let modulus = try XCTUnwrap(ASLCoefficientModulus.create(8192, bitSizes: [40,40,40,40]).first)
        try XCTAssertNoThrow(ASLNttTables(coefficentCountPower: 8, modulus: modulus))
    }
    
    func testWithCoefficentCountPowerAndModulusAndPool() throws {
        let modulus = try XCTUnwrap(ASLCoefficientModulus.create(8192, bitSizes: [40,40,40,40]).first)
        try XCTAssertNoThrow(ASLNttTables(coefficentCountPower: 8, modulus: modulus, pool: .global()))
    }
    
    func testCreateWithCoefficentCountPower() throws {
        let modulus = try ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40])
        let otherTable = try ASLNttTables(coefficentCountPower: 8, modulus: modulus.first!)
        XCTAssertNoThrow(try ASLNttTables.create(withCoefficentCountPower: 4, modulus: modulus, tables: otherTable, pool: .global()))
    }
    
    func testNttNegacyclicHarveyWithOperand() throws {
        let tables = ASLSealContext.bfvDefault().firstContextData.smallNttTables
        XCTAssertNoThrow(tables.negacyclicHarvey(withOperand: 8))
    }
    
    func testNttNegacyclicHarveyLazyWithOperand() throws {
        let tables = ASLSealContext.bfvDefault().firstContextData.smallNttTables
        XCTAssertNoThrow(tables.negacyclicHarveyLazy(withOperand: 8))
    }
    
    func testInverseNttNegacyclicHarveyLazyWithOperand() throws {
        let tables = ASLSealContext.bfvDefault().firstContextData.smallNttTables
        XCTAssertNoThrow(tables.inverseNegacyclicHarvey(withOperand: 8))
    }
    
    func testInverseNttNegacyclicHarveyWithOperand() throws {
        let tables = ASLSealContext.bfvDefault().firstContextData.smallNttTables
        XCTAssertNoThrow(tables.inverseNegacyclicHarveyLazy(withOperand: 8))
    }
    
    func testGetFromRootPowersWithIndex() throws {
        let tables = ASLSealContext.bfvDefault().firstContextData.plainNttTables
        let _ = tables.getFromRootPowers(with: 0)
    }
    
    func testGetFromScaledRootPowersWithIndex() throws {
        let modulus = try ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40])
        let table = try ASLNttTables(coefficentCountPower: 8, modulus: modulus.first!)
        XCTAssertEqual(16777240, table.getFromScaledRootPowers(with: 0))
    }
    
    func testGetFromInverseRootPowersWithIndex() throws {
        let modulus = try ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40])
        let table = try ASLNttTables(coefficentCountPower: 8, modulus: modulus.first!)
        XCTAssertEqual(1, table.getFromInverseRootPowers(with: 0))
    }
    
    func testGetFromScaledInverseRootPowersWithIndex() throws {
        let modulus = try ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40])
        let table = try ASLNttTables(coefficentCountPower: 8, modulus: modulus.first!)
        XCTAssertEqual(16777240, table.getFromScaledInverseRootPowers(with: 0))
    }
    
    func testGetInverseDegreeModulo() throws {
        let modulus = try ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40])
        let table = try ASLNttTables(coefficentCountPower: 8, modulus: modulus.first!)
        XCTAssertEqual(1095215044801, table.getInverseDegreeModulo())
    }
    
    func testRoot() throws {
        let modulus = try ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40])
        let table = try ASLNttTables(coefficentCountPower: 8, modulus: modulus.first!)
        XCTAssertEqual(table.root, 914223477)
    }
    
    func testModulus() throws {
        let modulus = try ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40])
        let table = try ASLNttTables(coefficentCountPower: 8, modulus: modulus.first!)
        XCTAssertEqual(table.modulus, try ASLModulus(value: 1099510005761))
    }
    
    func testCoefficentCountPower() throws {
        let modulus = try ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40])
        let table = try ASLNttTables(coefficentCountPower: 8, modulus: modulus.first!)
        XCTAssertEqual(table.coefficentCountPower, 8)
    }
    
    func testCoefficentCount() throws {
        let modulus = try ASLCoefficientModulus.create(8192, bitSizes: [40, 40, 40, 40, 40])
        let table = try ASLNttTables(coefficentCountPower: 8, modulus: modulus.first!)
        XCTAssertEqual(table.coefficentCount, 256)
    }
}
