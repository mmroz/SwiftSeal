//
//  ASLBaseConverter.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-04-21.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLModulus.h"
#import "ASLMemoryPoolHandle.h"
#import "ASLRnsBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLBaseConverter : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

# pragma mark - Initialization

+ (instancetype _Nullable)baseConverterWithPool:(ASLMemoryPoolHandle *)pool
                                iBase:(ASLRnsBase *)iBase
                                oBase:(ASLRnsBase *)oBase
                                error:(NSError **)error;

# pragma mark - Properties

@property (nonatomic, readonly, assign) size_t iBaseSize;

@property (nonatomic, readonly, assign) size_t oBaseSize;

@property (nonatomic, readonly, assign) ASLRnsBase* iBase;

@property (nonatomic, readonly, assign) ASLRnsBase* oBase;

-(NSNumber *)fastConvert:(NSNumber*)input
                  output:(NSNumber*)output
                    pool:(ASLMemoryPoolHandle *)pool;

-(NSNumber *)fastConvertArray:(NSNumber*)input
                    size:(size_t)size
                       output:(NSNumber*)output
                         pool:(ASLMemoryPoolHandle *)pool;

@end

NS_ASSUME_NONNULL_END
