//
//  ASLCipherText_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-11.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLCipherText.h"

#include "seal/ciphertext.h"
#include "seal/serializable.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLCipherText ()

@property (nonatomic, assign, readonly) seal::Ciphertext sealCipherText;

- (instancetype)initWithCipherText:(seal::Ciphertext)cipherText;
@end

@interface ASLSerializableCipherText ()

- (instancetype)initWithSerializableCipherText:(seal::Serializable<seal::Ciphertext>)serializableCipherText;

@end
NS_ASSUME_NONNULL_END
