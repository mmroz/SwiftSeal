//
//  ASLCKKSEncoder.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-05.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLCKKSEncoder.h"

#include "seal/ckks.h"

#import "ASLSealContext_Internal.h"
#import "ASLPlainText_Internal.h"
#import "ASLMemoryPoolHandle_Internal.h"
#import "ASLComplexType_Internal.h"
#import "ASLComplexType.h"
#import "NSString+CXXAdditions.h"
#import "NSError+CXXAdditions.h"

@implementation ASLCKKSEncoder {
    std::shared_ptr<seal::CKKSEncoder> _ckksEncoder;
}

#pragma mark - Initialization

+ (instancetype)ckksEncoderWithContext:(ASLSealContext *)context error:(NSError **)error {
    NSParameterAssert(context != nil);
    
    try {
        return [[ASLCKKSEncoder alloc] initWithCkksEncoder:seal::CKKSEncoder(context.sealContext)];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
    
    
}

- (instancetype)initWithCkksEncoder:(seal::CKKSEncoder)ckksEncoder {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _ckksEncoder = std::make_shared<seal::CKKSEncoder>(std::move(ckksEncoder));
    
    return self;
}

#pragma mark - Properties

- (size_t)slotCount {
    return _ckksEncoder->slot_count();
}

#pragma mark - Public Methods

- (ASLPlainText *)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
                            parametersId:(ASLParametersIdType)parametersId
                                   scale:(double)scale
                                   error:(NSError **)error {
    NSParameterAssert(values != nil);
    
    std::vector<double> doubleValuesList;
    for (NSNumber * const value in values) {
        doubleValuesList.push_back(value.doubleValue);
    }
    const std::vector<double> constDoubleValues = doubleValuesList;
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Plaintext destination = seal::Plaintext();
    
    try {
        _ckksEncoder->encode(constDoubleValues, sealParametersId, scale, destination);
        return [[ASLPlainText alloc] initWithPlainText:destination];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
                            parametersId:(ASLParametersIdType)parametersId
                                   scale:(double)scale
                                    pool:(ASLMemoryPoolHandle*)pool
                                   error:(NSError **)error {
    NSParameterAssert(values != nil);
    NSParameterAssert(pool != nil);
    
    std::vector<double> doubleValuesList;
    for (NSNumber * const value in values) {
        doubleValuesList.push_back(value.doubleValue);
    }
    const std::vector<double> constDoubleValues = doubleValuesList;
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Plaintext destination = seal::Plaintext();
    
    try {
        _ckksEncoder->encode(constDoubleValues, sealParametersId, scale, destination, pool.memoryPoolHandle);
        return [[ASLPlainText alloc] initWithPlainText:destination];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
                             parametersId:(ASLParametersIdType)parametersId
                                    scale:(double)scale
                                    error:(NSError **)error {
    NSParameterAssert(values != nil);
    
    std::vector<std::complex<double>> doubleValuesList;
    for (ASLComplexType * const value in values) {
        doubleValuesList.push_back(value.complex);
    }
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Plaintext destination = seal::Plaintext();
    
    try {
        _ckksEncoder->encode(doubleValuesList, sealParametersId, scale, destination);
        return [[ASLPlainText alloc] initWithPlainText:destination];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
                             parametersId:(ASLParametersIdType)parametersId
                                    scale:(double)scale
                                     pool:(ASLMemoryPoolHandle *)pool
                                    error:(NSError **)error {
    NSParameterAssert(values != nil);
    NSParameterAssert(pool != nil);
    
    std::vector<std::complex<double>> doubleValuesList;
    for (ASLComplexType * const value in values) {
        doubleValuesList.push_back(value.complex);
    }
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Plaintext destination = seal::Plaintext();
    
    try {
        _ckksEncoder->encode(doubleValuesList, sealParametersId, scale, destination, pool.memoryPoolHandle);
        return [[ASLPlainText alloc] initWithPlainText:destination];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
                                   scale:(double)scale
                                   error:(NSError **)error {
    NSParameterAssert(values != nil);
    
    std::vector<double> doubleValuesList;
    for (NSNumber * const value in values) {
        doubleValuesList.push_back(value.doubleValue);
    }
    const std::vector<double> constDoubleValues = doubleValuesList;
    
    seal::Plaintext destination = seal::Plaintext();
    
    try {
        _ckksEncoder->encode(constDoubleValues, scale, destination);
        return [[ASLPlainText alloc] initWithPlainText:destination];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
                                   scale:(double)scale
                                    pool:(ASLMemoryPoolHandle *)pool
                                   error:(NSError **)error {
    NSParameterAssert(values != nil);
    NSParameterAssert(pool != nil);
    
    std::vector<double> doubleValuesList;
    for (NSNumber * const value in values) {
        doubleValuesList.push_back(value.doubleValue);
    }
    const std::vector<double> constDoubleValues = doubleValuesList;
    
    seal::Plaintext destination = seal::Plaintext();
    
    try {
        _ckksEncoder->encode(constDoubleValues, scale, destination, pool.memoryPoolHandle);
        return [[ASLPlainText alloc] initWithPlainText:destination];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
                                    scale:(double)scale
                                    error:(NSError **)error {
    NSParameterAssert(values != nil);

    std::vector<std::complex<double>> doubleValuesList;
    for (ASLComplexType * const value in values) {
        doubleValuesList.push_back(value.complex);
    }
    
    seal::Plaintext destination = seal::Plaintext();
    
    try {
        _ckksEncoder->encode(doubleValuesList, scale, destination);
        return [[ASLPlainText alloc] initWithPlainText:destination];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
                                    scale:(double)scale
                              
                                     pool:(ASLMemoryPoolHandle *)pool
                                    error:(NSError **)error {
    NSParameterAssert(values != nil);
    
    NSParameterAssert(pool != nil);
    
    std::vector<std::complex<double>> doubleValuesList;
    for (ASLComplexType * const value in values) {
        doubleValuesList.push_back(value.complex);
    }
    
    seal::Plaintext destination = seal::Plaintext();
    
    try {
        _ckksEncoder->encode(doubleValuesList, scale, destination, pool.memoryPoolHandle);
        return [[ASLPlainText alloc] initWithPlainText:destination];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithDoubleValue:(double)value
                           parametersId:(ASLParametersIdType)parametersId
                                  scale:(double)scale
                            
                                  error:(NSError **)error {
    
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Plaintext destination = seal::Plaintext();
    
    try {
        _ckksEncoder->encode(value, sealParametersId, scale, destination);
        return [[ASLPlainText alloc] initWithPlainText:destination];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithDoubleValue:(double)value
                           parametersId:(ASLParametersIdType)parametersId
                                  scale:(double)scale
                            
                                   pool:(ASLMemoryPoolHandle *)pool
                                  error:(NSError **)error {
    
    NSParameterAssert(pool != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Plaintext destination = seal::Plaintext();
    
    try {
        _ckksEncoder->encode(value, sealParametersId, scale, destination);
        return [[ASLPlainText alloc] initWithPlainText:destination];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithDoubleValue:(double)value
                                  scale:(double)scale
                            
                                  error:(NSError **)error {
    
    
    seal::Plaintext destination = seal::Plaintext();
    try {
        _ckksEncoder->encode(value, scale, destination);
        return [[ASLPlainText alloc] initWithPlainText:destination];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithDoubleValue:(double)value
                                  scale:(double)scale
                            
                                   pool:(ASLMemoryPoolHandle *)pool
                                  error:(NSError **)error {
    
    NSParameterAssert(pool != nil);
    
    seal::Plaintext destination = seal::Plaintext();
    
    try {
        _ckksEncoder->encode(value, scale, destination, pool.memoryPoolHandle);
        return [[ASLPlainText alloc] initWithPlainText:destination];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithComplexValue:(ASLComplexType *)complexValue
                            parametersId:(ASLParametersIdType)parametersId
                                   scale:(double)scale
                                   error:(NSError **)error {
    NSParameterAssert(complexValue != nil);
    
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Plaintext destination = seal::Plaintext();
    
    try {
        _ckksEncoder->encode(complexValue.complex, sealParametersId, scale, destination);
        return [[ASLPlainText alloc] initWithPlainText:destination];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithComplexValue:(ASLComplexType *)complexValue
                            parametersId:(ASLParametersIdType)parametersId
                                   scale:(double)scale
                                    pool:(ASLMemoryPoolHandle *)pool
                                   error:(NSError **)error {
    NSParameterAssert(complexValue != nil);
    
    NSParameterAssert(pool != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Plaintext destination = seal::Plaintext();
    
    try {
        _ckksEncoder->encode(complexValue.complex, sealParametersId, scale, destination, pool.memoryPoolHandle);
        return [[ASLPlainText alloc] initWithPlainText:destination];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithComplexValue:(ASLComplexType *)complexValue
                                   scale:(double)scale
                                   error:(NSError **)error {
    NSParameterAssert(complexValue != nil);
    
    
    seal::Plaintext destination = seal::Plaintext();
    
    try {
        _ckksEncoder->encode(complexValue.complex, scale, destination);
        return [[ASLPlainText alloc] initWithPlainText:destination];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithComplexValue:(ASLComplexType *)complexValue
                                   scale:(double)scale
                                    pool:(ASLMemoryPoolHandle *)pool
                                   error:(NSError **)error {
    NSParameterAssert(complexValue != nil);
    NSParameterAssert(pool != nil);
    
    seal::Plaintext destination = seal::Plaintext();
    
    try {
        _ckksEncoder->encode(complexValue.complex, scale, destination, pool.memoryPoolHandle);
        return [[ASLPlainText alloc] initWithPlainText:destination];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithLongValue:(NSDecimalNumber *)longValue
                         parametersId:(ASLParametersIdType)parametersId
                                error:(NSError **)error {
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Plaintext destination = seal::Plaintext();
    
    try {
        _ckksEncoder->encode(longValue.longValue, sealParametersId, destination);
        return [[ASLPlainText alloc] initWithPlainText:destination];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithLongValue:(NSDecimalNumber *)longValue
                                error:(NSError **)error {
    
    seal::Plaintext destination = seal::Plaintext();
    
    try {
        _ckksEncoder->encode(longValue.longValue, destination);
        return [[ASLPlainText alloc] initWithPlainText:destination];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (NSArray<NSNumber *> *)decodeDoubleValues:(ASLPlainText *)plainText
                                      error:(NSError **)error {
    std::vector<double> doubleList = {};
    try {
        _ckksEncoder->decode(plainText.sealPlainText, doubleList);
        NSMutableArray<NSNumber *> * const result = [NSMutableArray arrayWithCapacity:doubleList.size()];
        for (double value : doubleList) {
            [result addObject:@(value)];
        }
        return result;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}
    
-(NSArray<ASLComplexType *> *)decodeComplexDoubleValues:(ASLPlainText *)plainText
                                                  error:(NSError **)error {
    std::vector<std::complex<double>> doubleList = {};
    try {
        _ckksEncoder->decode(plainText.sealPlainText, doubleList);
        NSMutableArray<ASLComplexType *> * const result = [NSMutableArray arrayWithCapacity:doubleList.size()];
        for (std::complex<double> value : doubleList) {
            ASLComplexType * complexValue = [[ASLComplexType alloc] initWithReal:value.real() imaginary:value.imag()];
            [result addObject:complexValue];
        }
        return result;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}

- (NSArray<NSNumber *> *)decodeDoubleValues:(ASLPlainText *)plainText
                                       pool:(ASLMemoryPoolHandle *)pool
                                      error:(NSError **)error {
    std::vector<double> doubleList = {};
    try {
        _ckksEncoder->decode(plainText.sealPlainText, doubleList, pool.memoryPoolHandle);
        NSMutableArray<NSNumber *> * const result = [NSMutableArray arrayWithCapacity:doubleList.size()];
        for (double value : doubleList) {
            [result addObject:@(value)];
        }
        return result;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}

-(NSArray<ASLComplexType *> *)decodeComplexDoubleValues:(ASLPlainText *)plainText
                                                   pool:(ASLMemoryPoolHandle *)pool
                                                  error:(NSError **)error {
    std::vector<std::complex<double>> doubleList = {};
    try {
        _ckksEncoder->decode(plainText.sealPlainText, doubleList, pool.memoryPoolHandle);
        NSMutableArray<ASLComplexType *> * const result = [NSMutableArray arrayWithCapacity:doubleList.size()];
        for (std::complex<double> value : doubleList) {
            ASLComplexType * complexValue = [[ASLComplexType alloc] initWithReal:value.real() imaginary:value.imag()];
            [result addObject:complexValue];
        }
        return result;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}
@end
