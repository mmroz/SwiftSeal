//
//  ASLModulus_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLModulus.h"

#include "seal/context.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLModulus ()

/// Returns a copy of the small modulus backing the receiver.
@property (nonatomic, assign, readonly) seal::Modulus modulus;

- (instancetype)initWithModulus:(seal::Modulus)modulus;

@end

NS_ASSUME_NONNULL_END
