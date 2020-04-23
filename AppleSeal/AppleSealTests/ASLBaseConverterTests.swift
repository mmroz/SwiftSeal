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

class ASLBaseConverterTests: XCTestCase {
    func testCreateWithMemoryPoolHandle() {
        let _ = ASLBaseConverter(pool: ASLMemoryPoolHandle.createNew(true))
    }
    
    func testCreate() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let _ = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
    }
    
    func testGenerate() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let converter = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
        
        converter.generate([try ASLSmallModulus(value: 2)], coefficientCount: 4, smallPlainModulus: try ASLSmallModulus(value: 4))
    }
    
    func testFloorLastCoeffModulusInplace() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let converter = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
        
        converter.floorLastCoefficientModulusInplace(5, pool: memoryPool)
    }
    
    func testRoundLastCoefficientModulusInplacet() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let converter = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
        
        converter.roundLastCoefficientModulusInplace(5, pool: memoryPool)
    }
    
    func testFastBaseConverterQToBsk() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let converter = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
        
        converter.fastBaseConverterQ(toBsk: 4, destination: 2, pool: memoryPool)
    }
    
    func testFastBaseConverterBskToQ() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let converter = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
        
        converter.fastBaseConverterBsk(toQ: 4, destination: 2, pool: memoryPool)
    }
    
    func testReduceBskPrimeToBsk() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let converter = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
        
        converter.reduceBskPrime(toBsk: 4, destination: 2)
    }
    
    func testFastFloor() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let converter = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
        
        converter.fastFloor(4, destination: 2, pool: memoryPool)
    }
    
    func testFastFloorFastBaseConverterQToBskPrime() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let converter = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
        
        converter.fastFloorFastBaseConverterQ(toBskPrime: 4, destination: 2, pool: memoryPool)
    }
    
    func testFastBaseConverterPlainGamma() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let converter = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
        
        converter.fastBaseConverterPlainGamma(4, destination: 2, pool: memoryPool)
    }
    
    func testReset() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let converter = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
        
        converter.reset()
    }
    
    func testIsGenerated() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let converter = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
        
        XCTAssertFalse(converter.isGenerated)
        
        converter.generate(smallModuluses, coefficientCount: 2, smallPlainModulus: plainModulus)
        
        XCTAssertTrue(converter.isGenerated)
    }
    
    func testCoefficientBaseMododulusCount() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let converter = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
        
        XCTAssertEqual(converter.coefficientBaseMododulusCount, 2)
    }
    
    func testAuxBaseModCount() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let converter = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
        
        XCTAssertEqual(converter.auxBaseModCount, 2)
    }
    
    func testInvertedGamma() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let converter = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
        
        XCTAssertEqual(converter.invertedGamma, 2)
    }
    
    func testMsk() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let converter = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
        
        XCTAssertEqual(converter.msk, try ASLSmallModulus(value: 4))
    }
    
    func testPrime() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let converter = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
        
        XCTAssertEqual(converter.mPrime, try ASLSmallModulus(value: 4))
    }
    
    func testMPrimeInverseCoefficientProductsModulusCoefficient() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let converter = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
        
        XCTAssertEqual(converter.mPrimeInverseCoefficientProductsModulusCoefficient, 4)
    }
    
    func testInverseCoefficientModulusMPrime() throws {
        let memoryPool = ASLMemoryPoolHandle.createNew(true)
        let smallModuluses = [try ASLSmallModulus(value: 2)]
        let plainModulus = try ASLSmallModulus(value: 4)
        
        let converter = ASLBaseConverter(moduluses: smallModuluses, coefficientCount: 4, smallPlainModulus: plainModulus, pool: memoryPool)
        
        XCTAssertEqual(converter.inverseCoefficientModulusMPrime, 4)
    }
}
