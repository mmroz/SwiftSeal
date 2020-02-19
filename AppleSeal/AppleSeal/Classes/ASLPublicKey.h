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

extern NSString * const ASLPublicKeyErrorDomain;

typedef NS_CLOSED_ENUM(NSInteger, ASLPublicKeyErrorCode) {
	ASLPublicKeyErrorCodeUnknown = 0,
	ASLPublicKeyErrorCodeInvalidParameter,
	ASLPublicKeyErrorCodeLogicError,
	ASLPublicKeyErrorCodeRuntimeError,
};

// TODO - move this into another place

typedef NS_CLOSED_ENUM(NSInteger, ASLCompressionModeType) {
	CompressionNone = 0,
	CompressionDeflate = 1,
};

@interface ASLPublicKey : NSObject <NSCopying, NSCoding>

@property (nonatomic, readonly, assign) ASLCipherText*  cipherTextData;

@property (nonatomic, readonly, assign) ASLParametersIdType parametersId;

@property (nonatomic, readonly, assign) ASLMemoryPoolHandle * pool;

- (long long)saveSize:(ASLCompressionModeType)compressionModeType
			   error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
