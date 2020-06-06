//
//  ASLGaloisKeys_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-19.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLGaloisKeys.h"

#include "seal/galoiskeys.h"
#include "seal/serializable.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLGaloisKeys ()

@property (nonatomic, assign, readonly) seal::GaloisKeys sealGaloisKeys;

- (instancetype)initWithGaloisKeys:(seal::GaloisKeys)sealGaloisKeys;

@end

@interface ASLSerializableGaloisKeys ()

- (instancetype)initWithSerializableGaloisKey:(seal::Serializable<seal::GaloisKeys>)serializableKeys;

@end

NS_ASSUME_NONNULL_END
