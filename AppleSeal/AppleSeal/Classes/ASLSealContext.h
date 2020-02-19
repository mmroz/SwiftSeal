//
//  ASLSealContext.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AppleSeal/ASLEncryptionParameters.h>
#import <AppleSeal/ASLParametersIdType.h>
#import <AppleSeal/ASLSealContextData.h>

typedef NS_CLOSED_ENUM(NSInteger, ASLSecurityLevel) {
	None = 0,
	TC128,
	TC192,
	TC256,
};

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ASLSealContextErrorDomain;

typedef NS_CLOSED_ENUM(NSInteger, ASLSealContextErrorCode) {
	ASLSealContextErrorCodeUnknown = 0,
	ASLSealContextErrorCodeInvalidParameter,
	ASLSealContextErrorCodeLogicError,
};

@interface ASLSealContext : NSObject

+ (instancetype _Nullable)sealContextWithEncrytionParameters:(ASLEncryptionParameters *)encrytionParameters
											  expandModChain:(BOOL)expandModChain
											   securityLevel:(ASLSecurityLevel)securityLevel
													   error:(NSError **)error;

+ (instancetype _Nullable)sealContextWithEncrytionParameters:(ASLEncryptionParameters *)encrytionParameters
											  securityLevel:(ASLSecurityLevel)securityLevel
													   error:(NSError **)error;

+ (instancetype _Nullable)sealContextWithEncrytionParameters:(ASLEncryptionParameters *)encrytionParameters
											  expandModChain:(BOOL)expandModChain
													   error:(NSError **)error;

+ (instancetype _Nullable)sealContextWithEncrytionParameters:(ASLEncryptionParameters *)encrytionParameters
													   error:(NSError **)error;

@property (nonatomic, assign, readonly) ASLSealContextData* keyContextData;

@property (nonatomic, assign, readonly) ASLSealContextData* firstContextData;

@property (nonatomic, assign, readonly) ASLSealContextData* lastContextData;

@property (nonatomic, assign, readonly) ASLParametersIdType keyParameterIds;

@property (nonatomic, assign, readonly) ASLParametersIdType firstParameterIds;

@property (nonatomic, assign, readonly) ASLParametersIdType lastParameterIds;

@property (nonatomic, readonly, assign, getter=isValidEncrytionParameters) BOOL validEncrytionParameters;

@property (nonatomic, readonly, assign, getter=isAllowedKeySwitching) BOOL allowedKeySwitching;

- (ASLSealContextData *)contextData:(ASLParametersIdType)parametersId
							  error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
