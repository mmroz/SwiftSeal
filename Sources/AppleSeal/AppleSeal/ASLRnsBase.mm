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
#import "NSString+CXXAdditions.h"
#import "NSError+CXXAdditions.h"

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
    seal::util::RNSBase * base = new seal::util::RNSBase(modulusList, pool.memoryPoolHandle);
    return [[ASLRnsBase alloc] initWithRnsBase:base freeWhenDone:true];
}

- (void)dealloc {
    if (_freeWhenDone) {
        delete _rnsBase;
    }
    _rnsBase = nullptr;
}

# pragma mark - ASLRnsBase_Internal

- (instancetype)initWithRnsBase:(seal::util::RNSBase *)rnsBase
                   freeWhenDone:(BOOL)freeWhenDone {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _rnsBase = rnsBase;
    _freeWhenDone = freeWhenDone;
    return self;
}

- (seal::util::RNSBase *)rnsBase {
    return _rnsBase;
}

# pragma mark - Public Methods

- (ASLRnsBase *)getAtIndex:(std::size_t)index {
    try {
        seal::util::RNSBase * result = new seal::util::RNSBase(_rnsBase[index]);;
        return [[ASLRnsBase alloc] initWithRnsBase:result freeWhenDone:true];
    } catch (...) {
        [NSException raise:NSRangeException
                    format:@"Index %@ out of bounds", @(index)];
    }
    return 0;
}

- (ASLRnsBase *)objectForKeyedSubscript:(size_t)key {
   return [self getAtIndex:key];
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
    seal::util::RNSBase * base = new seal::util::RNSBase(_rnsBase->extend(modulus.modulus));
    return[[ASLRnsBase alloc] initWithRnsBase:base freeWhenDone:true];
}

- (ASLRnsBase *)extendWithRnsBase:(ASLRnsBase *)rnsBase
                            error:(NSError **)error {
    try {
        seal::util::RNSBase base = *rnsBase.rnsBase;
        seal::util::RNSBase * extendedBase = new seal::util::RNSBase(_rnsBase->extend(base));
        return [[ASLRnsBase alloc] initWithRnsBase:extendedBase freeWhenDone:false];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
}

- (ASLRnsBase *)dropAllWithError:(NSError **)error {
    try {
        seal::util::RNSBase * base = new seal::util::RNSBase(_rnsBase->drop());
         return [[ASLRnsBase alloc] initWithRnsBase:base freeWhenDone:true];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
}

- (ASLRnsBase *)dropWithModulus:(ASLModulus *)modulus
                          error:(NSError **)error {
    try {
        seal::util::RNSBase * base = new seal::util::RNSBase(_rnsBase->drop(modulus.modulus));
        return [[ASLRnsBase alloc] initWithRnsBase:base freeWhenDone:true];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
    return nil;
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
