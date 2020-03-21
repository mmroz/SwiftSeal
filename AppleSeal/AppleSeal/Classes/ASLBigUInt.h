//
//  ASLBigUInt.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-28.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class ASLBigUInt
 
 @brief The ASLBigUInt class and wrapper for biguint
 
 @discussion Represents an unsigned integer with a specified bit width.
 Represents an unsigned integer with a specified bit width. Non-const
 BigUInts are mutable and able to be resized. The bit count for a BigUInt
 (which can be read with bit_count()) is set initially by the constructor
 and can be resized either explicitly with the resize() function or
 implicitly with an assignment operation (e.g., operator=(), operator+=(),
 etc.). A rich set of unsigned integer operations are provided by the
 BigUInt class, including comparison, traditional arithmetic (addition,
 subtraction, multiplication, division), and modular arithmetic functions.
 
 Backing Array
 The backing array for a BigUInt stores its unsigned integer value as
 a contiguous std::uint64_t array. Each std::uint64_t in the array
 sequentially represents 64-bits of the integer value, with the least
 significant quad-word storing the lower 64-bits and the order of the bits
 for each quad word dependent on the architecture's std::uint64_t
 representation. The size of the array equals the bit count of the BigUInt
 (which can be read with bit_count()) rounded up to the next std::uint64_t
 boundary (i.e., rounded up to the next 64-bit boundary). The uint64_count()
 function returns the number of std::uint64_t in the backing array. The
 data() function returns a pointer to the first std::uint64_t in the array.
 Additionally, the operator [] function allows accessing the individual
 bytes of the integer value in a platform-independent way - for example,
 reading the third byte will always return bits 16-24 of the BigUInt value
 regardless of the platform being little-endian or big-endian.
 
 Implicit Resizing
 Both the copy constructor and operator=() allocate more memory for the
 backing array when needed, i.e. when the source BigUInt has a larger
 backing array than the destination. Conversely, when the destination
 backing array is already large enough, the data is only copied and the
 unnecessary higher order bits are set to zero. When new memory has to be
 allocated, only the significant bits of the source BigUInt are taken
 into account. This is is important, because it avoids unnecessary zero
 bits to be included in the destination, which in some cases could
 accumulate and result in very large unnecessary allocations. However,
 sometimes it is necessary to preserve the original size, even if some
 of the leading bits are zero. For this purpose BigUInt contains functions
 duplicate_from and duplicate_to, which create an exact copy of the source
 BigUInt.
 
 Alias BigUInts
 An aliased BigUInt (which can be determined with is_alias()) is a special
 type of BigUInt that does not manage its underlying std::uint64_t pointer
 used to store the value. An aliased BigUInt supports most of the same
 operations as a non-aliased BigUInt, including reading and writing the
 value, however an aliased BigUInt does not internally allocate or
 deallocate its backing array and, therefore, does not support resizing.
 Any attempt, either explicitly or implicitly, to resize the BigUInt will
 result in an exception being thrown. An aliased BigUInt can be created
 with the BigUInt(int, std::uint64_t*) constructor or the alias() function.
 Note that the pointer specified to be aliased must be deallocated
 externally after the BigUInt is no longer in use. Aliasing is useful in
 cases where it is desirable to not have each BigUInt manage its own memory
 allocation and/or to prevent unnecessary copying.
 
 Thread Safety
 In general, reading a BigUInt is thread-safe while mutating is not.
 Specifically, the backing array may be freed whenever a resize occurs,
 the BigUInt is destroyed, or alias() is called, which would invalidate
 the address returned by data() and the byte references returned by
 operator []. When it is known that a resize will not occur, concurrent
 reading and mutating will not inherently fail but it is possible for
 a read to see a partially updated value from a concurrent write.
 A non-aliased BigUInt allocates its backing array from the global
 (thread-safe) memory pool. Consequently, creating or resizing a large
 number of BigUInt can result in a performance loss due to thread
 contention.
 
 @superclass SuperClass: NSObject\n
 */

@interface ASLBigUInt : NSObject <NSCopying>

/*!
 Creates a zero-initialized BigUInt of the specified bit width. Represents an unsigned integer with
 a specified bit width. This method returns the current temperature in the selected city, expressed in either Fahrenheit or Celsious degrees.
 
 @param  bitCount  The bit width.
 @throws ASL_SealInvalidParameter if  if bitCount is negative.
 */

