//
//  ASLComplexType_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-10.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLComplexType.h"

#include <complex>

NS_ASSUME_NONNULL_BEGIN

@interface ASLComplexType ()

@property (nonatomic, assign, readonly) std::complex<double> complex;

@end

NS_ASSUME_NONNULL_END

