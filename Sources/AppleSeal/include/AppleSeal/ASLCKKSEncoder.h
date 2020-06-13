//
//  ASLCKKSEncoder.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-05.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLSealContext.h"
#import "ASLPlainText.h"
#import "ASLMemoryPoolHandle.h"
#import "ASLComplexType.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 @class ASLCKKSEncoder
 
 @brief The ASLCipherText class and rapper for CKKSEncoder
 
 @discussion Provides functionality for encoding vectors of complex or real numbers into
 plaintext polynomials to be encrypted and computed on using the CKKS scheme.
 If the polynomial modulus degree is N, then CKKSEncoder converts vectors of
 N/2 complex numbers into plaintext elements. Homomorphic operations performed
 on such encrypted vectors are applied coefficient (slot-)wise, enabling
 powerful SIMD functionality for computations that are vectorizable. This
 functionality is often called "batching" in the homomorphic encryption
 literature.
 
 Mathematical Background
 Mathematically speaking, if the polynomial modulus is X^N+1, N is a power of
 two, the CKKSEncoder implements an approximation of the canonical embedding
 of the ring of integers Z[X]/(X^N+1) into C^(N/2), where C denotes the complex
 numbers. The Galois group of the extension is (Z/2NZ)* ~= Z/2Z x Z/(N/2)
 whose action on the primitive roots of unity modulo coeff_modulus is easy to
 describe. Since the batching slots correspond 1-to-1 to the primitive roots
 of unity, applying Galois automorphisms on the plaintext acts by permuting
 the slots. By applying generators of the two cyclic subgroups of the Galois
 group, we can effectively enable cyclic rotations and complex conjugations
 of the encrypted complex vectors.
 */

@interface ASLCKKSEncoder : NSObject

/*!
 Creates a CKKSEncoder instance initialized with the specified ASLSealContext.
 
 @param context The SEALContext
 @throws ASL_SealInvalidParameter if the context is not set or encryption
 parameters are not valid
 @throws ASL_SealInvalidParameter if scheme is not ASLSchemeTypeCKKS
 */
+ (instancetype _Nullable)ckksEncoderWithContext:(ASLSealContext *)context
                                           error:(NSError **)error;

/*!
 Returns the number of complex numbers encoded.
 */
@property (nonatomic, readonly, assign) size_t slotCount;

/*!
 Encodes a vector of double-precision floating-point real or complex numbers
 into a plaintext polynomial. Append zeros if vector size is less than N/2.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle.
 
 @param values The NSArray of ComplexDouble's to encode
 @param parametersId parametersId determining the encryption parameters to
 be used by the result plaintext
 @param scale Scaling parameter defining encoding precision
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if values has invalid size
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
- (ASLPlainText * _Nullable)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
                                       parametersId:(ASLParametersIdType)parametersId
                                              scale:(double)scale
                                               pool:(ASLMemoryPoolHandle *)pool
                                              error:(NSError **)error;

/*!
 Encodes a vector of double-precision floating-point real or complex numbers
 into a plaintext polynomial. Append zeros if vector size is less than N/2.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle.
 
 @param values The NSArray of ComplexDouble's to encode
 @param parametersId parametersId determining the encryption parameters to
 be used by the result plaintext
 @param scale Scaling parameter defining encoding precision
 @throws ASL_SealInvalidParameter if values has invalid size
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 */
- (ASLPlainText * _Nullable)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
                                       parametersId:(ASLParametersIdType)parametersId
                                              scale:(double)scale
                                              error:(NSError **)error;

/*!
 Encodes a vector of double-precision floating-point real or complex numbers
 into a plaintext polynomial. Append zeros if vector size is less than N/2.
 The encryption parameters used are the top level parameters for the given
 context. Dynamic memory allocations in the process are allocated from the
 memory pool pointed to by the given MemoryPoolHandle.
 
 @param values The vector of double-precision floating-point numbers
 (of type ASLComplexType) to encode
 @param scale Scaling parameter defining encoding precision
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if values has invalid size
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
- (ASLPlainText * _Nullable)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
                                              scale:(double)scale
                                               pool:(ASLMemoryPoolHandle *)pool
                                              error:(NSError **)error;

/*!
 Encodes a vector of double-precision floating-point real or complex numbers
 into a plaintext polynomial. Append zeros if vector size is less than N/2.
 The encryption parameters used are the top level parameters for the given
 context. Dynamic memory allocations in the process are allocated from the
 memory pool pointed to by the given MemoryPoolHandle.
 
 @param values The vector of double-precision floating-point numbers
 (of type ASLComplexType) to encode
 @param scale Scaling parameter defining encoding precision
 @throws ASL_SealInvalidParameter if values has invalid size
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 */

- (ASLPlainText * _Nullable)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
                                              scale:(double)scale
                                              error:(NSError **)error;

/*!
 Encodes a double-precision complex number into a plaintext polynomial.
 Append zeros to fill all slots. The encryption parameters used are the
 top level parameters for the given context. Dynamic memory allocations
 in the process are allocated from the memory pool pointed to by the
 given MemoryPoolHandle.
 
 @param complexValue The double-precision complex number to encode
 @param scale Scaling parameter defining encoding precision
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */

