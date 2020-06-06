//
//  ASLRelinearizationKeys_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-19.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLRelinearizationKeys.h"

#include "seal/relinkeys.h"
#include "seal/serializable.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLRelinearizationKeys ()

@property (nonatomic, assign, readonly) seal::RelinKeys sealRelinKeys;

- (instancetype)initWithRelinearizationKeys:(seal::RelinKeys)RelinearizationKeys;

@end

@interface ASLSerializableRelineraizationKeys ()

- (instancetype)initWithSerializableRelinearizationKey:(seal::Serializable<seal::RelinKeys>)serializableKeys;

@end


NS_ASSUME_NONNULL_END

