//
//  ASLRelinearizationKeys.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLRelinearizationKeys.h"

#include "seal/relinkeys.h"

#import "ASLPublicKey_Internal.h"
#import "ASLRelinearizationKeys_Internal.h"

@implementation ASLRelinearizationKeys {
	seal::RelinKeys _relinearizationKeys;
}

#pragma mark - initializers

- (instancetype)init {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	_relinearizationKeys = seal::RelinKeys();
	
	return self;
}

#pragma mark - Public Methods

- (size_t)getIndex:(NSNumber *)index {
	NSParameterAssert(index.intValue >= 2);
	return _relinearizationKeys.get_index(index.intValue);
}

- (BOOL)hasKey:(NSNumber *)key {
	NSParameterAssert(key.intValue >= 2);
	return _relinearizationKeys.has_key(key.intValue);
}

- (NSArray<ASLPublicKey *> *)keyWithKeyPower:(NSNumber *)keyPower {
	NSMutableArray * publicKeyVector = [[NSMutableArray alloc] init];
	for (seal::PublicKey const & publicKey: _relinearizationKeys.key(keyPower.intValue)) {
		ASLPublicKey* aslPublicKey = [[ASLPublicKey alloc] initWithPublicKey:publicKey];
		[publicKeyVector addObject:aslPublicKey];
	}
	return publicKeyVector;
}

#pragma mark - ASLRelinearizationKeys_Internal.h

- (seal::RelinKeys)sealRelinKeys {
	return _relinearizationKeys;
}

// TODO - do I need  to re-implement the base class methods?


@end
