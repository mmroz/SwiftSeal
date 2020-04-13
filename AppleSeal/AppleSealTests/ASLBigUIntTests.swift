
import AppleSeal
import XCTest

class ASLBigUIntTests: XCTestCase {
    
    // MARK: - Tests
    
    func testCreationWithDefaultInitializer() {
        let _ = ASLBigUInt()
    }
    
    func testCreationWithInvalidBitCount() {
        XCTAssertThrowsError(try ASLBigUInt(bitCount: -1))
        XCTAssertThrowsError(try ASLBigUInt(bitCount: .max))
    }
    
    func testCreationWithZeroBitCount() {
        let _ = try! ASLBigUInt(bitCount: 0)
        let _ = try! ASLBigUInt(bitCount: 1)
        let _ = try! ASLBigUInt(bitCount: 128)
    }
    
    func testCreateWithInvalidHexString() {
        XCTAssertThrowsError(try ASLBigUInt(hexValue: "z"))
    }
    
    func testCreateWithValidHexString() {
        let _ = try! ASLBigUInt(hexValue: "1234")
    }
    
    func testCreateWithInvalidBitCountAndValidHexString() {
        XCTAssertThrowsError(try ASLBigUInt(bitCount: -1, hexValue: "1234"))
        XCTAssertThrowsError(try ASLBigUInt(bitCount: .max, hexValue: "1234"))
    }
    
    func testCreateWithValidBitCountAndInvalidHexString() {
        XCTAssertThrowsError(try ASLBigUInt(bitCount: 1, hexValue: "z"))
    }
    
    func testCreateWithValidBitCountAndHexString() {
        let _ = try! ASLBigUInt(bitCount: 1, hexValue: "1234")
    }
    
    func testCreateWithInvalidBitCountAndValidValues() {
        XCTAssertThrowsError(try ASLBigUInt(bitCount: -1, scalarValues: uint64Pointer()))
    }
    
    func testCreateWithValidBitCountAndValidValues() {
        let _ = try! ASLBigUInt(bitCount: 1, scalarValues: uint64Pointer())
    }
    
    func testCreateWithValidScalarValueAndInvalidBitCount() {
        XCTAssertThrowsError(try ASLBigUInt(bitCount: -1, scalarValue: 1))
    }
    
    func testCreateWithValidScalarValueAndValidBitCount() {
        let _ = try! ASLBigUInt(bitCount: 1, scalarValue: 1)
    }
    
    func testEquals() {
        let first = try! ASLBigUInt(bitCount: 1, scalarValue: 1)
        let second = try! ASLBigUInt(bitCount: 1, scalarValue: 1)
        XCTAssertEqual(first, second)
    }
    
    func testComapre() {
        let lowest = try! ASLBigUInt(bitCount: 1, scalarValue: 1)
        let middle = try! ASLBigUInt(bitCount: 1, scalarValue: 2)
        let highest = try! ASLBigUInt(bitCount: 1, scalarValue: 3)
        
        XCTAssertEqual(lowest.compare(lowest), ComparisonResult.orderedSame)
        XCTAssertEqual(middle.compare(highest), ComparisonResult.orderedAscending)
        XCTAssertEqual(highest.compare(lowest), ComparisonResult.orderedDescending)
        
    }
    
    func testCopy() {
        let first = try! ASLBigUInt(bitCount: 1, scalarValue: 1)
        let second = first.copy() as! ASLBigUInt
        
        XCTAssertEqual(first, second)
    }
    
