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
    
    var context: ASLSealContext? = nil
    
    override func setUp() {
        super.setUp()
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        
        let polyModulusDegree = 4096
        try! parms.setPolynomialModulusDegree(polyModulusDegree)
        
        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        
        try! parms.setPlainModulus(ASLSmallModulus(value: 1024))
        
        context = try! ASLSealContext(parms)
    }
    
    override func tearDown() {
        super.tearDown()
        context = nil
    }
// TODO
    func testCreateWithDefaultInitializers() {
        _ = ASLSmallNttTables()
    }

// TODO
    func testCreateWithPool() throws {
        _ = ASLSmallNttTables(pool: ASLMemoryPoolHandle(clearOnDestruction: true))
    }
    
    func testCreateWithPower() throws {
        try ASLSealContext(ASLEncryptionParameters(schemeType: .CKKS)).firstContextData.smallNttTables
        _ = ASLSmallNttTables(coefficentCountPower: 2, smallModulus: try ASLSmallModulus(value: 5))
    }
    
    func testCreateWithPowerWithPool() throws {
           _ = ASLSmallNttTables(coefficentCountPower: 2, smallModulus: try ASLSmallModulus(value: 5), pool: ASLMemoryPoolHandle(clearOnDestruction: true))
    }
    
    func testGenerateReturnsTrueWhenSuccessful() throws {
        let  tables = context!.firstContextData.smallNttTables
        XCTAssertTrue(tables.generate(2, smallModulus: try ASLSmallModulus(value: 5)))
    }
    
    func testResetClearsData() throws {
         let  tables = context!.firstContextData.smallNttTables
        
        tables.reset()
    }
    
    func testGetFromRootPowersWithIndex() {
         let  tables = context!.firstContextData.smallNttTables
        XCTAssertEqual(1, tables.getFromRootPowers(withIndex: 0))
    }
    
    func testGetFromScaledRootPowersWithIndex() {
        let  tables = context!.firstContextData.smallNttTables
        XCTAssertEqual(1, tables.getFromScaledRootPowers(withIndex: 0))
    }
    
    func testGetFromInverseRootPowersWithIndex() {
         let  tables = ASLSmallNttTables(pool: ASLMemoryPoolHandle(clearOnDestruction: true))
        XCTAssertEqual(1, tables.getFromInverseRootPowers(withIndex: 0))
    }
    
    func testGetFromScaledInverseRootPowersWithIndex() {
         let  tables = ASLSmallNttTables(pool: ASLMemoryPoolHandle(clearOnDestruction: true))
        XCTAssertEqual(1, tables.getFromScaledInverseRootPowers(withIndex: 0))
    }
    
    
    func testGetFromScaledInverseRootPowersDividedByTwoWithIndex() {
         let  tables = ASLSmallNttTables(pool: ASLMemoryPoolHandle(clearOnDestruction: true))
        XCTAssertEqual(1, tables.getFromScaledInverseRootPowersDividedByTwo(withIndex: 0))
    }


    func testGetFromInverseRootPowersDividedByTwoWithIndex() {
         let  tables = context!.firstContextData.smallNttTables
        return XCTAssertEqual(34359701505, tables.getFromInverseRootPowersDividedByTwo(withIndex: 0))
    }
    
    func testGetInverseDegreeModulo() {
         let  tables = ASLSmallNttTables(pool: ASLMemoryPoolHandle(clearOnDestruction: true))
        XCTAssertEqual(1, tables.getInverseDegreeModulo())
    }
    
    func testRoot() {
         let  tables = ASLSmallNttTables(pool: ASLMemoryPoolHandle(clearOnDestruction: true))
         XCTAssertEqual(1, tables.root)
    }
    
    func testModulus() {
         let  tables = ASLSmallNttTables(pool: ASLMemoryPoolHandle(clearOnDestruction: true))
         XCTAssertEqual(try ASLSmallModulus(value: 5), tables.modulus)
    }
    

    func testCoefficentCountPower() {
         let  tables = context!.firstContextData.smallNttTables
        XCTAssertEqual(1, tables.coefficentCount)
    }

    func testCoefficentCount() {
         let  tables = ASLSmallNttTables(pool: ASLMemoryPoolHandle(clearOnDestruction: true))
         XCTAssertEqual(1, tables.coefficentCount)
    }
}
