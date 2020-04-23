//
//  ASLBaseConverter.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-04-21.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLBaseConverter.h"

#include "seal/util/baseconverter.h"

#import "ASLMemoryPoolHandle_Internal.h"
#import "ASLSmallModulus_Internal.h"

@implementation ASLBaseConverter {
    seal::util::BaseConverter * _baseConverter;
}

// TODO - rename these because the call sies imply the wrong thing

# pragma mark - Initialization

+ (instancetype)baseConverterWithPool:(ASLMemoryPoolHandle *)pool {
    auto converter = seal::util::BaseConverter(pool.memoryPoolHandle);
    return [[ASLBaseConverter alloc] initWithBaseConverter:&converter];
}

+ (instancetype)baseConverterWithModuluses:(NSArray<ASLSmallModulus *> *)moduluses coefficientCount:(NSNumber *)coefficientCount smallPlainModulus:(ASLSmallModulus *)smallPlainModulus pool:(ASLMemoryPoolHandle *)pool {
    
    std::vector<seal::SmallModulus> smallModulusList(static_cast<size_t>(moduluses.count));
    for (ASLSmallModulus * const smallModulus in moduluses) {
        smallModulusList.push_back(smallModulus.smallModulus);
    }
    
    auto converter = seal::util::BaseConverter(smallModulusList, coefficientCount.unsignedIntValue, smallPlainModulus.smallModulus, pool.memoryPoolHandle);
    
    return [[ASLBaseConverter alloc] initWithBaseConverter:&converter];
}

- (void)dealloc {
    delete _baseConverter;
    _baseConverter = nullptr;
}

#pragma mark - Properties - Internal

- (instancetype)initWithBaseConverter:(seal::util::BaseConverter *)baseConverter {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _baseConverter = std::move(baseConverter);
    
    return self;
}

#pragma mark - Public Method

- (void)generate:(NSArray<ASLSmallModulus *> *)coefficientBase coefficientCount:(NSNumber *)coefficientCount smallPlainModulus:(ASLSmallModulus *)smallPlainModulus {
    
    std::vector<seal::SmallModulus> smallModulusList(static_cast<size_t>(coefficientBase.count));
    for (ASLSmallModulus * const smallModulus in coefficientBase) {
        smallModulusList.push_back(smallModulus.smallModulus);
    }
    
    _baseConverter->generate(smallModulusList, coefficientCount.longLongValue, smallPlainModulus.smallModulus);
}

- (void)floorLastCoefficientModulusInplace:(NSNumber *)rnsPoly pool:(ASLMemoryPoolHandle *)pool {
    std::uint64_t value = rnsPoly.unsignedLongLongValue;
    _baseConverter->floor_last_coeff_modulus_inplace(&value, pool.memoryPoolHandle);
}

- (void)roundLastCoefficientModulusInplace:(NSNumber *)rnsPoly pool:(ASLMemoryPoolHandle *)pool {
    std::uint64_t value = rnsPoly.unsignedLongLongValue;
    _baseConverter->round_last_coeff_modulus_inplace(&value, pool.memoryPoolHandle);
}

- (void)fastBaseConverterQToBsk:(NSNumber *)input
                    destination:(NSNumber *)destination pool:(ASLMemoryPoolHandle *)pool {
    std::uint64_t inputValue = input.unsignedLongLongValue;
    std::uint64_t destinationValue = destination.unsignedLongLongValue;
    _baseConverter->fastbconv(&inputValue, &destinationValue, pool.memoryPoolHandle);
}

- (void)fastBaseConverterBskToQ:(NSNumber *)input destination:(NSNumber *)destination pool:(ASLMemoryPoolHandle *)pool {
    std::uint64_t inputValue = input.unsignedLongLongValue;
     std::uint64_t destinationValue = destination.unsignedLongLongValue;
    _baseConverter->fastbconv_sk(&inputValue, &destinationValue, pool.memoryPoolHandle);
    
}

- (void)reduceBskPrimeToBsk:(NSNumber *)input destination:(NSNumber *)destination {
    std::uint64_t inputValue = input.unsignedLongLongValue;
    std::uint64_t destinationValue = destination.unsignedLongLongValue;
    _baseConverter->mont_rq(&inputValue, &destinationValue);
    
}

- (void)fastFloor:(NSNumber *)input destination:(NSNumber *)destination pool:(ASLMemoryPoolHandle *)pool {
    std::uint64_t inputValue = input.unsignedLongLongValue;
    std::uint64_t destinationValue = destination.unsignedLongLongValue;
    _baseConverter->fast_floor(&inputValue, &destinationValue, pool.memoryPoolHandle);
}

- (void)fastFloorFastBaseConverterQToBskPrime:(NSNumber *)input destination:(NSNumber *)destination pool:(ASLMemoryPoolHandle *)pool {
    std::uint64_t inputValue = input.unsignedLongLongValue;
    std::uint64_t destinationValue = destination.unsignedLongLongValue;
    _baseConverter->fastbconv_mtilde(&inputValue, &destinationValue, pool.memoryPoolHandle);
    
}

- (void)fastBaseConverterPlainGamma:(NSNumber *)input destination:(NSNumber *)destination pool:(ASLMemoryPoolHandle *)pool {
    std::uint64_t inputValue = input.unsignedLongLongValue;
    std::uint64_t destinationValue = destination.unsignedLongLongValue;
    _baseConverter->fastbconv_plain_gamma(&inputValue, &destinationValue, pool.memoryPoolHandle);
}

- (void)reset {
    _baseConverter->reset();
}

- (BOOL)isGenerated {
    return _baseConverter->is_generated();
}

- (NSNumber *)coefficientBaseMododulusCount {
    return [[NSNumber alloc] initWithUnsignedLongLong:_baseConverter->coeff_base_mod_count()];
}

- (NSNumber *)auxBaseModCount {
    return [[NSNumber alloc] initWithUnsignedLong:_baseConverter->aux_base_mod_count()];
}

- (NSNumber *)invertedGamma {
    return [[NSNumber alloc] initWithUnsignedLong:_baseConverter->get_inv_gamma()];
}

- (ASLSmallModulus *)msk {
    return [[ASLSmallModulus alloc] initWithSmallModulus:_baseConverter->get_msk()];
}

- (ASLSmallModulus *)mPrime {
     return [[ASLSmallModulus alloc] initWithSmallModulus:_baseConverter->get_m_tilde()];
}

- (NSNumber *)mPrimeInverseCoefficientProductsModulusCoefficient {
    return [[NSNumber alloc] initWithUnsignedLongLong:_baseConverter->get_inv_coeff_mod_mtilde()];
}

- (NSNumber *)inverseCoefficientModulusMPrime {
    return [[NSNumber alloc] initWithUnsignedLongLong:_baseConverter->get_inv_coeff_mod_mtilde()];
}

@end
