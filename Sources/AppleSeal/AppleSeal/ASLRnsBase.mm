//
//  ASLRnsBase.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-05-15.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLRnsBase.h"

#include "seal/util/rns.h"

#import "ASLMemoryPoolHandle_Internal.h"
#import "ASLModulus_Internal.h"
#import "ASLRnsBase_Internal.h"
#import "ASLModulus_Internal.h"

@implementation ASLRnsBase {
    seal::util::RNSBase *_rnsBase;
    BOOL _freeWhenDone;
}

# pragma mark - Initialization

+ (instancetype)rnsBaseWithModuluses:(NSArray<ASLModulus *> *)moduluses
                                pool:(ASLMemoryPoolHandle *)pool {
    std::vector<seal::Modulus> modulusList;
    for (ASLModulus * const modulusValue in moduluses) {
        modulusList.push_back(modulusValue.modulus);
    }
    seal::util::RNSBase base = seal::util::RNSBase(modulusList, pool.memoryPoolHandle);
    return [[ASLRnsBase alloc] initWithRnsBase:base freeWhenDone:true];
}

// TODO - 💩 this is never deleted
- (void)dealloc {
    //    if (_freeWhenDone) {
    //       delete _rnsBase;
    //    }
    _rnsBase = nullptr;
}

# pragma mark - ASLRnsBase_Internal

- (instancetype)initWithRnsBase:(seal::util::RNSBase)rnsBase freeWhenDone:(BOOL)freeWhenDone {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _rnsBase = std::move(&rnsBase);
    _freeWhenDone = freeWhenDone;
    return self;
}

- (seal::util::RNSBase *)rnsBase {
    return _rnsBase;
}

# pragma mark - Public Methods

- (ASLRnsBase *)getAtIndex:(std::size_t)index {
    seal::util::RNSBase result = _rnsBase[index];
    return [[ASLRnsBase alloc] initWithRnsBase:result freeWhenDone:true];
}

- (BOOL)contains:(ASLModulus *)modulus {
    return _rnsBase->contains(modulus.modulus);
}

- (BOOL)isSubBaseOf:(ASLRnsBase *)subBase {
    return _rnsBase->is_subbase_of(*subBase->_rnsBase);
}

- (BOOL)isSuperBaseOf:(ASLRnsBase *)superBase {
    return _rnsBase->is_subbase_of(*superBase->_rnsBase);
}

- (BOOL)isProperSubBaseOf:(ASLRnsBase *)subBase {
    return _rnsBase->is_proper_subbase_of(*subBase->_rnsBase);
}

- (BOOL)isProperSuperBaseOf:(ASLRnsBase *)superBase {
    return _rnsBase->is_subbase_of(*superBase->_rnsBase);
}

- (ASLRnsBase *)extendWithModulus:(ASLModulus *)modulus {
    return[[ASLRnsBase alloc] initWithRnsBase:_rnsBase->extend(modulus.modulus) freeWhenDone:true];
}

- (ASLRnsBase *)extendWithRnsBase:(ASLRnsBase *)rnsBase {
    seal::util::RNSBase base = *rnsBase.rnsBase;
    seal::util::RNSBase extendedBase = _rnsBase->extend(base);
    return [[ASLRnsBase alloc] initWithRnsBase:extendedBase freeWhenDone:false];
}

- (ASLRnsBase *)drop {
    return [[ASLRnsBase alloc] initWithRnsBase:_rnsBase->drop() freeWhenDone:true];
}

- (ASLRnsBase *)dropWithModulus:(ASLModulus *)modulus {
    return [[ASLRnsBase alloc] initWithRnsBase:_rnsBase->drop(modulus.modulus) freeWhenDone:true];
}

- (NSNumber *)decomposeValue:(NSNumber *)value
                        pool:(ASLMemoryPoolHandle *)pool {
    std::uint64_t * valuePointer = new std::uint64_t(value.unsignedLongLongValue);
    _rnsBase->decompose(valuePointer, pool.memoryPoolHandle);
    return [[NSNumber alloc] initWithUnsignedLongLong:static_cast<unsigned long long>(*valuePointer)];
}

- (NSNumber *)decomposeArrayValue:(NSNumber *)value
                            count:(size_t)count
                             pool:(ASLMemoryPoolHandle *)pool {
    std::uint64_t * valuePointer = new std::uint64_t(value.unsignedLongLongValue);
    _rnsBase->decompose_array(valuePointer, count, pool.memoryPoolHandle);
    return [[NSNumber alloc] initWithUnsignedLongLong:static_cast<unsigned long long>(*valuePointer)];
}

- (NSNumber *)composeValue:(NSNumber *)value
                      pool:(ASLMemoryPoolHandle *)pool {
    std::uint64_t * valuePointer = new std::uint64_t(value.unsignedLongLongValue);
    _rnsBase->compose(valuePointer, pool.memoryPoolHandle);
    return [[NSNumber alloc] initWithUnsignedLongLong:static_cast<unsigned long long>(*valuePointer)];
}

- (NSNumber *)composeArrayValue:(NSNumber *)value
                          count:(size_t)count
                           pool:(ASLMemoryPoolHandle *)pool {
    std::uint64_t * valuePointer = new std::uint64_t(value.unsignedLongLongValue);
    _rnsBase->compose_array(valuePointer, count, pool.memoryPoolHandle);
    return [[NSNumber alloc] initWithUnsignedLongLong:static_cast<unsigned long long>(*valuePointer)];
}

# pragma mark - Properties

- (size_t)size {
    return _rnsBase->size();
}

- (ASLModulus *)base {
    return [[ASLModulus alloc] initWithModulus:*_rnsBase->base()];
}

- (NSNumber *)baseProd {
    return [[NSNumber alloc] initWithUnsignedLongLong:*_rnsBase->base_prod()];
}

- (NSNumber *)puncturedProdArray {
    return [[NSNumber alloc] initWithUnsignedLongLong:*_rnsBase->punctured_prod_array()];
}

- (NSNumber *)inversePuncturedProdModulusBaseArray {
    return [[NSNumber alloc] initWithUnsignedLongLong:*_rnsBase->inv_punctured_prod_mod_base_array()];
}
@end
