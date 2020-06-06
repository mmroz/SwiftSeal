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

+ (instancetype)nttTablesWithCoefficentCountPower:(int)coefficentCountPower
                                          modulus:(ASLModulus *)modulus
                                             pool:(ASLMemoryPoolHandle *)pool;

+ (instancetype)nttTablesWithCoefficentCountPower:(int)coefficentCountPower
                                          modulus:(ASLModulus *)modulus;

#pragma mark - Static Methods

+ (ASLNttTables * _Nullable)createWithCoefficentCountPower:(int)coefficentCountPower
                        modulus:(NSArray<ASLModulus *> *)modulus
                         tables:(ASLNttTables *)tables
                            pool:(ASLMemoryPoolHandle *)pool
                            error:(NSError **)error;

+ (ASLNttTables *)nttNegacyclicHarveyLazyWithOperand:(uint64_t)operand
                                              tables:(ASLNttTables *)tables;

+ (ASLNttTables *)nttNegacyclicHarveyWithOperand:(uint64_t)operand
                                              tables:(ASLNttTables *)tables;

+ (ASLNttTables *)inverseNttNegacyclicHarveyLazyWithOperand:(uint64_t)operand
                                              tables:(ASLNttTables *)tables;

+ (ASLNttTables *)inverseNttNegacyclicHarveyWithOperand:(uint64_t)operand
                                              tables:(ASLNttTables *)tables;

#pragma mark - Public Methods

-(NSNumber *)getFromRootPowersWithIndex:(NSNumber *)index;

-(NSNumber *)getFromScaledRootPowersWithIndex:(NSNumber *)index;

-(NSNumber *)getFromInverseRootPowersWithIndex:(NSNumber *)index;

-(NSNumber *)getFromScaledInverseRootPowersWithIndex:(NSNumber *)index;

-(NSNumber *)getInverseDegreeModulo;

#pragma mark - Properties

@property (nonatomic, readonly, readonly) NSNumber* root;

@property (nonatomic, readonly, readonly) ASLModulus* modulus;

@property (nonatomic, readonly, readonly) int coefficentCountPower;

@property (nonatomic, readonly, readonly) NSNumber * coefficentCount;

@end

NS_ASSUME_NONNULL_END
