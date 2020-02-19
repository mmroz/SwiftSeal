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
						   securityLevel:(ASLSecurityLevel)securityLevel {
	
	std::vector<seal::SmallModulus> defaultSmallModuluses =  seal::CoeffModulus::BFVDefault(polynomialModulusDegree, sealSecurityLevelFromASLSecurityLevel(securityLevel));
	NSMutableArray * aslSmallModulses = [[NSMutableArray alloc] init];
	
	for (seal::SmallModulus& modulus: defaultSmallModuluses) {
		ASLSmallModulus* aslSmallModulus = [[ASLSmallModulus alloc] initWithSmallModulus:modulus];
		[aslSmallModulses addObject:aslSmallModulus];
	}
	return aslSmallModulses;
}

+ (NSArray<ASLSmallModulus*>*)bfvDefault:(size_t)polynomialModulusDegree {
	
	std::vector<seal::SmallModulus> defaultSmallModuluses =  seal::CoeffModulus::BFVDefault(polynomialModulusDegree);
	NSMutableArray * aslSmallModulses = [[NSMutableArray alloc] init];
	
	for (seal::SmallModulus& modulus: defaultSmallModuluses) {
		ASLSmallModulus* aslSmallModulus = [[ASLSmallModulus alloc] initWithSmallModulus:modulus];
		[aslSmallModulses addObject:aslSmallModulus];
	}
	return aslSmallModulses;
}

+ (NSArray<ASLSmallModulus*>*)create:(size_t)polynomialModulusDegree
							bitSizes:(NSArray<NSNumber*>*)bitSizes {
	
	std::vector<int> intBitSizes(static_cast<size_t>(bitSizes.count));
	for (NSNumber * const bitSize in bitSizes) {
		intBitSizes.push_back(bitSize.intValue);
	}
	
	std::vector<seal::SmallModulus> defaultSmallModuluses =  seal::CoeffModulus::Create(polynomialModulusDegree, intBitSizes);
	NSMutableArray * aslSmallModulses = [[NSMutableArray alloc] init];
	
	for (seal::SmallModulus& modulus: defaultSmallModuluses) {
		ASLSmallModulus* aslSmallModulus = [[ASLSmallModulus alloc] initWithSmallModulus:modulus];
		[aslSmallModulses addObject:aslSmallModulus];
	}
	return aslSmallModulses;
}

@end