    func testIsAlias() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 1)
        XCTAssertFalse(bigInt.isAlias)
        try! bigInt.alias(1, scalarValues: uint64Pointer())
        XCTAssertTrue(bigInt.isAlias)
    }
    
    func testBitCount() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 1)
        
        XCTAssertEqual(bigInt.bitCount, 1)
    }
    
    func testData() {
        
        // TODO
        //		var bytes: [UInt64] = [39, 77, 111, 111, 102, 33, 39, 0]
        //		let uint64Pointer = UnsafeMutablePointer<UInt64>.allocate(capacity: 8)
        //		uint64Pointer.initialize(from: &bytes, count: 8)
        //
        //		let bigInt = try! ASLBigUInt(bitCount: 1, scalarValues: uint64Pointer)
        //
        //		memcmp(bigInt.data, uint64Pointer, 8*8)
        //		XCTAssertEqual(bigInt.data, uint64Pointer)
    }
    
    func testByteCount() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 2)
        
        XCTAssertEqual(bigInt.byteCount, 1)
    }
    
    func testUInt64Count() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 2)
        
        XCTAssertEqual(bigInt.uint64Count, 1)
    }
    
    func testSignificantBitCount() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 2)
        
        XCTAssertEqual(bigInt.significantBitCount, 2)
    }
    
    func testToDouble() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 2)
        
        XCTAssertEqual(bigInt.doubleValue, 2.0)
    }
    
    func testStringValue() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 2)
        
        XCTAssertEqual(bigInt.stringValue, "2")
    }
    
    func testDecimalStringValue() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 2)
        
        XCTAssertEqual(bigInt.decimalStringValue, "2")
    }
    
    func testIsZero() {
        let bigInt = try! ASLBigUInt(bitCount: 0, scalarValue: 2)
        XCTAssertTrue(bigInt.isZero)
    }
    
    func testIsNotZero() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 2)
        XCTAssertFalse(bigInt.isZero)
    }
    
    func testSubscripting() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 2)
        XCTAssertEqual(bigInt.byte(at: 0), 2)
    }
    
    func testSetZero() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 2)
        
        XCTAssertFalse(bigInt.isZero)
        bigInt.setZero()
        XCTAssertTrue(bigInt.isZero)
    }
    
    func testResizeWithAliasThrows() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 2)
        XCTAssertNoThrow(try bigInt.alias(2, scalarValues: uint64Pointer()))
        XCTAssertThrowsError(try bigInt.resize(5))
    }
    
    func testResizeWithNegativeBitCountThrows() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 2)
        XCTAssertThrowsError(try bigInt.resize(-1))
    }
    
    func testResizing() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 2)
        
        XCTAssertEqual(bigInt.bitCount, 2)
        try! bigInt.resize(10)
        XCTAssertEqual(bigInt.bitCount, 10)
    }
    
    func testAliasWithInvliadBitCount() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 2)
        XCTAssertThrowsError(try bigInt.resize(-1))
    }
    
    func testAlias() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 2)
        
        XCTAssertFalse(bigInt.isAlias)
        try! bigInt.alias(2, scalarValues: uint64Pointer())
        XCTAssertTrue(bigInt.isAlias)
    }
    
    func testUnaliasThrowsIfNotAliased() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 2)
        XCTAssertThrowsError(try bigInt.unalias())
    }
    
    func testUnalias() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 2)
        try! bigInt.alias(1, scalarValues: uint64Pointer())
        XCTAssertNoThrow(try bigInt.unalias())
    }
    
    func testDividingRemainder() {
        let bigInt = try! ASLBigUInt(bitCount: 1, scalarValue: 2)
        let otherBigUInt = ASLBigUInt.createNew(withValue: 4)
        let remainder = ASLBigUInt.createNew(withValue: 2)
        
        
        XCTAssertNoThrow(try bigInt.dividingRemainder(withBigUIntModulus: otherBigUInt, remainder: remainder))
    }
    
    func testDividingRemainderByZeroThrows() {
        //        let bigInt = ASLBigUInt.createNew(withValue: 2)
        //        let otherBigUInt = ASLBigUInt.createNew(withValue: 0)
        //        let remainder = ASLBigUInt.createNew(withValue: 2)
        
        //               XCTAssertThrowsError(try bigInt.dividingRemainder(withBigUIntModulus: otherBigUInt, remainder: remainder))
    }
    
    func testDividingRemainderWithAliasedRemainderThrows() {
        //        let bigInt = ASLBigUInt.createNew(withValue: 4)
        //        let otherBigUInt = ASLBigUInt.createNew(withValue: 22)
        //
        //        var remainder = ASLBigUInt.createNew(withValue: 2)
        //        try! remainder.alias(1, scalarValues: uint64Pointer())
        //
        //       XCTAssertThrowsError(try bigInt.dividingRemainder(withBigUIntModulus: otherBigUInt, remainder: remainder))
    }
    
    func testDividingByScalarModulus() {
//        let bigUInt = ASLBigUInt.createNew(withValue: 2)
//        let otherBigUInt = ASLBigUInt.createNew(withValue: 2)
//
//        XCTAssertNoThrow(try bigUInt.dividingRemainder(withScalarModulus: 2, remainder: otherBigUInt))
    }
    
    func testDividingRemainderByZeroScalarModulusThrows() {
//        let bigUInt = ASLBigUInt.createNew(withValue: 2)
//        let otherBigUInt = ASLBigUInt.createNew(withValue: 2)
//
//        XCTAssertThrowsError(try bigUInt.dividingRemainder(withScalarModulus: 0, remainder: otherBigUInt))
    }
    
    func testDividingRemainderScalarModulusWithAliasedRemainderThrows() {
        //             let bigInt = ASLBigUInt.createNew(withValue: 4)
        //             var remainder = ASLBigUInt.createNew(withValue: 2)
        //             try! remainder.alias(3, scalarValues: uint64Pointer())
        //
        //            XCTAssertThrowsError(try bigInt.dividingRemainder(withBigUIntModulus: otherBigUInt, remainder: remainder))
    }
    
    func testModuloInvertWithBigUInt() {
        let bigUInt = ASLBigUInt.createNew(withValue: 2)
        let otherBigUInt = ASLBigUInt.createNew(withValue: 4)
        
        XCTAssertThrowsError(try bigUInt.moduloInvert(withBigUIntModulus: otherBigUInt))
        
        let zeroBigUInt = ASLBigUInt.createNew(withValue: 0)
        XCTAssertThrowsError(try zeroBigUInt.moduloInvert(withBigUIntModulus: otherBigUInt))
    }
    
    func testModuloInvertWithBigUIntZero() {
        let bigUInt = ASLBigUInt.createNew(withValue: 4)
        let otherBigUInt = ASLBigUInt.createNew(withValue: 0)
        
        XCTAssertThrowsError(try bigUInt.moduloInvert(withBigUIntModulus: otherBigUInt))
    }
    
    func testModuloInvertWithBigUIntGreaterThanValue() {
        let bigUInt = ASLBigUInt.createNew(withValue: 4)
        let otherBigUInt = ASLBigUInt.createNew(withValue: 2)
        
        XCTAssertThrowsError(try bigUInt.moduloInvert(withBigUIntModulus: otherBigUInt))
    }
    
    func testModuloInvertWithScalarModulus() {
        let bigUInt = ASLBigUInt.createNew(withValue: 2)
        
        XCTAssertThrowsError(try bigUInt.moduloInvert(withScalarModulus: 2))
        
        let zeroBigUInt = ASLBigUInt.createNew(withValue: 0)
        XCTAssertThrowsError(try zeroBigUInt.moduloInvert(withScalarModulus: 2))
    }
    
    func testModuloInvertWithScalarModulusZero() {
        let bigUInt = ASLBigUInt.createNew(withValue: 4)
        
        XCTAssertThrowsError(try bigUInt.moduloInvert(withScalarModulus: 0))
    }
    
    func testModuloInvertWithScalarModulusGreaterThanValue() {
        let bigUInt = ASLBigUInt.createNew(withValue: 4)
        
        XCTAssertThrowsError(try bigUInt.moduloInvert(withScalarModulus: 2))
    }
    
    func testNegate() {
        let bigUInt = ASLBigUInt.createNew(withValue: 4)
        let _ = bigUInt.negate()
    }
    
    func testInvert() {
        let bigUInt = ASLBigUInt.createNew(withValue: 4)
        let _ = bigUInt.invert()
    }
    
    func testIncrement() {
        let bigUInt = ASLBigUInt.createNew(withValue: 4)
        XCTAssertNoThrow(try bigUInt.incremenet())
    }
    
    func testDecremenet() {
        let bigUInt = ASLBigUInt.createNew(withValue: 4)
        XCTAssertNoThrow(try bigUInt.decrement())
    }
    
    func testAddingBigUInt() {
        let bigUInt = ASLBigUInt.createNew(withValue: 4)
        let otherBigUInt = ASLBigUInt.createNew(withValue: 4)
        
        let result = bigUInt.adding(otherBigUInt)
        
        XCTAssertEqual(result, ASLBigUInt.createNew(withValue: 8))
    }
    
    func testAddingScalar() {
        let bigUInt = ASLBigUInt.createNew(withValue: 4)
        let result = bigUInt.addingScalar(4)
        
        XCTAssertEqual(result, ASLBigUInt.createNew(withValue: 8))
    }
    
    func testDividingByBigUInt() {
        let bigUInt = ASLBigUInt.createNew(withValue: 4)
        let otherBigUInt = ASLBigUInt.createNew(withValue: 2)
        
        let result = try! bigUInt.dividing(otherBigUInt)
        
        XCTAssertEqual(result, ASLBigUInt.createNew(withValue: 2))
    }
    
    func testDividingByBigUIntZero() {
        let bigUInt = ASLBigUInt.createNew(withValue: 4)
        let otherBigUInt = ASLBigUInt.createNew(withValue: 0)
        
        XCTAssertThrowsError(try bigUInt.dividing(otherBigUInt))
    }
    
    func testDividingByScalar() {
        let bigUInt = ASLBigUInt.createNew(withValue: 4)
        let result = try! bigUInt.dividingScalar(2)
        
        XCTAssertEqual(result, ASLBigUInt.createNew(withValue: 2))
    }
    
    func testDividingByScalarZero() {
        let bigUInt = ASLBigUInt.createNew(withValue: 4)
        
        XCTAssertThrowsError(try bigUInt.dividingScalar(0))
    }
    
    func testBitwiseAndWithBigUInt() {
        let bigUInt = ASLBigUInt.createNew(withValue: 14)
        let otherBigUInt = ASLBigUInt.createNew(withValue: 3)
        
        let result = bigUInt.byBitwiseAndBigUInt(otherBigUInt)
        
        XCTAssertEqual(result, ASLBigUInt.createNew(withValue: 2))
    }
    
    func testBitwiseAndWithScalar() {
        let bigUInt = ASLBigUInt.createNew(withValue: 14)
        let result = bigUInt.byBitwiseAndScalar(3)
        
        XCTAssertEqual(result, ASLBigUInt.createNew(withValue: 2))
    }
    
    func testSubtractingWithBigUInt() {
        let bigUInt = ASLBigUInt.createNew(withValue: 14)
        let otherBigUInt = ASLBigUInt.createNew(withValue: 3)
        let result = bigUInt.subtracting(otherBigUInt)
        
        XCTAssertEqual(result, ASLBigUInt.createNew(withValue: 11))
    }
    
    func testSubtractingWithScalar() {
        let bigUInt = ASLBigUInt.createNew(withValue: 14)
        let result = bigUInt.subtractingScalar(3)
        
        XCTAssertEqual(result, ASLBigUInt.createNew(withValue: 11))
    }
    
    func testBitwiseXorWithBigUInt() {
        let bigUInt = ASLBigUInt.createNew(withValue: 14)
        let otherBigUInt = ASLBigUInt.createNew(withValue: 3)
        
        let result = bigUInt.byBitwiseXOrBigUInt(otherBigUInt)
        
        XCTAssertEqual(result, ASLBigUInt.createNew(withValue: 13))
    }
    
    func testBitwiseXorWithScalar() {
        let bigUInt = ASLBigUInt.createNew(withValue: 14)
        let result = bigUInt.byBitwiseXOrScalar(3)
        
        XCTAssertEqual(result, ASLBigUInt.createNew(withValue: 13))
    }
    
    func testLeftShift() {
        let bigUInt = ASLBigUInt.createNew(withValue: 14)
        bigUInt.byLeftShift(2)
    }
    
    func testRightShift() {
        let bigUInt = ASLBigUInt.createNew(withValue: 14)
        bigUInt.byRightShift(2)
    }
    
    func testCreateWithNew() {
        let bigUInt = ASLBigUInt.createNew(withValue: 4)
        
        XCTAssertEqual(bigUInt, try! ASLBigUInt(bitCount: 2, scalarValue: 4))
    }
    
    func testDuplicateTo() {
        let bigUInt = ASLBigUInt.createNew(withValue: 4)
        let otherBigUInt = ASLBigUInt.createNew(withValue: 8)
        
        XCTAssertNoThrow(try bigUInt.duplicate(to: otherBigUInt))
    }
    
    func testDuplicateFrom() {
        let bigUInt = ASLBigUInt.createNew(withValue: 4)
        let otherBigUInt = ASLBigUInt.createNew(withValue: 8)
        
        XCTAssertNoThrow(try bigUInt.duplicate(from: otherBigUInt))
    }
    
    // tryModuloInvert
    
    //    func testTryModuloInvertWithBigUInt() {
    //
    //    }
    //
    //    func testTryModuloInvertWithBigUIntZero() {
    //
    //    }
    //
    //    func testTryModuloInvertWithBigUIntGreaterThanValue() {
    //
    //    }
    //    func testTryModuloInvertWithScalarModulus() {
    //
    //    }
    //
    //    func testTryModuloInvertWithScalarModulustZero() {
    //
    //    }
    //
    //    func testTryModuloInvertWithScalarModulusGreaterThanValue() {
    //
    //    }
    
    func testEncoding() {
        let bigUInt = ASLBigUInt.createNew(withValue: 4)
        
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        archiver.encode(bigUInt, forKey: "testObject")
        let data = archiver.encodedData

        let unarchiver = try! NSKeyedUnarchiver(forReadingFrom: data)
        unarchiver.requiresSecureCoding = false
        let decodedBigUInt = unarchiver.decodeObject(of: ASLBigUInt.self, forKey: "testObject")!

        XCTAssertEqual(bigUInt, decodedBigUInt)
    }
    
    // MARK: - Test Helper
    
    private func uint64Pointer() -> UnsafeMutablePointer<UInt64> {
        var bytes: [UInt64] = [39, 77, 111, 111, 102, 33, 39, 0]
        let uint64Pointer = UnsafeMutablePointer<UInt64>.allocate(capacity: 8)
        uint64Pointer.initialize(from: &bytes, count: 8)
        return uint64Pointer
    }
}

enum CodingKey: Decodable {
    case withContext(ASLSealContext)
    
    init(from decoder: Decoder) throws {
        <#code#>
    }
}
