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

extern NSString * const ASLSecretKeyErrorDomain;

typedef NS_CLOSED_ENUM(NSInteger, ASLSecretKeyErrorCode) {
	ASLSecretKeyErrorCodeUnknown = 0,
	ASLSecretKeyErrorCodeInvalidParameter,
	ASLSecretKeyErrorCodeLogicError,
	ASLSecretKeyErrorCodeRuntimeError,
};

@interface ASLSecretKey : NSObject <NSCopying, NSCoding>

@property (nonatomic, readonly, assign) ASLPlainText*  plainTextData;

@property (nonatomic, readonly, assign) ASLParametersIdType parametersId;

@property (nonatomic, readonly, assign) ASLMemoryPoolHandle * pool;

@end

NS_ASSUME_NONNULL_END
