//
//  ASLSmallNttTables_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-04-21.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLSmallNttTables.h"

#include "seal/util/smallntt.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLSmallNttTables ()

- (instancetype)initWithSmallNttTables:(const seal::util::SmallNTTTables *)smallNttTables;

@end

NS_ASSUME_NONNULL_END
