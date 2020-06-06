//
//  ASLKeyGenerator.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLPublicKey.h"
#import "ASLSecretKey.h"
#import "ASLGaloisKeys.h"
#import "ASLRelinearizationKeys.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 @class ASLKeyGenerator
 
 @brief The ASLKeyGenerator class and wrapper for the  keygenerator.h
 
 @discussion Class to store KeyGenerator.
 
 Generates matching secret key and public key. An existing KeyGenerator can
 also at any time be used to generate relinearization keys and Galois keys.
 Constructing a KeyGenerator requires only a SEALContext.
 */

@interface ASLKeyGenerator : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/*!
 Creates a KeyGenerator initialized with the specified SEALContext.
 
 @param context The SEALContext
 @throws ASL_SealInvalidParameter if the context is not set or encryption
 parameters are not valid
 */
+ (instancetype _Nullable)keyGeneratorWithContext:(ASLSealContext *)context
                                            error:(NSError **)error;

/*!
 Creates an KeyGenerator instance initialized with the specified SEALContext
 and specified previously secret key. This can e.g. be used to increase
 the number of relinearization keys from what had earlier been generated,
 or to generate Galois keys in case they had not been generated earlier.
 
 
 @param context The SEALContext
 @param secretKey A previously generated secret key
 @throws ASL_SealInvalidParameter if encryption parameters are not valid
 @throws ASL_SealInvalidParameter if secret_key or public_key is not valid
 for encryption parameters
 */
+ (instancetype _Nullable)keyGeneratorWithContext:(ASLSealContext *)context
                                        secretKey:(ASLSecretKey *)secretKey
                                            error:(NSError **)error;

/*!
 Returns a const reference to the public key.
 */
@property (nonatomic, readonly, assign) ASLPublicKey* publicKey;

/*!
 Returns a const reference to the secret  key.
 */
@property (nonatomic, readonly, assign) ASLSecretKey* secretKey;


/*!
 Generates and returns relinearization keys. This function returns
 relinearization keys in a fully expanded form and is meant to be used
 primarily for demo, testing, and debugging purposes.
 
 @throws ASLLogicError if the encryption parameters do not support
 keyswitching
 */
- (ASLRelinearizationKeys * _Nullable)relinearizationKeysLocal:(NSError **)error;

/*!
 Generates and returns relinearization keys as a serializable object.
 
 Half of the key data is pseudo-randomly generated from a seed to reduce
 the object size. The resulting serializable object cannot be used
 directly and is meant to be serialized for the size reduction to have an
 impact.
 
 @throws ASLLogicError if the encryption parameters do not support
 keyswitching
 */
- (ASLSerializableGaloisKeys* _Nullable)relinearizationKeys:(NSError **)error;

/*!
 Generates and returns Galois keys. This function returns Galois keys in
 a fully expanded form and is meant to be used primarily for demo, testing,
 and debugging purposes. This function creates specific Galois keys that
 can be used to apply specific Galois automorphisms on encrypted data. The
 user needs to give as input a vector of Galois elements corresponding to
 the keys that are to be created.
 
 The Galois elements are odd integers in the interval [1, M-1], where
 M = 2*N, and N = poly_modulus_degree. Used with batching, a Galois element
 3^i % M corresponds to a cyclic row rotation i steps to the left, and
 a Galois element 3^(N/2-i) % M corresponds to a cyclic row rotation i
 steps to the right. The Galois element M-1 corresponds to a column rotation
 (row swap) in BFV, and complex conjugation in CKKS. In the polynomial view
 (not batching), a Galois automorphism by a Galois element p changes
 Enc(plain(x)) to Enc(plain(x^p)).
 
 @param galoisElements The Galois elements for which to generate keys
 @throws ASLLogicError if the encryption parameters do not support
 batching and scheme is scheme_type::BFV
 @throws ASLLogicError if the encryption parameters do not support
 keyswitching
 @throws ASLInvalidParameter if the Galois elements are not valid
 */

- (ASLGaloisKeys * _Nullable)galoisKeysLocalWithGaloisElements:(NSArray<NSNumber *>*)galoisElements
                                                         error:(NSError **)error;

