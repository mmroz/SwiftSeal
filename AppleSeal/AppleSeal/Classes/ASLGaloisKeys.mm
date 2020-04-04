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
#import "NSString+CXXAdditions.h"
#import "NSError+CXXAdditions.h"

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

-(NSNumber *)getIndex:(NSNumber*)galoisElement
            error:(NSError **)error {
    NSParameterAssert(galoisElement != nil);
    NSParameterAssert(galoisElement.intValue >= 2);
    
    try {
        return [[NSNumber alloc] initWithUnsignedLongLong:_galoisKeys.get_index(galoisElement.intValue)];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}

-(NSNumber *)hasKey:(NSNumber*)galoisElement
        error:(NSError **)error {
    NSParameterAssert(galoisElement != nil);
    NSParameterAssert(galoisElement.intValue >= 2);
    try {
        return [[NSNumber alloc]initWithBool:_galoisKeys.has_key(galoisElement.intValue)];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}

-(NSArray<ASLPublicKey*>*)key:(NSNumber*)galoisElement
                        error:(NSError **)error {
    NSParameterAssert(galoisElement != nil);
    NSParameterAssert(galoisElement.intValue >= 2);
    try {
        NSMutableArray * publicKeyVector = [[NSMutableArray alloc] init];
        for (seal::PublicKey const & publicKey: _galoisKeys.key(galoisElement.intValue)) {
            ASLPublicKey* aslPublicKey = [[ASLPublicKey alloc] initWithPublicKey:publicKey];
            [publicKeyVector addObject:aslPublicKey];
        }
        return publicKeyVector;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}


#pragma mark - ASLGaloisKeys_Internal

- (seal::GaloisKeys)sealGaloisKeys {
    return _galoisKeys;
}

- (instancetype)initWithGaloisKeys:(seal::GaloisKeys)sealGaloisKeys {
    self = [super init];
       if (self == nil) {
           return nil;
       }
       
       _galoisKeys = std::move(sealGaloisKeys);

       return self;
}

@end
