//
//  ASLRnsBase.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-05-15.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLModulus.h"
#import "ASLMemoryPoolHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLRnsBase : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

# pragma mark - Initialization

+ (instancetype)rnsBaseWithModuluses:(NSArray<ASLModulus *> *)moduluses
                                      pool:(ASLMemoryPoolHandle *)pool;;

# pragma mark - Public Methods

-(ASLRnsBase *)getAtIndex:(size_t)index;

-(BOOL)contains:(ASLModulus *)modulus;

-(BOOL)isSubBaseOf:(ASLRnsBase *)subBase;

-(BOOL)isSuperBaseOf:(ASLRnsBase *)superBase;

-(BOOL)isProperSubBaseOf:(ASLRnsBase *)subBase;

-(BOOL)isProperSuperBaseOf:(ASLRnsBase *)superBase;

-(ASLRnsBase *)extendWithModulus:(ASLModulus *)modulus;

-(ASLRnsBase *)extendWithRnsBase:(ASLRnsBase *)rnsBase;

-(ASLRnsBase *)dropWithModulus:(ASLModulus *)modulus;

-(ASLRnsBase *)drop;

-(NSNumber *)decomposeValue:(NSNumber *)value
                 pool:(ASLMemoryPoolHandle *)pool;

-(NSNumber *)decomposeArrayValue:(NSNumber *)value
                     count:(size_t)count
                      pool:(ASLMemoryPoolHandle *)pool;

-(NSNumber *)composeValue:(NSNumber *)value
                 pool:(ASLMemoryPoolHandle *)pool;

-(NSNumber *)composeArrayValue:(NSNumber *)value
                     count:(size_t)count
                      pool:(ASLMemoryPoolHandle *)pool;

# pragma mark - Properties

@property (nonatomic, readonly, assign) size_t size;

@property (nonatomic, readonly, assign) ASLModulus* base;

@property (nonatomic, readonly, assign) NSNumber* baseProd;

@property (nonatomic, readonly, assign) NSNumber* puncturedProdArray;

@property (nonatomic, readonly, assign) NSNumber* inversePuncturedProdModulusBaseArray;

@end

NS_ASSUME_NONNULL_END
