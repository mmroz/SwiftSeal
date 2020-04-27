//
//  ASLCoefficientModulus.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLCoefficientModulus.h"

#include "seal/modulus.h"

#import "ASLSealContext.h"
#import "ASLSmallModulus_Internal.h"
#import "NSString+CXXAdditions.h"
#import "NSError+CXXAdditions.h"

static seal::sec_level_type sealSecurityLevelFromASLSecurityLevel(ASLSecurityLevel securityLevel) {
    switch(securityLevel) {
        case None:
            return seal::sec_level_type::none;
        case TC128:
            return seal::sec_level_type::tc128;
        case TC192:
            return seal::sec_level_type::tc192;
        case TC256:
            return seal::sec_level_type::tc256;
    }
}

@implementation ASLCoefficientModulus

#pragma mark - Public Static Methods

+ (int)maxBitCount:(size_t)polynomialModulusDegree
     securityLevel:(ASLSecurityLevel)securityLevel {
    return seal::CoeffModulus::MaxBitCount(polynomialModulusDegree, sealSecurityLevelFromASLSecurityLevel(securityLevel));
}

+ (int)maxBitCount:(size_t)polynomialModulusDegree {
    return seal::CoeffModulus::MaxBitCount(polynomialModulusDegree);
}

+ (NSArray<ASLSmallModulus*>*)bfvDefault:(size_t)polynomialModulusDegree
                           securityLevel:(ASLSecurityLevel)securityLevel
                                   error:(NSError **)error
{
    try {
        std::vector<seal::SmallModulus> defaultSmallModuluses = seal::CoeffModulus::BFVDefault(polynomialModulusDegree, sealSecurityLevelFromASLSecurityLevel(securityLevel));
        NSMutableArray * aslSmallModulses = [[NSMutableArray alloc] init];
        
        for (seal::SmallModulus& modulus: defaultSmallModuluses) {
            ASLSmallModulus* aslSmallModulus = [[ASLSmallModulus alloc] initWithSmallModulus:modulus];
            [aslSmallModulses addObject:aslSmallModulus];
        }
        return aslSmallModulses;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

+ (NSArray<ASLSmallModulus*>*)bfvDefault:(size_t)polynomialModulusDegree
                                   error:(NSError **)error {
    
    try {
        
        std::vector<seal::SmallModulus> defaultSmallModuluses =  seal::CoeffModulus::BFVDefault(polynomialModulusDegree);
        NSMutableArray * aslSmallModulses = [[NSMutableArray alloc] init];
        
        for (seal::SmallModulus& modulus: defaultSmallModuluses) {
            ASLSmallModulus* aslSmallModulus = [[ASLSmallModulus alloc] initWithSmallModulus:modulus];
            [aslSmallModulses addObject:aslSmallModulus];
        }
        return aslSmallModulses;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

+ (NSArray<ASLSmallModulus*>*)create:(size_t)polynomialModulusDegree
                            bitSizes:(NSArray<NSNumber*>*)bitSizes
                               error:(NSError **)error{
    
    std::vector<int> intBitSizes;
    for (NSNumber * const bitSize in bitSizes) {
        intBitSizes.push_back(bitSize.intValue);
    }
    
    try {
           std::vector<seal::SmallModulus> defaultSmallModuluses =  seal::CoeffModulus::Create(polynomialModulusDegree, intBitSizes);
           NSMutableArray * aslSmallModulses = [[NSMutableArray alloc] init];
           
           for (seal::SmallModulus& modulus: defaultSmallModuluses) {
               ASLSmallModulus* aslSmallModulus = [[ASLSmallModulus alloc] initWithSmallModulus:modulus];
               [aslSmallModulses addObject:aslSmallModulus];
           }
           return aslSmallModulses;
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

@end
