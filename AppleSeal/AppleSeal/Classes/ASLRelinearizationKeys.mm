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
#import "NSError+CXXAdditions.h"

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

- (NSNumber *)getIndex:(size_t)index
                 error:(NSError **)error; {
    NSParameterAssert(index >= 2);
    
    try {
        return [[NSNumber alloc]initWithFloat:_relinearizationKeys.get_index(index)];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (NSNumber *)hasKey:(size_t)key
               error:(NSError **)error;{
    NSParameterAssert(key >= 2);
    
    try {
        return [[NSNumber alloc]initWithBool:_relinearizationKeys.has_key(key)];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (NSArray<ASLPublicKey *> *)keyWithKeyPower:(size_t)keyPower
                                       error:(NSError **)error;{
    NSMutableArray * publicKeyVector = [[NSMutableArray alloc] init];
    NSParameterAssert(keyPower >= 2);
    
    try {
        for (seal::PublicKey const & publicKey:
             _relinearizationKeys.key(keyPower)) {
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
    return nil;
}

#pragma mark - ASLRelinearizationKeys_Internal.h

- (seal::RelinKeys)sealRelinKeys {
    return _relinearizationKeys;
}

- (instancetype)initWithRelinearizationKeys:(seal::RelinKeys)relinearizationKeys {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _relinearizationKeys = std::move(relinearizationKeys);
    
    return self;
}




@end
