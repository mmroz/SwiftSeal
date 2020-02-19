//
//  ASLCipherText.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-01.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLCipherText.h"

#import <AppleSeal/ASLMemoryPoolHandle.h>
#import <AppleSeal/ASLSealContext.h>
#import <AppleSeal/ASLParametersIdType.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ASLCipherTextErrorDomain;

typedef NS_CLOSED_ENUM(NSInteger, ASLCipherTextTextErrorCode) {
	ASLCipherTextErrorCodeUnknown = 0,
	ASLCipherTextErrorCodeInvalidParameter,
	ASLCipherTextErrorCodeLogicError,
	ASLCipherTextErrorCodeOutOfRange,
};

@interface ASLCipherText : NSObject <NSCopying, NSCoding>

+ (instancetype _Nullable)cipherTextWithCipherText:(ASLCipherText *)cipherText
											  pool:(ASLMemoryPoolHandle *)pool
											 error:(NSError **)error;

+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
								   parametersId:(ASLParametersIdType *)parametersId
								   sizeCapacity:(size_t)size_capacity
										   pool:(ASLMemoryPoolHandle *)pool
										  error:(NSError **)error;

+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
								   sizeCapacity:(size_t)size_capacity
								   parametersId:(ASLParametersIdType *)parametersId
										  error:(NSError **)error;

+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
								   parametersId:(ASLParametersIdType *)parametersId
										   pool:(ASLMemoryPoolHandle *)pool
										  error:(NSError **)error;

+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
								   parametersId:(ASLParametersIdType *)parametersId
										  error:(NSError **)error;

+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
										   pool:(ASLMemoryPoolHandle *)pool
										  error:(NSError **)error;

+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
										  error:(NSError **)error;

- (instancetype)initWithPool:(ASLMemoryPoolHandle *)pool;

- (BOOL)isEqualToCipherText:(ASLCipherText *)other;

- (BOOL)reserve:(ASLSealContext *)context
   parametersId:(ASLParametersIdType)parametersId
   sizeCapacity:(size_t)sizeCapacity
		  error:(NSError **)error;

- (BOOL)reserve:(ASLSealContext *)context
   sizeCapacity:(size_t)sizeCapacity
		  error:(NSError **)error;

- (BOOL)reserve:(size_t)sizeCapacity
		  error:(NSError **)error;

- (BOOL)resize:(ASLSealContext *)context
  parametersId:(ASLParametersIdType)parametersId
  sizeCapacity:(size_t)size
		 error:(NSError **)error;

- (BOOL)resize:(ASLSealContext *)context
  sizeCapacity:(size_t)size
		 error:(NSError **)error;

- (BOOL)resize:(size_t)size
		 error:(NSError **)error;

-(void)returnMemoryToPool;

- (uint64_t)polynomialCoefficientAtIndex:(size_t)index
								   error:(NSError **)error;

@property (nonatomic, readonly, assign) size_t coefficientModulusCount;

@property (nonatomic, readonly, assign) size_t polynomialModulusDegree;

@property (nonatomic, readonly, assign) size_t size;

@property (nonatomic, readonly, assign) size_t sizeCapacity;

@property (nonatomic, readonly, assign, getter=isTransparent) BOOL transparent;

@property (nonatomic, readonly, assign, getter=isNntForm) BOOL nntForm;

@property (nonatomic, readonly, assign) ASLParametersIdType parametersId;

@property (nonatomic, readonly, assign) double scale;

@property (nonatomic, readonly, assign) ASLMemoryPoolHandle* pool;


@end

NS_ASSUME_NONNULL_END
