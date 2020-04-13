//
//  ASLSecretKey.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-11.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLSecretKey.h"

#include <string>
#include <stdexcept>
#include "seal/secretkey.h"

#import "NSString+CXXAdditions.h"

#import "ASLMemoryPoolHandle.h"
#import "ASLMemoryPoolHandle_Internal.h"
#import "ASLPlainText.h"
#import "ASLPlainText_Internal.h"
#import "ASLSealContext_Internal.h"
#import "ASLSecretKey_Internal.h"

@implementation ASLSecretKey  {
	seal::SecretKey _secretKey;
}

#pragma mark - Initialization

- (instancetype)init {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	_secretKey = seal::SecretKey();
	return self;
}

# pragma mark - ASLSecretKey_Internal

- (instancetype)initWithSecretKey:(seal::SecretKey)secretKey {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _secretKey = std::move(secretKey);
    
    return self;
}

- (seal::SecretKey)sealSecretKey {
	return _secretKey;
}

# pragma mark - Public  Properties

- (ASLPlainText *)plainTextData {
	return [[ASLPlainText alloc] initWithPlainText:_secretKey.data()];
}

- (ASLParametersIdType)parametersId {
	auto const parameters = _secretKey.parms_id();
	return ASLParametersIdTypeMake(parameters[0], parameters[1], parameters[2], parameters[3]);
}

- (ASLMemoryPoolHandle *)pool {
	return [[ASLMemoryPoolHandle alloc] initWithMemoryPoolHandle:_secretKey.pool()];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [[ASLSecretKey allocWithZone:zone] initWithSecretKey:_secretKey];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
	std::size_t const lengthUpperBound = _secretKey.save_size(seal::Serialization::compr_mode_default);
	NSMutableData * const data = [NSMutableData dataWithLength:lengthUpperBound];
	std::size_t const actualLength = _secretKey.save(static_cast<std::byte *>(data.mutableBytes), lengthUpperBound);
	[data setLength:actualLength];
	[coder encodeDataObject:data];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSData * const encodedValueData = [coder decodeDataObject];
    if (encodedValueData.length == 0) {
        return nil;
    }

    seal::SecretKey encodedSecretKey;
    std::byte const * bytes = static_cast<std::byte const *>(encodedValueData.bytes);
    std::size_t const length = static_cast<std::size_t const>(encodedValueData.length);
   //    encodedSecretKey.load(bytes, length);
    return [self initWithSecretKey:encodedSecretKey];
}

@end
