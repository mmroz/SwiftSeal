//
//  ASLPlainModulus.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLPlainModulus.h"

#include "seal/modulus.h"

#import "ASLModulus.h"
#import "ASLModulus_Internal.h"
#import "NSError+CXXAdditions.h"

@implementation ASLPlainModulus

#pragma mark - Public Static Methods

+ (ASLModulus*)batching:(size_t)polynomialModulusDegree
					 bitSize:(int)bitSize
					   error:(NSError **)error {
    try {
        seal::Modulus modulus = seal::PlainModulus::Batching(polynomialModulusDegree, bitSize);
        return [[ASLModulus alloc] initWithModulus:modulus];
    }  catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }  catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
    return nil;
}

+ (NSArray<ASLModulus*>*)batching:(size_t)polynomialModulusDegree
							  bitSizes:(NSArray<NSNumber*>*)bitSizes
								 error:(NSError **)error {
	
	std::vector<int> intBitSizes;
	for (NSNumber * const bitSize in bitSizes) {
		intBitSizes.push_back(bitSize.intValue);
	}
	
	std::vector<seal::Modulus> defaultModuluses =  seal::PlainModulus::Batching(polynomialModulusDegree, intBitSizes);
	NSMutableArray * aslSmallModulses = [[NSMutableArray alloc] init];
	
    try {
        for (seal::Modulus& modulus: defaultModuluses) {
            ASLModulus* aslModulus = [[ASLModulus alloc] initWithModulus:modulus];
            [aslSmallModulses addObject:aslModulus];
        }
        return aslSmallModulses;
    }  catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }  catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
    return nil;
    
	
}

@end
