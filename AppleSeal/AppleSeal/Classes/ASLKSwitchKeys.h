//
//  ASLKSwitchKeys.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-12.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLPublicKey.h"
#import "ASLParametersIdType.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 @class ASLKSwitchKeys
 
 @brief The ASLKSwitchKeys class and wrapper for the  seal::KeyGenerator
 
 @discussion Class to store seal::KeyGenerator.
 
 Class to store keyswitching keys. It should never be necessary for normal
 users to create an instance of KSwitchKeys. This class is used strictly as
 a base class for RelinKeys and GaloisKeys classes.
 
 Keyswitching
 Concretely, keyswitching is used to change a ciphertext encrypted with one
 key to be encrypted with another key. It is a general technique and is used
 in relinearization and Galois rotations. A keyswitching key contains a sequence
 (vector) of keys. In RelinKeys, each key is an encryption of a power of the
 secret key. In GaloisKeys, each key corresponds to a type of rotation.
 
 Thread Safety
 In general, reading from KSwitchKeys is thread-safe as long as no
 other thread is concurrently mutating it. This is due to the underlying
 data structure storing the keyswitching keys not being thread-safe.
 
 @see RelinKeys for the class that stores the relinearization keys.
 @see GaloisKeys for the class that stores the Galois keys.
 */
@interface ASLKSwitchKeys : NSObject <NSCopying, NSCoding>

/*!
 Returns the current number of keyswitching keys. Only keys that are
 non-empty are counted.
 */
@property (nonatomic, readonly, assign) size_t size;

/*!
Returns a reference to the KSwitchKeys data.
*/
@property (nonatomic, readonly, assign) NSArray<NSArray<ASLPublicKey*>*>* data;

/*!
Returns a reference to ASLParametersIdType.
*/
@property (nonatomic, readonly, assign) ASLParametersIdType parametersId;

/*!
Returns the currently used MemoryPoolHandle.
*/
@property (nonatomic, readonly, assign) ASLMemoryPoolHandle * pool;

/*!
 Loads a ASLKSwitchKeys from data overwriting the current ASLKSwitchKeys.
 The loaded ASLKSwitchKeys is verified to be valid for the given SEALContext.
 
 @param data The stream to load the ASLKSwitchKeys from
 @param context The SEALContext
 @throws ASL_InvalidArgument if the context is not set or encryption
 parameters are not valid
 @throws ASLogicError if the loaded data is invalid or if decompression
 failed
 @throws ASL_RuntimeError if I/O operations failed
 */

- (instancetype _Nullable)initWithData:(NSData *)data
                               context:(ASLSealContext *)context
                                 error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
