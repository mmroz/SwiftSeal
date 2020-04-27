//
//  ASLSmallNttTables.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-04-21.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLSmallNttTables.h"

#include "seal/util/smallntt.h"

#import "ASLSmallModulus_Internal.h"
#import "ASLMemoryPoolHandle_Internal.h"

@implementation ASLSmallNttTables {
    seal::util::SmallNTTTables * _smallNttTables;
    BOOL _freeWhenDone;
}

# pragma mark - Initialization

+ (instancetype)smallNttTablesWithPool:(ASLMemoryPoolHandle *)pool {
    auto table = seal::util::SmallNTTTables(pool.memoryPoolHandle);
    return [[ASLSmallNttTables alloc] initWithSmallNttTables:&table freeWhenDone:YES];
}

+ (instancetype)smallNttTablesWithCoefficentCountPower:(int)coefficentCountPower smallModulus:(ASLSmallModulus *)smallModulus pool:(ASLMemoryPoolHandle *)pool {
    auto table = seal::util::SmallNTTTables(coefficentCountPower, smallModulus.smallModulus, pool.memoryPoolHandle);
    return [[ASLSmallNttTables alloc] initWithSmallNttTables:&table freeWhenDone:YES];
}

+ (instancetype)smallNttTablesWithCoefficentCountPower:(int)coefficentCountPower smallModulus:(ASLSmallModulus *)smallModulus {
    auto table = seal::util::SmallNTTTables(coefficentCountPower, smallModulus.smallModulus);
    
    return [[ASLSmallNttTables alloc] initWithSmallNttTables:&table freeWhenDone:YES];
}

- (instancetype)init {
    auto table = seal::util::SmallNTTTables();
    return [[ASLSmallNttTables alloc] initWithSmallNttTables:&table freeWhenDone:YES];
}

// TODO - 💩 this is never deleted
- (void)dealloc {
//    if (_freeWhenDone) {
//       delete _smallNttTables;
//    }
    _smallNttTables = nullptr;
}

#pragma mark - Properties - Internal

- (instancetype)initWithSmallNttTables:(seal::util::SmallNTTTables *)smallNttTables freeWhenDone:(BOOL)freeWhenDone{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _smallNttTables = std::move(smallNttTables);
    _freeWhenDone = freeWhenDone;
    
    return self;
}

#pragma mark - Public Method

- (BOOL)generate:(int)coefficentCountPower
    smallModulus:(ASLSmallModulus *)smallModulus {
    return _smallNttTables->generate(coefficentCountPower, smallModulus.smallModulus);
}

- (void)reset {
    _smallNttTables->reset();
}

-(NSNumber *)getFromRootPowesrWithIndex:(NSNumber *)index {
    return [[NSNumber alloc]initWithLong:_smallNttTables->get_from_root_powers(index.longValue)];
}

-(NSNumber *)getFromScaledRootPowersWithIndex:(NSNumber *)index {
    return [[NSNumber alloc]initWithLong: _smallNttTables->get_from_scaled_root_powers(index.longValue)];
}

- (NSNumber *)getFromRootPowersWithIndex:(NSNumber *)index {
    return [[NSNumber alloc]initWithLong:_smallNttTables->get_from_root_powers(index.longValue)];
}

-(NSNumber *)getFromInverseRootPowersWithIndex:(NSNumber *)index {
    return [[NSNumber alloc]initWithLong:_smallNttTables->get_from_inv_root_powers(index.longValue)];
}

-(NSNumber *)getFromScaledInverseRootPowersWithIndex:(NSNumber *)index {
    return [[NSNumber alloc]initWithLong:_smallNttTables->get_from_scaled_inv_root_powers(index.longValue)];
}

-(NSNumber *)getFromScaledInverseRootPowersDividedByTwoWithIndex:(NSNumber *)index {
    return [[NSNumber alloc]initWithLong:_smallNttTables->get_from_scaled_inv_root_powers_div_two(index.longValue)];
}

-(NSNumber *)getFromInverseRootPowersDividedByTwoWithIndex:(NSNumber *)index {
    return [[NSNumber alloc]initWithLong:_smallNttTables->get_from_inv_root_powers_div_two(index.longValue)];
}

-(NSNumber *)getInverseDegreeModulo {
    return [[NSNumber alloc]initWithLong:*_smallNttTables->get_inv_degree_modulo()];
}

- (NSNumber *)root {
    return [[NSNumber alloc]initWithLong:_smallNttTables->get_root()];
}

- (ASLSmallModulus *)modulus {
    return [[ASLSmallModulus alloc]initWithSmallModulus:_smallNttTables->modulus()];
}

- (int)coefficentCountPower {
    return _smallNttTables->coeff_count_power();
}

- (NSNumber *)coefficentCount {
    return [[NSNumber alloc]initWithLong:_smallNttTables->coeff_count()];
}
@end
