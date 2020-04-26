//
//  ASLBatchEncoderTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-03-14.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLBatchEncoderTests: XCTestCase {
    
    // MARK: - Tests
    
    func testCreateBatchEncoder() throws {
        XCTAssertNoThrow(_ = try ASLBatchEncoder(context: .bfvDefault))
    }
    
    func testSlotCount() throws {
        let batchEncoder = try ASLBatchEncoder(context: .bfvDefault)
        XCTAssertEqual(batchEncoder.slotCount, 1)
    }
    
    func testEncoderWithPlainText() throws {
        let batchEncoder = try ASLBatchEncoder(context: .bfvDefault)
        
        let plainText = try ASLPlainText(coefficientCount: 2)
        try batchEncoder.encode(with: plainText)
    }
    
    func testEncoderWithPlainTextWithMemoryPoolHandle() throws {
        let batchEncoder = try ASLBatchEncoder(context: .bfvDefault)
        
        let plainText = try ASLPlainText(coefficientCount: 2)
        try batchEncoder.encode(with: plainText, pool: ASLMemoryPoolHandle(clearOnDestruction: true))
    }
    
    func testEncoderWithPlainTextWithSignedValues() throws {
        let batchEncoder = try ASLBatchEncoder(context: .bfvDefault)
        
        let plainText = try ASLPlainText(coefficientCount: 2)
        try batchEncoder.encode(withSignedValues: [1], destination: plainText)
    }
    
    func testEncoderWithPlainTextWithUnsignedValues() throws {
        let batchEncoder = try ASLBatchEncoder(context: .bfvDefault)
        
        let plainText = try ASLPlainText(coefficientCount: 2)
        try batchEncoder.encode(withUnsignedValues: [1], destination: plainText)
    }
}
