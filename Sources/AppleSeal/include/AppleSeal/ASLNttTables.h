//
//  ASLNttTables.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-04-21.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLModulus.h"
#import "ASLMemoryPoolHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLNttTables : NSObject

#pragma mark - Initilization

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (instancetype _Nullable)nttTablesWithCoefficentCountPower:(int)coefficentCountPower
                                          modulus:(ASLModulus *)modulus
                                             pool:(ASLMemoryPoolHandle *)pool
                                            error:(NSError **)error;

+ (instancetype _Nullable)nttTablesWithCoefficentCountPower:(int)coefficentCountPower
                                          modulus:(ASLModulus *)modulus
                                            error:(NSError **)error;

#pragma mark - Static Methods

+ (ASLNttTables * _Nullable)createWithCoefficentCountPower:(int)coefficentCountPower
                        modulus:(NSArray<ASLModulus *> *)modulus
                         tables:(ASLNttTables *)tables
                            pool:(ASLMemoryPoolHandle *)pool
                            error:(NSError **)error;

#pragma mark - Public Methods

-(NSNumber *)getFromRootPowersWithIndex:(NSInteger)index;

-(NSNumber *)getFromScaledRootPowersWithIndex:(NSInteger)index;

-(NSNumber *)getFromInverseRootPowersWithIndex:(NSInteger)index;

-(NSNumber *)getFromScaledInverseRootPowersWithIndex:(NSInteger)index;

-(NSNumber *)getInverseDegreeModulo;

- (void)negacyclicHarveyWithOperand:(uint64_t)operand;

- (void)negacyclicHarveyLazyWithOperand:(uint64_t)operand;

- (void)inverseNegacyclicHarveyWithOperand:(uint64_t)operand;

- (void)inverseNegacyclicHarveyLazyWithOperand:(uint64_t)operand;

#pragma mark - Properties

@property (nonatomic, readonly, readonly) NSNumber* root;

@property (nonatomic, readonly, readonly) ASLModulus* modulus;

@property (nonatomic, readonly, readonly) int coefficentCountPower;

@property (nonatomic, readonly, readonly) NSNumber * coefficentCount;

@end

NS_ASSUME_NONNULL_END
