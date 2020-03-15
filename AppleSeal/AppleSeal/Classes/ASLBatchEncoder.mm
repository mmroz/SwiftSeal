//
//  ASLBatchEncoder.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-10.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLBatchEncoder.h"

#include "seal/batchencoder.h"

#import "ASLEncryptionParameters.h"
#import "ASLSealContextData.h"
#import "ASLSealContextData_Internal.h"
#import "ASLSealContext_Internal.h"
#import "ASLEncryptionParameters_Internal.h"
#import "ASLPlainText_Internal.h"
#import "ASLMemoryPoolHandle_Internal.h"
#import "NSString+CXXAdditions.h"
#import "NSError+CXXAdditions.h"

NSString * const ASLBatchEncoderErrorDomain = @"ASLBatchEncodertErrorDomain";

@implementation ASLBatchEncoder {
    seal::BatchEncoder* _batchEncoder;
}

#pragma mark - Initialization

+ (instancetype)batchEncoderWithContext:(ASLSealContext *)context error:(NSError **)error {
    NSParameterAssert(context != nil);
    
    try {
        seal::BatchEncoder* batchEncoder = new seal::BatchEncoder(context.sealContext);
        return [[ASLBatchEncoder alloc] initWithBatchEncoder:batchEncoder];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}

- (instancetype)initWithBatchEncoder:(seal::BatchEncoder *)batchEncoder {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _batchEncoder = batchEncoder;
    
    return self;
}

- (void)dealloc {
    delete _batchEncoder;
    _batchEncoder = nullptr;
}

#pragma mark - Properties

- (size_t)slot_count {
    return _batchEncoder->slot_count();
}

#pragma mark - Public Methods

- (BOOL)encodeWithUnsignedValues:(NSArray<NSNumber *> *)unsignedValues destination:(ASLPlainText *)destination error:(NSError **)error {
    
    std::vector<std::uint64_t> valuesList(static_cast<size_t>(unsignedValues.count));
    for (NSNumber * const value in unsignedValues) {
        valuesList.push_back(value.intValue);
    }
    const std::vector<uint64_t> constValuesValues = valuesList;
    
    auto sealPlainText = destination.sealPlainText;
    
    try {
        _batchEncoder->encode(constValuesValues, sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithSignedValues:(NSArray<NSNumber *> *)signedValues destination:(ASLPlainText *)destination error:(NSError **)error {
    
    std::vector<std::uint64_t> valuesList(static_cast<size_t>(signedValues.count));
    for (NSNumber * const value in signedValues) {
        valuesList.push_back(value.intValue);
    }
    const std::vector<uint64_t> constValuesValues = valuesList;
    
    auto sealPlainText = destination.sealPlainText;
    
    try {
        _batchEncoder->encode(constValuesValues, sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithPlainText:(ASLPlainText*)plainText
                      error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    
    auto sealPlainText = plainText.sealPlainText;
    try {
        _batchEncoder->encode(sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)encodeWithPlainText:(ASLPlainText*)plainText
                       pool:(ASLMemoryPoolHandle *)pool
                      error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    NSParameterAssert(pool != nil);
    
    auto sealPlainText = plainText.sealPlainText;
    try {
        _batchEncoder->encode(sealPlainText, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)decodeWithPlainText:(ASLPlainText*)plainText
        unsignedDestination:(NSArray<NSNumber *>*)unsignedDestination
                      error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    NSParameterAssert(unsignedDestination != nil);
    
    std::vector<std::uint64_t> destinationValuesList(static_cast<size_t>(unsignedDestination.count));
    for (NSNumber * const value in unsignedDestination) {
        destinationValuesList.push_back(value.intValue);
    }
    
    auto sealPlainText = plainText.sealPlainText;
    
    try {
        _batchEncoder->decode(sealPlainText, destinationValuesList);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)decodeWithPlainText:(ASLPlainText*)plainText
          signedDestination:(NSArray<NSNumber *>*)signedDestination
                      error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    NSParameterAssert(signedDestination != nil);
    
    std::vector<std::uint64_t> destinationValuesList(static_cast<size_t>(signedDestination.count));
    for (NSNumber * const value in signedDestination) {
        destinationValuesList.push_back(value.intValue);
    }
    
    auto sealPlainText = plainText.sealPlainText;
    
    try {
        _batchEncoder->decode(sealPlainText, destinationValuesList);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}


- (BOOL)decodeWithPlainText:(ASLPlainText*)plainText
                      error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    
    auto sealPlainText = plainText.sealPlainText;
    
    try {
        _batchEncoder->decode(sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)decodeWithPlainText:(ASLPlainText*)plainText
                       pool:(ASLMemoryPoolHandle *)pool
                      error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    NSParameterAssert(pool != nil);
    
    auto sealPlainText = plainText.sealPlainText;
    
    try {
        _batchEncoder->decode(sealPlainText, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

@end