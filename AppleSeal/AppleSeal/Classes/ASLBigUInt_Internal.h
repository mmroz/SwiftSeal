//
//  ASLBigUInt_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-03-09.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLBigUInt.h"

#include "seal/biguint.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLBigUInt ()

@property (nonatomic, assign, readonly) seal::BigUInt sealBigUInt;

- (instancetype)initWithBigUInt:(seal::BigUInt)bigUInt;

@end

NS_ASSUME_NONNULL_END