/*!
 Generates and returns Galois keys as a serializable object. This function
 creates specific Galois keys that can be used to apply specific Galois
 automorphisms on encrypted data. The user needs to give as input a vector
 of Galois elements corresponding to the keys that are to be created.
 
 The Galois elements are odd integers in the interval [1, M-1], where
 M = 2*N, and N = poly_modulus_degree. Used with batching, a Galois element
 3^i % M corresponds to a cyclic row rotation i steps to the left, and
 a Galois element 3^(N/2-i) % M corresponds to a cyclic row rotation i
 steps to the right. The Galois element M-1 corresponds to a column rotation
 (row swap) in BFV, and complex conjugation in CKKS. In the polynomial view
 (not batching), a Galois automorphism by a Galois element p changes
 Enc(plain(x)) to Enc(plain(x^p)).
 
 Half of the key data is pseudo-randomly generated from a seed to reduce
 the object size. The resulting serializable object cannot be used
 directly and is meant to be serialized for the size reduction to have an
 impact.
 
 @param galoisElements The Galois elements for which to generate keys
 @throws ASLLogicError if the encryption parameters do not support
 batching and scheme is scheme_type::BFV
 @throws ASLLogicError if the encryption parameters do not support
 keyswitching
 @throws ASLInvalidParameter if the Galois elements are not valid
 */
- (ASLSerializableGaloisKeys * _Nullable)galoisKeysWithGaloisElements:(NSArray<NSNumber *>*)galoisElements
                                                                error:(NSError **)error;

/*!
 Generates and returns Galois keys. This function returns Galois keys in
 a fully expanded form and is meant to be used primarily for demo, testing,
 and debugging purposes. The user needs to give as input a vector of desired
 Galois rotation step counts, where negative step counts correspond to
 rotations to the right and positive step counts correspond to rotations toO
 the left. A step count of zero can be used to indicate a column rotation
 in the BFV scheme complex conjugation in the CKKS scheme.
 
 @param steps The rotation step counts for which to generate keys
 @throws ASLLogicError if the encryption parameters do not support
 batching and scheme is scheme_type::BFV
 @throws ASLLogicError if the encryption parameters do not support
 keyswitching
 @throws ASLInvalidParameter if the step counts are not valid
 */
- (ASLGaloisKeys * _Nullable) galoisKeysLocalWithSteps:(NSArray<NSNumber *>*)steps
                                                 error:(NSError **)error;

/*!
 Generates and returns Galois keys as a serializable object. This function
 creates specific Galois keys that can be used to apply specific Galois
 automorphisms on encrypted data. The user needs to give as input a vector
 of desired Galois rotation step counts, where negative step counts
 correspond to rotations to the right and positive step counts correspond
 to rotations to the left. A step count of zero can be used to indicate
 a column rotation in the BFV scheme complex conjugation in the CKKS scheme.
 
 Half of the key data is pseudo-randomly generated from a seed to reduce
 the object size. The resulting serializable object cannot be used
 directly and is meant to be serialized for the size reduction to have an
 impact.
 
 @param steps The rotation step counts for which to generate keys
 @throws ASLLogicError if the encryption parameters do not support
 batching and scheme is scheme_type::BFV
 @throws ASLLogicError if the encryption parameters do not support
 keyswitching
 @throws ASLInvalidParameter if the step counts are not valid
 */

- (ASLSerializableGaloisKeys * _Nullable) galoisKeysWithSteps:(NSArray<NSNumber *>*)steps
                                                        error:(NSError **)error;

/*!
 Generates and returns Galois keys as a serializable object. This function
 creates logarithmically many (in degree of the polynomial modulus) Galois
 keys that is sufficient to apply any Galois automorphism (e.g. rotations)
 on encrypted data. Most users will want to use this overload of the function.
 
 Half of the key data is pseudo-randomly generated from a seed to reduce
 the object size. The resulting serializable object cannot be used
 directly and is meant to be serialized for the size reduction to have an
 impact.
 
 @throws ASLLogicError if the encryption parameters do not support
 batching and scheme is scheme_type::BFV
 @throws ASLLogicError if the encryption parameters do not support
 keyswitching
 */

- (ASLSerializableGaloisKeys * _Nullable)galoisKeys:(NSError **)error;

/*!
 Generates and returns Galois keys. This function returns Galois keys in
 a fully expanded form and is meant to be used primarily for demo, testing,
 and debugging purposes. This function creates logarithmically many (in
 degree of the polynomial modulus) Galois keys that is sufficient to apply
 any Galois automorphism (e.g. rotations) on encrypted data. Most users
 will want to use this overload of the function.
 
 @throws ASLLogicError if the encryption parameters do not support
 batching and scheme is scheme_type::BFV
 @throws ASLLogicError if the encryption parameters do not support
 keyswitching
 */

- (ASLGaloisKeys * _Nullable)galoisKeysLocal:(NSError **)error;



@end

NS_ASSUME_NONNULL_END
