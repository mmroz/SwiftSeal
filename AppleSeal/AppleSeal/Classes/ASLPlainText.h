//
// ASLPlainText.h
// AppleSeal
//
// Created by Mark Mroz on 2020-01-01.
// Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AppleSeal/ASLMemoryPoolHandle.h>
#import <AppleSeal/ASLParametersIdType.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class ASLPlainText
 
 @brief The ASLPlainText class and wrapper for the seal::PlainText
 
 @discussion Class to store ASLPlainText.
 
 Class to store a plaintext element. The data for the plaintext is a polynomial
 with coefficients modulo the plaintext modulus. The degree of the plaintext
 polynomial must be one less than the degree of the polynomial modulus. The
 backing array always allocates one 64-bit word per each coefficient of the
 polynomial.
 
 Memory Management
 The coefficient count of a plaintext refers to the number of word-size
 coefficients in the plaintext, whereas its capacity refers to the number of
 word-size coefficients that fit in the current memory allocation. In high-
 performance applications unnecessary re-allocations should be avoided by
 reserving enough memory for the plaintext to begin with either by providing
 the desired capacity to the constructor as an extra argument, or by calling
 the reserve function at any time.
 
 When the scheme is scheme_type::BFV each coefficient of a plaintext is a 64-bit
 word, but when the scheme is scheme_type::CKKS the plaintext is by default
 stored in an NTT transformed form with respect to each of the primes in the
 coefficient modulus. Thus, the size of the allocation that is needed is the
 size of the coefficient modulus (number of primes) times the degree of the
 polynomial modulus. In addition, a valid CKKS plaintext also store the parms_id
 for the corresponding encryption parameters.
 
 Thread Safety
 In general, reading from plaintext is thread-safe as long as no other thread
 is concurrently mutating it. This is due to the underlying data structure
 storing the plaintext not being thread-safe.
 
 @see Ciphertext for the class that stores ciphertexts.
 */

@interface ASLPlainText : NSObject <NSCopying, NSCoding>

/*!
 Constructs a plaintext from a given hexadecimal string describing the
 plaintext polynomial.
 
 The string description of the polynomial must adhere to the format returned
 by to_string(),
 which is of the form "7FFx^3 + 1x^1 + 3" and summarized by the following
 rules:
 1. Terms are listed in order of strictly decreasing exponent
 2. Coefficient values are non-negative and in hexadecimal format (upper
 and lower case letters are both supported)
 3. Exponents are positive and in decimal format
 4. Zero coefficient terms (including the constant term) may be (but do
 not have to be) omitted
 5. Term with the exponent value of one must be exactly written as x^1
 6. Term with the exponent value of zero (the constant term) must be written
 as just a hexadecimal number without exponent
 7. Terms must be separated by exactly <space>+<space> and minus is not
 allowed
 8. Other than the +, no other terms should have whitespace
 
 @param polynomialString The formatted polynomial string specifying the plaintext
 polynomial
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if hex_poly does not adhere to the expected
 format
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
+ (instancetype _Nullable)plainTextWithPolynomialString:(NSString *)polynomialString
                                                   pool:(ASLMemoryPoolHandle *)pool
                                                  error:(NSError **)error;

/*!
 Constructs a plaintext from a given hexadecimal string describing the
 plaintext polynomial.
 
 The string description of the polynomial must adhere to the format returned
 by to_string(),
 which is of the form "7FFx^3 + 1x^1 + 3" and summarized by the following
 rules:
 1. Terms are listed in order of strictly decreasing exponent
 2. Coefficient values are non-negative and in hexadecimal format (upper
 and lower case letters are both supported)
 3. Exponents are positive and in decimal format
 4. Zero coefficient terms (including the constant term) may be (but do
 not have to be) omitted
 5. Term with the exponent value of one must be exactly written as x^1
 6. Term with the exponent value of zero (the constant term) must be written
 as just a hexadecimal number without exponent
 7. Terms must be separated by exactly <space>+<space> and minus is not
 allowed
 8. Other than the +, no other terms should have whitespace
 
 @param polynomialString The formatted polynomial string specifying the plaintext
 polynomial
 @throws ASL_SealInvalidParameter if hex_poly does not adhere to the expected
 format
 */
+ (instancetype _Nullable)plainTextWithPolynomialString:(NSString *)polynomialString
                                                  error:(NSError **)error;

/*!
 Constructs a plaintext representing a constant polynomial 0. The coefficient
 count of the polynomial and the capacity are set to the given values.
 
 @param capacity The capacity
 @param coefficientCount The number of (zeroed) coefficients in the plaintext
 polynomial
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if capacity is less than coeff_count
 @throws ASL_SealInvalidParameter if coeff_count is negative
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
+ (instancetype _Nullable)plainTextWithCapacity:(size_t)capacity
                               coefficientCount:(size_t)coefficientCount
                                           pool:(ASLMemoryPoolHandle *)pool
                                          error:(NSError **)error;

/*!
 Constructs a plaintext representing a constant polynomial 0. The coefficient
 count of the polynomial and the capacity are set to the given values.
 
 @param capacity The capacity
 @param coefficientCount The number of (zeroed) coefficients in the plaintext
 polynomial
 @throws ASL_SealInvalidParameter if capacity is less than coeff_count
 @throws ASL_SealInvalidParameter if coeff_count is negative
 */
+ (instancetype _Nullable)plainTextWithCapacity:(size_t)capacity
                               coefficientCount:(size_t)coefficientCount
                                          error:(NSError **)error;

