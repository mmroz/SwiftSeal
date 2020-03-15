//
//  ASLCipherText.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-01.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLCipherText.h"

#import <AppleSeal/ASLMemoryPoolHandle.h>
#import <AppleSeal/ASLSealContext.h>
#import <AppleSeal/ASLParametersIdType.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASLCipherText : NSObject <NSCopying, NSCoding>

/*!
 Constructs an empty ciphertext allocating no memory.
 
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASLSealErrorCodeInvalidParameter if pool is uninitialized
 */
- (instancetype)initWithPool:(ASLMemoryPoolHandle *)pool;

/*!
 Constructs an empty ciphertext with capacity 2. In addition to the
 capacity, the allocation size is determined by the highest-level
 parameters associated to the given SEALContext.
 
 @param context The SEALContext
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASLSealErrorCodeInvalidParameter if the context is not set or encryption
 parameters are not valid
 @throws ASLSealErrorCodeInvalidParameter if pool is uninitialized
 */
+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
                                           pool:(ASLMemoryPoolHandle *)pool
                                          error:(NSError **)error;

/*!
 Constructs an empty ciphertext with capacity 2. In addition to the
 capacity, the allocation size is determined by the highest-level
 parameters associated to the given SEALContext.
 
 @param context The SEALContext
 @throws ASLSealErrorCodeInvalidParameter if the context is not set or encryption
 parameters are not valid
 */
+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
                                          error:(NSError **)error;

/*!
 Constructs an empty ciphertext with capacity 2. In addition to the
 capacity, the allocation size is determined by the encryption parameters
 with given parms_id.
 
 @param context The SEALContext
 @param parametersId The parms_id corresponding to the encryption
 parameters to be used
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASLSealErrorCodeInvalidParameter if the context is not set or encryption
 parameters are not valid
 @throws ASLSealErrorCodeInvalidParameter if parms_id is not valid for the encryption
 parameters
 @throws ASLSealErrorCodeInvalidParameter if pool is uninitialized
 */
+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
                                   parametersId:(ASLParametersIdType *)parametersId
                                           pool:(ASLMemoryPoolHandle *)pool
                                          error:(NSError **)error;

/*!
 Constructs an empty ciphertext with capacity 2. In addition to the
 capacity, the allocation size is determined by the encryption parameters
 with given parms_id.
 
 @param context The SEALContext
 @param parametersId The parms_id corresponding to the encryption
 parameters to be used
 @throws ASLSealErrorCodeInvalidParameter if the context is not set or encryption
 parameters are not valid
 @throws ASLSealErrorCodeInvalidParameter if parms_id is not valid for the encryption
 parameters
 */
+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
                                   parametersId:(ASLParametersIdType *)parametersId
                                          error:(NSError **)error;

/*!
 Constructs an empty ciphertext with given capacity. In addition to
 the capacity, the allocation size is determined by the given
 encryption parameters.
 
 @param context The SEALContext
 @param parametersId The parms_id corresponding to the encryption
 parameters to be used
 @param sizeCapacity The capacity
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASLSealErrorCodeInvalidParameter if the context is not set or encryption
 parameters are not valid
 @throws ASLSealErrorCodeInvalidParameter if parms_id is not valid for the encryption
 parameters
 @throws ASLSealErrorCodeInvalidParameter if size_capacity is less than 2 or too large
 @throws ASLSealErrorCodeInvalidParameter if pool is uninitialized
 */
+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
                                   parametersId:(ASLParametersIdType *)parametersId
                                   sizeCapacity:(size_t)sizeCapacity
                                           pool:(ASLMemoryPoolHandle *)pool
                                          error:(NSError **)error;

