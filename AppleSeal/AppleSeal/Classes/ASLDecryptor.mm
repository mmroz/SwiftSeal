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
#import "NSString+CXXAdditions.h"
#import "NSError+CXXAdditions.h"

@implementation ASLDecryptor {
    seal::Decryptor* _decryptor;
}

#pragma mark - Initialization

+ (instancetype)decryptorWithContext:(ASLSealContext *)context
                           secretKey:(ASLSecretKey *)secretKey
                               error:(NSError **)error {
    try {
        seal::Decryptor* decryptor = new seal::Decryptor(context.sealContext, secretKey.sealSecretKey);
        return [[ASLDecryptor alloc] initWithDecryptor:decryptor];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
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

- (ASLPlainText *)decrypt:(ASLCipherText *)encrypted
    destination:(ASLPlainText *)destination
          error:(NSError **)error {
    auto sealPlainText = destination.sealPlainText;
    try {
        _decryptor->decrypt(encrypted.sealCipherText, sealPlainText);
        return [[ASLPlainText alloc] initWithPlainText:sealPlainText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (NSNumber *)invariantNoiseBudget:(ASLCipherText *)cipherText
                             error:(NSError **)error {
    try {
        return [[NSNumber alloc]initWithInt:_decryptor->invariant_noise_budget(cipherText.sealCipherText)];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

@end





