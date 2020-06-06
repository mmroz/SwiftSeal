//
//  ASLCoefficientModulus.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLSealContext.h"
#import "ASLModulus.h"


NS_ASSUME_NONNULL_BEGIN

@interface ASLCoefficientModulus : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/*!
 Returns the largest bit-length of the coefficient modulus, i.e., bit-length
 of the product of the primes in the coefficient modulus, that guarantees
 a given security level when using a given poly_modulus_degree, according
 to the HomomorphicEncryption.org security standard.
 
 @param polynomialModulusDegree The value of the polynomialModulusDegree
 encryption parameter
 @param securityLevel The desired standard security level
 */
+ (int)maxBitCount:(size_t)polynomialModulusDegree
     securityLevel:(ASLSecurityLevel)securityLevel;

/*!
 Returns the largest bit-length of the coefficient modulus, i.e., bit-length
 of the product of the primes in the coefficient modulus, that guarantees
 a given security level when using a given polynomialModulusDegree, according
 to the HomomorphicEncryption.org security standard.
 
 @param polynomialModulusDegree The value of the polynomialModulusDegree
 encryption parameter
 */
+ (int)maxBitCount:(size_t)polynomialModulusDegree;

/*!
 Returns a default coefficient modulus for the BFV scheme that guarantees
 a given security level when using a given poly_modulus_degree, according
 to the HomomorphicEncryption.org security standard. Note that all security
 guarantees are lost if the output is used with encryption parameters with
 a mismatching value for the poly_modulus_degree.
 
 The coefficient modulus returned by this function will not perform well
 if used with the CKKS scheme.
 
 @param polynomialModulusDegree The value of the poly_modulus_degree
 encryption parameter
 @param securityLevel The desired standard security level
 @throws ASLSealErrorCodeInvalidParameter if polynomialModulusDegree is not a power-of-two
 or is too large
 @throws ASLSealErrorCodeInvalidParameter if securityLevel is sec_level_type::none
 */
+ (NSArray<ASLModulus*>* _Nullable)bfvDefault:(size_t)polynomialModulusDegree
                                     securityLevel:(ASLSecurityLevel)securityLevel
                                             error:(NSError **)error;

/*!
 Returns a default coefficient modulus for the BFV scheme that guarantees
 a given security level when using a given poly_modulus_degree, according
 to the HomomorphicEncryption.org security standard. Note that all security
 guarantees are lost if the output is used with encryption parameters with
 a mismatching value for the poly_modulus_degree.
 
 The coefficient modulus returned by this function will not perform well
 if used with the CKKS scheme.
 
 @param polynomialModulusDegree The value of the polynomialModulusDegree
 encryption parameter
 @throws ASLSealErrorCodeInvalidParameter if polynomialModulusDegree is not a power-of-two
 or is too large
 */
+ (NSArray<ASLModulus*>* _Nullable)bfvDefault:(size_t)polynomialModulusDegree
                                             error:(NSError **)error;

/*!
 Returns a custom coefficient modulus suitable for use with the specified
 poly_modulus_degree. The return value will be a vector consisting of
 Modulus elements representing distinct prime numbers of bit-lengths
 as given in the bit_sizes parameter. The bit sizes of the prime numbers
 can be at most 60 bits.
 
 @param polynomialModulusDegree The value of the poly_modulus_degree
 encryption parameter
 @param bitSizes The bit-lengths of the primes to be generated
 @throws ASLSealErrorCodeInvalidParameter if polynomialModulusDegree is not a power-of-two
 or is too large
 @throws ASLSealErrorCodeInvalidParameter if bitSizes is too large or if its elements
 are out of bounds
 @throws ASLSealErrorCodeLogicError if not enough suitable primes could be found
 */

+ (NSArray<ASLModulus*>* _Nullable)create:(size_t)polynomialModulusDegree
                            bitSizes:(NSArray<NSNumber*>*)bitSizes
                               error:(NSError **)error;


@end

NS_ASSUME_NONNULL_END
