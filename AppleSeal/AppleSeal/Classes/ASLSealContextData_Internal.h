//
//  ASLSealContextData_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLSealContextData.h"

#include "seal/context.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLSealContextData ()

- (instancetype)initWithSEALContextData:(std::shared_ptr<const seal::SEALContext::ContextData>)contextData;

@end

NS_ASSUME_NONNULL_END
