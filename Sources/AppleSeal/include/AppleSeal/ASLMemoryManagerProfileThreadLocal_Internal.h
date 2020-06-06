//
//  ASLMemoryManagerProfileThreadLocal_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-31.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLMemoryManagerProfile_Internal.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLMemoryManagerProfileThreadLocal (ASLMemoryManagerProfile_Internal) <ASLMemoryManagerProfile_Internal>

- (instancetype)initWithMMProfThreadLocal:(std::unique_ptr<seal::MMProfThreadLocal>)mmProfThreadLocal;

@end

NS_ASSUME_NONNULL_END
