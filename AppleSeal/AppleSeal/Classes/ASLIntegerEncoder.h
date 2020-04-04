//
//  ASLIntegerEncoder.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLSealContext.h"
#import "ASLPlainText.h"
#import "ASLCipherText.h"
#import "ASLBigUInt.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 @class ASLIntegerEncoder
 
 @brief The ASLIntegerEncoder class and wrapper for the  seal IntegerEncoder
 
 @discussion Encodes integers into plaintext polynomials that Encryptor can encrypt. An instance of
 the IntegerEncoder class converts an integer into a plaintext polynomial by placing its
 binary digits as the coefficients of the polynomial. Decoding the integer amounts to
 evaluating the plaintext polynomial at x=2.
 
 Addition and multiplication on the integer side translate into addition and multiplication
 on the encoded plaintext polynomial side, provided that the length of the polynomial
 never grows to be of the size of the polynomial modulus (poly_modulus), and that the
 coefficients of the plaintext polynomials appearing throughout the computations never
 experience coefficients larger than the plaintext modulus (plain_modulus).
 
 Negative Integers
 Negative integers are represented by using -1 instead of 1 in the binary representation,
 and the negative coefficients are stored in the plaintext polynomials as unsigned integers
 that represent them modulo the plaintext modulus. Thus, for example, a coefficient of -1
 would be stored as a polynomial coefficient plain_modulus-1.
 */


@interface ASLIntegerEncoder : NSObject

/*!
 Creates a IntegerEncoder object. The constructor takes as input a pointer to
 a SEALContext object which contains the plaintext modulus.
 
 @param context The SEALContext
 @throws ASL_SealInvalidParameter if the context is not set
 @throws ASL_SealInvalidParameter if the plain_modulus set in context is not
 at least 2
 */

+ (instancetype _Nullable)integerEncoderWithContext:(ASLSealContext *)context
                                              error:(NSError **)error;
/*!
 Encodes an unsigned integer (represented by std::uint64_t) into a plaintext polynomial.
 
 @param uInt64Value The unsigned integer to encode
 */

- (ASLPlainText*)encodeUInt64Value:(uint64_t)uInt64Value;

/*!
 Encodes an unsigned integer (represented by std::uint64_t) into a plaintext polynomial.
 
 @param uInt64Value The unsigned integer to encode
 @param destination The plaintext to overwrite with the encoding
 */
- (void)encodeUInt64Value:(uint64_t)uInt64Value
              destination:(ASLPlainText *)destination;

/*!
 Decodes a plaintext polynomial and returns the result as std::uint32_t.
 Mathematically this amounts to evaluating the input polynomial at x=2.
 
 @param plain The plaintext to be decoded
 @throws ASL_SealInvalidParameter if the output does not fit in std::uint32_t
 */
- (NSNumber * _Nullable)decodeUInt32WithPlain:(ASLPlainText *)plain
                            error:(NSError **)error;

/*!
 Decodes a plaintext polynomial and returns the result as std::uint64_t.
 Mathematically this amounts to evaluating the input polynomial at x=2.
 
 @param plain The plaintext to be decoded
 @throws ASL_SealInvalidParameter if the output does not fit in std::uint64_t
 */
- (NSNumber * _Nullable)decodeUInt64WithPlain:(ASLPlainText *)plain
                            error:(NSError **)error;

/*!
 Encodes a signed integer (represented by std::uint64_t) into a plaintext polynomial.
 
 Negative Integers
 Negative integers are represented by using -1 instead of 1 in the binary representation,
 and the negative coefficients are stored in the plaintext polynomials as unsigned integers
 that represent them modulo the plaintext modulus. Thus, for example, a coefficient of -1
 would be stored as a polynomial coefficient plain_modulus-1.
 
 @param int64Value The signed integer to encode
 */
- (ASLPlainText*)encodeInt64Value:(int64_t)int64Value;

