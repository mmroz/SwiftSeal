//
//  ASLDecryptor.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-11.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLSealContext.h"
#import "ASLSecretKey.h"
#import "ASLCipherText.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 @class ASLDecryptor
 
 @brief The ASLDecryptor class and wrapper for the Decryptor.
 
 @discussion Decrypts Ciphertext objects into Plaintext objects. Constructing a Decryptor
 requires a SEALContext with valid encryption parameters, and the secret key.
 The Decryptor is also used to compute the invariant noise budget in a given
 ciphertext.
 
 Overloads
 For the decrypt function we provide two overloads concerning the memory pool
 used in allocations needed during the operation. In one overload the global
 memory pool is used for this purpose, and in another overload the user can
 supply a MemoryPoolHandle to be used instead. This is to allow one single
 Decryptor to be used concurrently by several threads without running into
 thread contention in allocations taking place during operations. For example,
 one can share one single Decryptor across any number of threads, but in each
 thread call the decrypt function by giving it a thread-local MemoryPoolHandle
 to use. It is important for a developer to understand how this works to avoid
 unnecessary performance bottlenecks.
 
 NTT form
 When using the BFV scheme (scheme_type::BFV), all plaintext and ciphertexts
 should remain by default in the usual coefficient representation, i.e. not in
 NTT form. When using the CKKS scheme (scheme_type::CKKS), all plaintexts and
 ciphertexts should remain by default in NTT form. We call these scheme-specific
 NTT states the "default NTT form". Decryption requires the input ciphertexts
 to be in the default NTT form, and will throw an exception if this is not the
 case.
 */

@interface ASLDecryptor : NSObject

/*!
 Creates a Decryptor instance initialized with the specified SEALContext
 and secret key.
 
 @param context The SEALContext
 @param secretKey The secret key
 @throws ASL_SealInvalidParameter if the context is not set or encryption
 parameters are not valid
 @throws ASL_SealInvalidParameter if secret_key is not valid
 */
+ (instancetype _Nullable)decryptorWithContext:(ASLSealContext *)context
                                     secretKey:(ASLSecretKey *)secretKey
                                         error:(NSError **)error;
/*!
 Decrypts a Ciphertext and stores the result in the destination parameter.
 
 @param encrypted The ciphertext to decrypt
 ciphertext
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 */
- (ASLPlainText * _Nullable)decrypt:(ASLCipherText *)encrypted
                              error:(NSError **)error;

/*!
 Computes the invariant noise budget (in bits) of a ciphertext. The
 invariant noise budget measures the amount of room there is for the noise
 to grow while ensuring correct decryptions. This function works only with
 the BFV scheme.
 
 Invariant Noise Budget
 The invariant noise polynomial of a ciphertext is a rational coefficient
 polynomial, such that a ciphertext decrypts correctly as long as the
 coefficients of the invariantnoise polynomial are of absolute value less
 than 1/2. Thus, we call the infinity-norm of the invariant noise polynomial
 the invariant noise, and for correct decryption requireit to be less than
 1/2. If v denotes the invariant noise, we define the invariant noise budget
 as -log2(2v). Thus, the invariant noise budget starts from some initial
 value, which depends on the encryption parameters, and decreases when
 computations are performed. When the budget reaches zero, the ciphertext
 becomes too noisy to decrypt correctly.
 
 @param cipherText The ciphertext
 @throws ASL_SealInvalidParameter if the scheme is not BFV
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if encrypted is in NTT form
 */
- (NSNumber * _Nullable)invariantNoiseBudget:(ASLCipherText *)cipherText
                                       error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
