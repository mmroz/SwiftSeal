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

- (BOOL)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
                  parametersId:(ASLParametersIdType)parametersId
                         scale:(double)scale
                   destination:(ASLPlainText *)destination
                         error:(NSError **)error {
    NSParameterAssert(values != nil);
    NSParameterAssert(destination != nil);
    
    std::vector<double> doubleValuesList(static_cast<size_t>(values.count));
    for (NSNumber * const value in values) {
        doubleValuesList.push_back(value.doubleValue);
    }
    const std::vector<double> constDoubleValues = doubleValuesList;
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    auto sealPlainText = destination.sealPlainText;
    
    try {
        _ckksEncoder->encode(constDoubleValues, sealParametersId, scale, sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
                  parametersId:(ASLParametersIdType)parametersId
                         scale:(double)scale
                   destination:(ASLPlainText *)destination
                          pool:(ASLMemoryPoolHandle*)pool
                         error:(NSError **)error {
    NSParameterAssert(values != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    std::vector<double> doubleValuesList(static_cast<size_t>(values.count));
    for (NSNumber * const value in values) {
        doubleValuesList.push_back(value.doubleValue);
    }
    const std::vector<double> constDoubleValues = doubleValuesList;
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    auto sealPlainText = destination.sealPlainText;
    
    try {
        _ckksEncoder->encode(constDoubleValues, sealParametersId, scale, sealPlainText, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
                   parametersId:(ASLParametersIdType)parametersId
                          scale:(double)scale
                    destination:(ASLPlainText *)destination
                          error:(NSError **)error {
    NSParameterAssert(values != nil);
    NSParameterAssert(destination != nil);
    
    std::vector<std::complex<double>> doubleValuesList(static_cast<size_t>(values.count));
    for (ASLComplexType * const value in values) {
        doubleValuesList.push_back(value.complex);
    }
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    auto sealPlainText = destination.sealPlainText;
    
    try {
        _ckksEncoder->encode(doubleValuesList, sealParametersId, scale, sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
                   parametersId:(ASLParametersIdType)parametersId
                          scale:(double)scale
                    destination:(ASLPlainText *)destination
                           pool:(ASLMemoryPoolHandle *)pool
                          error:(NSError **)error {
    NSParameterAssert(values != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    std::vector<std::complex<double>> doubleValuesList(static_cast<size_t>(values.count));
    for (ASLComplexType * const value in values) {
        doubleValuesList.push_back(value.complex);
    }
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    auto sealPlainText = destination.sealPlainText;
    
    try {
        _ckksEncoder->encode(doubleValuesList, sealParametersId, scale, sealPlainText, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
                         scale:(double)scale
                   destination:(ASLPlainText *)destination
                         error:(NSError **)error {
    NSParameterAssert(values != nil);
    NSParameterAssert(destination != nil);
    
    std::vector<double> doubleValuesList(static_cast<size_t>(values.count));
    for (NSNumber * const value in values) {
        doubleValuesList.push_back(value.doubleValue);
    }
    const std::vector<double> constDoubleValues = doubleValuesList;
    
    auto sealPlainText = destination.sealPlainText;
    
    try {
        _ckksEncoder->encode(constDoubleValues, scale, sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
                         scale:(double)scale
                   destination:(ASLPlainText *)destination
                          pool:(ASLMemoryPoolHandle *)pool
                         error:(NSError **)error {
    NSParameterAssert(values != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    std::vector<double> doubleValuesList(static_cast<size_t>(values.count));
    for (NSNumber * const value in values) {
        doubleValuesList.push_back(value.doubleValue);
    }
    const std::vector<double> constDoubleValues = doubleValuesList;
    
    auto sealPlainText = destination.sealPlainText;
    
    try {
        _ckksEncoder->encode(constDoubleValues, scale, sealPlainText, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
                          scale:(double)scale
                    destination:(ASLPlainText *)destination
                          error:(NSError **)error {
    NSParameterAssert(values != nil);
    NSParameterAssert(destination != nil);
    
    std::vector<std::complex<double>> doubleValuesList(static_cast<size_t>(values.count));
    for (ASLComplexType * const value in values) {
        doubleValuesList.push_back(value.complex);
    }
    
    auto sealPlainText = destination.sealPlainText;
    
    try {
        _ckksEncoder->encode(doubleValuesList, scale, sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
                          scale:(double)scale
                    destination:(ASLPlainText *)destination
                           pool:(ASLMemoryPoolHandle *)pool
                          error:(NSError **)error {
    NSParameterAssert(values != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    std::vector<std::complex<double>> doubleValuesList(static_cast<size_t>(values.count));
    for (ASLComplexType * const value in values) {
        doubleValuesList.push_back(value.complex);
    }
    
    auto sealPlainText = destination.sealPlainText;
    
    try {
        _ckksEncoder->encode(doubleValuesList, scale, sealPlainText, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithDoubleValue:(double)value
                 parametersId:(ASLParametersIdType)parametersId
                        scale:(double)scale
                  destination:(ASLPlainText *)destination
                        error:(NSError **)error {
    NSParameterAssert(destination != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    auto sealPlainText = destination.sealPlainText;
    
    try {
        _ckksEncoder->encode(value, sealParametersId, scale, sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithDoubleValue:(double)value
                 parametersId:(ASLParametersIdType)parametersId
                        scale:(double)scale
                  destination:(ASLPlainText *)destination
                         pool:(ASLMemoryPoolHandle *)pool
                        error:(NSError **)error {
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    auto sealPlainText = destination.sealPlainText;
    
    try {
        _ckksEncoder->encode(value, sealParametersId, scale, sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithDoubleValue:(double)value
                        scale:(double)scale
                  destination:(ASLPlainText *)destination
                        error:(NSError **)error {
    NSParameterAssert(destination != nil);
    
    auto sealPlainText = destination.sealPlainText;
    try {
        _ckksEncoder->encode(value, scale, sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithDoubleValue:(double)value
                        scale:(double)scale
                  destination:(ASLPlainText *)destination
                         pool:(ASLMemoryPoolHandle *)pool
                        error:(NSError **)error {
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    auto sealPlainText = destination.sealPlainText;
    try {
        _ckksEncoder->encode(value, scale, sealPlainText, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithComplexValue:(ASLComplexType *)complexValue
                  parametersId:(ASLParametersIdType)parametersId
                         scale:(double)scale
                   destination:(ASLPlainText *)destination
                         error:(NSError **)error {
    NSParameterAssert(complexValue != nil);
    NSParameterAssert(destination != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    auto sealPlainText = destination.sealPlainText;
    
    try {
        _ckksEncoder->encode(complexValue.complex, sealParametersId, scale, sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithComplexValue:(ASLComplexType *)complexValue
                  parametersId:(ASLParametersIdType)parametersId
                         scale:(double)scale
                   destination:(ASLPlainText *)destination
                          pool:(ASLMemoryPoolHandle *)pool
                         error:(NSError **)error {
    NSParameterAssert(complexValue != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    auto sealPlainText = destination.sealPlainText;
    
    try {
        _ckksEncoder->encode(complexValue.complex, sealParametersId, scale, sealPlainText, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithComplexValue:(ASLComplexType *)complexValue
                         scale:(double)scale
                   destination:(ASLPlainText *)destination
                         error:(NSError **)error {
    NSParameterAssert(complexValue != nil);
    NSParameterAssert(destination != nil);
    
    auto sealPlainText = destination.sealPlainText;
    
    try {
        _ckksEncoder->encode(complexValue.complex, scale, sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithComplexValue:(ASLComplexType *)complexValue
                         scale:(double)scale
                   destination:(ASLPlainText *)destination
                          pool:(ASLMemoryPoolHandle *)pool
                         error:(NSError **)error {
    NSParameterAssert(complexValue != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    auto sealPlainText = destination.sealPlainText;
    
    try {
        _ckksEncoder->encode(complexValue.complex, scale, sealPlainText, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithLongValue:(NSDecimalNumber *)longValue
               parametersId:(ASLParametersIdType)parametersId
                destination:(ASLPlainText *)destination
                      error:(NSError **)error {
    NSParameterAssert(destination != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    auto sealPlainText = destination.sealPlainText;
    
    try {
        
        _ckksEncoder->encode(longValue.longValue, sealParametersId, sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithLongValue:(NSDecimalNumber *)longValue
                destination:(ASLPlainText *)destination
                      error:(NSError **)error {
    NSParameterAssert(destination != nil);
    
    auto sealPlainText = destination.sealPlainText;
    try {
        _ckksEncoder->encode(longValue.longValue, sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)decode:(ASLPlainText *)plainText
   destination:(NSArray<NSNumber *> *)destination
         error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    NSParameterAssert(destination != nil);
    
    std::vector<double> doubleValuesList(static_cast<size_t>(destination.count));
    for (NSNumber * const value in destination) {
        doubleValuesList.push_back(value.doubleValue);
    }
    const std::vector<double> constDoubleValues = doubleValuesList;
    
    auto const sealPlainText = plainText.sealPlainText;
    try {
        // TODO - fix this
        //_ckksEncoder->decode(sealPlainText, constDoubleValues)
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)decode:(ASLPlainText *)plainText
   destination:(NSArray<NSNumber *> *)destination
          pool:(ASLMemoryPoolHandle *)pool
         error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    NSParameterAssert(destination != nil);
    
    std::vector<std::uint64_t> destinationValues(static_cast<size_t>(destination.count));
    for (NSNumber * const value in destination) {
        destinationValues.push_back(value.intValue);
    }
    
    auto const sealPlainText = plainText.sealPlainText;
    try {
        // TODO - fix this
        //_ckksEncoder->decode(sealPlainText, destinationValues, pool.memoryPoolHandle)
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)decodeWithDoubleValues:(ASLPlainText *)plainText
                   destination:(NSArray<NSDecimalNumber *> *)destination
                         error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    NSParameterAssert(destination != nil);
    
    std::vector<std::uint64_t> destinationValues(static_cast<size_t>(destination.count));
    for (NSNumber * const value in destination) {
        destinationValues.push_back(value.intValue);
    }
    
    auto const sealPlainText = plainText.sealPlainText;
    try {
        // TODO - fix this
        //_ckksEncoder->decode(sealPlainText, destinationValues)
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
    
    return YES;
}
@end
