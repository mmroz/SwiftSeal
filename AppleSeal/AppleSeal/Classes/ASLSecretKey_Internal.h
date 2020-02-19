//
//  ASLSecretKey_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-11.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLSecretKey.h"

#include "seal/secretkey.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLSecretKey ()

@property (nonatomic, assign, readonly) seal::SecretKey sealSecretKey;

@end

NS_ASSUME_NONNULL_END