+ (instancetype _Nullable)bigUIntWithBitCount:(NSInteger)bitCount
                                        error:(NSError **)error;

/*!
 Creates a BigUInt initialized and minimally sized to fit the unsigned
 hexadecimal integer specified by the string. The string matches the format
 returned by to_string() and must consist of only the characters 0-9, A-F,
 or a-f, most-significant nibble first.
 
 @param  hexValue  The hexadecimal integer string specifying the initial value.
 @throws  ASL_SealInvalidParameter if hexValue does not adhere to the expected format.
 */

+ (instancetype _Nullable)bigUIntWithHexValue:(NSString *)hexValue
                                        error:(NSError **)error;

/*!
 Creates a BigUInt of the specified bit width and initializes it with the
 unsigned hexadecimal integer specified by the string. The string must match
 the format returned by to_string() and must consist of only the characters
 0-9, A-F, or a-f, most-significant nibble first.
 
 @param  bitCount  The bit width.
 @param  hexValue The hexadecimal integer string specifying the initial value.
 @throws  ASL_SealInvalidParameter if the bit count is negative or the hexValue does not adhere to the expected format.
 */

+ (instancetype _Nullable)bigUIntWithBitCount:(NSInteger)bitCount
                                     hexValue:(NSString *)hexValue
                                        error:(NSError **)error;

/*!
 Creates a BigUInt of the specified bit width and initializes it to the specified unsigned integer value.
 
 @param bitCount The bit width.
 @param value The initial value to set the BigUInt.
 @throws  ASL_SealInvalidParameter if the bit count is negative.
 */
+ (instancetype _Nullable)bigUIntWithBitCount:(NSInteger)bitCount
                                  scalarValue:(uint64_t)value
                                        error:(NSError **)error;

/*!
 Creates an aliased BigUInt with the specified bit width and backing array.
 An aliased BigUInt does not internally allocate or deallocate the backing
 array, and instead uses the specified backing array for all read/write
 operations. Note that resizing is not supported by an aliased BigUInt and
 any required deallocation of the specified backing array must occur
 externally after the aliased BigUInt is no longer in use.
 
 @param  bitCount The bit width.
 @param  values value The backing array to use.
 @throws  ASL_SealInvalidParameter if bit_count is negative or value is null and bit_count is positive.
 */
+ (instancetype _Nullable)bigUIntWithBitCount:(NSInteger)bitCount
                                 scalarValues:(uint64_t *_Nullable)values
                                        error:(NSError **)error;

- (BOOL)isEqualToBigUInt:(ASLBigUInt *)other;

- (NSComparisonResult)compare:(ASLBigUInt *)other;

/*!
 Returns whether or not the BigUInt is an alias
 */
@property (nonatomic, readonly, assign, getter=isAlias) BOOL alias;

/*!
 Returns the bit count for the BigUInt.
 */
@property (nonatomic, readonly, assign) NSInteger bitCount;

/*!
 Returns the number of bytes in the backing array used to store the BigUInt value.
 */
@property (nonatomic, readonly, assign) size_t byteCount;

/*!
 Returns the number of System.UInt64 in the backing array used to store the BigUInt value.
 */
@property (nonatomic, readonly, assign) size_t uint64Count;

/*!
 Returns whether or not the BigUInt has the value zero.
 */
@property (nonatomic, readonly, assign, getter=isZero) BOOL zero;

/*!
 Returns the number of significant bits for the BigUInt.
 */
@property (nonatomic, readonly, assign) NSInteger significantBitCount;

@property (nonatomic, readonly, assign) uint64_t *data;

/*!
 Returns the BigUInt value as a double. Note that precision may be lost during
 the conversion.
 */
@property (nonatomic, readonly, assign) double doubleValue;

/*!
 Returns the BigUInt value as a hexadecimal string.
 */
@property (nonatomic, readonly, copy) NSString * stringValue;

/*!
 Returns the BigUInt value as a decimal string.
 */
@property (nonatomic, readonly, copy) NSString * decimalStringValue;

- (uint8_t)byteAtIndex:(NSInteger)index;

/*!
 Sets the BigUInt value to zero. This does not resize the BigUInt.
 */
