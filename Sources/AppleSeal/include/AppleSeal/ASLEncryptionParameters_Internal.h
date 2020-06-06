//
//  ASLEncryptionParameters_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-05.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLEncryptionParameters.h"

#include "seal/encryptionparams.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLEncryptionParameters ()

@property (nonatomic, assign, readonly) seal::EncryptionParameters sealEncryptionParams;

	- (instancetype)initWithEncryptionParameters:(seal::EncryptionParameters)encryptionParameters;
@end

NS_ASSUME_NONNULL_END
