//
//  ASLEvaluatorTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-03-24.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLEvaluatorTests: XCTestCase {
    func testCreateWithWithContext() throws {
        XCTAssertNoThrow(try ASLEvaluator(createValidContext()))
    }
    
    private func createValidContext() throws -> ASLSealContext {
        let params = ASLEncryptionParameters(schemeType: .BFV)
        try params.setPolynomialModulusDegree(8192)
        try params.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(8192))
        try params.setPlainModulusWithInteger(65537)
        let context = try ASLSealContext(encrytionParameters: params, expandModChain: true, securityLevel: .None, memoryPoolHandle: ASLMemoryPoolHandle.createNew(true))
        return context
    }
}
