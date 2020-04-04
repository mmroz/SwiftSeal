//
//  ASLRelinearizationKeys.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLKSwitchKeys.h"
#import "ASLPublicKey.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 @class ASLRelinearizationKeys
 
 @brief The ASLRelinearizationKeys class and wrapper for the  seal::RelinKeys
 
 @discussion Class to store relinearization keys.
 
 Relinearization
 Freshly encrypted ciphertexts have a size of 2, and multiplying ciphertexts
 of sizes K and L results in a ciphertext of size K+L-1. Unfortunately, this
 growth in size slows down further multiplications and increases noise growth.
 Relinearization is an operation that has no semantic meaning, but it reduces
 the size of ciphertexts back to 2. Microsoft SEAL can only relinearize size 3
 ciphertexts back to size 2, so if the ciphertexts grow larger than size 3,
 there is no way to reduce their size. Relinearization requires an instance of
 RelinKeys to be created by the secret key owner and to be shared with the
 evaluator. Note that plain multiplication is fundamentally different from
 normal multiplication and does not result in ciphertext size growth.
 
 When to Relinearize
 Typically, one should always relinearize after each multiplications. However,
 in some cases relinearization should be postponed as late as possible due to
 its computational cost. For example, suppose the computation involves several
 homomorphic multiplications followed by a sum of the results. In this case it
 makes sense to not relinearize each product, but instead add them first and
 only then relinearize the sum. This is particularly important when using the
 CKKS scheme, where relinearization is much more computationally costly than
 multiplications and additions.
 
 Thread Safety
 In general, reading from RelinKeys is thread-safe as long as no other thread
 is concurrently mutating it. This is due to the underlying data structure
 storing the relinearization keys not being thread-safe.
 
 @see SecretKey for the class that stores the secret key.
 @see PublicKey for the class that stores the public key.
 @see GaloisKeys for the class that stores the Galois keys.
 @see KeyGenerator for the class that generates the relinearization keys.
 */
@interface ASLRelinearizationKeys : ASLKSwitchKeys

/*!
 Returns the index of a relinearization key in the backing KSwitchKeys
 instance that corresponds to the given secret key power, assuming that
 it exists in the backing KSwitchKeys.
 
 @param keyPower The power of the secret key
 @throws ASLSealErrorCodeInvalidParameter if key_power is less than 2
 */
-(NSNumber * _Nullable)getIndex:(size_t)keyPower
            error:(NSError **)error;

/*!
 Returns whether a relinearization key corresponding to a given power of
 the secret key exists.
 
 @param key The power of the secret key
 @throws ASLSealErrorCodeInvalidParameter if key_power is less than 2
 */
-(NSNumber * _Nullable)hasKey:(size_t)key
        error:(NSError **)error;

/*!
 Returns a const reference to a relinearization key. The returned
 relinearization key corresponds to the given power of the secret key.
 
 @param keyPower The power of the secret key
 @throws ASLSealErrorCodeInvalidParameter if the key corresponding to key_power does not exist
 */
-(NSArray<ASLPublicKey*>* _Nullable)keyWithKeyPower:(size_t)keyPower
                                    error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
