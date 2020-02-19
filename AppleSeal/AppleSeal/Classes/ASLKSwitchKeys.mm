//
//  ASLKSwitchKeys.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-12.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLKSwitchKeys.h"

#include "seal/publickey.h"
#include "seal/kswitchkeys.h"

#import "ASLPublicKey_Internal.h"
#import "ASLMemoryPoolHandle.h"
#import "ASLMemoryPoolHandle_Internal.h"
#import "ASLKSwitchKeys_Internal.h"

@implementation ASLKSwitchKeys {
	seal::KSwitchKeys _kSiwtchKeys;
}

#pragma mark - initializers

- (instancetype)initWithKSwitchKeys:(seal::KSwitchKeys)kSwitckKeys {
	self = [super init];
	if (self == nil) {
		return nil;
	}
	
	_kSiwtchKeys = std::move(kSwitckKeys);
	
	return self;
}

- (instancetype)init {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	_kSiwtchKeys = seal::KSwitchKeys();
	
	return self;
}

#pragma mark - ASLKSwitchKeys_Internal

- (seal::KSwitchKeys)sealKSwitchKeys {
	return _kSiwtchKeys;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [[ASLKSwitchKeys allocWithZone:zone] initWithKSwitchKeys:_kSiwtchKeys];
}

#pragma mark - Public Properties

- (size_t)size {
	return _kSiwtchKeys.size();
}

- (NSArray<NSArray<ASLPublicKey *> *> *)data {
	NSMutableArray * publicKeyMatrix = [[NSMutableArray alloc] init];
	for (auto dataVectors: _kSiwtchKeys.data()) {
		NSMutableArray * publicKeyRow = [[NSMutableArray alloc] init];
		for (seal::PublicKey& publicKey: dataVectors) {
			ASLPublicKey* aslPublicKey = [[ASLPublicKey alloc] initWithPublicKey:publicKey];
			[publicKeyRow addObject:aslPublicKey];
		}
		[publicKeyMatrix addObject:publicKeyRow];
	}
	return publicKeyMatrix;
}

- (ASLParametersIdType)parametersId {
	auto const parameters = _kSiwtchKeys.parms_id();
	return ASLParametersIdTypeMake(parameters[0], parameters[1], parameters[2], parameters[3]);
}

- (ASLMemoryPoolHandle *)pool {
	return [[ASLMemoryPoolHandle alloc] initWithMemoryPoolHandle:_kSiwtchKeys.pool()];
}

#pragma mark: - NSCoding

// TODO - add this and the other required save and load methods

//- (void)encodeWithCoder:(nonnull NSCoder *)coder {
//	<#code#>
//}
//
//- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
//	<#code#>
//}

@end
