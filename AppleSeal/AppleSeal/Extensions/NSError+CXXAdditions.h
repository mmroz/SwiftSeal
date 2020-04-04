//
//  NSError+NSError_CXXAdditions.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-19.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <exception>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ASLSealErrorErrorDomain;

typedef NS_CLOSED_ENUM(NSInteger, ASLSealErrorErrorCode) {
	ASLSealErrorCodeUnknown = 0,
	ASLSealErrorCodeInvalidParameter,
	ASLSealErrorCodeLogicError,
    ASLSealErrorCodeRuntimeError,
};

@interface NSError (NSError_CXXAdditions)

+ (instancetype)ASL_SealInvalidParameter:(std::exception const &)exception;

+ (instancetype)ASL_SealLogicError:(std::exception const &)exception;

+ (instancetype)ASL_SealRuntimeError:(const std::exception &)exception;

@end

NS_ASSUME_NONNULL_END
