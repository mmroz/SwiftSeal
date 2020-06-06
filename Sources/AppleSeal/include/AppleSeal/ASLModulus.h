//
//  ASLModulus.h
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
} ASLModulusConstRatio;

@interface ASLModulus : NSObject <NSCopying, NSCoding>

/*!
 Creates a Modulus instance. The value of the Modulus is set to
 the given value, or to zero by default.
 
 @param value The integer modulus
 @throws ASLSealErrorCodeInvalidParameter if value is 1 or more than 62 bits
 */
+ (instancetype _Nullable)modulusWithValue:(uint64_t)value
                                          error:(NSError **)error;

- (BOOL)isEqualToModulus:(ASLModulus *)other;

- (NSComparisonResult)compare:(ASLModulus *)other;

/*!
 Returns the Barrett ratio computed for the value of the current Modulus.
 The first two components of the Barrett ratio are the floor of 2^128/value,
 and the third component is the remainder.
 */

- (ASLModulusConstRatio)constRatio;

/*!
 Returns the significant bit count of the value of the current Modulus.
 */
@property (nonatomic, readonly, assign) NSInteger bitCount;

/*!
 Returns the size (in 64-bit words) of the value of the current Modulus.
 */
@property (nonatomic, readonly, assign) size_t uint64Count;

/*!
 Returns a const pointer to the value of the current Modulus.
 */
@property (nonatomic, readonly, assign) uint64_t const *data;

/*!
 Returns the value of the current Modulus.
 */
@property (nonatomic, readonly, assign) uint64_t uint64Value;

/*!
 Returns whether the value of the current Modulus is zero.
 */
@property (nonatomic, readonly, assign, getter=isZero) BOOL zero;

/*!
 Returns whether the value of the current Modulus is a prime number.
 */
@property (nonatomic, readonly, assign, getter=isPrime) BOOL prime;

- (void)setUInt64Value:(uint64_t)value;

@end

NS_ASSUME_NONNULL_END
