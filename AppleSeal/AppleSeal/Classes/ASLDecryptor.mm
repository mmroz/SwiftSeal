//
//  ASLDecryptor.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-11.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLDecryptor.h"

#include "seal/decryptor.h"
#include <memory>

#import "ASLSealContext.h"
#import "ASLSealContext_Internal.h"
#import "ASLSecretKey.h"
#import "ASLSecretKey_Internal.h"
#import "ASLCipherText.h"
#import "ASLCipherText_Internal.h"
#import "ASLPlainText.h"
#import "ASLPlainText_Internal.h"

NSString * const ASLDecryptorErrorDomain = @"ASLDecryptorErrorDomain";

@implementation ASLDecryptor {
	seal::Decryptor* _decryptor;
}

#pragma mark - Initialization

// TODO - refactor error handling here

+ (instancetype)decryptorWithContext:(ASLSealContext *)context
						   secretKey:(ASLSecretKey *)secretKey
							   error:(NSError **)error {
	try {
		seal::Decryptor* decryptor = new seal::Decryptor(context.sealContext, secretKey.sealSecretKey);
		return [[ASLDecryptor alloc] initWithDecryptor:decryptor];
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLDecryptorErrorDomain
												code:ASLDecryptorErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
		return nil;
	}
}

- (instancetype)initWithDecryptor:(seal::Decryptor *)decryptor {
	self = [super init];
	if (self == nil) {
		return nil;
	}
	_decryptor = decryptor;
	return self;
}

- (void)dealloc {
	delete _decryptor;
	_decryptor = nullptr;
}

#pragma mark - Public Methods

// TODO - add error handling
- (BOOL)decrypt:(ASLCipherText *)encrypted
destination:(ASLPlainText *)destination
		  error:(NSError **)error {
	auto sealPlainText = destination.sealPlainText;
	_decryptor->decrypt(encrypted.sealCipherText, sealPlainText);
	return true;
}

// TODO - add error handling
- (int)invariantNoiseBudget:(ASLCipherText *)cipherText
					  error:(NSError **)error {
	return _decryptor->invariant_noise_budget(cipherText.sealCipherText);
}

@end





