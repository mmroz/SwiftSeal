//
//  ASLSealContextData.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLEncryptionParameters.h"
#import "ASLParametersIdType.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLSealContextData : NSObject

// TODO - uh oh this isnt good
//+ (instancetype)new NS_UNAVAILABLE;
//- (instancetype)new NS_UNAVAILABLE;

/*!
 Returns a const reference to the underlying encryption parameters.
 */
@property (nonatomic, readonly, readonly) ASLEncryptionParameters* encryptionParameters;

/*!
 Returns the parms_id of the current parameters.
 */
@property (nonatomic, readonly, assign) ASLParametersIdType parametersId;

//TODO - add this once ASLEncryptionParameterQualifiers exists
//@property (nonatomic, assign, readonly) ASLEncryptionParameterQualifiers* qualifiers;

/*!
 Returns a pointer to a pre-computed product of all primes in the coefficient
 modulus. The security of the encryption parameters largely depends on the
 bit-length of this product, and on the degree of the polynomial modulus.
 */
@property (nonatomic, assign, readonly) const uint64_t* totalCoefficientModulus;

// TODO - add these as well as the classes they need
//SEAL_NODISCARD inline auto &base_converter() const noexcept
//SEAL_NODISCARD inline auto &small_ntt_tables() const noexcept
//SEAL_NODISCARD inline auto &plain_ntt_tables() const noexcept

/*!
 Returns the significant bit count of the total coefficient modulus.
 */
@property (nonatomic, assign, readonly) NSInteger totalCoefficientModulusBitCount;

/*!
 Return a pointer to BFV "Delta", i.e. coefficient modulus divided by
 plaintext modulus.
 */
@property (nonatomic, assign, readonly) const uint64_t* coefficientDividedPlainModulus;

/*!
 Return the threshold for the upper half of integers modulo plain_modulus.
 This is simply (plain_modulus + 1) / 2.
 */
@property (nonatomic, assign, readonly) NSInteger plainUpperHalfThreshold;

/*!
 Return a pointer to the plaintext upper half increment, i.e. coeff_modulus
 minus plain_modulus. The upper half increment is represented as an integer
 for the full product coeff_modulus if using_fast_plain_lift is false and is
 otherwise represented modulo each of the coeff_modulus primes in order.
 */
@property (nonatomic, assign, readonly) const uint64_t* plainUpperHalfIncrement;

/*!
 Return a pointer to the upper half threshold with respect to the total
 coefficient modulus. This is needed in CKKS decryption.
 */
@property (nonatomic, assign, readonly) NSInteger upperHalfThreshold;

/*!
 Return a pointer to the upper half increment used for computing Delta*m
 and converting the coefficients to modulo coeff_modulus. For example,
 t-1 in plaintext should change into
 q - Delta = Delta*t + r_t(q) - Delta
 = Delta*(t-1) + r_t(q)
 so multiplying the message by Delta is not enough and requires also an
 addition of r_t(q). This is precisely the upper_half_increment. Note that
 this operation is only done for negative message coefficients, i.e. those
 that exceed plain_upper_half_threshold.
 */
@property (nonatomic, assign, readonly) const uint64_t* upperHalfIncrement;

/*!
 Return the non-RNS form of upppoer_half_increment which is q mod t.
 */
@property (nonatomic, assign, readonly) const uint64_t coefficientModPlainModulus;

/*!
 Returns a shared_ptr to the context data corresponding to the previous parameters
 in the modulus switching chain. If the current data is the first one in the
 chain, then the result is nullptr.
 */
@property (nonatomic, assign, readonly) ASLSealContextData* previousContextData;

/*!
 Returns a shared_ptr to the context data corresponding to the next parameters
 in the modulus switching chain. If the current data is the last one in the
 chain, then the result is nullptr.
 */
@property (nonatomic, assign, readonly) ASLSealContextData* nextContextData;

/*!
 Returns the index of the parameter set in a chain. The initial parameters
 have index 0 and the index increases sequentially in the parameter chain.
 */
@property (nonatomic, assign, readonly) NSInteger chainIndex;

@end

NS_ASSUME_NONNULL_END
