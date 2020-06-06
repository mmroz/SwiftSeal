//
//  ASLKeyGenerator_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-05-17.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLKeyGenerator.h"

#include "seal/keygenerator.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLKeyGenerator ()

- (instancetype)initWithKeyGenerator:(seal::KeyGenerator *)keyGenerator;


@end

NS_ASSUME_NONNULL_END
