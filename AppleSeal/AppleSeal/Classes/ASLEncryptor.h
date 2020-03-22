//
//  ASLEncryptor.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-11.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLSealContext.h"
#import "ASLPublicKey.h"
#import "ASLSecretKey.h"
#import "ASLParametersIdType.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 @class ASLEncryptor
 
 @brief The ASLEncryptor class and wrapper for the encryptor.h
 
 @discussion Encrypts Plaintext objects into Ciphertext objects. Constructing an Encryptor
 requires a SEALContext with valid encryption parameters, the public key and/or
 the secret key. If an Encrytor is given a secret key, it supports symmetric-key
 encryption. If an Encryptor is given a public key, it supports asymmetric-key
 encryption.
 
 Overloads
 For the encrypt function we provide two overloads concerning the memory pool
 used in allocations needed during the operation. In one overload the global
 memory pool is used for this purpose, and in another overload the user can
 supply a MemoryPoolHandle to to be used instead. This is to allow one single
 Encryptor to be used concurrently by several threads without running into thread
 contention in allocations taking place during operations. For example, one can
 share one single Encryptor across any number of threads, but in each thread
 call the encrypt function by giving it a thread-local MemoryPoolHandle to use.
 It is important for a developer to understand how this works to avoid unnecessary
 performance bottlenecks.
 
 NTT form
 When using the BFV scheme (scheme_type::BFV), all plaintext and ciphertexts should
 remain by default in the usual coefficient representation, i.e. not in NTT form.
 When using the CKKS scheme (scheme_type::CKKS), all plaintexts and ciphertexts
 should remain by default in NTT form. We call these scheme-specific NTT states
 the "default NTT form". Decryption requires the input ciphertexts to be in
 the default NTT form, and will throw an exception if this is not the case.
 */

@interface ASLEncryptor : NSObject <NSCoding>

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/*!
 Creates an Encryptor instance initialized with the specified SEALContext
 and public key.
 
 @param context The SEALContext
 @param publicKey The public key
 @throws ASL_SealInvalidParameter if the context is not set or encryption
 parameters are not valid
 @throws ASL_SealInvalidParameter if public_key is not valid
 */

+ (instancetype _Nullable)encryptorWithContext:(ASLSealContext *)context
                                     publicKey:(ASLPublicKey *)publicKey
                                         error:(NSError **)error;

/*!
 Creates an Encryptor instance initialized with the specified SEALContext
 and secret key.
 
 @param context The SEALContext
 @param secretKey The secret key
 @throws ASL_SealInvalidParameter if the context is not set or encryption
 parameters are not valid
 @throws ASL_SealInvalidParameter if secret_key is not valid
 */
+ (instancetype _Nullable)encryptorWithContext:(ASLSealContext *)context
                                     secretKey:(ASLSecretKey *)secretKey
                                         error:(NSError **)error;

/*!
 Creates an Encryptor instance initialized with the specified SEALContext,
 secret key, and public key.
 
 @param context The SEALContext
 @param publicKey The public key
 @param secretKey The secret key
 @throws ASL_SealInvalidParameter if the context is not set or encryption
 parameters are not valid
 @throws ASL_SealInvalidParameter if public_key or secret_key is not valid
 */
+ (instancetype _Nullable)encryptorWithContext:(ASLSealContext *)context
                                     publicKey:(ASLPublicKey *)publicKey
                                     secretKey:(ASLSecretKey *)secretKey
                                         error:(NSError **)error;

/*!
 Encrypts a plaintext with the public key and stores the result in
 destination. The encryption parameters for the resulting ciphertext
 correspond to:
 1) in BFV, the highest (data) level in the modulus switching chain,
 2) in CKKS, the encryption parameters of the plaintext.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle.
 
 @param plainText The plaintext to encrypt
 @param cipherText The ciphertext to overwrite with the encrypted
 plaintext
 @throws ASL_SealLogicError if a public key is not set
 @throws ASL_SealInvalidParameter if plain is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if plain is not in default NTT form
 */
- (BOOL)encryptWithPlainText:(ASLPlainText *)plainText
                  cipherText:(ASLCipherText *)cipherText
                       error:(NSError **)error;

/*!
 Encrypts a plaintext with the public key and stores the result in
 destination. The encryption parameters for the resulting ciphertext
 correspond to:
 1) in BFV, the highest (data) level in the modulus switching chain,
 2) in CKKS, the encryption parameters of the plaintext.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle.
 
 @param plainText The plaintext to encrypt
 @param cipherText The ciphertext to overwrite with the encrypted
 plaintext
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealLogicError if a public key is not set
 @throws ASL_SealInvalidParameter if plain is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if plain is not in default NTT form
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
- (BOOL)encryptWithPlainText:(ASLPlainText *)plainText
                  cipherText:(ASLCipherText *)cipherText
                        pool:(ASLMemoryPoolHandle *)pool
                       error:(NSError **)error;

/*!
 Encrypts a zero plaintext with the public key and stores the result in
 destination. The encryption parameters for the resulting ciphertext
 correspond to the highest (data) level in the modulus switching chain.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle.
 
 @param cipherText The ciphertext to overwrite with the encrypted
 plaintext
 @throws ASL_SealLogicError if a public key is not set
 */
-(BOOL)encryptZeroWithCipherText:(ASLCipherText *)cipherText
                           error:(NSError **)error;

