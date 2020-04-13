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

@end

NS_ASSUME_NONNULL_END
