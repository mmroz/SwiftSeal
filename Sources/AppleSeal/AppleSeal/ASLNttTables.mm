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
#import "NSError+CXXAdditions.h"

@implementation ASLNttTables {
    seal::util::NTTTables * _nttTables;
    BOOL _freeWhenDone;
}

#pragma mark - Initialization

+ (instancetype)nttTablesWithCoefficentCountPower:(int)coefficentCountPower
                                          modulus:(ASLModulus *)modulus
                                            error:(NSError **)error{
    try {
        seal::util::NTTTables * tables = new seal::util::NTTTables(coefficentCountPower, modulus.modulus);
        return [[ASLNttTables alloc] initWithNttTablesNoCopy:tables freeWhenDone:true];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

+ (instancetype)nttTablesWithCoefficentCountPower:(int)coefficentCountPower
                                          modulus:(ASLModulus *)modulus
                                             pool:(ASLMemoryPoolHandle *)pool
                                            error:(NSError **)error {
    try {
        seal::util::NTTTables * tables = new seal::util::NTTTables(coefficentCountPower, modulus.modulus, pool.memoryPoolHandle);
        return [[ASLNttTables alloc] initWithNttTablesNoCopy:tables freeWhenDone:true];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (void)dealloc {
    if (_freeWhenDone) {
       delete _nttTables;
    }
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
    return [[ASLNttTables alloc] initWithNttTablesNoCopy:tablesPointer.get()
                                            freeWhenDone:false];
}

#pragma mark - Properties - Internal

- (seal::util::NTTTables *)sealNttTables {
    return _nttTables;
}

- (instancetype)initWithNttTablesNoCopy:(seal::util::NTTTables *)nttTables
                           freeWhenDone:(BOOL)freeWhenDone {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _nttTables = nttTables;
    _freeWhenDone = freeWhenDone;
    return self;
}

#pragma mark - Public Method

-(NSNumber *)getFromRootPowersWithIndex:(NSInteger)index {
    return [[NSNumber alloc]initWithLong:_nttTables->get_from_root_powers(index)];
}

-(NSNumber *)getFromScaledRootPowersWithIndex:(NSInteger)index {
    return [[NSNumber alloc]initWithLong: _nttTables->get_from_scaled_root_powers(index)];
}

-(NSNumber *)getFromInverseRootPowersWithIndex:(NSInteger)index {
    return [[NSNumber alloc]initWithLong:_nttTables->get_from_inv_root_powers(index)];
}

-(NSNumber *)getFromScaledInverseRootPowersWithIndex:(NSInteger)index {
    return [[NSNumber alloc]initWithLong:_nttTables->get_from_scaled_inv_root_powers(index)];
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

- (void)negacyclicHarveyWithOperand:(uint64_t)operand {
    seal::util::ntt_negacyclic_harvey(&operand, *_nttTables);
}

- (void)negacyclicHarveyLazyWithOperand:(uint64_t)operand {
    seal::util::ntt_negacyclic_harvey_lazy(&operand, *_nttTables);
}

- (void)inverseNegacyclicHarveyWithOperand:(uint64_t)operand {
    seal::util::inverse_ntt_negacyclic_harvey(&operand, *_nttTables);
}

- (void)inverseNegacyclicHarveyLazyWithOperand:(uint64_t)operand {
    seal::util::inverse_ntt_negacyclic_harvey(&operand, *_nttTables);
}

+ (ASLNttTables *)nttNegacyclicHarveyLazyWithOperand:(uint64_t)operand
                                              tables:(ASLNttTables *)tables {
    seal::util::ntt_negacyclic_harvey_lazy(&operand, *tables.sealNttTables);
    return [[ASLNttTables alloc] initWithNttTablesNoCopy:tables.sealNttTables
                                            freeWhenDone:false];
}

+ (ASLNttTables *)inverseNttNegacyclicHarveyLazyWithOperand:(uint64_t)operand
                                                     tables:(ASLNttTables *)tables {
    seal::util::inverse_ntt_negacyclic_harvey_lazy(&operand, *tables.sealNttTables);
    return [[ASLNttTables alloc] initWithNttTablesNoCopy:tables.sealNttTables
                                            freeWhenDone:false];
}

+ (ASLNttTables *)inverseNttNegacyclicHarveyWithOperand:(uint64_t)operand
                                                 tables:(ASLNttTables *)tables {
    seal::util::inverse_ntt_negacyclic_harvey(&operand, *tables.sealNttTables);
    return [[ASLNttTables alloc] initWithNttTablesNoCopy:tables.sealNttTables
                                            freeWhenDone:false];
}

@end
