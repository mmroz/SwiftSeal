//
//  ASLBatchEncoder.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-10.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLBatchEncoder.h"

#import "ASLSealContext.h"
#import "ASLPlainText.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 @class ASLBatchEncoder
 
 @brief The ASLBatchEncoder class and wrapper for batchencoder.h
 
 @discussion Provides functionality for CRT batching. If the polynomial modulus degree is N, and the plaintext modulus is a prime number T such that T is congruent to 1 modulo 2N,
 then BatchEncoder allows the plaintext elements to be viewed as 2-by-(N/2)
 matrices of integers modulo T. Homomorphic operations performed on such encrypted
 matrices are applied coefficient (slot) wise, enabling powerful SIMD functionality
 for computations that are vectorizable. This functionality is often called "batching"
 in the homomorphic encryption literature.
 
 Mathematical Background
 Mathematically speaking, if the polynomial modulus is X^N+1, N is a power of two, and
 plain_modulus is a prime number T such that 2N divides T-1, then integers modulo T
 contain a primitive 2N-th root of unity and the polynomial X^N+1 splits into n distinct
 linear factors as X^N+1 = (X-a_1)*...*(X-a_N) mod T, where the constants a_1, ..., a_n
 are all the distinct primitive 2N-th roots of unity in integers modulo T. The Chinese
 Remainder Theorem (CRT) states that the plaintext space Z_T[X]/(X^N+1) in this case is
 isomorphic (as an algebra) to the N-fold direct product of fields Z_T. The isomorphism
 is easy to compute explicitly in both directions, which is what this class does.
 Furthermore, the Galois group of the extension is (Z/2NZ)* ~= Z/2Z x Z/(N/2) whose
 action on the primitive roots of unity is easy to describe. Since the batching slots
 correspond 1-to-1 to the primitive roots of unity, applying Galois automorphisms on the
 plaintext act by permuting the slots. By applying generators of the two cyclic
 subgroups of the Galois group, we can effectively view the plaintext as a 2-by-(N/2)
 matrix, and enable cyclic row rotations, and column rotations (row swaps).
 
 Valid Parameters
 Whether batching can be used depends on whether the plaintext modulus has been chosen
 appropriately. Thus, to construct a BatchEncoder the user must provide an instance
 of SEALContext such that its associated EncryptionParameterQualifiers object has the
 flags parameters_set and enable_batching set to true.
 
 @superclass SuperClass: NSObject\n.
 */

@interface ASLBatchEncoder : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (instancetype _Nullable)batchEncoderWithContext:(ASLSealContext *)context
                                            error:(NSError **)error;

/*!
 Returns the number of slots.
 */
@property (nonatomic, readonly, assign) size_t slotCount;

/*!
 Creates a plaintext from a given matrix. This function "batches" a given matrix
 of integers modulo the plaintext modulus into a plaintext element, and stores
 the result in the destination parameter. The input vector must have size at most equal
 to the degree of the polynomial modulus. The first half of the elements represent the
 first row of the matrix, and the second half represent the second row. The numbers
 in the matrix can be at most equal to the plaintext modulus for it to represent
 a valid plaintext.
 
 If the destination plaintext overlaps the input values in memory, the behavior of
 this function is undefined.
 
 @param unsignedValues The matrix of integers modulo plaintext modulus to batch
 @param destination The plaintext polynomial to overwrite with the result
 @throws ASLSealErrorCodeInvalidParameter if values is too large
 */
- (ASLPlainText * _Nullable)encodeWithUnsignedValues:(NSArray<NSNumber *>*)unsignedValues
                     destination:(ASLPlainText *)destination
                           error:(NSError **)error;

/*!
 Creates a plaintext from a given matrix. This function "batches" a given matrix
 of integers modulo the plaintext modulus into a plaintext element, and stores
 the result in the destination parameter. The input vector must have size at most equal
 to the degree of the polynomial modulus. The first half of the elements represent the
 first row of the matrix, and the second half represent the second row. The numbers
 in the matrix can be at most equal to the plaintext modulus for it to represent
 a valid plaintext.
 
 If the destination plaintext overlaps the input values in memory, the behavior of
 this function is undefined.
 
 @param signedValues The matrix of integers modulo plaintext modulus to batch
 @param destination The plaintext polynomial to overwrite with the result
 @throws ASLSealErrorCodeInvalidParameter if values is too large
 */
- (ASLPlainText * _Nullable)encodeWithSignedValues:(NSArray<NSNumber *>*)signedValues
                   destination:(ASLPlainText *)destination
                         error:(NSError **)error;

