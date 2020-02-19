
import AppleSeal
import XCTest

class ASLBigUIntTests: XCTestCase {

	// MARK: - Tests

	func testCreationWithDefaultInitializer() {
		let _ = ASLBigUInt()
//		ASLBigUInt(bitCount: <#T##Int#>, scalarValue: <#T##UInt64#>)
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
	
	// MARK: - Test Helper
	
	private func uint64Pointer() -> UnsafeMutablePointer<UInt64> {
		var bytes: [UInt64] = [39, 77, 111, 111, 102, 33, 39, 0]
		let uint64Pointer = UnsafeMutablePointer<UInt64>.allocate(capacity: 8)
		uint64Pointer.initialize(from: &bytes, count: 8)
		return uint64Pointer
	}
}
