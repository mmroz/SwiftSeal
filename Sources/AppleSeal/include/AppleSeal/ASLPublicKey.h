//
//  ASLPublicKey.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-11.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLCipherText.h"
#import "ASLParametersIdType.h"
#import "ASLMemoryPoolHandle.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_CLOSED_ENUM(NSInteger, ASLCompressionModeType) {
	CompressionNone = 0,
	CompressionDeflate = 1,
};

/*!
 @class ASLPublicKey
 
 @brief The ASLPublicKey class and wrapper for the seal::PublicKey
 
 @discussion Class to store ASLPublicKey.
 
 Class to store a public key.
 
 Thread Safety
 In general, reading from PublicKey is thread-safe as long as no other thread
 is concurrently mutating it. This is due to the underlying data structure
 storing the public key not being thread-safe.
 
 @see KeyGenerator for the class that generates the public key.
 @see SecretKey for the class that stores the secret key.
 @see RelinKeys for the class that stores the relinearization keys.
 @see GaloisKeys for the class that stores the Galois keys.
 */
@interface ASLPublicKey : NSObject <NSCopying, NSCoding>

- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

/*!
Returns a const reference to the underlying data.
*/
@property (nonatomic, readonly, assign) ASLCipherText*  cipherTextData;

/*!
Returns a reference to parms_id.
*/
@property (nonatomic, readonly, assign) ASLParametersIdType parametersId;

/*!
Returns the currently used MemoryPoolHandle.
*/
@property (nonatomic, readonly, assign) ASLMemoryPoolHandle * pool;

- (long long)saveSize:(ASLCompressionModeType)compressionModeType
			   error:(NSError **)error;

/*!
 Loads a ASLPublicKey from data overwriting the current PublicKey.
 The loaded ASLPublicKey is verified to be valid for the given SEALContext.
 
 @param data The stream to load the ASLPublicKey from
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
