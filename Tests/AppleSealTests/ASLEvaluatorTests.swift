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
    
    var context: ASLSealContext!
    
    var keyGen: ASLKeyGenerator {
        try! ASLKeyGenerator(context: context)
    }
    
    var evaluator: ASLEvaluator {
        try! ASLEvaluator(context)
    }
    
    var encoder: ASLIntegerEncoder {
        try! ASLIntegerEncoder(context: context)
    }
    
    var encryptor: ASLEncryptor {
        try! ASLEncryptor(context: context, publicKey: keyGen.publicKey)
    }
    
    var decryptor: ASLDecryptor {
        try! ASLDecryptor(context: context, secretKey: keyGen.secretKey)
    }
    
    var relinKeys: ASLRelinearizationKeys {
        try! keyGen.relinearizationKeysLocal()
    }
    
    var params: ASLParametersIdType {
        context.firstContextData.parametersId
    }
    
    var ckksPlainFive: ASLPlainText {
        try! ASLCKKSEncoder(context: context).encode(withLongValue: 5)
    }
    
    var plainFive: ASLPlainText {
        encoder.encodeInt64Value(5)
    }
    var encryptedFive: ASLCipherText {
        let plain = encoder.encodeInt64Value(5)
        return try! encryptor.encrypt(with: plain)
    }
    var encryptedSeven: ASLCipherText {
        let plain = encoder.encodeInt64Value(7)
        return try! encryptor.encrypt(with: plain)
    }
    
    override func setUp() {
        super.setUp()
        context = standardContext()
    }
    
    override func tearDown() {
        super.tearDown()
        context = nil
    }
    
    func testCreateWithContext() throws {
        XCTAssertNoThrow(try ASLEvaluator(.bfvDefault()))
    }
    
    func testNegate() throws {
        XCTAssertNoThrow(try evaluator.negate(encryptedFive))
    }
    
    func testNegateInplace() throws {
        XCTAssertNoThrow(try evaluator.negateInplace(encryptedFive))
    }
    
    func testAddInplace() throws {
        XCTAssertNoThrow(try evaluator.addInplace(encryptedFive, encrypted2: encryptedFive))
    }
    
    func testAdd() throws {
        XCTAssertNoThrow(try evaluator.add(encryptedFive, encrypted2: encryptedFive))
    }
    
    func testAddMany() throws {
        XCTAssertNoThrow(try evaluator.addMany([encryptedFive, encryptedFive, encryptedFive]))
    }
    
    func testSubInplace() throws {
        XCTAssertNoThrow(try evaluator.subInplace(encryptedSeven, encrypted2: encryptedFive))
    }
    
    func testSub() throws {
        XCTAssertNoThrow(try evaluator.subInplace(encryptedSeven, encrypted2: encryptedFive))
    }
    
    func testMultiplyInplace() throws {
        XCTAssertNoThrow(try evaluator.multiplyInplace(encryptedFive, encrypted2: encryptedFive))
    }
    
    func testMultiplyInplaceWithPool() throws {
        XCTAssertNoThrow(try evaluator.multiplyInplace(encryptedFive, encrypted2: encryptedFive, pool: .global()))
    }
    
    func testMultiply() throws {
        XCTAssertNoThrow(try evaluator.multiply(encryptedFive, encrypted2: encryptedFive))
    }
    
    func testMultiplyWithPool() throws {
        XCTAssertNoThrow(try evaluator.multiply(encryptedFive, encrypted2: encryptedFive, pool: .global()))
    }
    
    func testSquareInplace() throws {
        XCTAssertNoThrow(try evaluator.squareInplace(encryptedFive))
    }
    
    func testSquareInplaceWithPool() throws {
        XCTAssertNoThrow(try evaluator.squareInplace(encryptedFive, pool: .global()))
    }
    
    func testSquare() throws {
        XCTAssertNoThrow(try evaluator.square(encryptedFive))
    }
    
    func testSquareWithPool() throws {
        XCTAssertNoThrow(try evaluator.square(encryptedFive, pool: .global()))
    }
    
    func testRelinearizeInplace() throws {
        XCTAssertNoThrow(try evaluator.relinearizeInplace(encryptedFive, relinearizationKeys: relinKeys))
    }
    
    func testRelinearizeInplaceWithPool() throws {
        XCTAssertNoThrow(try evaluator.relinearizeInplace(encryptedFive, relinearizationKeys: relinKeys, pool: .global()))
    }
    
    func testRelinearize() throws {
        XCTAssertNoThrow(try evaluator.relinearize(encryptedFive, relinearizationKeys: relinKeys))
    }
    
    func testRelinearizeWithPool() throws {
        XCTAssertNoThrow(try evaluator.relinearize(encryptedFive, relinearizationKeys: relinKeys, pool: .global()))
    }
    
    func testModSwitchToNext() throws {
        XCTAssertNoThrow(try evaluator.modSwitch(toNext: encryptedFive))
    }
    
    func testModSwitchToNextWithPool() throws {
        XCTAssertNoThrow(try evaluator.modSwitch(toNext: encryptedFive, pool: .global()))
    }
    
    func testModSwitchToNextInplace() throws {
        XCTAssertNoThrow(try evaluator.modSwitch(toNextInplace: encryptedFive))
    }
    
    func testModSwitchToNextInplaceWithPool() throws {
        XCTAssertNoThrow(try evaluator.modSwitch(toNextInplace: encryptedFive, pool: .global()))
    }
    
    func testModSwitchToNextWithPlain() throws {
        // TODO - fix this
        //XCTAssertNoThrow(try evaluator.modSwitchToNext(withPlain: try ASLPlainText(polynomialString: "1x^127")))
    }
    
    func testModSwitchToInplace() throws {
        XCTAssertNoThrow(try evaluator.modSwitch(toInplace: encryptedFive, parametersId: params))
    }
    
    func testModSwitchToInplaceWithPool() throws {
        XCTAssertNoThrow(try evaluator.modSwitch(toInplace: encryptedFive, parametersId: params, pool: .global()))
    }
    
    func testModSwitchTo() throws {
        XCTAssertNoThrow(try evaluator.modSwitch(to: encryptedFive, parametersId: params))
    }
    
    func testModSwitchToWithPool() throws {
        XCTAssertNoThrow(try evaluator.modSwitch(to: encryptedFive, parametersId: params, pool: .global()))
    }
    
    func testModSwitchToInplaceWithPlain() throws {
        context = ckksContext()
        XCTAssertNoThrow(try evaluator.modSwitchToInplace(withPlain: ckksPlainFive, parametersId: params))
    }
    
    func testModSwitchToWithPlain() throws {
        context = ckksContext()
        XCTAssertNoThrow(try evaluator.modSwitchTo(withPlain: ckksPlainFive, parametersId: params))
    }
    
    func testRescaleToNext() throws {
        context = ckksContext()
        let five = try! encryptor.encrypt(with: ckksPlainFive)
        XCTAssertNoThrow(try evaluator.rescale(toNext: five))
    }
    
    func testRescaleToNextWithPool() throws {
        context = ckksContext()
        let five = try! encryptor.encrypt(with: ckksPlainFive)
        XCTAssertNoThrow(try evaluator.rescale(toNext: five, pool: .global()))
    }
    
    func testRescaleToNextInplace() throws {
        context = ckksContext()
        let five = try! encryptor.encrypt(with: ckksPlainFive)
        XCTAssertNoThrow(try evaluator.rescale(toNextInplace: five))
    }
    
    func testRescaleToNextInplaceWithPool() throws {
        context = ckksContext()
        let five = try! encryptor.encrypt(with: ckksPlainFive)
        XCTAssertNoThrow(try evaluator.rescale(toNextInplace: five, pool: .global()))
    }
    
    func testRescaleToInplace() throws {
        context = ckksContext()
        let five = try! encryptor.encrypt(with: ckksPlainFive)
        XCTAssertNoThrow(try evaluator.rescale(toInplace: five, parametersId: params))
    }
    
    func testRescaleToInplaceWithPool() throws {
        context = ckksContext()
        let five = try! encryptor.encrypt(with: ckksPlainFive)
        XCTAssertNoThrow(try evaluator.rescale(toInplace: five, parametersId: params, pool: .global()))
    }
    
    func testRescaleTo() throws {
        context = ckksContext()
        let five = try! encryptor.encrypt(with: ckksPlainFive)
        XCTAssertNoThrow(try evaluator.rescale(to: five, parametersId: params))
    }
    
    func testRescaleToWithPool() throws {
        context = ckksContext()
        let five = try! encryptor.encrypt(with: ckksPlainFive)
        XCTAssertNoThrow(try evaluator.rescale(to: five, parametersId: params, pool: .global()))
    }
    
    func testMultiplyMany() throws {
        context = standardContext()
        XCTAssertNoThrow(try evaluator.multiplyMany([encryptedFive, encryptedFive], relinearizationKeys: relinKeys))
    }
    
    func testMultiplyManyWithPool() throws {
        context = standardContext()
        XCTAssertNoThrow(try evaluator.multiplyMany([encryptedFive, encryptedSeven], relinearizationKeys: relinKeys, pool: .global()))
    }
    
    func testExponentiateInplace() throws {
        XCTAssertNoThrow(try evaluator.exponentiateInplace(encryptedFive, exponent: 2, relinearizationKeys: relinKeys))
    }
    
    func testExponentiateInplaceWithPool() throws {
        context = standardContext()
        XCTAssertNoThrow(try evaluator.exponentiateInplace(encryptedFive, exponent: 2, relinearizationKeys: relinKeys, pool: .global()))
    }
    
    func testExponentiate() throws {
        XCTAssertNoThrow(try evaluator.exponentiate(encryptedFive, exponent: 2, relinearizationKeys: relinKeys, pool: .global()))
    }
    
    func testExponentiateWithPool() throws {
        XCTAssertNoThrow(try evaluator.exponentiate(encryptedFive, exponent: 2, relinearizationKeys: relinKeys))
    }
    
    func testAddPlainInplace() throws {
        XCTAssertNoThrow(try evaluator.addPlainInplace(encryptedFive, plain: plainFive))
    }
    
    func testAddPlain() throws {
        let x = 6
        let xPlain = try ASLPlainText(polynomialString: "\(x)")
        let xEncrypted = try encryptor.encrypt(with: xPlain)
        XCTAssertNoThrow(try evaluator.addPlain(xEncrypted, plain: plainFive))
    }
    
    func testSubPlainInplace() throws {
        XCTAssertNoThrow(try evaluator.subPlainInplace(encryptedSeven, plain: plainFive))
    }
    
    func testSubPlain() throws {
        XCTAssertNoThrow(try evaluator.subPlain(encryptedSeven, plain: plainFive))
    }
    
    func testMultiplyPlainInplace() throws {
        XCTAssertNoThrow(try evaluator.multiplyPlainInplace(encryptedFive, plain: plainFive))
    }
    
    func testMultiplyPlainInplaceWithPool() throws {
        XCTAssertNoThrow(try evaluator.multiplyPlainInplace(encryptedFive, plain: plainFive, pool: .global()))
    }
    
    func testMultiplyPlain() throws {
        XCTAssertNoThrow(try evaluator.multiplyPlain(encryptedFive, plain: plainFive))
    }
    
    func testMultiplyPlainWithPool() throws {
        XCTAssertNoThrow(try evaluator.multiplyPlain(encryptedFive, plain: plainFive, pool: .global()))
    }
    
    func testTransformToNttInplace() throws {
        XCTAssertNoThrow(try evaluator.transform(toNttInplace: plainFive, parametersId: params))
    }
    
    func testTransformToNttInplaceWithPool() throws {
        XCTAssertNoThrow(try evaluator.transform(toNttInplace: plainFive, parametersId: params, pool: .global()))
    }
    
    func testTransformToNtt() throws {
        XCTAssertNoThrow(try evaluator.transform(toNtt: plainFive, parametersId: params))
    }
    
    func testTransformToNttWithPool() throws {
        XCTAssertNoThrow(try evaluator.transform(toNtt: plainFive, parametersId: params, pool: .global()))
    }
    
    func testTransformToNttInplaceWithCipherText() throws {
        XCTAssertNoThrow(try evaluator.transform(toNtt: plainFive, parametersId: params))
    }
    
    func testTransformFromNttInplace() throws {
        context = {
            let parms = ASLEncryptionParameters(schemeType: .BFV)
            let plainModulus = try! ASLModulus(value: 1 << 6)
            try! parms.setPolynomialModulusDegree(128)
            try! parms.setPlainModulus(plainModulus)
            try! parms.setCoefficientModulus(ASLCoefficientModulus.create(128, bitSizes: [40, 40]))
            return try! ASLSealContext(parms, expandModChain: false, securityLevel: .None, handle: .global())
        }()
        
        let encrypted = try encryptor.encrypt(with: ASLPlainText())
        let transformed = try evaluator.transform(toNttInplace: encrypted)
        XCTAssertNoThrow(try evaluator.transform(fromNttInplace: transformed))
    }
    
    func testTransformFromNtt() throws {
        context = {
            let parms = ASLEncryptionParameters(schemeType: .BFV)
            let plainModulus = try! ASLModulus(value: 1 << 6)
            try! parms.setPolynomialModulusDegree(128)
            try! parms.setPlainModulus(plainModulus)
            try! parms.setCoefficientModulus(ASLCoefficientModulus.create(128, bitSizes: [40, 40]))
            return try! ASLSealContext(parms, expandModChain: false, securityLevel: .None, handle: .global())
        }()
        
        let encrypted = try encryptor.encrypt(with: ASLPlainText())
        let transformed = try evaluator.transform(toNttInplace: encrypted)
        XCTAssertNoThrow(try evaluator.transform(fromNtt: transformed))
    }
    
    func testApplyGaloisInplace() throws {
        context = galoisContext()
        let key = try keyGen.galoisKeysLocal(withGaloisElements: [1, 3, 5, 15])
        XCTAssertNoThrow(try evaluator.applyGaloisInplace(encryptedSeven, galoisElement: 1, galoisKey: key))
    }
    
    func testApplyGaloisInplaceWithPool() throws {
        context = galoisContext()
        let key = try keyGen.galoisKeysLocal(withGaloisElements: [1, 3, 5, 15])
        XCTAssertNoThrow(try evaluator.applyGaloisInplace(encryptedSeven, galoisElement: 1, galoisKey: key, pool: .global()))
    }
    
    func testApplyGalois() throws {
        context = galoisContext()
        let key = try keyGen.galoisKeysLocal(withGaloisElements: [1, 3, 5, 15])
        XCTAssertNoThrow(try evaluator.applyGalois(encryptedSeven, galoisElement: 1, galoisKey: key))
    }
    
    func testApplyGaloisWithPool() throws {
        context = galoisContext()
        let key = try keyGen.galoisKeysLocal(withGaloisElements: [1, 3, 5, 15])
        XCTAssertNoThrow(try evaluator.applyGalois(encryptedSeven, galoisElement: 1, galoisKey: key, pool: .global()))
    }
    
    func testRotateRowsInplace() throws {
        context = galoisContext()
        let key = try keyGen.galoisKeysLocal(withGaloisElements: [1, 3, 5, 15])
        XCTAssertNoThrow(try evaluator.rotateRowsInplace(encryptedSeven, steps: 1, galoisKey: key))
    }
    
    func testRotateRowsInplaceWithPool() throws {
        context = galoisContext()
        let key = try keyGen.galoisKeysLocal()
        XCTAssertNoThrow(try evaluator.rotateRowsInplace(encryptedSeven, steps: 2, galoisKey: key, pool: .global()))
    }
    func testRotateRows() throws {
        context = galoisContext()
        let key = try keyGen.galoisKeysLocal()
        XCTAssertNoThrow(try evaluator.rotateRows(encryptedSeven, steps: 2, galoisKey: key))
    }
    
    func testRotateRowsWithPool() throws {
        context = galoisContext()
        let key = try keyGen.galoisKeysLocal()
        XCTAssertNoThrow(try evaluator.rotateRows(encryptedSeven, steps: 2, galoisKey: key, pool: .global()))
    }
    
    func testRotateColumnsInplace() throws {
        context = galoisContext()
        let key = try keyGen.galoisKeysLocal(withGaloisElements: [1, 3, 5, 15])
        XCTAssertNoThrow(try evaluator.rotateColumnsInplace(encryptedSeven, galoisKey: key, pool: .global()))
    }
    
    func testRotateColumnsInplaceWithPool() throws {
        context = galoisContext()
        let key = try keyGen.galoisKeysLocal(withGaloisElements: [1, 3, 5, 15])
        XCTAssertNoThrow(try evaluator.rotateColumnsInplace(encryptedSeven, galoisKey: key))
    }
    
    func testRotateColumns() throws {
        context = galoisContext()
        let key = try keyGen.galoisKeysLocal(withGaloisElements: [1, 3, 5, 15])
        XCTAssertNoThrow(try evaluator.rotateColumns(encryptedSeven, galoisKey: key))
    }
    
    func testRotateColumnsWithPool() throws {
        context = galoisContext()
        let key = try keyGen.galoisKeysLocal(withGaloisElements: [1, 3, 5, 15])
        XCTAssertNoThrow(try evaluator.rotateColumns(encryptedSeven, galoisKey: key, pool: .global()))
    }
    
    func testRotateVectorInplace() throws {
        context = ckksContext()
        let key = try keyGen.galoisKeysLocal(withGaloisElements: [1, 3, 5, 15])
        let encrypted = try ASLCKKSEncoder(context: context).encode(withDoubleValues: [1.1, 2.2, 3.3], scale: pow(3.0, 30))
        let cipher = try encryptor.encrypt(with: encrypted)
        XCTAssertNoThrow(try evaluator.rotateVector(cipher , steps: 1, galoisKey: key))
    }
    
    func testRotateVectorInplaceWithPool() throws {
        context = ckksContext()
        let key = try keyGen.galoisKeysLocal(withGaloisElements: [1, 3, 5, 15])
        let encrypted = try ASLCKKSEncoder(context: context).encode(withDoubleValues: [1.1, 2.2, 3.3], scale: pow(3.0, 30))
        let cipher = try encryptor.encrypt(with: encrypted)
        XCTAssertNoThrow(try evaluator.rotateVectorInplace(cipher, steps: 1, galoisKey: key, pool: .global()))
    }
    
    func testRotateVector() throws {
        context = ckksContext()
        let key = try keyGen.galoisKeysLocal(withGaloisElements: [1, 3, 5, 15])
        let encrypted = try ASLCKKSEncoder(context: context).encode(withDoubleValues: [1.1, 2.2, 3.3], scale: pow(3.0, 30))
        let cipher = try encryptor.encrypt(with: encrypted)
        XCTAssertNoThrow(try evaluator.rotateVectorInplace(cipher, steps: 1, galoisKey: key))
    }
    
    func testRotateVectorWithPool() throws {
        context = ckksContext()
        let key = try keyGen.galoisKeysLocal(withGaloisElements: [1, 3, 5, 15])
        let encrypted = try ASLCKKSEncoder(context: context).encode(withDoubleValues: [1.1, 2.2, 3.3], scale: pow(3.0, 30))
        let cipher = try encryptor.encrypt(with: encrypted)
        XCTAssertNoThrow(try evaluator.rotateVector(cipher, steps: 1, galoisKey: key, pool: .global()))
    }
    
    func testComplexConjugateInplace() throws {
        context = ckksContext()
        let key = try keyGen.galoisKeysLocal()
        let complex = ASLComplexType(real: 1, imaginary: 1)
        let encrypted = try ASLCKKSEncoder(context: context).encode(withComplexValue: complex, scale: pow(2.0, 30))
        let cipher = try encryptor.encrypt(with: encrypted)
        XCTAssertNoThrow(try evaluator.complexConjugateInplace(cipher, galoisKey: key))
    }
    
    func testComplexConjugateInplaceWithPool() throws {
        context = ckksContext()
        let key = try keyGen.galoisKeysLocal()
        let complex = ASLComplexType(real: 1, imaginary: 1)
        let encrypted = try ASLCKKSEncoder(context: context).encode(withComplexValue: complex, scale: pow(2.0, 30))
        let cipher = try encryptor.encrypt(with: encrypted)
        XCTAssertNoThrow(try evaluator.complexConjugateInplace(cipher, galoisKey: key, pool: .global()))
    }
    
    func testComplexConjugate() throws {
        context = ckksContext()
        let key = try keyGen.galoisKeysLocal()
        let complex = ASLComplexType(real: 1, imaginary: 1)
        let encrypted = try ASLCKKSEncoder(context: context).encode(withComplexValue: complex, scale: pow(2.0, 30))
        let cipher = try encryptor.encrypt(with: encrypted)
        XCTAssertNoThrow(try evaluator.complexConjugate(cipher, galoisKey: key))
    }
    
    func testcomplexConjugateWithPool() throws {
        context = ckksContext()
        let key = try keyGen.galoisKeysLocal()
        let complex = ASLComplexType(real: 1, imaginary: 1)
        let encrypted = try ASLCKKSEncoder(context: context).encode(withComplexValue: complex, scale: pow(2.0, 30))
        let cipher = try encryptor.encrypt(with: encrypted)
        XCTAssertNoThrow(try evaluator.complexConjugate(cipher, galoisKey: key, pool: .global()))
    }
    
    private func decode(_ cipher: ASLCipherText) -> NSNumber {
        let decrypted = try! decryptor.decrypt(cipher)
        return try! encoder.decodeInt32(withPlain: decrypted)
    }
    
    private func galoisContext() -> ASLSealContext {
        let params = ASLEncryptionParameters(schemeType: .BFV)
        let plainModulus = try! ASLModulus(value: 257)
        try! params.setPolynomialModulusDegree(8)
        try! params.setPlainModulus(plainModulus)
        try! params.setCoefficientModulus(ASLCoefficientModulus.create(8, bitSizes: [40, 40]))
        return try! ASLSealContext(encrytionParameters: params, expandModChain: false, securityLevel: .None, memoryPoolHandle: .global())
    }
    
    private func standardContext() -> ASLSealContext {
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        let polyModulusDegree = 4096
        try! parms.setPolynomialModulusDegree(polyModulusDegree)
        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try! parms.setPlainModulus(ASLModulus(value: 512))
        return try! ASLSealContext(parms)
    }
    
    private func batchingContext() -> ASLSealContext {
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        let polyModulusDegree = 8192
        try! parms.setPolynomialModulusDegree(polyModulusDegree)
        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try! parms.setPlainModulus(ASLPlainModulus.batching(polyModulusDegree, bitSize: 20))
        return try! ASLSealContext(parms)
    }
    
    private func ckksContext() -> ASLSealContext {
        let parms = ASLEncryptionParameters(schemeType: .CKKS)
        let polyModulusDegree = 4096
        try! parms.setPolynomialModulusDegree(polyModulusDegree)
        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        return try! ASLSealContext(parms)
    }
}
