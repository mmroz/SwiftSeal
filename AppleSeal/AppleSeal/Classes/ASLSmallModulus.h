//
//  ASLSmallModulus.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ASLSmallModulusErrorDomain;

typedef NS_CLOSED_ENUM(NSInteger, ASLSmallModulusErrorCode) {
	ASLSmallModulusErrorCodeUnknown = 0,
	ASLSmallModulusErrorCodeInvalidParameter,
};

typedef struct {
	unsigned long floor;
	unsigned long value;
	unsigned long remainder;
} ASLSmallModulusConstRatio;

@interface ASLSmallModulus : NSObject <NSCopying, NSCoding>

+ (instancetype _Nullable)smallModulusWithValue:(uint64_t)value
										  error:(NSError **)error;

- (BOOL)isEqualToSmallModulus:(ASLSmallModulus *)other;

- (NSComparisonResult)compare:(ASLSmallModulus *)other;

- (ASLSmallModulusConstRatio)constRatio;

@property (nonatomic, readonly, assign) NSInteger bitCount;

@property (nonatomic, readonly, assign) size_t uint64Count;

@property (nonatomic, readonly, assign) uint64_t const *data;

@property (nonatomic, readonly, assign) uint64_t uint64Value;

@property (nonatomic, readonly, assign, getter=isZero) BOOL zero;

@property (nonatomic, readonly, assign, getter=isPrime) BOOL prime;

@end

NS_ASSUME_NONNULL_END
