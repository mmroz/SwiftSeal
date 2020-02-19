//
//  ASLKSwitchKeys.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-12.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLPublicKey.h"
#import "ASLParametersIdType.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLKSwitchKeys : NSObject <NSCopying, NSCoding>

@property (nonatomic, readonly, assign) size_t size;

@property (nonatomic, readonly, assign) NSArray<NSArray<ASLPublicKey*>*>* data;

@property (nonatomic, readonly, assign) ASLParametersIdType parametersId;

@property (nonatomic, readonly, assign) ASLMemoryPoolHandle * pool;

// TODO - handle saving

@end

NS_ASSUME_NONNULL_END