/*!
 Constructs an empty ciphertext with given capacity. In addition to
 the capacity, the allocation size is determined by the given
 encryption parameters.
 
 @param context The SEALContext
 @param parametersId The parms_id corresponding to the encryption
 parameters to be used
 @param sizeCapacity The capacity
 @throws ASLSealErrorCodeInvalidParameter if the context is not set or encryption
 parameters are not valid
 @throws ASLSealErrorCodeInvalidParameter if parms_id is not valid for the encryption
 parameters
 @throws ASLSealErrorCodeInvalidParameter if size_capacity is less than 2 or too large
 */
+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
                                   sizeCapacity:(size_t)sizeCapacity
                                   parametersId:(ASLParametersIdType *)parametersId
                                          error:(NSError **)error;

/**
 Constructs a new ciphertext by copying a given one.
 
 @param cipherText The ciphertext to copy from
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASLSealErrorCodeInvalidParameter if pool is uninitialized
 */
+ (instancetype _Nullable)cipherTextWithCipherText:(ASLCipherText *)cipherText
                                              pool:(ASLMemoryPoolHandle *)pool
                                             error:(NSError **)error;

- (BOOL)isEqualToCipherText:(ASLCipherText *)other;

/*!
 Allocates enough memory to accommodate the backing array of a ciphertext
 with given capacity. In addition to the capacity, the allocation size is
 determined by the encryption parameters corresponing to the given
 parms_id.
 
 @param context The SEALContext
 @param parametersId The parms_id corresponding to the encryption
 parameters to be used
 @param sizeCapacity The capacity
 @throws ASLSealErrorCodeInvalidParameter if the context is not set or encryption
 parameters are not valid
 @throws ASLSealErrorCodeInvalidParameter if parms_id is not valid for the encryption
 parameters
 @throws ASLSealErrorCodeInvalidParameter if size_capacity is less than 2 or too large
 */
- (BOOL)reserve:(ASLSealContext *)context
   parametersId:(ASLParametersIdType)parametersId
   sizeCapacity:(size_t)sizeCapacity
          error:(NSError **)error;

/*!
 Allocates enough memory to accommodate the backing array of a ciphertext
 with given capacity. In addition to the capacity, the allocation size is
 determined by the highest-level parameters associated to the given
 SEALContext.
 
 @param context The SEALContext
 @param sizeCapacity The capacity
 @throws ASLSealErrorCodeInvalidParameter if the context is not set or encryption
 parameters are not valid
 @throws ASLSealErrorCodeInvalidParameter if size_capacity is less than 2 or too large
 */
- (BOOL)reserve:(ASLSealContext *)context
   sizeCapacity:(size_t)sizeCapacity
          error:(NSError **)error;

/*!
 Allocates enough memory to accommodate the backing array of a ciphertext
 with given capacity. In addition to the capacity, the allocation size is
 determined by the current encryption parameters.
 
 @param sizeCapacity The capacity
 @throws ASLSealErrorCodeInvalidParameter if size_capacity is less than 2 or too large
 @throws ASLSealErrorCodeLogicError if the encryption parameters are not
 */
- (BOOL)reserve:(size_t)sizeCapacity
          error:(NSError **)error;

/*!
 Resizes the ciphertext to given size, reallocating if the capacity
 of the ciphertext is too small. The ciphertext parameters are
 determined by the given SEALContext and parms_id.
 
 This function is mainly intended for internal use and is called
 automatically by functions such as Evaluator::multiply and
 Evaluator::relinearize. A normal user should never have a reason
 to manually resize a ciphertext.
 
 @param context The SEALContext
 @param parametersId The parms_id corresponding to the encryption
 parameters to be used
 @param size The new size
 @throws ASLSealErrorCodeInvalidParameter if the context is not set or encryption
 parameters are not valid
 @throws ASLSealErrorCodeInvalidParameter if parms_id is not valid for the encryption
 parameters
 @throws ASLSealErrorCodeInvalidParameter if size is less than 2 or too large
 */
- (BOOL)resize:(ASLSealContext *)context
  parametersId:(ASLParametersIdType)parametersId
  sizeCapacity:(size_t)size
         error:(NSError **)error;

