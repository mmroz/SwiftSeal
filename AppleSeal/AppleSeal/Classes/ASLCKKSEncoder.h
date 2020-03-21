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
@property (nonatomic, readonly, assign) size_t slot_count;

/*!
 Encodes a vector of double-precision floating-point real or complex numbers
 into a plaintext polynomial. Append zeros if vector size is less than N/2.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle.
 
 @param values TheNSArray of ComplexDouble's to encode
 @param parametersId parametersId determining the encryption parameters to
 be used by the result plaintext
 @param scale Scaling parameter defining encoding precision
 @param destination The plaintext polynomial to overwrite with the
 result
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if values has invalid size
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
- (BOOL)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
                   parametersId:(ASLParametersIdType)parametersId
                          scale:(double)scale
                    destination:(ASLPlainText *)destination
                           pool:(ASLMemoryPoolHandle *)pool
                          error:(NSError **)error;

/*!
 Encodes a vector of double-precision floating-point real or complex numbers
 into a plaintext polynomial. Append zeros if vector size is less than N/2.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle.
 
 @param values TheNSArray of ComplexDouble's to encode
 @param parametersId parametersId determining the encryption parameters to
 be used by the result plaintext
 @param scale Scaling parameter defining encoding precision
 @param destination The plaintext polynomial to overwrite with the
 result
 @throws ASL_SealInvalidParameter if values has invalid size
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 */
- (BOOL)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
                   parametersId:(ASLParametersIdType)parametersId
                          scale:(double)scale
                    destination:(ASLPlainText *)destination
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
 @param destination The plaintext polynomial to overwrite with the
 result
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if values has invalid size
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
- (BOOL)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
                          scale:(double)scale
                    destination:(ASLPlainText *)destination
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
 @param destination The plaintext polynomial to overwrite with the
 result
 @throws ASL_SealInvalidParameter if values has invalid size
 @throws ASL_SealInvalidParameter if scale is not strictly positive
 @throws ASL_SealInvalidParameter if encoding is too large for the encryption
 parameters
 */

- (BOOL)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
                          scale:(double)scale
                    destination:(ASLPlainText *)destination
                          error:(NSError **)error;

/*!
Encodes a double-precision complex number into a plaintext polynomial.
Append zeros to fill all slots. The encryption parameters used are the
top level parameters for the given context. Dynamic memory allocations
in the process are allocated from the memory pool pointed to by the
given MemoryPoolHandle.

@param complexValue The double-precision complex number to encode
@param scale Scaling parameter defining encoding precision
@param destination The plaintext polynomial to overwrite with the
result
@param pool The MemoryPoolHandle pointing to a valid memory pool
@throws ASL_SealInvalidParameter if scale is not strictly positive
@throws ASL_SealInvalidParameter if encoding is too large for the encryption
parameters
@throws ASL_SealInvalidParameter if pool is uninitialized
*/

- (BOOL)encodeWithComplexValue:(ASLComplexType *)complexValue
      scale:(double)scale
destination:(ASLPlainText *)destination
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
@param destination The plaintext polynomial to overwrite with the
result
@throws ASL_SealInvalidParameter if scale is not strictly positive
@throws ASL_SealInvalidParameter if encoding is too large for the encryption
parameters
*/
- (BOOL)encodeWithComplexValue:(ASLComplexType *)complexValue
                         scale:(double)scale
                   destination:(ASLPlainText *)destination
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
@param destination The plaintext polynomial to overwrite with the
result
@throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
parameters
@throws ASL_SealInvalidParameter if scale is not strictly positive
@throws ASL_SealInvalidParameter if encoding is too large for the encryption
parameters
*/
- (BOOL)encodeWithDoubleValue:(double)value
                 parametersId:(ASLParametersIdType)parametersId
                        scale:(double)scale
                  destination:(ASLPlainText *)destination
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
@param destination The plaintext polynomial to overwrite with the
result
@param pool The MemoryPoolHandle pointing to a valid memory pool
@throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
parameters
@throws ASL_SealInvalidParameter if scale is not strictly positive
@throws ASL_SealInvalidParameter if encoding is too large for the encryption
parameters
@throws ASL_SealInvalidParameter if pool is uninitialized
*/
- (BOOL)encodeWithDoubleValue:(double)value
                 parametersId:(ASLParametersIdType)parametersId
                        scale:(double)scale
                  destination:(ASLPlainText *)destination
                         pool:(ASLMemoryPoolHandle *)pool
                        error:(NSError **)error;