/*!
 Encrypts a zero plaintext with the public key and stores the result in
 destination. The encryption parameters for the resulting ciphertext
 correspond to the highest (data) level in the modulus switching chain.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle.
 
 @param cipherText The ciphertext to overwrite with the encrypted
 plaintext
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealLogicError if a public key is not set
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
-(BOOL)encryptZeroWithCipherText:(ASLCipherText *)cipherText
                            pool:(ASLMemoryPoolHandle *)pool
                           error:(NSError **)error;

/*!
 Encrypts a zero plaintext with the public key and stores the result in
 destination. The encryption parameters for the resulting ciphertext
 correspond to the given parms_id. Dynamic memory allocations in the process
 are allocated from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param parametersId The parms_id for the resulting ciphertext
 @param cipherText The ciphertext to overwrite with the encrypted
 plaintext
 @throws ASL_SealLogicError if a public key is not set
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
 parameters
 */
-(BOOL)encryptZeroWithParametersId:(ASLParametersIdType)parametersId
                        cipherText:(ASLCipherText *)cipherText
                             error:(NSError **)error;

/*!
 Encrypts a zero plaintext with the public key and stores the result in
 destination. The encryption parameters for the resulting ciphertext
 correspond to the given parms_id. Dynamic memory allocations in the process
 are allocated from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param parametersId The parms_id for the resulting ciphertext
 @param cipherText The ciphertext to overwrite with the encrypted
 plaintext
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealLogicError if a public key is not set
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
-(BOOL)encryptZeroWithParametersId:(ASLParametersIdType)parametersId
                        cipherText:(ASLCipherText *)cipherText
                              pool:(ASLMemoryPoolHandle *)pool
                             error:(NSError **)error;

/*!
 Encrypts a plaintext with the secret key and stores the result in
 destination. The encryption parameters for the resulting ciphertext
 correspond to:
 1) in BFV, the highest (data) level in the modulus switching chain,
 2) in CKKS, the encryption parameters of the plaintext.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle.
 
 @param plainText The plaintext to encrypt
 @param cipherText The ciphertext to overwrite with the encrypted
 plaintext
 @throws ASL_SealLogicError if a secret key is not set
 @throws ASL_SealInvalidParameter if plain is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if plain is not in default NTT form
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
-(BOOL)encryptSymmetricWithPlainText:(ASLPlainText *)plainText
                              cipherText:(ASLCipherText *)cipherText
                                   error:(NSError **)error;

/*!
 Encrypts a plaintext with the secret key and stores the result in
 destination. The encryption parameters for the resulting ciphertext
 correspond to:
 1) in BFV, the highest (data) level in the modulus switching chain,
 2) in CKKS, the encryption parameters of the plaintext.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle.
 
 @param plainText The plaintext to encrypt
 @param cipherText The ciphertext to overwrite with the encrypted
 plaintext
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealLogicError if a secret key is not set
 @throws ASL_SealInvalidParameter if plain is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if plain is not in default NTT form
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
-(BOOL)encryptSymmetricWithPlainText:(ASLPlainText *)plainText
                              cipherText:(ASLCipherText *)cipherText
                                    pool:(ASLMemoryPoolHandle *)pool
                                   error:(NSError **)error;

/*!
 Encrypts a zero plaintext with the secret key and stores the result in
 destination. The encryption parameters for the resulting ciphertext
 correspond to the highest (data) level in the modulus switching chain.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle.
 
 @param cipherText The ciphertext to overwrite with the encrypted
 plaintext
 @throws ASL_SealLogicError if a secret key is not set
 */
-(BOOL)encryptZeroSymmetricWithCipherText:(ASLCipherText *)cipherText
                                     error:(NSError **)error;

/*!
 Encrypts a zero plaintext with the secret key and stores the result in
 destination. The encryption parameters for the resulting ciphertext
 correspond to the highest (data) level in the modulus switching chain.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle.
 
 @param cipherText The ciphertext to overwrite with the encrypted
 plaintext
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealLogicError if a secret key is not set
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
-(BOOL)encryptZeroSymmetricWithCipherText:(ASLCipherText *)cipherText
                                      pool:(ASLMemoryPoolHandle *)pool
                                     error:(NSError **)error;

/*!
 Encrypts a zero plaintext with the secret key and stores the result in
 destination. The encryption parameters for the resulting ciphertext
 correspond to the given parms_id. Dynamic memory allocations in the process
 are allocated from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param parametersId The parms_id for the resulting ciphertext
 @param destination The ciphertext to overwrite with the encrypted
 plaintext
 @throws ASL_SealLogicError if a secret key is not set
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
-(BOOL)encryptZeroSymmetricWithParametersId:(ASLParametersIdType)parametersId
                                destination:(ASLCipherText *)destination
                                      error:(NSError **)error;

/*!
 Encrypts a zero plaintext with the secret key and stores the result in
 destination. The encryption parameters for the resulting ciphertext
 correspond to the given parms_id. Dynamic memory allocations in the process
 are allocated from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param parametersId The parms_id for the resulting ciphertext
 @param destination The ciphertext to overwrite with the encrypted
 plaintext
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealLogicError if a secret key is not set
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
-(BOOL)encryptZeroSymmetricWithParametersId:(ASLParametersIdType)parametersId
                                destination:(ASLCipherText *)destination
                                       pool:(ASLMemoryPoolHandle *)pool
                                      error:(NSError **)error;

/*!
 Give a new instance of public key.
 
 @param publicKey The public key
 @throws ASL_SealInvalidParameter if publicKey is not valid
 */
- (BOOL)setPublicKey:(ASLPublicKey *)publicKey
               error:(NSError **)error;

/*!
 Give a new instance of secret key.
 
 @param secretKey The secret key
 @throws ASL_SealInvalidParameter if secretKey is not valid
 */
- (BOOL)setSecretKey:(ASLSecretKey *)secretKey
               error:(NSError **)error;

// TODO - fix this
-(BOOL)save;

// TODO - fix this
-(BOOL)load;

@end

NS_ASSUME_NONNULL_END
