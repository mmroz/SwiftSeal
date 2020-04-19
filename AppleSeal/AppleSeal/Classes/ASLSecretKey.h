//
//  ASLSecretKey.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-11.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLSealContext.h"
#import "ASLMemoryPoolHandle.h"
#import "ASLParametersIdType.h"
#import "ASLPlainText.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLSecretKey : NSObject <NSCopying, NSCoding>

- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

/*!
 Returns a reference to the underlying polynomial.
 */
@property (nonatomic, readonly, assign) ASLPlainText*  plainTextData;

/*!
 Returns a const reference to parametersId.
 
 @see EncryptionParameters for more information about parametersId.
 */
@property (nonatomic, readonly, assign) ASLParametersIdType parametersId;

/*!
 Returns the currently used MemoryPoolHandle.
 */
@property (nonatomic, readonly, assign) ASLMemoryPoolHandle * pool;

/*!
 Loads a SecretKey from dat overwriting the current SecretKey.
 The loaded SecretKey is verified to be valid for the given SEALContext.
 
 @param data The stream to load the SecretKey from
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