/**
Encodes a double-precision floating-point real number into a plaintext
polynomial. The number repeats for N/2 times to fill all slots. The
encryption parameters used are the top level parameters for the given
context. Dynamic memory allocations in the process are allocated from
the memory pool pointed to by the given MemoryPoolHandle.

@param value The double-precision floating-point number to encode
@param scale Scaling parameter defining encoding precision
@param destination The plaintext polynomial to overwrite with the
result
@throws ASL_SealInvalidParameter if scale is not strictly positive
@throws ASL_SealInvalidParameter if encoding is too large for the encryption
parameters
*/
- (BOOL)encodeWithDoubleValue:(double)value
                        scale:(double)scale
                  destination:(ASLPlainText *)destination
                        error:(NSError **)error;

/**
Encodes a double-precision floating-point real number into a plaintext
polynomial. The number repeats for N/2 times to fill all slots. The
encryption parameters used are the top level parameters for the given
context. Dynamic memory allocations in the process are allocated from
the memory pool pointed to by the given MemoryPoolHandle.

@param value The double-precision floating-point number to encode
@param scale Scaling parameter defining encoding precision
@param destination The plaintext polynomial to overwrite with the
result
@param pool The MemoryPoolHandle pointing to a valid memory pool
@throws ASL_SealInvalidParameter if scale is not strictly positive
@throws ASL_SealInvalidParameter if encoding is too large for the encryption
parameters
@throws ASL_SealInvalidParameter if pool is uninitialized
*/
- (BOOL)encodeWithDoubleValue:(double)value
                        scale:(double)scale
                  destination:(ASLPlainText *)destination
                         pool:(ASLMemoryPoolHandle *)pool
                        error:(NSError **)error;

/**
Encodes a double-precision complex number into a plaintext polynomial.
Append zeros to fill all slots. Dynamic memory allocations in the process
are allocated from the memory pool pointed to by the given MemoryPoolHandle.

@param complexValue The double-precision complex number to encode
@param parametersId parms_id determining the encryption parameters to be
used by the result plaintext
@param scale Scaling parameter defining encoding precision
@param destination The plaintext polynomial to overwrite with the
result
@throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
parameters
@throws ASL_SealInvalidParameter if scale is not strictly positive
@throws ASL_SealInvalidParameter if encoding is too large for the encryption
parameters
*/
- (BOOL)encodeWithComplexValue:(ASLComplexType *)complexValue
                  parametersId:(ASLParametersIdType)parametersId
                         scale:(double)scale
                   destination:(ASLPlainText *)destination
                         error:(NSError **)error;

/**
Encodes a double-precision complex number into a plaintext polynomial.
Append zeros to fill all slots. Dynamic memory allocations in the process
are allocated from the memory pool pointed to by the given MemoryPoolHandle.

@param complexValue The double-precision complex number to encode
@param parametersId parms_id determining the encryption parameters to be
used by the result plaintext
@param scale Scaling parameter defining encoding precision
@param destination The plaintext polynomial to overwrite with the
result
@param pool The MemoryPoolHandle pointing to a valid memory pool
@throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
parameters
@throws ASL_SealInvalidParameter if scale is not strictly positive
@throws ASL_SealInvalidParameter if encoding is too large for the encryption
parameters
@throws ASL_SealInvalidParameter if pool is uninitialized
*/
- (BOOL)encodeWithComplexValue:(ASLComplexType *)complexValue
                  parametersId:(ASLParametersIdType)parametersId
                         scale:(double)scale
                   destination:(ASLPlainText *)destination
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
@param destination The plaintext polynomial to overwrite with the
result
@throws ASL_SealInvalidParameter if values has invalid size
@throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
parameters
@throws ASL_SealInvalidParameter if scale is not strictly positive
@throws ASL_SealInvalidParameter if encoding is too large for the encryption
parameters
*/
- (BOOL)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
				  parametersId:(ASLParametersIdType)parametersId
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
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
@param destination The plaintext polynomial to overwrite with the
result
@param pool The MemoryPoolHandle pointing to a valid memory pool
@throws ASL_SealInvalidParameter if values has invalid size
@throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
parameters
@throws ASL_SealInvalidParameter if scale is not strictly positive
@throws ASL_SealInvalidParameter if encoding is too large for the encryption
parameters
@throws ASL_SealInvalidParameter if pool is uninitialized
*/
- (BOOL)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
				  parametersId:(ASLParametersIdType)parametersId
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
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
@param destination The plaintext polynomial to overwrite with the
result
@throws ASL_SealInvalidParameter if values has invalid size
@throws ASL_SealInvalidParameter if scale is not strictly positive
@throws ASL_SealInvalidParameter if encoding is too large for the encryption
parameters
*/
- (BOOL)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
						 error:(NSError **)error;

