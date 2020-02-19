//
//  ASLMemoryManagerProfileFixed_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-31.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLMemoryManagerProfile_Internal.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLMemoryManagerProfileFixed (ASLMemoryManagerProfile_Internal) <ASLMemoryManagerProfile_Internal>

- (instancetype)initWithMMProfFixed:(std::unique_ptr<seal::MMProfFixed>)mmProfFixed;

@end

NS_ASSUME_NONNULL_END
