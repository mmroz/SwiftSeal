//
//  ASLSmallModulus.m
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLSmallModulus.h"
#import "ASLSmallModulus_Internal.h"

#include <array>
#include <string>
#include <stdexcept>
#include <vector>
#include "seal/smallmodulus.h"

#import "NSString+CXXAdditions.h"

NSString * const ASLSmallModulusErrorDomain = @"ASLSmallModulusErrorDomain";

@implementation ASLSmallModulus {
	seal::SmallModulus _smallModulus;
}

#pragma mark - Initialization

+ (instancetype)smallModulusWithValue:(uint64_t)value
								error:(NSError **)error {
	try {
		seal::SmallModulus const smallModulus = seal::SmallModulus(value);
		return [[ASLSmallModulus alloc] initWithSmallModulus:smallModulus];
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLSmallModulusErrorDomain
												code:ASLSmallModulusErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
	}
	return nil;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
	NSData * const encodedValueData = [coder decodeDataObject];
	if (encodedValueData.length == 0) {
		return nil;
	}

	seal::SmallModulus encodedSmallModulus;
	std::byte const * bytes = static_cast<std::byte const *>(encodedValueData.bytes);
	std::size_t const length = static_cast<std::size_t const>(encodedValueData.length);
	encodedSmallModulus.load(bytes, length);
	return [self initWithSmallModulus:encodedSmallModulus];
}

- (instancetype)initWithSmallModulus:(seal::SmallModulus)smallModulus {
	self = [super init];
	if (self == nil) {
		return nil;
	}
	
	_smallModulus = std::move(smallModulus);

	return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
	std::size_t const lengthUpperBound = _smallModulus.save_size(seal::Serialization::compr_mode_default);
	NSMutableData * const data = [NSMutableData dataWithLength:lengthUpperBound];
	std::size_t const actualLength = _smallModulus.save(static_cast<std::byte *>(data.mutableBytes), lengthUpperBound);
	[data setLength:actualLength];
	[coder encodeDataObject:data];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [[ASLSmallModulus allocWithZone:zone] initWithSmallModulus:_smallModulus];
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
	if (self == object) {
	  return YES;
	}

	if (![object isKindOfClass:[ASLSmallModulus class]]) {
	  return NO;
	}

	return [self isEqualToSmallModulus:(ASLSmallModulus *)object];
}

#pragma mark - Public Methods

- (BOOL)isEqualToSmallModulus:(ASLSmallModulus *)other {
	NSParameterAssert(other != nil);
	if (other == nil) {
		return NO;
	} else {
		return _smallModulus == other->_smallModulus;
	}
}

- (NSComparisonResult)compare:(ASLSmallModulus *)other {
	NSParameterAssert(other != nil);
	if (other == nil) {
		return NSOrderedSame;
	} else if (_smallModulus == other->_smallModulus) {
		return NSOrderedSame;
	} else if (_smallModulus < other->_smallModulus) {
		return NSOrderedAscending;
	} else {
		return NSOrderedDescending;
	}
}

- (ASLSmallModulusConstRatio)constRatio {
	std::array<unsigned long long, 3> const array = _smallModulus.const_ratio();
	return ASLSmallModulusConstRatio {
		.floor = array[0],
		.value = array[1],
		.remainder = array[2],
	};
}

#pragma mark - Properties

- (NSInteger)bitCount {
	return _smallModulus.bit_count();
}

- (size_t)uint64Count {
	return _smallModulus.uint64_count();
}

- (uint64_t const *)data {
	return _smallModulus.data();
}

- (uint64_t)uint64Value {
	return _smallModulus.value();
}

- (BOOL)isZero {
	return _smallModulus.is_zero();
}

- (BOOL)isPrime {
	return _smallModulus.is_prime();
}

#pragma mark - Properties - Internal

- (seal::SmallModulus)smallModulus {
	return _smallModulus;
}

@end
