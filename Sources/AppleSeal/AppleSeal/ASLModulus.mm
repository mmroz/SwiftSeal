//
//  ASLModulus.m
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLModulus.h"
#import "ASLModulus_Internal.h"

#include <array>
#include <string>
#include <stdexcept>
#include <vector>
#include "seal/modulus.h"

#import "NSError+CXXAdditions.h"


@implementation ASLModulus {
	seal::Modulus _modulus;
}

#pragma mark - Initialization

+ (instancetype)modulusWithValue:(uint64_t)value
								error:(NSError **)error {
	try {
		seal::Modulus const modulus = seal::Modulus(value);
		return [[ASLModulus alloc] initWithModulus:modulus];
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
	}
	return nil;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
	std::size_t const lengthUpperBound = _modulus.save_size(seal::Serialization::compr_mode_default);
	NSMutableData * const data = [NSMutableData dataWithLength:lengthUpperBound];
	std::size_t const actualLength = _modulus.save(static_cast<std::byte *>(data.mutableBytes), lengthUpperBound);
	[data setLength:actualLength];
	[coder encodeDataObject:data];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSData * const encodedValueData = [coder decodeDataObject];
    if (encodedValueData.length == 0) {
        return nil;
    }

    seal::Modulus encodedModulus;
    std::byte const * bytes = static_cast<std::byte const *>(encodedValueData.bytes);
    std::size_t const length = static_cast<std::size_t const>(encodedValueData.length);
    encodedModulus.load(bytes, length);
    return [self initWithModulus:encodedModulus];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [[ASLModulus allocWithZone:zone] initWithModulus:_modulus];
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"Value: %llu", self.uint64Value];
}

- (BOOL)isEqual:(id)object {
	if (self == object) {
	  return YES;
	}

	if (![object isKindOfClass:[ASLModulus class]]) {
	  return NO;
	}

	return [self isEqualToModulus:(ASLModulus *)object];
}

#pragma mark - Public Methods

- (BOOL)isEqualToModulus:(ASLModulus *)other {
	NSParameterAssert(other != nil);
	if (other == nil) {
		return NO;
	} else {
		return _modulus == other->_modulus;
	}
}

- (NSComparisonResult)compare:(ASLModulus *)other {
	NSParameterAssert(other != nil);
	if (other == nil) {
		return NSOrderedSame;
	} else if (_modulus == other->_modulus) {
		return NSOrderedSame;
	} else if (_modulus < other->_modulus) {
		return NSOrderedAscending;
	} else {
		return NSOrderedDescending;
	}
}

- (ASLModulusConstRatio)constRatio {
	std::array<unsigned long long, 3> const array = _modulus.const_ratio();
	return ASLModulusConstRatio {
		.floor = array[0],
		.value = array[1],
		.remainder = array[2],
	};
}

#pragma mark - Properties

- (NSInteger)bitCount {
	return _modulus.bit_count();
}

- (size_t)uint64Count {
	return _modulus.uint64_count();
}

- (uint64_t const *)data {
	return _modulus.data();
}

- (uint64_t)uint64Value {
	return _modulus.value();
}

- (BOOL)isZero {
	return _modulus.is_zero();
}

- (BOOL)isPrime {
	return _modulus.is_prime();
}

#pragma mark - Public Methods

- (void)setUInt64Value:(uint64_t)value {
    _modulus = value;
}

#pragma mark - Properties - Internal

- (seal::Modulus)modulus {
	return _modulus;
}

- (instancetype)initWithModulus:(seal::Modulus)modulus {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _modulus = std::move(modulus);

    return self;
}

@end
