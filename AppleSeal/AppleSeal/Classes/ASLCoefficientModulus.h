//
//  ASLCoefficientModulus.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLSealContext.h"
#import "ASLSmallModulus.h"


NS_ASSUME_NONNULL_BEGIN

@interface ASLCoefficientModulus : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

// TODO - add erros to these methods

+ (int)maxBitCount:(size_t)polynomialModulusDegree
	 securityLevel:(ASLSecurityLevel)securityLevel;

+ (int)maxBitCount:(size_t)polynomialModulusDegree;

+ (NSArray<ASLSmallModulus*>*)bfvDefault:(size_t)polynomialModulusDegree
						   securityLevel:(ASLSecurityLevel)securityLevel;

+ (NSArray<ASLSmallModulus*>*)bfvDefault:(size_t)polynomialModulusDegree;

+ (NSArray<ASLSmallModulus*>*)create:(size_t)polynomialModulusDegree
							bitSizes:(NSArray<NSNumber*>*)bitSizes;


@end

NS_ASSUME_NONNULL_END