- (void)setZero;

/*!
 Divides two BigUInts and returns the quotient and sets the remainder
 parameter to the remainder. The bit count of the quotient is set to be
 the significant bit count of the BigUInt. The remainder is resized if
 and only if it is smaller than the bit count of the BigUInt.
 
 @param  bigUIntModulus The bit width.
 @param  remainder The BigUInt to store the remainder.
 @throws  ASL_SealInvalidParameter if otherOperand is zero.
 @throws  ASL_SealLogicError if the remainder is an alias and the operator attempts to enlarge the BigUInt to fit the result.
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt * _Nullable)dividingRemainderWithBigUIntModulus:(ASLBigUInt *)bigUIntModulus
                                          remainder:(ASLBigUInt *)remainder
                                              error:(NSError **)error;

/*!
 Divides a BigUInt and an unsigned integer and returns the quotient and
 sets the remainder parameter to the remainder. The bit count of the
 quotient is set to be the significant bit count of the BigUInt. The
 remainder is resized if and only if it is smaller than the bit count
 of the BigUInt.
 
 @param  scalarModulus The second scalarModulus to divide.
 @param  remainder The BigUInt to store the remainder.
 @throws  ASL_SealInvalidParameter if scalarModulus is zero.
 @throws  ASL_SealLogicError if the remainder is an alias and the operator attempts to enlarge the BigUInt to fit the result.
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt * _Nullable)dividingRemainderWithScalarModulus:(uint64_t)scalarModulus
                                         remainder:(ASLBigUInt *)remainder
                                             error:(NSError **)error;

/*!
 Returns the inverse of a BigUInt with respect to the specified modulus.
 The original BigUInt is not modified. The bit count of the inverse is
 set to be the significant bit count of the modulus.
 
 @param  bigUIntModulus  The modulus to calculate the inverse with respect to.
 @throws  ASL_SealInvalidParameter if bigUIntModulus is zero.
 @throws  ASL_SealInvalidParameter if bigUIntModulus is not greater than the BigUInt value.
 @throws  ASL_SealInvalidParameter if the BigUInt value and bigUIntModulus are not co-prime.
 @throws  ASL_SealLogicError if the BigUInt value is zero.
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt * _Nullable)moduloInvertWithBigUIntModulus:(ASLBigUInt *)bigUIntModulus
                                         error:(NSError **)error;

/*!
 Returns the inverse of a BigUInt with respect to the specified modulus.
 The original BigUInt is not modified. The bit count of the inverse is set
 to be the significant bit count of the modulus.
 
 @param  scalarModulus  Returns the inverse of a BigUInt with respect to the specified modulus.
 @throws  ASL_SealInvalidParameter if scalarModulus is zero.
 @throws  ASL_SealInvalidParameter if scalarModulus is not greater than the BigUInt value.
 @throws  ASL_SealInvalidParameter if the BigUInt value and scalarModulus are not co-prime.
 @throws  ASL_SealLogicError if the BigUInt value is zero.
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt * _Nullable)moduloInvertWithScalarModulus:(uint64_t)scalarModulus
                                        error:(NSError **)error;

/*!
 Attempts to calculate the inverse of a BigUInt with respect to the
 specified modulus, returning whether or not the inverse was successful
 and setting the inverse parameter to the inverse. The original BigUInt
 is not modified. The inverse parameter is resized if and only if its bit
 count is smaller than the significant bit count of the modulus.
 
 @param  bigUIntModulus modulus The modulus to calculate the inverse with respect to.
 @param  inverse  inverse Stores the inverse if the inverse operation was successful.
 @throws  ASL_SealInvalidParameter if bigUIntModulus is zero.
 @throws  ASL_SealInvalidParameter if bigUIntModulus is not greater than the BigUInt value.
 @throws  ASL_SealInvalidParameter if the BigUInt value and scalarModulus are not co-prime.
 @throws  ASL_SealLogicError if the inverse is an alias which the function attempts to enlarge to fit the result.
 @return  True if it succeeds and false otherwise.
 */
- (BOOL)tryModuloInvertWithBigUIntModulus:(ASLBigUInt *)bigUIntModulus
                                  inverse:(ASLBigUInt *)inverse
                                    error:(NSError **)error;

