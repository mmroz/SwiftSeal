//
//  ASLBaseConverter_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-04-21.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//


#import "ASLBaseConverter.h"

#include "seal/util/baseconverter.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLBaseConverter ()

- (instancetype)initWithBaseConverter:(const seal::util::BaseConverter *)baseConverter freeWhenDone:(BOOL)freeWhenDone;

@end

NS_ASSUME_NONNULL_END
