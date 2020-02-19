//
//  ASLPublicKey_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-12.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLPublicKey.h"

#include "seal/publickey.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLPublicKey ()

@property (nonatomic, assign, readonly) seal::PublicKey sealPublicKey;

- (instancetype)initWithPublicKey:(seal::PublicKey)publicKey;

@end

NS_ASSUME_NONNULL_END
