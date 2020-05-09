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
    var evaluator: ASLEvaluator! = nil
    
    var encryptor: ASLEncryptor! = nil
    var encoder: ASLIntegerEncoder! = nil
    var decryptor: ASLDecryptor! = nil
    var relinearizationKey: ASLRelinearizationKeys! = nil
    
    override func setUp() {
        super.setUp()
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        let polyModulusDegree = 4096
        try! parms.setPolynomialModulusDegree(polyModulusDegree)
        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try! parms.setPlainModulus(ASLSmallModulus(value: 1024))
        let context = try! ASLSealContext(parms)
        let keygen = try! ASLKeyGenerator(context: context)
        let publicKey = keygen.publicKey
        let secretKey = keygen.secretKey
        encryptor = try! ASLEncryptor(context: context, publicKey: publicKey)
        evaluator = try! ASLEvaluator(context)
        encoder = try! ASLIntegerEncoder(context: context)
        decryptor = try! ASLDecryptor(context: context, secretKey: secretKey)
        relinearizationKey = try! keygen.relinearizationKeys()
    }
    
    override func tearDown() {
        super.tearDown()
        evaluator = nil
        encryptor = nil
        encoder = nil
        decryptor = nil
        relinearizationKey = nil
    }
    
    func testNegate() throws {
        let encryptedResult = try evaluator.negate(encodeInt32(7), detination: ASLCipherText())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, -7)
    }
    
    func testNegateInplace() throws {
        let encryptedResult = try evaluator.negateInplace(encodeInt32(7))
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, -7)
    }
    
    func testAddInplace() throws {
        let encryptedResult = try evaluator.addInplace(encodeInt32(7), encrypted2: encodeInt32(3))
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 10)
    }
    
    func testAdd() throws {
        let encryptedResult = try evaluator.add(encodeInt32(7), encrypted2: encodeInt32(3), destination: ASLCipherText())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 10)
    }
    
    func testAddMany() throws {
        let encryptedResult = try evaluator.addMany([encodeInt32(2), encodeInt32(3)], destination: ASLCipherText())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 5)
    }
    
    func testSubInplace() throws {
        let encryptedResult = try evaluator.subInplace(encodeInt32(5), encrypted2: encodeInt32(2))
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 3)
    }
    
    func testSub() throws {
        let encryptedResult = try evaluator.sub(encodeInt32(5), encrypted2: encodeInt32(2), destination: ASLCipherText())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 3)
    }
    
    func testMultiplyInplace() throws {
        let encryptedResult = try evaluator.multiplyInplace(encodeInt32(2), encrypted2: encodeInt32(5))
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 10)
    }
    
    func testMultiplyInplaceWithPool() throws {
        let encryptedResult = try evaluator.multiplyInplace(encodeInt32(2), encrypted2: encodeInt32(5), pool: .global())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 10)
    }
    
    func testMultiply() throws {
        let encryptedResult = try evaluator.multiply(encodeInt32(2), encrypted2: encodeInt32(3), destination: ASLCipherText())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 6)
    }
    
    func testMultiplyWithPool() throws {
        let encryptedResult = try evaluator.multiply(encodeInt32(2), encrypted2: encodeInt32(3), destination: ASLCipherText(), pool: .global())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 6)
    }
    
    func testSquareInplace() throws {
        let encryptedResult = try evaluator.squareInplace(encodeInt32(2))
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testSquareInplaceWithPool() throws {
        let encryptedResult = try evaluator.squareInplace(encodeInt32(2), pool: .global())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testSquare() throws {
        let encryptedResult = try evaluator.square(encodeInt32(2), destination: ASLCipherText())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testSquareWithPool() throws {
        let encryptedResult = try evaluator.square(encodeInt32(2), destination: ASLCipherText(), pool: .global())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testRelinearizeInplace() throws {
        let encryptedResult = try evaluator.relinearizeInplace(encodeInt32(4), relinearizationKeys: relinearizationKey)
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testRelinearizeInplaceWithPool() throws {
        let encryptedResult = try evaluator.relinearizeInplace(encodeInt32(4), relinearizationKeys: relinearizationKey, pool: .global())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testRelinearize() throws {
        let encryptedResult = try evaluator.relinearize(encodeInt32(4), relinearizationKeys: relinearizationKey, destination: ASLCipherText())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testRelinearizeWithPool() throws {
        let encryptedResult = try evaluator.relinearize(encodeInt32(4), relinearizationKeys: relinearizationKey, destination: ASLCipherText(), pool: .global())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testModSwitchToNext() throws {
        let encryptedResult = try evaluator.modSwitch(toNext: encodeInt32(4), destination: ASLCipherText())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testModSwitchToNextWithPool() throws {
        let encryptedResult = try evaluator.modSwitch(toNext: encodeInt32(4), destination: ASLCipherText(), pool: .global())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testModSwitchToNextInplace() throws {
        let encryptedResult = try evaluator.modSwitch(toNextInplace: encodeInt32(4))
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testModSwitchToNextInplaceWithGlobal() throws {
        let encryptedResult = try evaluator.modSwitch(toNextInplace: encodeInt32(4), pool: .global())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testModSwitchToNextWithPlain() throws {
        let encryptedResult = try evaluator.modSwitch(toNext: ASLPlainText(polynomialString: "\(6)"))
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testModSwitchToInplace() throws {
        let paramId = ASLParametersIdType(block: (40, 40, 40, 40))
        let encryptedResult = try evaluator.modSwitch(toInplace: encodeInt32(3), parametersId: paramId)
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testModSwitchToInplaceWithPool() throws {
        let paramId = ASLParametersIdType(block: (40, 40, 40, 40))
        let encryptedResult = try evaluator.modSwitch(toInplace: encodeInt32(3), parametersId: paramId, pool: .global())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testModSwitchToWithParams() throws {
        let paramId = ASLParametersIdType(block: (40, 40, 40, 40))
        let encryptedResult = try evaluator.modSwitch(to: encodeInt32(4), parametersId: paramId, destination: ASLCipherText())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testModSwitchToWithParamsAndGloabl() throws {
        let paramId = ASLParametersIdType(block: (40, 40, 40, 40))
        let encryptedResult = try evaluator.modSwitch(to: encodeInt32(4), parametersId: paramId, destination: ASLCipherText(), pool: .global())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testModSwitchToInplaceWithPlain() throws {
        let paramId = ASLParametersIdType(block: (40, 40, 40, 40))
        let encryptedResult = try evaluator.modSwitchToInplace(withPlain: ASLPlainText(polynomialString: "3"), parametersId: paramId)
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testModSwitchToWithPlain() throws {
        let paramId = ASLParametersIdType(block: (40, 40, 40, 40))
        let encryptedResult = try evaluator.modSwitchTo(withPlain: ASLPlainText(polynomialString: "\(6)"), parametersId: paramId, destination: ASLPlainText())
        XCTAssertEqual(encryptedResult, try ASLPlainText(polynomialString: "\(6)"))
    }
    
    func testRescaleToNext() throws {
        let encryptedResult = try evaluator.rescale(toNext: encodeInt32(4), destination: ASLCipherText())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testRescaleToNextWithPool() throws {
        let encryptedResult = try evaluator.rescale(toNext: encodeInt32(4), destination: ASLCipherText(), pool: .global())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testRescaleToNextInplace() throws {
        let encryptedResult = try evaluator.rescale(toNextInplace: encodeInt32(4))
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testRescaleToNextInplaceWithParams() throws {
        let paramId = ASLParametersIdType(block: (40, 40, 40, 40))
        let encryptedResult = try evaluator.rescale(toInplace: encodeInt32(4), parametersId: paramId)
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testRescaleToNextInplaceWithParamsAndPool() throws {
        let paramId = ASLParametersIdType(block: (40, 40, 40, 40))
        let encryptedResult = try evaluator.rescale(toInplace: encodeInt32(4), parametersId: paramId, pool: .global())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testRescaleTo() throws {
        let paramId = ASLParametersIdType(block: (40, 40, 40, 40))
        let encryptedResult = try evaluator.rescale(to: encodeInt32(4), parametersId: paramId, destination: ASLCipherText())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testRescaleToWithPool() throws {
        let paramId = ASLParametersIdType(block: (40, 40, 40, 40))
        let encryptedResult = try evaluator.rescale(to: encodeInt32(4), parametersId: paramId, destination: ASLCipherText(), pool: .global())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testMultiplyMany() throws {
        let encryptedResult = try evaluator.multiplyMany([encodeInt32(4)], relinearizationKeys: relinearizationKey, destination: ASLCipherText())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testMultiplyManyWithPool() throws {
        let encryptedResult = try evaluator.multiplyMany([encodeInt32(4)], relinearizationKeys: relinearizationKey, destination: ASLCipherText(), pool: .global())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 4)
    }
    
    func testExponentiateInplace() throws {
        let encryptedResult = try evaluator.exponentiateInplace(encodeInt32(4), exponent: 2, relinearizationKeys: relinearizationKey)
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 16)
    }
    
    func testExponentiateInplaceWithPool() throws {
        let encryptedResult = try evaluator.exponentiateInplace(encodeInt32(4), exponent: 2, relinearizationKeys: relinearizationKey)
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 16)
    }
    
    func testExponentiate() throws {
        let encryptedResult = try evaluator.exponentiate(encodeInt32(3), exponent: 2, relinearizationKeys: relinearizationKey, destination: ASLCipherText())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 16)
    }
    
    func testExponentiateWithPool() throws {
        let encryptedResult = try evaluator.exponentiate(encodeInt32(3), exponent: 2, relinearizationKeys: relinearizationKey, destination: ASLCipherText(), pool: .global())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 9)
    }
    
    func testAddPlainInplace() throws {
        let encryptedResult = try evaluator.addPlainInplace(encodeInt32(4), plain: ASLPlainText(polynomialString: "\(6)"))
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 10)
    }
    
    func testAddPlain() throws {
        let encryptedResult = try evaluator.addPlain(encodeInt32(4), plain: ASLPlainText(polynomialString: "\(6)"), destination: ASLCipherText())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 10)
    }
    
    func testAddPlainWithEncrypted() throws {
        let encryptedResult = try evaluator.addPlain(encodeInt32(4), plain: ASLPlainText(polynomialString: "\(6)"), destination: ASLCipherText())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 10)
    }
    
    func testSubPlainInplace() throws {
        let encryptedResult = try evaluator.subPlainInplace(encodeInt32(4), plain: ASLPlainText(polynomialString: "\(6)"))
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 10)
    }
    
    func testSubPlain() throws {
        let encryptedResult = try evaluator.subPlain(encodeInt32(4), plain: ASLPlainText(polynomialString: "\(6)"), destination: ASLCipherText())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, -2)
    }
    
    func testMultiplyPlainInplace() throws {
        let encryptedResult = try evaluator.multiplyPlainInplace(encodeInt32(4), plain: ASLPlainText(polynomialString: "\(6)"))
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 24)
    }
    
    func testMultiplyPlainInplaceWithPool() throws {
        let encryptedResult = try evaluator.multiplyPlainInplace(encodeInt32(4), plain: ASLPlainText(polynomialString: "\(6)"), pool: .global())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 24)
    }
    
    func testMultiplyPlain() throws {
        let encryptedResult = try evaluator.multiplyPlain(encodeInt32(4), plain: ASLPlainText(polynomialString: "\(6)"), destination: ASLCipherText())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 24)
    }
    
    func testMultiplyPlainWithPool() throws {
        let encryptedResult = try evaluator.multiplyPlain(encodeInt32(4), plain: ASLPlainText(polynomialString: "\(6)"), destination: ASLCipherText(), pool: .global())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 24)
    }
    
    func testTransformToNttInplace() throws {
        let paramId = ASLParametersIdType(block: (40, 40, 40, 40))
        let encryptedResult = try evaluator.transform(toNttInplace: ASLPlainText(polynomialString: "\(6)"), parametersId: paramId)
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 24)
    }
    
    func testTransformToNtt() throws {
        let encryptedResult = try evaluator.transform(toNtt: encodeInt32(4), destinationNtt: ASLCipherText())
        let plainResult = try decryptor.decrypt(encryptedResult, destination: ASLPlainText())
        let decodedResult = try encoder.decodeInt32(withPlain: plainResult)
        XCTAssertEqual(decodedResult, 24)
    }
    
    // TODO - add remaining tests
    
    func testTransformToNttWithPool() throws {
        
    }
    
    
    private func encodeInt32(_ value: Int32) -> ASLCipherText {
        let plain = encoder.encodeInt32Value(value)
        return try! encryptor.encrypt(with: plain, destination: ASLCipherText())
    }
    
}
