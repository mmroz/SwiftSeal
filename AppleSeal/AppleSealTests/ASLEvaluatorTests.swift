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
        XCTAssertNoThrow(try ASLEvaluator(.bfvDefault))
    }
}
