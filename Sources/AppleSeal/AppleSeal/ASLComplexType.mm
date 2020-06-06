//
//  ASLComplexType.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-10.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLComplexType.h"

#import "ASLComplexType_Internal.h"

#include <complex>

@implementation ASLComplexType {
	std::complex<double> _complexDouble;
}

#pragma mark - Initialization

- (instancetype)initWithReal:(double)real imaginary:(double)imaginary {
	std::complex<double> const complex = std::complex<double>(real, imaginary);
	return [[ASLComplexType alloc] initWithComplexDouble:complex];
}

- (instancetype)initWithComplexDouble:(std::complex<double>)complexDouble {
	self = [super init];
	if (self == nil) {
		return nil;
	}
	
	_complexDouble = complexDouble;
	
	return self;
}

# pragma mark - Properties

- (double)real {
	return std::real(_complexDouble);
}

- (double)imaginary {
	return std::imag(_complexDouble);
}

# pragma mark - ASLComplexType_Internal

- (std::complex<double>)complex {
    return _complexDouble;
}

@end