/**
 Resizes the ciphertext to given size, reallocating if the capacity
 of the ciphertext is too small. The ciphertext parameters are
 determined by the highest-level parameters associated to the given
 SEALContext.
 
 This function is mainly intended for internal use and is called
 automatically by functions such as Evaluator::multiply and
 Evaluator::relinearize. A normal user should never have a reason
 to manually resize a ciphertext.
 
 @param context The SEALContext
 @param size The new size
 @throws ASLSealErrorCodeInvalidParameter if the context is not set or encryption
 parameters are not valid
 @throws ASLSealErrorCodeInvalidParameter if size is less than 2 or too large
 */
- (BOOL)resize:(ASLSealContext *)context
  sizeCapacity:(size_t)size
         error:(NSError **)error;

/*!
 Resizes the ciphertext to given size, reallocating if the capacity
 of the ciphertext is too small.
 
 This function is mainly intended for internal use and is called
 automatically by functions such as Evaluator::multiply and
 Evaluator::relinearize. A normal user should never have a reason
 to manually resize a ciphertext.
 
 @param size The new size
 @throws ASLSealErrorCodeInvalidParameter if size is less than 2 or too large
 */
- (BOOL)resize:(size_t)size
         error:(NSError **)error;

/*!
 Resets the ciphertext. This function releases any memory allocated
 by the ciphertext, returning it to the memory pool. It also sets all
 encryption parameter specific size information to zero.
 */
-(void)returnMemoryToPool;

/**
 Returns a pointer to a particular polynomial in the ciphertext
 data. Note that Microsoft SEAL stores each polynomial in the ciphertext
 modulo all of the K primes in the coefficient modulus. The pointer
 returned by this function is to the beginning (constant coefficient)
 of the first one of these K polynomials.
 
 @param index The index of the polynomial in the ciphertext
 @throws NSRangeException if index is less than 0 or bigger
 than the size of the ciphertext
 */
- (uint64_t)polynomialCoefficientAtIndex:(size_t)index
                                   error:(NSError **)error;

/*!
 Returns a reference to the backing IntArray object.
 */
@property (nonatomic, readonly, assign) NSInteger intArray;

/*!
 Returns the number of primes in the coefficient modulus of the
 associated encryption parameters. This directly affects the
 allocation size of the ciphertext.
 */
@property (nonatomic, readonly, assign) size_t coefficientModulusCount;

/*!
 Returns the degree of the polynomial modulus of the associated
 encryption parameters. This directly affects the allocation size
 of the ciphertext.
 */
@property (nonatomic, readonly, assign) size_t polynomialModulusDegree;

/*!
 Returns the size of the ciphertext.
 */
@property (nonatomic, readonly, assign) size_t size;

/*!
 Returns the capacity of the allocation. This means the largest size
 of the ciphertext that can be stored in the current allocation with
 the current encryption parameters.
 */
@property (nonatomic, readonly, assign) size_t sizeCapacity;

/*!
 Check whether the current ciphertext is transparent, i.e. does not require
 a secret key to decrypt. In typical security models such transparent
 ciphertexts would not be considered to be valid. Starting from the second
 polynomial in the current ciphertext, this function returns true if all
 following coefficients are identically zero. Otherwise, returns false.
 */
@property (nonatomic, readonly, assign, getter=isTransparent) BOOL transparent;

/*!
 Returns whether the ciphertext is in NTT form.
 */
@property (nonatomic, readonly, assign, getter=isNntForm) BOOL nntForm;

/*!
 Returns a reference to ASLParametersIdType.
 */
@property (nonatomic, readonly, assign) ASLParametersIdType parametersId;

/*!
 Returns a reference to the scale. This is only needed when using the
 CKKS encryption scheme. The user should have little or no reason to ever
 change the scale by hand.
 */
@property (nonatomic, readonly, assign) double scale;

/*!
 Returns the currently used MemoryPoolHandle.
 */
@property (nonatomic, readonly, assign) ASLMemoryPoolHandle* pool;

@end

NS_ASSUME_NONNULL_END