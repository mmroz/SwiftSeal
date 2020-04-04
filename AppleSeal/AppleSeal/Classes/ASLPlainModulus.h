//
//  ASLPlainModulus.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLSmallModulus.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 This class contains static methods for creating a plaintext modulus easily.
 */
@interface ASLPlainModulus : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/*!
 Creates a prime number SmallModulus for use as plain_modulus encryption
 parameter that supports batching with a given poly_modulus_degree.
 
 @param polynomialModulusDegree The value of the poly_modulus_degree
 encryption parameter
 @param bitSize The bit-length of the prime to be generated
 @throws std::invalid_argument if poly_modulus_degree is not a power-of-two
 or is too large
 @throws ASLSealErrorCodeInvalidParameter if bitSize is out of bounds
 @throws ASLSealErrorCodeLogicError if a suitable prime could not be found
 */
+ (ASLSmallModulus* _Nullable)batching:(size_t)polynomialModulusDegree
                               bitSize:(int)bitSize
                                 error:(NSError **)error;

/*!
 Creates several prime number SmallModulus elements that can be used as
 plain_modulus encryption parameters, each supporting batching with a given
 poly_modulus_degree.
 
 @param polynomialModulusDegree The value of the polynomialModulusDegree
 encryption parameter
 @param bitSizes The bit-lengths of the primes to be generated
 @throws ASLSealErrorCodeInvalidParameter if poly_modulus_degree is not a power-of-two
 or is too large
 @throws ASLSealErrorCodeInvalidParameter if bit_sizes is too large or if its elements
 are out of bounds
 @throws ASLSealErrorCodeLogicError if not enough suitable primes could be found
 */
+ (NSArray<ASLSmallModulus*>* _Nullable)batching:(size_t)polynomialModulusDegree
                                        bitSizes:(NSArray<NSNumber*>*)bitSizes
                                           error:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
