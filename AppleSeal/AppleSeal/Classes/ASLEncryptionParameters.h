//
//  ASLEncryptionParameters.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASLSmallModulus;

NS_ASSUME_NONNULL_BEGIN

typedef NS_CLOSED_ENUM(NSInteger, ASLSchemeType) {
	ASLSchemeTypeNone = 0,
	ASLSchemeTypeBFV,
	ASLSchemeTypeCKKS,
};

extern NSString * const ASLEncryptionParametersErrorDomain;

typedef NS_CLOSED_ENUM(NSInteger, ASLEncryptionParametersErrorCode) {
	ASLEncryptionParametersErrorCodeUnknown = 0,
	ASLEncryptionParametersErrorCodeInvalidArgument,
	ASLEncryptionParametersErrorCodeLogicError,
};

@interface ASLEncryptionParameters : NSObject <NSCopying, NSCoding>

+ (instancetype)encryptionParametersWithSchemeType:(ASLSchemeType)schemeType;
+ (instancetype _Nullable)encryptionParametersWithScheme:(uint8_t)scheme
												   error:(NSError **)error;

@property (nonatomic, assign, readonly) size_t polynomialModulusDegree;
@property (nonatomic, assign, readonly) NSArray<ASLSmallModulus *> *coefficientModulus;
@property (nonatomic, assign, readonly) ASLSmallModulus *plainModulus;
@property (nonatomic, assign, readonly) ASLSchemeType scheme;

- (BOOL)setPolynomialModulusDegree:(size_t)polynomialModulusDegree
							 error:(NSError **)error;
- (BOOL)setCoefficientModulus:(NSArray<ASLSmallModulus *>*)coefficientModulus
					 error:(NSError **)error;
- (BOOL)setPlainModulus:(ASLSmallModulus *)plainModulus
				  error:(NSError **)error;
- (BOOL)setPlainModulusWithInteger:(uint64_t)plainModulus
							 error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
