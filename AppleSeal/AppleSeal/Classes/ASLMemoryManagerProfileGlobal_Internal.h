//
//  ASLMemoryManagerProfileGlobal_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-31.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLMemoryManagerProfile_Internal.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLMemoryManagerProfileGlobal (ASLMemoryManagerProfile_Internal) <ASLMemoryManagerProfile_Internal>

- (instancetype)initWithMMProfGlobal:(std::unique_ptr<seal::MMProfGlobal>)mmProfGlobal;

@end

NS_ASSUME_NONNULL_END
