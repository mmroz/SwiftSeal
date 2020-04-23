//
//  ASLBaseConverter.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-04-21.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLSmallModulus.h"
#import "ASLMemoryPoolHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLBaseConverter : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)baseConverterWithPool:(ASLMemoryPoolHandle *)pool;

+ (instancetype)baseConverterWithModuluses:(NSArray<ASLSmallModulus *>*)moduluses
                          coefficientCount:(NSNumber *)coefficientCount
                         smallPlainModulus:(ASLSmallModulus *)smallPlainModulus
                                      pool:(ASLMemoryPoolHandle *)pool;

-(void)generate:(NSArray<ASLSmallModulus *>*)coefficientBase
coefficientCount:(NSNumber *)coefficientCount
smallPlainModulus:(ASLSmallModulus *)smallPlainModulus;

-(void)floorLastCoefficientModulusInplace:(NSNumber *)rnsPoly
                                     pool:(ASLMemoryPoolHandle *)pool;

// TODO - fix this
// floor_last_coeff_modulus_ntt_inplace

-(void)roundLastCoefficientModulusInplace:(NSNumber *)rnsPoly
                                     pool:(ASLMemoryPoolHandle *)pool;

// TODO - fix this
// round_last_coeff_modulus_ntt_inplace

/*!
 Fast base converter from q to Bsk
 */
-(void)fastBaseConverterQToBsk:(NSNumber *)input
                   destination:(NSNumber *)destination
                          pool:(ASLMemoryPoolHandle *)pool;

/*!
 Fast base converter from Bsk to q
 */
-(void)fastBaseConverterBskToQ:(NSNumber *)input
                   destination:(NSNumber *)destination
                          pool:(ASLMemoryPoolHandle *)pool;

/*!
 Reduction from Bsk U {m_tilde} to Bsk
 */
-(void)reduceBskPrimeToBsk:(NSNumber *)input
               destination:(NSNumber *)destination;

/*!
 Fast base converter from q U Bsk to Bsk
 */
-(void)fastFloor:(NSNumber *)input
     destination:(NSNumber *)destination
            pool:(ASLMemoryPoolHandle *)pool;

/*!
 Fast base converter from q to Bsk U {m_tilde}
 */
-(void)fastFloorFastBaseConverterQToBskPrime:(NSNumber *)input
                                 destination:(NSNumber *)destination
                                        pool:(ASLMemoryPoolHandle *)pool;

/*!
 Fast base converter from q to plain_modulus U {gamma}
 */
-(void)fastBaseConverterPlainGamma:(NSNumber *)input
                       destination:(NSNumber *)destination
                              pool:(ASLMemoryPoolHandle *)pool;

-(void)reset;

@property (nonatomic, readonly, assign, getter=isGenerated) BOOL generated;

@property (nonatomic, readonly, assign) NSNumber* coefficientBaseMododulusCount;

@property (nonatomic, readonly, assign) NSNumber* auxBaseModCount;

// TODO - Pointer
//@property (nonatomic, readonly, assign) NSNumber* plainGammaProduct;

// TODO - Pointer
// @property (nonatomic, readonly, assign) NSNumber* negativeInverseCoefficient;

// TODO - Pointer
//@property (nonatomic, readonly, assign) NSNumber* plainGammaArray;

// TODO - Pointer
//@property (nonatomic, readonly, assign) NSNumber* coefficientProductsArray;

@property (nonatomic, readonly, assign) NSNumber* invertedGamma;

// TODO - Pointer
//@property (nonatomic, readonly, assign) NSNumber* bskSmallNttTables;

// TODO - Pointer
//@property (nonatomic, readonly, assign) NSNumber* bskBaseModCount;

// TODO - Pointer
//@property (nonatomic, readonly, assign) NSNumber* bskModArray;

@property (nonatomic, readonly, assign) ASLSmallModulus* msk;

@property (nonatomic, readonly, assign) ASLSmallModulus* mPrime;

@property (nonatomic, readonly, assign) NSNumber* mPrimeInverseCoefficientProductsModulusCoefficient;

@property (nonatomic, readonly, assign) NSNumber* inverseCoefficientModulusMPrime;

// TODO - Pointer
//@property (nonatomic, readonly, assign) NSNumber* inverseCoefficientModulusCoefficientArray;

// TODO - Pointer
//@property (nonatomic, readonly, assign) NSNumber* inverseLastCoefficientModulusArray;

// TODO - Pointer
//@property (nonatomic, readonly, assign) NSNumber* coefficientBaseProductsModdulusMsk;

@end

NS_ASSUME_NONNULL_END
