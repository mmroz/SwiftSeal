//
//  ASLEncryptionParameters.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASLSmallModulus;

NS_ASSUME_NONNULL_BEGIN

/*!
 Describes the type of encryption scheme to be used.
 */
typedef NS_CLOSED_ENUM(NSInteger, ASLSchemeType) {
    /*!
     No scheme set; cannot be used for encryption
     */
    ASLSchemeTypeNone = 0,
    /*!
     Brakerski/Fan-Vercauteren scheme
     */
    ASLSchemeTypeBFV,
    /*!
     Cheon-Kim-Kim-Song scheme
     */
    ASLSchemeTypeCKKS,
};

/*!
 @class ASLEncryptionParameters
 
 @brief The ASLEncryptionParameters class and wrapper for EncryptionParameters
 
 @discussion Represents user-customizable encryption scheme settings. The parameters (most
 importantly poly_modulus, coeff_modulus, plain_modulus) significantly affect
 the performance, capabilities, and security of the encryption scheme. Once
 an instance of EncryptionParameters is populated with appropriate parameters,
 it can be used to create an instance of the SEALContext class, which verifies
 the validity of the parameters, and performs necessary pre-computations.
 
 Picking appropriate encryption parameters is essential to enable a particular
 application while balancing performance and security. Some encryption settings
 will not allow some inputs (e.g. attempting to encrypt a polynomial with more
 coefficients than poly_modulus or larger coefficients than plain_modulus) or,
 support the desired computations (with noise growing too fast due to too large
 plain_modulus and too small coeff_modulus).
 
 ASLParametersIdType
 The EncryptionParameters class maintains at all times a 256-bit hash of the
 currently set encryption parameters called the parms_id. This hash acts as
 a unique identifier of the encryption parameters and is used by all further
 objects created for these encryption parameters. The parms_id is not intended
 to be directly modified by the user but is used internally for pre-computation
 data lookup and input validity checks. In modulus switching the user can use
 the parms_id to keep track of the chain of encryption parameters. The parms_id
 is not exposed in the public API of EncryptionParameters, but can be accessed
 through the SEALContext::ContextData class once the SEALContext has been created.
 
 Thread Safety
 In general, reading from EncryptionParameters is thread-safe, while mutating
 is not.
 
 @warning Choosing inappropriate encryption parameters may lead to an encryption
 scheme that is not secure, does not perform well, and/or does not support the
 input and computation of the desired application. We highly recommend consulting
 an expert in RLWE-based encryption when selecting parameters, as this is where
 inexperienced users seem to most often make critical mistakes.
 */

@interface ASLEncryptionParameters : NSObject <NSCopying, NSCoding>

/*!
 Creates an empty set of encryption parameters.
 
 @param schemeType The encryption scheme to be used
 @see ASLSchemeType for the supported schemes
 */
+ (instancetype)encryptionParametersWithSchemeType:(ASLSchemeType)schemeType;

/*!
 Creates an empty set of encryption parameters.
 
 @paramASL_SealInvalidParameter scheme The encryption scheme to be used
 @throws ASL_SealInvalidParameter if scheme is not supported
 */
+ (instancetype _Nullable)encryptionParametersWithScheme:(uint8_t)scheme
                                                   error:(NSError **)error;

/*!
 Returns the degree of the polynomial modulus parameter.
 */
@property (nonatomic, assign, readonly) size_t polynomialModulusDegree;

/*!
 Returns a const reference to the currently set coefficient modulus parameter.
 */
@property (nonatomic, assign, readonly) NSArray<ASLSmallModulus *> *coefficientModulus;

/*!
 Returns a const reference to the currently set plaintext modulus parameter.
 */
@property (nonatomic, assign, readonly) ASLSmallModulus *plainModulus;

/*!
 Returns the encryption scheme type.
 */
@property (nonatomic, assign, readonly) ASLSchemeType scheme;

/*!
 Sets the degree of the polynomial modulus parameter to the specified value.
 The polynomial modulus directly affects the number of coefficients in
 plaintext polynomials, the size of ciphertext elements, the computational
 performance of the scheme (bigger is worse), and the security level (bigger
 is better). In Microsoft SEAL the degree of the polynomial modulus must be
 a power of 2 (e.g.  1024, 2048, 4096, 8192, 16384, or 32768).
 
 @param polynomialModulusDegree The new polynomial modulus degree
 @throws ASLSealErrorCodeLogicError if a valid scheme is not set and polynomialModulusDegree
 is non-zero
 */
- (BOOL)setPolynomialModulusDegree:(size_t)polynomialModulusDegree
                             error:(NSError **)error;

/*!
 Sets the coefficient modulus parameter. The coefficient modulus consists
 of a list of distinct prime numbers, and is represented by a vector of
 SmallModulus objects. The coefficient modulus directly affects the size
 of ciphertext elements, the amount of computation that the scheme can
 perform (bigger is better), and the security level (bigger is worse). In
 Microsoft SEAL each of the prime numbers in the coefficient modulus must
 be at most 60 bits, and must be congruent to 1 modulo 2*poly_modulus_degree.
 
 @param coefficientModulus The new coefficient modulus
 @throws ASLSealErrorCodeLogicError if a valid scheme is not set and coeff_modulus is
 is non-empty
 @throws ASL_SealInvalidParameter if size of coefficientModulus is invalid
 */
- (BOOL)setCoefficientModulus:(NSArray<ASLSmallModulus *>*)coefficientModulus
                        error:(NSError **)error;

/*!
 Sets the plaintext modulus parameter. The plaintext modulus is an integer
 modulus represented by the SmallModulus class. The plaintext modulus
 determines the largest coefficient that plaintext polynomials can represent.
 It also affects the amount of computation that the scheme can perform
 (bigger is worse). In Microsoft SEAL the plaintext modulus can be at most
 60 bits long, but can otherwise be any integer. Note, however, that some
 features (e.g. batching) require the plaintext modulus to be of a particular
 form.
 
 @param plainModulus The new plaintext modulus
 @throws ASLSealErrorCodeLogicError if scheme is not ASLSchemeTypeBFV and plainModulus
 is non-zero
 */
- (BOOL)setPlainModulus:(ASLSmallModulus *)plainModulus
                  error:(NSError **)error;

/**
 Sets the plaintext modulus parameter. The plaintext modulus is an integer
 modulus represented by the SmallModulus class. This constructor instead
 takes a std::uint64_t and automatically creates the SmallModulus object.
 The plaintext modulus determines the largest coefficient that plaintext
 polynomials can represent. It also affects the amount of computation that
 the scheme can perform (bigger is worse). In Microsoft SEAL the plaintext
 modulus can be at most 60 bits long, but can otherwise be any integer. Note,
 however, that some features (e.g. batching) require the plaintext modulus
 to be of a particular form.
 
 @param plainModulus The new plaintext modulus
 @throws ASL_SealInvalidParameter if plainModulus is invalid
 */
- (BOOL)setPlainModulusWithInteger:(uint64_t)plainModulus
                             error:(NSError **)error;

// TODO - fix this
-(BOOL)setRandomGenerator;

// TODO - fix this
-(BOOL)save;

// TODO - fix this
-(BOOL)load;

@end

NS_ASSUME_NONNULL_END
