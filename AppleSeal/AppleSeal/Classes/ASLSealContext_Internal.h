//
//  ASLSealContext_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-01.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLSealContext.h"

#include "seal/context.h"
#include "seal/modulus.h"

#import "ASLEncryptionParameters.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLSealContext ()

- (instancetype)initWithEncryptionParameters:(seal::EncryptionParameters)encryptionParameters
                              expandModChain:(BOOL)expandModChain
                               securityLevel:(seal::sec_level_type)securityLevel;

/// Returns a copy of the small modulus backing the receiver.
@property (nonatomic, assign, readonly) std::shared_ptr<seal::SEALContext> sealContext;

@end

NS_ASSUME_NONNULL_END


