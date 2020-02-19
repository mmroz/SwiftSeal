//
//  ASLSealContextData.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLEncryptionParameters.h"
#import "ASLParametersIdType.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLSealContextData : NSObject

// TODO - uh oh this isnt good
//+ (instancetype)new NS_UNAVAILABLE;
//- (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, readonly, readonly) ASLEncryptionParameters* encryptionParameters;

@property (nonatomic, readonly, assign) ASLParametersIdType parametersId;

//TODO - add this once ASLEncryptionParameterQualifiers exists
//@property (nonatomic, assign, readonly) ASLEncryptionParameterQualifiers* qualifiers;

@property (nonatomic, assign, readonly) const uint64_t* totalCoefficientModulus;

@property (nonatomic, assign, readonly) NSInteger totalCoefficientModulusBitCount;

@property (nonatomic, assign, readonly) const uint64_t* coefficientDividedPlainModulus;

@property (nonatomic, assign, readonly) NSInteger plainUpperHalfThreshold;

@property (nonatomic, assign, readonly) const uint64_t* plainUpperHalfIncrement;

@property (nonatomic, assign, readonly) NSInteger upperHalfThreshold;

@property (nonatomic, assign, readonly) const uint64_t* upperHalfIncrement;

@property (nonatomic, assign, readonly) ASLSealContextData* previousContextData;

@property (nonatomic, assign, readonly) ASLSealContextData* nextContextData;

@property (nonatomic, assign, readonly) NSInteger chainIndex;

@end

NS_ASSUME_NONNULL_END
