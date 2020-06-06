//
//  ASLBaseConverter_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-04-21.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//


#import "ASLBaseConverter.h"

#include "seal/util/rns.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLBaseConverter ()

- (instancetype)initWithBaseConverter:(seal::util::BaseConverter *)baseConverter freeWhenDone:(BOOL)freeWhenDone;

@property (nonatomic, assign, readonly) seal::util::BaseConverter * baseConverter;

@end

NS_ASSUME_NONNULL_END