- (ASLPlainText * _Nullable)encodeWithComplexValue:(ASLComplexType *)complexValue
                                             scale:(double)scale
                                              pool:(ASLMemoryPoolHandle *)pool
                                             error:(NSError **)error;


/*!
 Encodes a double-precision complex number into a plaintext polynomial.
 Append zeros to fill all slots. The encryption parameters used are the
 top level parameters for the given context. Dynamic memory allocations
 in the process are allocated from the memory pool pointed to by the
 given MemoryPoolHandle.
 
 @param complexValue The double-precision complex number to encode
 @param scale Scaling parameter defining encoding precision
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 */
- (ASLPlainText * _Nullable)encodeWithComplexValue:(ASLComplexType *)complexValue
                                             scale:(double)scale
                                             error:(NSError **)error;

/*!
 Encodes a double-precision floating-point real number into a plaintext
 polynomial. The number repeats for N/2 times to fill all slots. Dynamic
 memory allocations in the process are allocated from the memory pool
 pointed to by the given MemoryPoolHandle.
 
 @param value The double-precision floating-point number to encode
 @param parametersId parms_id determining the encryption parameters to be
 used by the result plaintext
 @param scale Scaling parameter defining encoding precision
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 */
- (ASLPlainText * _Nullable)encodeWithDoubleValue:(double)value
                                     parametersId:(ASLParametersIdType)parametersId
                                            scale:(double)scale
                                            error:(NSError **)error;

/*!
 Encodes a double-precision floating-point real number into a plaintext
 polynomial. The number repeats for N/2 times to fill all slots. Dynamic
 memory allocations in the process are allocated from the memory pool
 pointed to by the given MemoryPoolHandle.
 
 @param value The double-precision floating-point number to encode
 @param parametersId parms_id determining the encryption parameters to be
 used by the result plaintext
 @param scale Scaling parameter defining encoding precision
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
- (ASLPlainText * _Nullable)encodeWithDoubleValue:(double)value
                                     parametersId:(ASLParametersIdType)parametersId
                                            scale:(double)scale
                                             pool:(ASLMemoryPoolHandle *)pool
                                            error:(NSError **)error;

/*!
 Encodes a double-precision floating-point real number into a plaintext
 polynomial. The number repeats for N/2 times to fill all slots. The
 encryption parameters used are the top level parameters for the given
 context. Dynamic memory allocations in the process are allocated from
 the memory pool pointed to by the given MemoryPoolHandle.
 
 @param value The double-precision floating-point number to encode
 @param scale Scaling parameter defining encoding precision
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 */
- (ASLPlainText * _Nullable)encodeWithDoubleValue:(double)value
                                            scale:(double)scale
                                            error:(NSError **)error;

/*!
 Encodes a double-precision floating-point real number into a plaintext
 polynomial. The number repeats for N/2 times to fill all slots. The
 encryption parameters used are the top level parameters for the given
 context. Dynamic memory allocations in the process are allocated from
 the memory pool pointed to by the given MemoryPoolHandle.
 
 @param value The double-precision floating-point number to encode
 @param scale Scaling parameter defining encoding precision
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
- (ASLPlainText * _Nullable)encodeWithDoubleValue:(double)value
                                            scale:(double)scale
                                             pool:(ASLMemoryPoolHandle *)pool
                                            error:(NSError **)error;

/*!
 Encodes a double-precision complex number into a plaintext polynomial.
 Append zeros to fill all slots. Dynamic memory allocations in the process
 are allocated from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param complexValue The double-precision complex number to encode
 @param parametersId parms_id determining the encryption parameters to be
 used by the result plaintext
 @param scale Scaling parameter defining encoding precision
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 */
- (ASLPlainText * _Nullable)encodeWithComplexValue:(ASLComplexType *)complexValue
                                      parametersId:(ASLParametersIdType)parametersId
                                             scale:(double)scale
                                             error:(NSError **)error;

/*!
 Encodes a double-precision complex number into a plaintext polynomial.
 Append zeros to fill all slots. Dynamic memory allocations in the process
 are allocated from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param complexValue The double-precision complex number to encode
 @param parametersId parms_id determining the encryption parameters to be
 used by the result plaintext
 @param scale Scaling parameter defining encoding precision
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
- (ASLPlainText * _Nullable)encodeWithComplexValue:(ASLComplexType *)complexValue
                                      parametersId:(ASLParametersIdType)parametersId
                                             scale:(double)scale
                                              pool:(ASLMemoryPoolHandle *)pool
                                             error:(NSError **)error;

/*!
 Encodes a vector of double-precision floating-point real or complex numbers
 into a plaintext polynomial. Append zeros if vector size is less than N/2.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle.
 
 @param values The vector of double-precision floating-point double values to encode
 @param parametersId parms_id determining the encryption parameters to
 be used by the result plaintext
 @param scale Scaling parameter defining encoding precision
 @throws ASL_SealInvalidParameter if values has invalid size
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 */
- (ASLPlainText * _Nullable)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
                                      parametersId:(ASLParametersIdType)parametersId
                                             scale:(double)scale
                                             error:(NSError **)error;

