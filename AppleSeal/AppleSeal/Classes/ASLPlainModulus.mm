//
//  ASLPlainModulus.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLPlainModulus.h"

#include "seal/modulus.h"

#import "ASLSmallModulus.h"
#import "ASLSmallModulus_Internal.h"

@implementation ASLPlainModulus

#pragma mark - Public Static Methods

+ (ASLSmallModulus*)batching:(size_t)polynomialModulusDegree
					 bitSize:(int)bitSize
					   error:(NSError **)error {
	seal::SmallModulus modulus = seal::PlainModulus::Batching(polynomialModulusDegree, bitSize);
	return [[ASLSmallModulus alloc] initWithSmallModulus:modulus];
}

+ (NSArray<ASLSmallModulus*>*)batching:(size_t)polynomialModulusDegree
							  bitSizes:(NSArray<NSNumber*>*)bitSizes
								 error:(NSError **)error {
	
	std::vector<int> intBitSizes(static_cast<size_t>(bitSizes.count));
	for (NSNumber * const bitSize in bitSizes) {
		intBitSizes.push_back(bitSize.intValue);
	}
	
	std::vector<seal::SmallModulus> defaultSmallModuluses =  seal::PlainModulus::Batching(polynomialModulusDegree, intBitSizes);
	NSMutableArray * aslSmallModulses = [[NSMutableArray alloc] init];
	
	for (seal::SmallModulus& modulus: defaultSmallModuluses) {
		ASLSmallModulus* aslSmallModulus = [[ASLSmallModulus alloc] initWithSmallModulus:modulus];
		[aslSmallModulses addObject:aslSmallModulus];
	}
	return aslSmallModulses;
}

@end
