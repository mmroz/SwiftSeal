//
//  ASLRelinearizationKeys_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-19.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLRelinearizationKeys.h"

#include "seal/relinkeys.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLRelinearizationKeys ()

@property (nonatomic, assign, readonly) seal::RelinKeys sealRelinKeys;

@end

NS_ASSUME_NONNULL_END