/*!
 Encodes a signed integer (represented by std::int64_t) into a plaintext polynomial.
 
 Negative Integers
 Negative integers are represented by using -1 instead of 1 in the binary representation,
 and the negative coefficients are stored in the plaintext polynomials as unsigned integers
 that represent them modulo the plaintext modulus. Thus, for example, a coefficient of -1
 would be stored as a polynomial coefficient plain_modulus-1.
 
 @param int64Value The signed integer to encode
 @param destination The plaintext to overwrite with the encoding
 */
- (void)encodeInt64Value:(int64_t)int64Value
             destination:(ASLPlainText *)destination;

/*!
 Encodes an unsigned integer (represented by BigUInt) into a plaintext polynomial.
 
 @param bigUInt The unsigned integer to encode
 */
- (ASLPlainText*)encodeBigUInt:(ASLBigUInt *)bigUInt;

/*!
 Encodes an unsigned integer (represented by ASLBigUInt) into a plaintext polynomial.
 
 @param bigUInt The unsigned integer to encode
 @param destination The plaintext to overwrite with the encoding
 */
- (void)encodeBigUInt:(ASLBigUInt *)bigUInt
          destination:(ASLPlainText *)destination;

/*!
 Decodes a plaintext polynomial and returns the result as std::int32_t.
 Mathematically this amounts to evaluating the input polynomial at x=2.
 
 @param plain The plaintext to be decoded
 @throws ASL_SealInvalidParameter if plain does not represent a valid plaintext polynomial
 @throws ASL_SealInvalidParameter if the output does not fit in std::int32_t
 */
- (NSNumber * _Nullable)decodeInt32WithPlain:(ASLPlainText *)plain
                          error:(NSError **)error;

/*!
 Decodes a plaintext polynomial and returns the result as std::int64_t.
 Mathematically this amounts to evaluating the input polynomial at x=2.
 
 @param plain The plaintext to be decoded
 @throws ASL_SealInvalidParameter if plain does not represent a valid plaintext polynomial
 @throws ASL_SealInvalidParameter if the output does not fit in std::int64_t
 */
- (NSNumber * _Nullable)decodeInt64WithPlain:(ASLPlainText *)plain
                          error:(NSError **)error;

/*!
 Decodes a plaintext polynomial and returns the result as BigUInt.
 Mathematically this amounts to evaluating the input polynomial at x=2.
 
 @param plain The plaintext to be decoded
 @throws ASL_SealInvalidParameter if plain does not represent a valid plaintext polynomial
 @throws ASL_SealInvalidParameter if the output is negative
 */
- (ASLBigUInt *)decodeBigUInWithPlain:(ASLPlainText *)plain
                                error:(NSError **)error;

/*!
 Encodes a signed integer (represented by std::int32_t) into a plaintext polynomial.
 
 Negative Integers
 Negative integers are represented by using -1 instead of 1 in the binary representation,
 and the negative coefficients are stored in the plaintext polynomials as unsigned integers
 that represent them modulo the plaintext modulus. Thus, for example, a coefficient of -1
 would be stored as a polynomial coefficient plain_modulus-1.
 
 @param int32Value The signed integer to encode
 */
- (ASLPlainText*)encodeInt32Value:(int32_t)int32Value;


/*!
 Encodes an unsigned integer (represented by std::uint32_t) into a plaintext polynomial.
 
 @param uInt32Value The unsigned integer to encode
 @param destination The plaintext to overwrite with the encoding
 */

- (void)encodeUInt32Value:(uint32_t)uInt32Value
              destination:(ASLPlainText *)destination;

/*!
 Encodes an unsigned integer (represented by std::uint32_t) into a plaintext polynomial.
 
 @param int32Value The unsigned integer to encode
 @param destination The plaintext to overwrite with the encoding
 */
- (void)encodeInt32Value:(int32_t)int32Value
             destination:(ASLPlainText *)destination;

/*!
 Encodes an unsigned integer (represented by std::uint32_t) into a plaintext polynomial.
 
 @param uInt32Value The unsigned integer to encode
 */
- (ASLPlainText*)encodeUInt32Value:(uint32_t)uInt32Value;


/*!
 Returns a reference to the plaintext modulus.
 */
@property (nonatomic, readonly, assign) ASLSmallModulus* plainModulus;

@end

NS_ASSUME_NONNULL_END
