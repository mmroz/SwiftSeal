//
//  ASLRnsBase_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-05-15.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLRnsBase.h"

#include "seal/util/rns.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLRnsBase ()

@property (nonatomic, assign, readonly) seal::util::RNSBase * rnsBase;

- (instancetype)initWithRnsBase:(seal::util::RNSBase *)rnsBase freeWhenDone:(BOOL)freeWhenDone;

@end

NS_ASSUME_NONNULL_END