/*!
Encodes a vector of double-precision floating-point real or complex numbers
into a plaintext polynomial. Append zeros if vector size is less than N/2.
The encryption parameters used are the top level parameters for the given
context. Dynamic memory allocations in the process are allocated from the
memory pool pointed to by the given MemoryPoolHandle.

@param values The vector of double-precision floating-point numbers to encode
@param scale Scaling parameter defining encoding precision
@param destination The plaintext polynomial to overwrite with the
result
@param pool The MemoryPoolHandle pointing to a valid memory pool
@throws ASL_SealInvalidParameter if values has invalid size
@throws ASL_SealInvalidParameter if scale is not strictly positive
@throws ASL_SealInvalidParameter if encoding is too large for the encryption
parameters
@throws ASL_SealInvalidParameter if pool is uninitialized
*/
- (BOOL)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
						  pool:(ASLMemoryPoolHandle *)pool
						 error:(NSError **)error;

/**
Encodes an integer number into a plaintext polynomial without any scaling.
The number repeats for N/2 times to fill all slots.
@param longValue The integer number to encode
@param parametersId parms_id determining the encryption parameters to be
used by the result plaintext
@param destination The plaintext polynomial to overwrite with the
result
@throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
parameters
*/
- (BOOL)encodeWithLongValue:(NSDecimalNumber*)longValue
			   parametersId:(ASLParametersIdType)parametersId
				destination:(ASLPlainText *)destination
					  error:(NSError **)error;

/**
Encodes an integer number into a plaintext polynomial without any scaling.
The number repeats for N/2 times to fill all slots. The encryption
parameters used are the top level parameters for the given context.

@param longValue The integer number to encode
@param destination The plaintext polynomial to overwrite with the
result
*/
- (BOOL)encodeWithLongValue:(NSDecimalNumber*)longValue
				destination:(ASLPlainText *)destination
					  error:(NSError **)error;


/*!
Inverse of encode. This function "unbatches" a given plaintext into a matrix
of integers modulo the plaintext modulus, and stores the result in the destination
parameter. The input plaintext must have degress less than the polynomial modulus,
and coefficients less than the plaintext modulus, i.e. it must be a valid plaintext
for the encryption parameters. Dynamic memory allocations in the process are
allocated from the memory pool pointed to by the given MemoryPoolHandle.

@param plainText The plaintext polynomial to unbatch
@param destination The matrix to be overwritten with the values in the slots
@throws ASL_SealInvalidParameter if plain is not valid for the encryption parameters
@throws ASL_SealInvalidParameter if plain is in NTT form
*/
- (BOOL)decode:(ASLPlainText *)plainText
   destination:(NSArray<NSNumber *> *)destination
		 error:(NSError **)error;

/*!
Inverse of encode. This function "unbatches" a given plaintext into a matrix
of integers modulo the plaintext modulus, and stores the result in the destination
parameter. The input plaintext must have degress less than the polynomial modulus,
and coefficients less than the plaintext modulus, i.e. it must be a valid plaintext
for the encryption parameters. Dynamic memory allocations in the process are
allocated from the memory pool pointed to by the given MemoryPoolHandle.

@param plainText The plaintext polynomial to unbatch
@param destination The matrix to be overwritten with the values in the slots
@param pool The MemoryPoolHandle pointing to a valid memory pool
@throws ASL_SealInvalidParameter if plain is not valid for the encryption parameters
@throws ASL_SealInvalidParameter if plain is in NTT form
@throws ASL_SealInvalidParameter if pool is uninitialized
*/
- (BOOL)decode:(ASLPlainText *)plainText
   destination:(NSArray<NSNumber *> *)destination
		  pool:(ASLMemoryPoolHandle *)pool
		 error:(NSError **)error;

/*!
Inverse of encode. This function "unbatches" a given plaintext into a matrix
of integers modulo the plaintext modulus, and stores the result in the destination
parameter. The input plaintext must have degress less than the polynomial modulus,
and coefficients less than the plaintext modulus, i.e. it must be a valid plaintext
for the encryption parameters. Dynamic memory allocations in the process are
allocated from the memory pool pointed to by the given MemoryPoolHandle.

@param plainText The plaintext polynomial to unbatch
@param destination The matrix to be overwritten with the values in the slots
@throws ASL_SealInvalidParameter if plain is not valid for the encryption parameters
@throws ASL_SealInvalidParameter if plain is in NTT form
*/
- (BOOL)decodeWithDoubleValues:(ASLPlainText *)plainText
				   destination:(NSArray<NSDecimalNumber *> *)destination
						 error:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