/*!
 Encodes a vector of double-precision floating-point real or complex numbers
 into a plaintext polynomial. Append zeros if vector size is less than N/2.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle.
 
 @param values The vector of double-precision floating-point double values to encode
 @param parametersId parms_id determining the encryption parameters to
 be used by the result plaintext
 @param scale Scaling parameter defining encoding precision
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if values has invalid size
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
- (ASLPlainText * _Nullable)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
                                      parametersId:(ASLParametersIdType)parametersId
                                             scale:(double)scale
                                              pool:(ASLMemoryPoolHandle*)pool
                                             error:(NSError **)error;

/*!
 Encodes a vector of double-precision floating-point real or complex numbers
 into a plaintext polynomial. Append zeros if vector size is less than N/2.
 The encryption parameters used are the top level parameters for the given
 context. Dynamic memory allocations in the process are allocated from the
 memory pool pointed to by the given MemoryPoolHandle.
 
 @param values The vector of double-precision floating-point numbers to encode
 @param scale Scaling parameter defining encoding precision
 @throws ASL_SealInvalidParameter if values has invalid size
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 */
- (ASLPlainText * _Nullable)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
                                             scale:(double)scale
                                             error:(NSError **)error;

/*!
 Encodes a vector of double-precision floating-point real or complex numbers
 into a plaintext polynomial. Append zeros if vector size is less than N/2.
 The encryption parameters used are the top level parameters for the given
 context. Dynamic memory allocations in the process are allocated from the
 memory pool pointed to by the given MemoryPoolHandle.
 
 @param values The vector of double-precision floating-point numbers to encode
 @param scale Scaling parameter defining encoding precision
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if values has invalid size
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
- (ASLPlainText * _Nullable)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
                                             scale:(double)scale
                                              pool:(ASLMemoryPoolHandle *)pool
                                             error:(NSError **)error;

/*!
 Encodes an integer number into a plaintext polynomial without any scaling.
 The number repeats for N/2 times to fill all slots.
 @param longValue The integer number to encode
 @param parametersId parms_id determining the encryption parameters to be
 used by the result plaintext
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
 parameters
 */
- (ASLPlainText * _Nullable)encodeWithLongValue:(NSDecimalNumber*)longValue
                                   parametersId:(ASLParametersIdType)parametersId
                                          error:(NSError **)error;

/*!
 Encodes an integer number into a plaintext polynomial without any scaling.
 The number repeats for N/2 times to fill all slots. The encryption
 parameters used are the top level parameters for the given context.
 
 @param longValue The integer number to encode
 */
- (ASLPlainText * _Nullable)encodeWithLongValue:(NSDecimalNumber*)longValue
                                          error:(NSError **)error;

/*!
 Decodes a plaintext polynomial into double-precision floating-point
 real.
 
 @param plain The plaintext to decode
 the slots
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASLInvalidParameter if plain is not in NTT form or is invalid
 for the encryption parameters
 @throws ASLInvalidParameter if pool is uninitialized
 */

- (NSArray<NSNumber *> * _Nullable)decodeDoubleValues:(ASLPlainText *)plainText
                                                error:(NSError **)error;

/*!
 Decodes a plaintext polynomial into complex numbers.
 
 @param plain The plaintext to decode
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASLInvalidParameter if plain is not in NTT form or is invalid
 for the encryption parameters
 @throws ASLInvalidParameter if pool is uninitialized
 */

- (NSArray<ASLComplexType *> * _Nullable)decodeComplexDoubleValues:(ASLPlainText *)plainText
                                                             error:(NSError **)error;

/*!
Decodes a plaintext polynomial into double-precision floating-point
real numbers. Dynamic memory allocations in the process are
allocated from the memory pool pointed to by the given MemoryPoolHandle.

@param plain The plaintext to decode
@param pool The MemoryPoolHandle pointing to a valid memory pool
@throws ASLInvalidParameter if plain is not in NTT form or is invalid
for the encryption parameters
@throws ASLInvalidParameter if pool is uninitialized
*/
- (NSArray<NSNumber *> * _Nullable)decodeDoubleValues:(ASLPlainText *)plainText
                                                 pool:(ASLMemoryPoolHandle *)pool
                                                error:(NSError **)error;

/*!
Decodes a plaintext polynomial into complex numbers. Dynamic memory allocations in the process are
allocated from the memory pool pointed to by the given MemoryPoolHandle.

@param plain The plaintext to decode
@param pool The MemoryPoolHandle pointing to a valid memory pool
@throws ASLInvalidParameter if plain is not in NTT form or is invalid
for the encryption parameters
@throws ASLInvalidParameter if pool is uninitialized
*/
- (NSArray<ASLComplexType *> * _Nullable)decodeComplexDoubleValues:(ASLPlainText *)plainText
                                                              pool:(ASLMemoryPoolHandle *)pool
                                                             error:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