/*!
 Attempts to calculate the inverse of a BigUInt with respect to the
 specified modulus, returning whether or not the inverse was successful
 and setting the inverse parameter to the inverse. The original BigUInt
 is not modified. The inverse parameter is resized if and only if its
 bit count is smaller than the significant bit count of the modulus.
 
 @param scalarModulus The modulus to calculate the inverse with respect to
 @param inverse Stores the inverse if the inverse operation was
 successful.
 @throws std::ASL_SealInvalidParameter if modulus is zero
 @throws ASL_SealInvalidParameter if modulus is not greater than the BigUInt
 value.
 @throws ASL_SealLogicError if the inverse is an alias which the function
 attempts to enlarge to fit the result.
 @return  True if it succeeds and false otherwise.
 */
- (BOOL)tryModuloInvertWithScalarModulus:(uint64_t)scalarModulus
                                 inverse:(ASLBigUInt *)inverse
                                   error:(NSError **)error;

/*!
 Creates a minimally sized BigUInt initialized to the specified unsigned
 integer value.
 
 @param value The value to initialized the BigUInt to
 @return  Constructed ASLBuigUInt.
 */

+ (ASLBigUInt *) createNewWithValue:(uint64_t)value;

/*!
 Duplicates the current BigUInt. The bit count and the value of the
 given BigUInt are set to be exactly the same as in the current one.
 
 @param destination The BigUInt to overwrite with the duplicate
 @throws ASL_SealLogicError if the destination BigUInt is an alias
 @return  The resuling ASLBigUInt.
 */
- (BOOL)duplicateTo:(ASLBigUInt *)destination
              error:(NSError **)error;

/*!
 Duplicates a given BigUInt. The bit count and the value of the current
 BigUInt are set to be exactly the same as in the given one.
 
 @param value The BigUInt to duplicate
 @throws ASL_SealLogicError if the current BigUInt is an alias
 */
- (BOOL)duplicateFrom:(ASLBigUInt *)value
                error:(NSError **)error;

/*!
 Returns a copy of the BigUInt value resized to the significant bit count.
 
 @throws ASL_SealLogicErrorif the BigUInt is an alias
 @return  The resuling ASLBigUInt.
 */
- (BOOL)resize:(int)bitCount
         error:(NSError **)error;

