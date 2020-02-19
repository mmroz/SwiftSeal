//
//  ASLPlainText.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-01.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AppleSeal/ASLMemoryPoolHandle.h>
#import <AppleSeal/ASLParametersIdType.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ASLPlainTextErrorDomain;

typedef NS_CLOSED_ENUM(NSInteger, ASLPlainTextErrorCode) {
	ASLPlainTextErrorCodeUnknown = 0,
	ASLPlainTextErrorCodeInvalidParameter,
	ASLPlainTextErrorCodeLogicError,
	ASLPlainTextErrorCodeOutOfRange,
};

@interface ASLPlainText : NSObject <NSCopying, NSCoding>

+ (instancetype _Nullable)plainTextWithPolynomialString:(NSString *)polynomialString
												   pool:(ASLMemoryPoolHandle *)pool
												  error:(NSError **)error;

+ (instancetype _Nullable)plainTextWithPolynomialString:(NSString *)polynomialString
												  error:(NSError **)error;

+ (instancetype _Nullable)plainTextWithCapacity:(size_t)capacity
							   coefficientCount:(size_t)coefficientCount
										   pool:(ASLMemoryPoolHandle *)pool
										  error:(NSError **)error;

+ (instancetype _Nullable)plainTextWithCapacity:(size_t)capacity
							   coefficientCount:(size_t)coefficientCount
										  error:(NSError **)error;

+ (instancetype _Nullable)plainTextWithCoefficientCount:(size_t)coefficientCount
												   pool:(ASLMemoryPoolHandle *)pool
												  error:(NSError **)error;

+ (instancetype _Nullable)plainTextWithCoefficientCount:(size_t)coefficientCount
												  error:(NSError **)error;

- (instancetype)initWithPool:(ASLMemoryPoolHandle *)pool;

@property (nonatomic, readonly, assign, getter=isZero) BOOL zero;

@property (nonatomic, readonly, assign) NSInteger capacity;

@property (nonatomic, readonly, assign) NSInteger coefficientCount;

@property (nonatomic, readonly, assign) NSInteger significantCoefficientCount;

@property (nonatomic, readonly, assign) NSInteger nonZeroCoefficientCount;

@property (nonatomic, readonly, assign) ASLParametersIdType parametersId;

@property (nonatomic, readonly, assign) double scale;

@property (nonatomic, readonly, assign) ASLMemoryPoolHandle* pool;

@property (nonatomic, readonly, copy) NSString * stringValue;

- (BOOL)isEqualToPlainText:(ASLPlainText *)other;

- (BOOL)reserve:(size_t)capacity
		  error:(NSError **)error;

-(void)shrinkToFit;

-(void)returnMemoryToPool;

- (BOOL)resize:(size_t)coefficientCount
		 error:(NSError **)error;

- (BOOL)setZero:(size_t)startCoefficient
		length:(size_t)length
		  error:(NSError **)error;

- (BOOL)setZero:(size_t)startCoefficient
		  error:(NSError **)error;

- (void)setZero;

@end

NS_ASSUME_NONNULL_END
