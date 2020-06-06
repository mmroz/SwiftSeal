//
//  ASLNttTables.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-04-21.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLNttTables.h"

#include "seal/util/ntt.h"

#import "ASLNttTables_Internal.h"
#import "ASLModulus_Internal.h"
#import "ASLMemoryPoolHandle_Internal.h"

@implementation ASLNttTables {
    seal::util::NTTTables * _nttTables;
    BOOL _freeWhenDone;
}

# pragma mark - Initialization

+ (instancetype)nttTablesWithCoefficentCountPower:(int)coefficentCountPower
                                          modulus:(ASLModulus *)modulus {
    seal::util::NTTTables * tables = new seal::util::NTTTables(coefficentCountPower, modulus.modulus);
    return [[ASLNttTables alloc] initWithNttTables:tables freeWhenDone:true];
}

+ (instancetype)nttTablesWithCoefficentCountPower:(int)coefficentCountPower
                                          modulus:(ASLModulus *)modulus
                                             pool:(ASLMemoryPoolHandle *)pool{
    seal::util::NTTTables * tables = new seal::util::NTTTables(coefficentCountPower, modulus.modulus, pool.memoryPoolHandle);
    return [[ASLNttTables alloc] initWithNttTables:tables freeWhenDone:true];
}

// TODO - 💩 this is never deleted
- (void)dealloc {
//    if (_freeWhenDone) {
//       delete _nttTables;
//    }
    _nttTables = nullptr;
}

#pragma mark - Static Methods

+ (ASLNttTables *)createWithCoefficentCountPower:(int)coefficentCountPower
                                         modulus:(NSArray<ASLModulus *> *)modulus
                                          tables:(ASLNttTables *)tables
                                             pool:(ASLMemoryPoolHandle *)pool
                                           error:(NSError **)error {
    
    seal::util::Pointer<seal::util::NTTTables> tablesPointer = seal::util::Pointer<seal::util::NTTTables>::Aliasing(tables.sealNttTables);

    std::vector<seal::Modulus> modulusList;
    for (ASLModulus * const modulusValue in modulus) {
        modulusList.push_back(modulusValue.modulus);
    }
    seal::util::CreateNTTTables(coefficentCountPower, modulusList, tablesPointer, pool.memoryPoolHandle);
    return [[ASLNttTables alloc] initWithNttTables:tablesPointer.get() freeWhenDone:false];
}

+ (ASLNttTables *)nttNegacyclicHarveyLazyWithOperand:(uint64_t)operand
                                              tables:(ASLNttTables *)tables {
    std::uint64_t * operandPointer = new std::uint64_t(operand);
    seal::util::ntt_negacyclic_harvey_lazy(operandPointer, *tables.sealNttTables);
    return [[ASLNttTables alloc] initWithNttTables:tables.sealNttTables freeWhenDone:false];
}

+ (ASLNttTables *)nttNegacyclicHarveyWithOperand:(uint64_t)operand
                                          tables:(ASLNttTables *)tables {
    std::uint64_t * operandPointer = new std::uint64_t(operand);
    seal::util::ntt_negacyclic_harvey(operandPointer, *tables.sealNttTables);
    return [[ASLNttTables alloc] initWithNttTables:tables.sealNttTables freeWhenDone:false];
}

+ (ASLNttTables *)inverseNttNegacyclicHarveyLazyWithOperand:(uint64_t)operand
                                                     tables:(ASLNttTables *)tables {
    std::uint64_t * operandPointer = new std::uint64_t(operand);
    seal::util::inverse_ntt_negacyclic_harvey_lazy(operandPointer, *tables.sealNttTables);
    return [[ASLNttTables alloc] initWithNttTables:tables.sealNttTables freeWhenDone:false];
}

+ (ASLNttTables *)inverseNttNegacyclicHarveyWithOperand:(uint64_t)operand
                                                 tables:(ASLNttTables *)tables {
    std::uint64_t * operandPointer = new std::uint64_t(operand);
    seal::util::inverse_ntt_negacyclic_harvey(operandPointer, *tables.sealNttTables);
    return [[ASLNttTables alloc] initWithNttTables:tables.sealNttTables freeWhenDone:false];
}

#pragma mark - Properties - Internal

- (seal::util::NTTTables *)sealNttTables {
    return _nttTables;
}

- (instancetype)initWithNttTables:(seal::util::NTTTables *)smallNttTables
                     freeWhenDone:(BOOL)freeWhenDone{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _nttTables = std::move(smallNttTables);
    _freeWhenDone = freeWhenDone;
    return self;
}

#pragma mark - Public Method

-(NSNumber *)getFromRootPowesrWithIndex:(NSNumber *)index {
    return [[NSNumber alloc]initWithLong:_nttTables->get_from_root_powers(index.longValue)];
}

-(NSNumber *)getFromScaledRootPowersWithIndex:(NSNumber *)index {
    return [[NSNumber alloc]initWithLong: _nttTables->get_from_scaled_root_powers(index.longValue)];
}

- (NSNumber *)getFromRootPowersWithIndex:(NSNumber *)index {
    return [[NSNumber alloc]initWithLong:_nttTables->get_from_root_powers(index.longValue)];
}

-(NSNumber *)getFromInverseRootPowersWithIndex:(NSNumber *)index {
    return [[NSNumber alloc]initWithLong:_nttTables->get_from_inv_root_powers(index.longValue)];
}

-(NSNumber *)getFromScaledInverseRootPowersWithIndex:(NSNumber *)index {
    return [[NSNumber alloc]initWithLong:_nttTables->get_from_scaled_inv_root_powers(index.longValue)];
}

-(NSNumber *)getInverseDegreeModulo {
    return [[NSNumber alloc]initWithLong:*_nttTables->get_inv_degree_modulo()];
}

- (NSNumber *)root {
    return [[NSNumber alloc]initWithLong:_nttTables->get_root()];
}

- (ASLModulus *)modulus {
    return [[ASLModulus alloc]initWithModulus:_nttTables->modulus()];
}

- (int)coefficentCountPower {
    return _nttTables->coeff_count_power();
}

- (NSNumber *)coefficentCount {
    return [[NSNumber alloc]initWithLong:_nttTables->coeff_count()];
}
@end
