//
//  ASLKSwitchKeys_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-19.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLKSwitchKeys.h"

#include "seal/kswitchkeys.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLKSwitchKeys ()

- (instancetype)initWithKSwitchKeys:(seal::KSwitchKeys)kSwitckKeys;

@property (nonatomic, assign, readonly) seal::KSwitchKeys sealKSwitchKeys;

@end

NS_ASSUME_NONNULL_END