/*!
 Returns a negated copy of the BigUInt value. The bit count does not change.
 
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt *)negate;

/*!
 Returns an inverted copy of the BigUInt value. The bit count does not change.
 
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt *)invert;

/*!
 Increments the value.
 
 @throws ASL_SealLogicError if BigUInt is an alias and a carry occurs requiring the BigUInt to be resized
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt * _Nullable)incremenet:(NSError **)error;

/*!
 Decrements the value.
 
 @throws ASL_SealLogicError if BigUInt is an alias and a carry occurs requiring
 the BigUInt to be resized
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt * _Nullable)decrement:(NSError **)error;

/*!
 Adds two BigUInts and returns the sum. The input operands are not modified.
 The bit count of the sum is set to be one greater than the significant bit
 count of the larger of the two input operands.
 
 @param bigUInt The BigUInt to add
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt *)bigUIntByAddingBigUInt:(ASLBigUInt *)bigUInt;

/*!
 Adds a BigUInt and an unsigned integer and returns the sum. The input
 operands are not modified. The bit count of the sum is set to be one greater
 than the significant bit count of the larger of the two operands.
 
 @param scalar The value to add
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt *)bigUIntByAddingScalar:(uint64_t)scalar;

/*!
 Divides two BigUInts and returns the quotient. The input operands are
 not modified. The bit count of the quotient is set to be the significant
 bit count of the first input operand.
 
 @param bigUInt The second operand to divide
 @throws ASL_SealInvalidParameter if operand is zero
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt * _Nullable)bigUIntByDividingBigUInt:(ASLBigUInt *)bigUInt error:(NSError **)error;

/*!
 Divides a BigUInt and an unsigned integer and returns the quotient. The
 input operands are not modified. The bit count of the quotient is set
 to be the significant bit count of the first input operand.
 
 @param scalar The value to add
 @throws  ASL_SealInvalidParameter if operand2 is zero
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt * _Nullable)bigUIntByDividingScalar:(uint64_t)scalar
                                  error:(NSError **)error;

/*!
 Performs a bit-wise AND operation between two BigUInts and returns the
 result. The input operands are not modified. The bit count of the result
 is set to the maximum of the two input operand bit counts.
 
 @param[in] bigUInt The second operand to AND
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt *)bigUIntByBitwiseAndBigUInt:(ASLBigUInt *)bigUInt;

/*!
 Performs a bit-wise AND operation between a BigUInt and an unsigned
 integer and returns the result. The input operands are not modified.
 The bit count of the result is set to the maximum of the two input
 operand bit counts.
 
 @param scalar The second operand to AND
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt *)bigUIntByBitwiseAndScalar:(uint64_t)scalar;

/*!
 Subtracts two BigUInts and returns the difference. The input operands are
 not modified. The bit count of the difference is set to be the significant
 bit count of the larger of the two input operands.
 
 @param bigUInt The second operand to subtract
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt *)bigUIntBySubtractingBigUInt:(ASLBigUInt *)bigUInt;

/*!
 Subtracts a BigUInt and an unsigned integer and returns the difference.
 The input operands are not modified. The bit count of the difference is set
 to be the significant bit count of the larger of the two operands.
 
 @param scalar The second operand to subtract
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt *)bigUIntBySubtractingScalar:(uint64_t)scalar;

/*!
 Performs a bit-wise XOR operation between two BigUInts and returns the
 result. The input operands are not modified. The bit count of the result
 is set to the maximum of the two input operand bit counts.
 
 @param bigUInt The second operand to XOR
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt *)bigUIntByBitwiseXOrBigUInt:(ASLBigUInt *)bigUInt;

/*!
 Performs a bit-wise XOR operation between a BigUInt and an unsigned
 integer and returns the result. The input operands are not modified.
 The bit count of the result is set to the maximum of the two input
 operand bit counts.
 
 @param scalar The second operand to XOR
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt *)bigUIntByBitwiseXOrScalar:(uint64_t)scalar;

/*!
 Performs a bit-wise OR operation between two BigUInts and returns the
 result. The input operands are not modified. The bit count of the result
 is set to the maximum of the two input operand bit counts.
 
 @param bigUInt The second operand to OR
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt *)bigUIntByBitwiseOrBigUInt:(ASLBigUInt *)bigUInt;

/*!
 Performs a bit-wise OR operation between a BigUInt and an unsigned
 integer and returns the result. The input operands are not modified.
 The bit count of the result is set to the maximum of the two input
 operand bit counts.
 
 @param scalar The second operand to OR
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt *)bigUIntByBitwiseOrScalar:(uint64_t)scalar;

/*!
 Returns a left-shifted copy of the BigUInt. The bit count of the
 returned value is the sum of the original significant bit count and
 the shift amount.
 
 @param shift The number of bits to shift by
 @throws ASL_SealInvalidParameter if shift is negative
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt *)bigUIntByLeftShift:(int)shift;

/*!
 Returns a right-shifted copy of the BigUInt. The bit count of the
 returned value is the original significant bit count subtracted by
 the shift amount (clipped to zero if negative).
 
 @param shift The number of bits to shift by
 @throws ASL_SealInvalidParameter if shift is negative
 @return  The resuling ASLBigUInt.
 */
- (ASLBigUInt *)bigUIntByRightShift:(int)shift;

/*!
 Makes the BigUInt an aliased BigUInt with the specified bit width and
 backing array. An aliased BigUInt does not internally allocate or
 deallocate the backing array, and instead uses the specified backing array
 for all read/write operations. Note that resizing is not supported by
 an aliased BigUInt and any required deallocation of the specified backing
 array must occur externally after the aliased BigUInt is no longer in use.
 
 @param bitCount The bit width
 @param value The backing array to use
 @throws ASL_SealInvalidParameter if bit_count is negative or value is null
 @return True if successful.
 */

- (BOOL)alias:(NSInteger)bitCount
 scalarValues:(uint64_t *)value
        error:(NSError **)error;

/**
 Resets an aliased BigUInt into an empty non-alias BigUInt with bit count
 of zero.
 
 @throws ASL_SealLogicError if BigUInt is not an alias
 @return True if successful.
 */

- (BOOL)unalias:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