/*!
 Creates a plaintext from a given matrix. This function "batches" a given matrix
 of integers modulo the plaintext modulus in-place into a plaintext ready to be
 encrypted. The matrix is given as a plaintext element whose first N/2 coefficients
 represent the first row of the matrix, and the second N/2 coefficients represent the
 second row, where N denotes the degree of the polynomial modulus. The input plaintext
 must have degress less than the polynomial modulus, and coefficients less than the
 plaintext modulus, i.e. it must be a valid plaintext for the encryption parameters.
 Dynamic memory allocations in the process are allocated from the memory pool pointed
 to by the given MemoryPoolHandle.
 
 @param plainText The matrix of integers modulo plaintext modulus to batch
 @throws ASLSealErrorCodeInvalidParameter if plain is not valid for the encryption parameters
 @throws ASLSealErrorCodeInvalidParameter if plain is in NTT form
 @throws ASLSealErrorCodeInvalidParameter if pool is uninitialized
 */

- (ASLPlainText * _Nullable)encodeWithPlainText:(ASLPlainText*)plainText
                      error:(NSError **)error;

/*!
 Creates a plaintext from a given matrix. This function "batches" a given matrix
 of integers modulo the plaintext modulus in-place into a plaintext ready to be
 encrypted. The matrix is given as a plaintext element whose first N/2 coefficients
 represent the first row of the matrix, and the second N/2 coefficients represent the
 second row, where N denotes the degree of the polynomial modulus. The input plaintext
 must have degress less than the polynomial modulus, and coefficients less than the
 plaintext modulus, i.e. it must be a valid plaintext for the encryption parameters.
 Dynamic memory allocations in the process are allocated from the memory pool pointed
 to by the given MemoryPoolHandle.
 
 @param plainText The matrix of integers modulo plaintext modulus to batch
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASLSealErrorCodeInvalidParameter if plain is not valid for the encryption parameters
 @throws ASLSealErrorCodeInvalidParameter if plain is in NTT form
 @throws ASLSealErrorCodeInvalidParameter if pool is uninitialized
 */
- (ASLPlainText * _Nullable)encodeWithPlainText:(ASLPlainText*)plainText
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
 @param unsignedDestination The matrix to be overwritten with the values in the slots
 @parampool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASLSealErrorCodeInvalidParameter if plain is not valid for the encryption parameters
 @throws ASLSealErrorCodeInvalidParameter if plain is in NTT form
 @throws ASLSealErrorCodeInvalidParameter if pool is uninitialized
 */
- (NSArray<NSNumber *> * _Nullable)decodeWithPlainText:(ASLPlainText*)plainText
        unsignedDestination:(NSArray<NSNumber *>*)unsignedDestination
                      error:(NSError **)error;

/*!
 Inverse of encode. This function "unbatches" a given plaintext into a matrix
 of integers modulo the plaintext modulus, and stores the result in the destination
 parameter. The input plaintext must have degress less than the polynomial modulus,
 and coefficients less than the plaintext modulus, i.e. it must be a valid plaintext
 for the encryption parameters. Dynamic memory allocations in the process are
 allocated from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param plainText The plaintext polynomial to unbatch
 @param signedDestination The matrix to be overwritten with the values in the slots
 @throws ASLSealErrorCodeInvalidParameter if plain is not valid for the encryption parameters
 @throws ASLSealErrorCodeInvalidParameter if plain is in NTT form
 @throws ASLSealErrorCodeInvalidParameter if pool is uninitialized
 */
- (NSArray<NSNumber *> * _Nullable)decodeWithPlainText:(ASLPlainText*)plainText
          signedDestination:(NSArray<NSNumber *>*)signedDestination
                      error:(NSError **)error;


/*!
 Inverse of encode. This function "unbatches" a given plaintext in-place into
 a matrix of integers modulo the plaintext modulus. The input plaintext must have
 degress less than the polynomial modulus, and coefficients less than the plaintext
 modulus, i.e. it must be a valid plaintext for the encryption parameters. Dynamic
 memory allocations in the process are allocated from the memory pool pointed to by
 the given MemoryPoolHandle.
 
 @param plainText The plaintext polynomial to unbatch
 @throws ASLSealErrorCodeInvalidParameter if plain is not valid for the encryption parameters
 @throws ASLSealErrorCodeInvalidParameter if plain is in NTT form
 @throws ASLSealErrorCodeInvalidParameter if pool is uninitialized
 */
- (ASLPlainText* _Nullable)decodeWithPlainText:(ASLPlainText*)plainText
                      error:(NSError **)error;

/*!
 Inverse of encode. This function "unbatches" a given plaintext in-place into
 a matrix of integers modulo the plaintext modulus. The input plaintext must have
 degress less than the polynomial modulus, and coefficients less than the plaintext
 modulus, i.e. it must be a valid plaintext for the encryption parameters. Dynamic
 memory allocations in the process are allocated from the memory pool pointed to by
 the given MemoryPoolHandle.
 
 @param plainText The plaintext polynomial to unbatch
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASLSealErrorCodeInvalidParameter if plain is not valid for the encryption parameters
 @throws ASLSealErrorCodeInvalidParameter if plain is in NTT form
 @throws ASLSealErrorCodeInvalidParameter if pool is uninitialized
 */
- (ASLPlainText* _Nullable)decodeWithPlainText:(ASLPlainText*)plainText
                       pool:(ASLMemoryPoolHandle *)pool
                      error:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
