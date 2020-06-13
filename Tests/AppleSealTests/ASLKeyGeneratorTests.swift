//
//  ASLKeyGeneratorTests.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-03-28.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class ASLKeyGeneratorTests: XCTestCase {
    
    var keyGenerator: ASLKeyGenerator! = nil
    
    override func setUp() {
        super.setUp()
        let context = ASLSealContext.bfvDefault()
        self.keyGenerator = try! ASLKeyGenerator(context: context)
    }
    
    override func tearDown() {
        super.tearDown()
        keyGenerator = nil
    }
    
    func testCreateWithSecretKey() throws {
        let context = ASLSealContext.bfvDefault()
        let keyGenerator = try! ASLKeyGenerator(context: context)
        let secretKey = keyGenerator.secretKey
        
        XCTAssertNoThrow(try ASLKeyGenerator(context: context, secretKey: secretKey))
    }
    
    func testPublicKey() throws {
        XCTAssertNoThrow(keyGenerator.publicKey)
    }
    
    func testSecretKey() throws {
        XCTAssertNoThrow(keyGenerator.secretKey)
    }
    
    func testRelinearizationKeysLocal() throws {
        XCTAssertNoThrow(try keyGenerator.relinearizationKeysLocal())
    }
    
    func testRelinearizationKeys() throws {
       let relinKey = try keyGenerator.relinearizationKeys()
        
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        archiver.encode(relinKey, forKey: "testObject")
        let data = archiver.encodedData
        
        let decodedRelinKey = try ASLRelinearizationKeys(data: data, context: .bfvDefault())
        
        XCTAssertEqual(relinKey, decodedRelinKey)
    }
    
    func testGaloisKeysLocalWithGaloisElements() throws {
        let result = try keyGenerator.galoisKeysLocal(withGaloisElements: [1,2])
        XCTAssertEqual(result, ASLGaloisKeys())
    }
    
    func testGaloisKeysWithGaloisElements() throws {
        let galoisKey = try keyGenerator.galoisKeys(withGaloisElements: [4,16,256])
        
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        archiver.encode(galoisKey, forKey: "testObject")
        let data = archiver.encodedData
        
        let unarchiver = try! NSKeyedUnarchiver(forReadingFrom: data)
        unarchiver.requiresSecureCoding = false
        let decodedGaloisKey = unarchiver.decodeObject(of: ASLGaloisKeys.self, forKey: "testObject")!
        
        XCTAssertEqual(galoisKey, decodedGaloisKey)
    }
    
    func testGaloisKeysLocalWithSteps() throws {
        let result = try keyGenerator.galoisKeysLocal(withSteps: [1,2])
        
        XCTAssertEqual(result, ASLGaloisKeys())
    }
    
    func testGaloisKeysWithSteps() throws {
        let galoisKey = try keyGenerator.galoisKeys(withSteps: [4,16,256])
        
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        archiver.encode(galoisKey, forKey: "testObject")
        let data = archiver.encodedData
        
        let unarchiver = try! NSKeyedUnarchiver(forReadingFrom: data)
        unarchiver.requiresSecureCoding = false
        let decodedGaloisKey = unarchiver.decodeObject(of: ASLGaloisKeys.self, forKey: "testObject")!
        
        XCTAssertEqual(galoisKey, decodedGaloisKey)
    }
    
    func testGaloisKeys() throws {
        let galoisKey = try keyGenerator.galoisKeys()
        
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        archiver.encode(galoisKey, forKey: "testObject")
        let data = archiver.encodedData
        
        let unarchiver = try! NSKeyedUnarchiver(forReadingFrom: data)
        unarchiver.requiresSecureCoding = false
        let decodedGaloisKey = unarchiver.decodeObject(of: ASLGaloisKeys.self, forKey: "testObject")!
        
        XCTAssertEqual(galoisKey, decodedGaloisKey)
    }
    
    func testGaloisKeysWithLocal() throws {
        XCTAssertNoThrow(try keyGenerator.galoisKeysLocal())
    }
}