/*!
 Constructs a plaintext representing a constant polynomial 0. The coefficient
 count of the polynomial is set to the given value. The capacity is set to
 the same value.
 
 @param coefficientCount The number of (zeroed) coefficients in the plaintext
 polynomial
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if coeff_count is negative
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */

+ (instancetype _Nullable)plainTextWithCoefficientCount:(size_t)coefficientCount
                                                   pool:(ASLMemoryPoolHandle *)pool
                                                  error:(NSError **)error;

/*!
 Constructs a plaintext representing a constant polynomial 0. The coefficient
 count of the polynomial is set to the given value. The capacity is set to
 the same value.
 
 @param coefficientCount The number of (zeroed) coefficients in the plaintext
 polynomial
 @throws ASL_SealInvalidParameter if coeff_count is negative
 */
+ (instancetype _Nullable)plainTextWithCoefficientCount:(size_t)coefficientCount
                                                  error:(NSError **)error;

/*!
 Constructs an empty plaintext allocating no memory.
 
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws if pool is uninitialized
 */
- (instancetype)initWithPool:(ASLMemoryPoolHandle *)pool;

/*!
 Returns whether the current plaintext polynomial has all zero coefficients.
 */
@property (nonatomic, readonly, assign, getter=isZero) BOOL zero;

/*!
 Returns the capacity of the current allocation.
 */
@property (nonatomic, readonly, assign) NSInteger capacity;

/*!
 Returns the coefficient count of the current plaintext polynomial.
 */
@property (nonatomic, readonly, assign) NSInteger coefficientCount;

/*!
 Returns the significant coefficient count of the current plaintext polynomial.
 */
@property (nonatomic, readonly, assign) NSInteger significantCoefficientCount;

/*!
 Returns the non-zero coefficient count of the current plaintext polynomial.
 */
@property (nonatomic, readonly, assign) NSInteger nonZeroCoefficientCount;

/*!
 Returns a reference to parametersId. The parametersId must remain zero unless the
 plaintext polynomial is in NTT form.
 
 @see ASLEncryptionParameters for more information about parametersId.
 */

@property (nonatomic, readonly, assign) ASLParametersIdType parametersId;

/*!
 Returns a reference to the scale. This is only needed when using the CKKS
 encryption scheme. The user should have little or no reason to ever change
 the scale by hand.
 */
@property (nonatomic, readonly, assign) double scale;

/*!
 Returns the currently used MemoryPoolHandle.
 */
@property (nonatomic, readonly, assign) ASLMemoryPoolHandle* pool;

/*!
 Returns a human-readable string description of the plaintext polynomial.
 
 The returned string is of the form "7FFx^3 + 1x^1 + 3" with a format
 summarized by the following:
 1. Terms are listed in order of strictly decreasing exponent
 2. Coefficient values are non-negative and in hexadecimal format (hexadecimal
 letters are in upper-case)
 3. Exponents are positive and in decimal format
 4. Zero coefficient terms (including the constant term) are omitted unless
 the polynomial is exactly 0 (see rule 9)
 5. Term with the exponent value of one is written as x^1
 6. Term with the exponent value of zero (the constant term) is written as
 just a hexadecimal number without x or exponent
 7. Terms are separated exactly by <space>+<space>
 8. Other than the +, no other terms have whitespace
 9. If the polynomial is exactly 0, the string "0" is returned
 
 @throwsASL_SealInvalidParameter if the plaintext is in NTT transformed form
 */
@property (nonatomic, readonly, copy) NSString * stringValue;

- (BOOL)isEqualToPlainText:(ASLPlainText *)other;

/*!
 Allocates enough memory to accommodate the backing array of a plaintext
 with given capacity.
 
 @param capacity The capacity
 @throwsASL_SealInvalidParameter if capacity is negative
 @throws ASL_SealLogicError if the plaintext is NTT transformed
 */
- (BOOL)reserve:(size_t)capacity
          error:(NSError **)error;

/*!
 Allocates enough memory to accommodate the backing array of the current
 plaintext and copies it over to the new location. This function is meant
 to reduce the memory use of the plaintext to smallest possible and can be
 particularly important after modulus switching.
 */
-(void)shrinkToFit;

/*!
 Resets the plaintext. This function releases any memory allocated by the
 plaintext, returning it to the memory pool.
 */
-(void)returnMemoryToPool;

/*!
 Resizes the plaintext to have a given coefficient count. The plaintext
 is automatically reallocated if the new coefficient count does not fit in
 the current capacity.
 
 @param coefficientCount The number of coefficients in the plaintext polynomial
 @throws ASL_SealInvalidParameter if coeff_count is negative
 @throws ASL_SealLogicError if the plaintext is NTT transformed
 */
- (BOOL)resize:(size_t)coefficientCount
         error:(NSError **)error;

/*!
 Sets a given range of coefficients of a plaintext polynomial to zero; does
 nothing if length is zero.
 
 @param startCoefficient The index of the first coefficient to set to zero
 @param length The number of coefficients to set to zero
 @throws NSRangeException if start_coeff + length - 1 is not within [0, coeff_count)
 */
- (BOOL)setZero:(size_t)startCoefficient
         length:(size_t)length
          error:(NSError **)error;

/*!
 Sets the plaintext polynomial coefficients to zero starting at a given index.
 
 @param startCoefficient The index of the first coefficient to set to zero
 @throws NSRangeException if start_coeff is not within [0, coeff_count)
 */
- (BOOL)setZero:(size_t)startCoefficient
          error:(NSError **)error;

/*!
 Sets the plaintext polynomial to zero.
 */
- (void)setZero;

@end

NS_ASSUME_NONNULL_END
