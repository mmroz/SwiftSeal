//
//  ASLSmallModulus.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    unsigned long floor;
    unsigned long value;
    unsigned long remainder;
} ASLSmallModulusConstRatio;

@interface ASLSmallModulus : NSObject <NSCopying, NSCoding>

/*!
 Creates a SmallModulus instance. The value of the SmallModulus is set to
 the given value, or to zero by default.
 
 @param value The integer modulus
 @throws ASLSealErrorCodeInvalidParameter if value is 1 or more than 62 bits
 */
+ (instancetype _Nullable)smallModulusWithValue:(uint64_t)value
                                          error:(NSError **)error;

- (BOOL)isEqualToSmallModulus:(ASLSmallModulus *)other;

- (NSComparisonResult)compare:(ASLSmallModulus *)other;

/*!
 Returns the Barrett ratio computed for the value of the current SmallModulus.
 The first two components of the Barrett ratio are the floor of 2^128/value,
 and the third component is the remainder.
 */

- (ASLSmallModulusConstRatio)constRatio;

/*!
 Returns the significant bit count of the value of the current SmallModulus.
 */
@property (nonatomic, readonly, assign) NSInteger bitCount;

/*!
 Returns the size (in 64-bit words) of the value of the current SmallModulus.
 */
@property (nonatomic, readonly, assign) size_t uint64Count;

/*!
 Returns a const pointer to the value of the current SmallModulus.
 */
@property (nonatomic, readonly, assign) uint64_t const *data;

/*!
 Returns the value of the current SmallModulus.
 */
@property (nonatomic, readonly, assign) uint64_t uint64Value;

/*!
 Returns whether the value of the current SmallModulus is zero.
 */
@property (nonatomic, readonly, assign, getter=isZero) BOOL zero;

/*!
 Returns whether the value of the current SmallModulus is a prime number.
 */
@property (nonatomic, readonly, assign, getter=isPrime) BOOL prime;

- (void)setUInt64Value:(uint64_t)value;

@end

NS_ASSUME_NONNULL_END
