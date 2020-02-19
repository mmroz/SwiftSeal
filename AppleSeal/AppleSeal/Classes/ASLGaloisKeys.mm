//
//  ASLGaloisKeys.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLGaloisKeys.h"

#include "seal/galoiskeys.h"

#import "ASLPublicKey_Internal.h"
#import "ASLGaloisKeys_Internal.h"

@implementation ASLGaloisKeys  {
	seal::GaloisKeys _galoisKeys;
}

#pragma mark - initializers

- (instancetype)init {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	_galoisKeys = seal::GaloisKeys();
	
	return self;
}

#pragma mark - Public Methods

- (size_t)getIndex:(NSNumber *)index {
	NSParameterAssert(index.intValue >= 2);
	return _galoisKeys.get_index(index.intValue);
}

- (BOOL)hasKey:(NSNumber *)key {
	NSParameterAssert(key.intValue >= 2);
	return _galoisKeys.has_key(key.intValue);
}

- (NSArray<ASLPublicKey *> *)keyWithKeyPower:(NSNumber *)keyPower {
	NSMutableArray * publicKeyVector = [[NSMutableArray alloc] init];
	for (seal::PublicKey const & publicKey: _galoisKeys.key(keyPower.intValue)) {
		ASLPublicKey* aslPublicKey = [[ASLPublicKey alloc] initWithPublicKey:publicKey];
		[publicKeyVector addObject:aslPublicKey];
	}
	return publicKeyVector;
}

#pragma mark - ASLGaloisKeys_Internal

- (seal::GaloisKeys)sealGaloisKeys {
	return _galoisKeys;
}

@end
