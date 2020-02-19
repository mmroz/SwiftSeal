//
//  ASLBigUInt.m
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-28.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLBigUInt.h"

#include <string>
#include <stdexcept>
#include "seal/biguint.h"

#import "NSString+CXXAdditions.h"
#import "NSError+CXXAdditions.h"

@implementation ASLBigUInt {
	seal::BigUInt _bigUInt;
}

#pragma mark - Initialization

+ (instancetype _Nullable)bigUIntWithBitCount:(NSInteger)bitCount
								  scalarValue:(uint64_t)value
										error:(NSError **)error {
	try {
		seal::BigUInt const bigUInt = seal::BigUInt(static_cast<int>(bitCount), value);
		return [[ASLBigUInt alloc] initWithBigUInt:bigUInt];
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			*error = [NSError ASL_SealInvalidParameter:e];
		}
		return nil;
	}
}

+ (instancetype)bigUIntWithBitCount:(NSInteger)bitCount
					   scalarValues:(uint64_t *)values
							  error:(NSError **)error {
	try {
		seal::BigUInt const bigUInt = seal::BigUInt(static_cast<int>(bitCount), values);
		return [[ASLBigUInt alloc] initWithBigUInt:bigUInt];
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			*error = [NSError ASL_SealInvalidParameter:e];
		}
		return nil;
	}
}

+ (instancetype)bigUIntWithBitCount:(NSInteger)bitCount
						   hexValue:(NSString *)hexValue
							  error:(NSError **)error {
	NSParameterAssert(hexValue != nil);
	
	std::string const hexValueString = (hexValue.length > 0
										? hexValue.stdString
										: "");
	try {
		seal::BigUInt const bigUInt = seal::BigUInt(static_cast<int>(bitCount), hexValueString);
		return [[ASLBigUInt alloc] initWithBigUInt:bigUInt];
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			*error = [NSError ASL_SealInvalidParameter:e];
		}
		return nil;
	}
}

+ (instancetype)bigUIntWithHexValue:(NSString *)hexValue error:(NSError **)error {
	NSParameterAssert(hexValue != nil);
	
	std::string const hexValueString = (hexValue.length > 0
										? hexValue.stdString
										: "");
	try {
		seal::BigUInt const bigUInt = seal::BigUInt(hexValueString);
		return [[ASLBigUInt alloc] initWithBigUInt:bigUInt];
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			*error = [NSError ASL_SealInvalidParameter:e];
		}
		return nil;
	}
}

+ (instancetype)bigUIntWithBitCount:(NSInteger)bitCount error:(NSError **)error {
	try {
		seal::BigUInt const bigUInt = seal::BigUInt(static_cast<int>(bitCount));
		return [[ASLBigUInt alloc] initWithBigUInt:bigUInt];
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			*error = [NSError ASL_SealInvalidParameter:e];
		}
		return nil;
	}
}

- (instancetype)initWithBigUInt:(seal::BigUInt)bigUInt {
	self = [super init];
	if (self == nil) {
		return nil;
	}
	
	_bigUInt = std::move(bigUInt);
	
	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [[ASLBigUInt allocWithZone:zone] initWithBigUInt:_bigUInt];
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
	if (self == object) {
	  return YES;
	}

	if (![object isKindOfClass:[ASLBigUInt class]]) {
	  return NO;
	}

	return [self isEqualToBigUInt:(ASLBigUInt *)object];
}

#pragma mark - Public Methods

- (BOOL)isEqualToBigUInt:(ASLBigUInt *)other {
	NSParameterAssert(other != nil);
	if (other == nil) {
		return NO;
	} else {
		return _bigUInt == other->_bigUInt;
	}
}

- (NSComparisonResult)compare:(ASLBigUInt *)other {
	NSParameterAssert(other != nil);
	if (other == nil) {
		return NSOrderedSame;
	} else if (_bigUInt == other->_bigUInt) {
		return NSOrderedSame;
	} else if (_bigUInt < other->_bigUInt) {
		return NSOrderedAscending;
	} else {
		return NSOrderedDescending;
	}
}

#pragma mark - Properties

- (BOOL)isAlias {
	return _bigUInt.is_alias();
}

- (NSInteger)bitCount {
	return _bigUInt.bit_count();
}

- (uint64_t *)data {
	return _bigUInt.data();
}

- (size_t)byteCount {
	return _bigUInt.byte_count();
}

- (size_t)uint64Count {
	return _bigUInt.uint64_count();
}

- (NSInteger)significantBitCount {
	return _bigUInt.significant_bit_count();
}

- (double)doubleValue {
	return _bigUInt.to_double();
}

- (NSString *)stringValue {
	return [NSString ASL_stringWithStdString:_bigUInt.to_string()];
}

- (NSString *)decimalStringValue {
	return [NSString ASL_stringWithStdString:_bigUInt.to_dec_string()];
}

- (BOOL)isZero {
	return _bigUInt.is_zero();
}

- (uint8_t)byteAtIndex:(NSInteger)index {
	try {
		return static_cast<uint8_t>(_bigUInt[index]);
	} catch (...) {
		[NSException raise:NSRangeException
					format:@"Index %@ out of bounds", @(index)];
	}
	return 0;
}

- (void)setZero {
	_bigUInt.set_zero();
}

- (BOOL)resize:(NSInteger)bitCount
		 error:(NSError **)error {
	try {
		_bigUInt.resize(static_cast<int>(bitCount));
		return YES;
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			*error = [NSError ASL_SealInvalidParameter:e];
		}
		return NO;
	} catch (std::logic_error const &e) {
		if (error != nil) {
			*error = [NSError ASL_SealLogicError:e];
		}
		return NO;
	}
	return NO;
}

- (BOOL)alias:(NSInteger)bitCount
 scalarValues:(uint64_t *)value
		error:(NSError **)error {
	try {
		_bigUInt.alias(static_cast<int>(bitCount), value);
		return YES;
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			*error = [NSError ASL_SealInvalidParameter:e];
		}
		return NO;
	}
	return NO;
}

- (BOOL)unalias:(NSError **)error {
	try {
		_bigUInt.unalias();
		return YES;
	} catch (std::logic_error const &e) {
		if (error != nil) {
			*error = [NSError ASL_SealLogicError:e];
		}
		return NO;
	}
	return NO;
}

@end
