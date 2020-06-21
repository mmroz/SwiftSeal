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
#import "NSError+CXXAdditions.h"

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

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"{slotCount: %zu}", [self slotCount]];
}

#pragma mark - Properties

- (size_t)slotCount {
    return _batchEncoder->slot_count();
}

#pragma mark - Public Methods

- (ASLPlainText *)encodeWithUnsignedValues:(NSArray<NSNumber *> *)unsignedValues
                                     error:(NSError **)error {
    NSParameterAssert(unsignedValues != nil);
    
    std::vector<std::uint64_t> valuesList;
    for (NSNumber * const value in unsignedValues) {
        valuesList.push_back(value.intValue);
    }
    const std::vector<uint64_t> constValuesValues = valuesList;
    
    seal::Plaintext sealPlainText = seal::Plaintext();
    
    try {
        _batchEncoder->encode(constValuesValues, sealPlainText);
        return [[ASLPlainText alloc] initWithPlainText:sealPlainText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithSignedValues:(NSArray<NSNumber *> *)signedValues
                                   error:(NSError **)error {
    
    NSParameterAssert(signedValues != nil);
    
    std::vector<std::uint64_t> valuesList;
    for (NSNumber * const value in signedValues) {
        valuesList.push_back(value.intValue);
    }
    const std::vector<uint64_t> constValuesValues = valuesList;
    
    seal::Plaintext sealPlainText = seal::Plaintext();
    
    try {
        _batchEncoder->encode(constValuesValues, sealPlainText);
        return [[ASLPlainText alloc] initWithPlainText:sealPlainText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithPlainText:(ASLPlainText*)plainText
                                error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    seal::Plaintext sealPlainText = plainText.sealPlainText;
    try {
        _batchEncoder->encode(sealPlainText);
        return [[ASLPlainText alloc]initWithPlainText:sealPlainText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText *)encodeWithPlainText:(ASLPlainText*)plainText
                                 pool:(ASLMemoryPoolHandle *)pool
                                error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    NSParameterAssert(pool != nil);
    
    seal::Plaintext sealPlainText = plainText.sealPlainText;
    try {
        _batchEncoder->encode(sealPlainText, pool.memoryPoolHandle);
        return [[ASLPlainText alloc]initWithPlainText:sealPlainText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (NSArray<NSNumber *> *)decodeUnsignedValuesWithPlainText:(ASLPlainText*)plainText
                                                     error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    
    std::vector<std::uint64_t> destinationValuesList = {};
    
    try {
        _batchEncoder->decode(plainText.sealPlainText, destinationValuesList);
        NSMutableArray<NSNumber *> * results = [[NSMutableArray alloc] initWithCapacity:destinationValuesList.size()];
        for (std::uint64_t & value : destinationValuesList) {
            [results addObject:@(value)];
        }
        return results;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (NSArray<NSNumber *> *)decodeSignedValuesWithPlainText:(ASLPlainText*)plainText
                                                   error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    
    std::vector<std::uint64_t> destinationValuesList;
    
    try {
        _batchEncoder->decode(plainText.sealPlainText, destinationValuesList);
        NSMutableArray<NSNumber *> * results = [[NSMutableArray alloc] initWithCapacity:destinationValuesList.size()];
        for (std::uint64_t & value : destinationValuesList) {
            [results addObject:[[NSNumber alloc]initWithFloat:value]];
        }
        return results;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}


- (ASLPlainText*)decodeWithPlainText:(ASLPlainText*)plainText
                               error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    
    seal::Plaintext sealPlainText = plainText.sealPlainText;
    
    try {
        _batchEncoder->decode(sealPlainText);
        return [[ASLPlainText alloc]initWithPlainText:sealPlainText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLPlainText*)decodeWithPlainText:(ASLPlainText*)plainText
                                pool:(ASLMemoryPoolHandle *)pool
                               error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    NSParameterAssert(pool != nil);
    
    seal::Plaintext sealPlainText = plainText.sealPlainText;
    
    try {
        _batchEncoder->decode(sealPlainText, pool.memoryPoolHandle);
        return [[ASLPlainText alloc]initWithPlainText:sealPlainText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

@end
