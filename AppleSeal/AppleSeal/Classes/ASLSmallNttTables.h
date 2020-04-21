//
//  ASLSmallNttTables.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-04-21.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLSmallModulus.h"
#import "ASLMemoryPoolHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLSmallNttTables : NSObject

+ (instancetype)smallNttTablesWithPool:(ASLMemoryPoolHandle *)pool;

+ (instancetype)smallNttTablesWithCoefficentCountPower:(int)coefficentCountPower
                                          smallModulus:(ASLSmallModulus *)smallModulus
                                                  pool:(ASLMemoryPoolHandle *)pool;

+ (instancetype)smallNttTablesWithCoefficentCountPower:(int)coefficentCountPower
                                          smallModulus:(ASLSmallModulus *)smallModulus;

-(BOOL)generate:(int)coefficentCountPower
   smallModulus:(ASLSmallModulus *)smallModulus;

-(void)reset;

-(NSNumber *)getFromRootPowersWithIndex:(NSNumber *)index;

-(NSNumber *)getFromScaledRootPowersWithIndex:(NSNumber *)index;

-(NSNumber *)getFromInverseRootPowersWithIndex:(NSNumber *)index;

-(NSNumber *)getFromScaledInverseRootPowersWithIndex:(NSNumber *)index;

-(NSNumber *)getFromScaledInverseRootPowersDividedByTwoWithIndex:(NSNumber *)index;

-(NSNumber *)getFromInverseRootPowersDividedByTwoWithIndex:(NSNumber *)index;

-(NSNumber *)getInverseDegreeModulo;

@property (nonatomic, readonly, readonly) NSNumber* root;

@property (nonatomic, readonly, readonly) ASLSmallModulus* modulus;

@property (nonatomic, readonly, readonly) int coefficentCountPower;

@property (nonatomic, readonly, readonly) NSNumber * coefficentCount;

@end

NS_ASSUME_NONNULL_END
