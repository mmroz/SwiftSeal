//
//  ASLBigUInt.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-28.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASLBigUInt : NSObject <NSCopying>

// TODO - redo this class and compre to the dotnet one

/*!
Creates a BigUInt of the specified bit width and initializes it to the specified unsigned integer value.
 
@param bitCount The bit width
@param value The initial value to set the BigUInt
*/
+ (instancetype _Nullable)bigUIntWithBitCount:(NSInteger)bitCount
								  scalarValue:(uint64_t)value
										error:(NSError **)error;

/*
 @param bitCount The bit width.
 @param values The backing array to use.
 @return A new instance of the receiver initialized with the specified bit count.
 Will return nil if bitCount is negative or Values is null and bitCount is positive.
 */
+ (instancetype _Nullable)bigUIntWithBitCount:(NSInteger)bitCount
								 scalarValues:(uint64_t *_Nullable)values
										error:(NSError **)error;

/*
 @param bitCount The bit width.
 @param hexValue The hexadecimal integer string specifying the initial value.
 @return A new instance of the receiver initialized with the specified bit count.
 Will return nil if hexValue is invalid or the bit count is negative.
 */
+ (instancetype _Nullable)bigUIntWithBitCount:(NSInteger)bitCount
									 hexValue:(NSString *)hexValue
										error:(NSError **)error;

/*
 @param hexValue The hexadecimal integer string specifying the initial value.
 @return A new instance of the receiver initialized with the specified bit count.
 Will return nil if hexValue is invalid.
 */
+ (instancetype _Nullable)bigUIntWithHexValue:(NSString *)hexValue
										error:(NSError **)error;

/*
 @param bitCount The bit width.
 @return A new instance of the receiver initialized with the specified bit count.
 Will return nil if bitCount is either negative or invalid.
 */
+ (instancetype _Nullable)bigUIntWithBitCount:(NSInteger)bitCount error:(NSError **)error;

- (BOOL)isEqualToBigUInt:(ASLBigUInt *)other;

- (NSComparisonResult)compare:(ASLBigUInt *)other;

@property (nonatomic, readonly, assign, getter=isAlias) BOOL alias;

@property (nonatomic, readonly, assign) NSInteger bitCount;

@property (nonatomic, readonly, assign) uint64_t *data;

@property (nonatomic, readonly, assign) size_t byteCount;

@property (nonatomic, readonly, assign) size_t uint64Count;

@property (nonatomic, readonly, assign) NSInteger significantBitCount;

@property (nonatomic, readonly, assign) double doubleValue;

@property (nonatomic, readonly, copy) NSString * stringValue;

@property (nonatomic, readonly, copy) NSString * decimalStringValue;

@property (nonatomic, readonly, assign, getter=isZero) BOOL zero;

- (uint8_t)byteAtIndex:(NSInteger)index;

- (void)setZero;

- (BOOL)resize:(NSInteger)bitCount
		 error:(NSError **)error;

- (BOOL)alias:(NSInteger)bitCount
 scalarValues:(uint64_t *)value
		error:(NSError **)error;

- (BOOL)unalias:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
