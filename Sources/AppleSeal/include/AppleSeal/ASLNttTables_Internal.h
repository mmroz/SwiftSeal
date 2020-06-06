//
//  ASLNttTables_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-04-21.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLNttTables.h"

#include "seal/util/ntt.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLNttTables ()

@property (nonatomic, assign, readonly) seal::util::NTTTables * sealNttTables;

- (instancetype)initWithNttTables:(seal::util::NTTTables *)NttTables
freeWhenDone:(BOOL)freeWhenDone;

@end

NS_ASSUME_NONNULL_END
