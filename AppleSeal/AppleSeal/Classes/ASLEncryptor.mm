//
//  ASLEncryptor.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-11.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLEncryptor.h"

#include "seal/encryptor.h"

#import "ASLSealContext_Internal.h"
#import "ASLPublicKey_Internal.h"

NSString * const ASLEncryptorErrorDomain = @"ASLEncryptorErrorDomain";

// TODO - implement this when I figure out the pointer stuff

@implementation ASLEncryptor {
	std::shared_ptr<seal::Encryptor> _encryptor;
}

//#pragma mark - Initialization
//
//- (instancetype)initWithEncryptor:(std::shared_ptr<seal::Encryptor>)encryptor {
//	self = [super init];
//	if (self == nil) {
//		return nil;
//	}
//
//	_encryptor = encryptor;
//
//	return self;
//}

@end
