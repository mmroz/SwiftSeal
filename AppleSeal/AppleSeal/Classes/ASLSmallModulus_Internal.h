//
//  ASLSmallModulus_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLSmallModulus.h"

#include "seal/context.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLSmallModulus ()

/// Returns a copy of the small modulus backing the receiver.
@property (nonatomic, assign, readonly) seal::SmallModulus smallModulus;

- (instancetype)initWithSmallModulus:(seal::SmallModulus)smallModulus;

@end

NS_ASSUME_NONNULL_END
