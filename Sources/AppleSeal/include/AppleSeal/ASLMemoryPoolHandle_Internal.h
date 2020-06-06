//
//  ASLMemoryPoolHandle_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLMemoryPoolHandle.h"

#include "seal/memorymanager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLMemoryPoolHandle ()

@property (nonatomic, assign, readonly) seal::MemoryPoolHandle memoryPoolHandle;

- (instancetype)initWithMemoryPoolHandle:(seal::MemoryPoolHandle)memoryPoolHandle;

@end

NS_ASSUME_NONNULL_END
