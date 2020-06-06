//
//  ASLPlainText.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-01.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLPlainText.h"

#include <string>
#include <stdexcept>
#include "seal/plaintext.h"

#import "NSString+CXXAdditions.h"

#import "ASLMemoryPoolHandle.h"
#import "ASLMemoryPoolHandle_Internal.h"
#import "ASLPlainText_Internal.h"
#import "ASLSealContext_Internal.h"
#import "NSError+CXXAdditions.h"

@implementation ASLPlainText {
    seal::Plaintext _plainText;
}

#pragma mark - Initialization

+ (instancetype _Nullable)plainTextWithPolynomialString:(NSString *)polynomialString
                                                   pool:(ASLMemoryPoolHandle *)pool
                                                  error:(NSError **)error {
    NSParameterAssert(polynomialString != nil);
    
    std::string const polynomialValueString = (polynomialString.length > 0
                                               ? polynomialString.stdString
                                               : "");
    try {
        seal::Plaintext const plainText = seal::Plaintext(polynomialValueString, pool.memoryPoolHandle);
        return [[ASLPlainText alloc] initWithPlainText:plainText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}

+ (instancetype _Nullable)plainTextWithPolynomialString:(NSString *)polynomialString
                                                  error:(NSError **)error {
    NSParameterAssert(polynomialString != nil);
    
    std::string const polynomialValueString = (polynomialString.length > 0
                                               ? polynomialString.stdString
                                               : "");
    try {
        seal::Plaintext const plainText = seal::Plaintext(polynomialValueString);
        return [[ASLPlainText alloc] initWithPlainText:plainText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}

+ (instancetype)plainTextWithCapacity:(size_t)capacity
                     coefficientCount:(size_t)coefficientCount
                                 pool:(ASLMemoryPoolHandle *)pool
                                error:(NSError **)error {
    try {
        seal::Plaintext const plainText = seal::Plaintext(capacity, coefficientCount, pool.memoryPoolHandle);
        return [[ASLPlainText alloc] initWithPlainText:plainText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}

+ (instancetype)plainTextWithCapacity:(size_t)capacity
                     coefficientCount:(size_t)coefficientCount
                                error:(NSError **)error {
    try {
        seal::Plaintext const plainText = seal::Plaintext(capacity, coefficientCount);
        return [[ASLPlainText alloc] initWithPlainText:plainText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}

+ (instancetype)plainTextWithCoefficientCount:(unsigned long)coefficientCount
                                         pool:(ASLMemoryPoolHandle *)pool
                                        error:(NSError **)error {
    try {
        seal::Plaintext const plainText = seal::Plaintext(coefficientCount, pool.memoryPoolHandle);
        return [[ASLPlainText alloc] initWithPlainText:plainText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}

+ (instancetype)plainTextWithCoefficientCount:(unsigned long)coefficientCount
                                        error:(NSError **)error {
    try {
        seal::Plaintext const plainText = seal::Plaintext(coefficientCount);
        return [[ASLPlainText alloc] initWithPlainText:plainText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}

- (instancetype)initWithPool:(ASLMemoryPoolHandle *)pool {
    return [[ASLPlainText alloc] initWithPlainText:pool.memoryPoolHandle];
}

- (instancetype)init {
    return [[ASLPlainText alloc] initWithPlainText:seal::Plaintext()];
}

- (instancetype)initWithPlainText:(seal::Plaintext)plainText {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _plainText = std::move(plainText);
    
    return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder {
   // Intentially left blank
    return nil;
}

- (instancetype)initWithData:(NSData *)data
                     context:(ASLSealContext *)context
                       error:(NSError **)error{
     seal::Plaintext encodedPlainText;
     std::byte const * bytes = static_cast<std::byte const *>(data.bytes);
     std::size_t const length = static_cast<std::size_t const>(data.length);

    try {
        encodedPlainText.load(context.sealContext, bytes, length);
         return [self initWithPlainText:encodedPlainText];
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    } catch (std::invalid_argument const &e) {
           if (error != nil) {
               *error = [NSError ASL_SealInvalidParameter:e];
           }
           return nil;
       }  catch (std::runtime_error const &e) {
           if (error != nil) {
               *error = [NSError ASL_SealRuntimeError:e];
           }
           return nil;
       }
    return nil;
}


- (void)encodeWithCoder:(NSCoder *)coder {
    std::size_t const lengthUpperBound = _plainText.save_size(seal::Serialization::compr_mode_default);
    NSMutableData * const data = [NSMutableData dataWithLength:lengthUpperBound];
    std::size_t const actualLength = _plainText.save(static_cast<std::byte *>(data.mutableBytes), lengthUpperBound);
    [data setLength:actualLength];
    [coder encodeDataObject:data];
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[ASLPlainText allocWithZone:zone] initWithPlainText:_plainText];
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString ASL_stringWithStdString:_plainText.to_string()];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[ASLPlainText class]]) {
        return NO;
    }
    
    return [self isEqualToPlainText:(ASLPlainText *)object];
}

#pragma mark - Properties

- (BOOL)isZero {
    return _plainText.is_zero();
}

- (NSInteger)capacity {
    return _plainText.capacity();
}

- (NSInteger)coefficientCount {
    return _plainText.coeff_count();
}

- (NSInteger)significantCoefficientCount {
    return _plainText.significant_coeff_count();
}

- (NSInteger)nonZeroCoefficientCount {
    return _plainText.nonzero_coeff_count();
}

- (ASLParametersIdType)parametersId {
    auto const parameters = _plainText.parms_id();
    return ASLParametersIdTypeMake(parameters[0], parameters[1], parameters[2], parameters[3]);
}

- (double)scale {
    return _plainText.scale();
}

- (ASLMemoryPoolHandle *)pool {
    return [[ASLMemoryPoolHandle alloc] initWithMemoryPoolHandle:_plainText.pool()];
}

- (NSString *)stringValue {
    return [NSString ASL_stringWithStdString:_plainText.to_string()];
}

#pragma mark - Public Methods

- (BOOL)isEqualToPlainText:(ASLPlainText *)other {
    NSParameterAssert(other != nil);
    if (other == nil) {
        return NO;
    } else {
        return _plainText == other->_plainText;
    }
}

- (BOOL)reserve:(size_t)capacity error:(NSError **)error {
    try {
        _plainText.reserve(capacity);
        return YES;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (void)shrinkToFit {
    _plainText.shrink_to_fit();
}

- (void)returnMemoryToPool {
    _plainText.release();
}

- (BOOL)resize:(size_t)coefficientCount
         error:(NSError **)error {
    try {
        _plainText.resize(coefficientCount);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}


- (BOOL)setZero:(size_t)coefficientCount
          error:(NSError **)error {
    try {
        _plainText.set_zero(coefficientCount);
        return YES;
    } catch (...) {
        [NSException raise:NSRangeException
                    format:@"Index %@ out of bounds", @(coefficientCount)];
        return NO;
    }
    return NO;
}

- (BOOL)setZero:(size_t)startCoefficient
         length:(size_t)length
          error:(NSError **)error {
    try {
        _plainText.set_zero(startCoefficient, length);
        return YES;
    } catch (...) {
        [NSException raise:NSRangeException
                    format:@"Index %@ out of bounds", @(length)];
        return NO;
    }
    return NO;
}

- (void)setZero {
    _plainText.set_zero();
}

#pragma mark ASLPlainText_Internal

- (seal::Plaintext)sealPlainText {
    return _plainText;
}



@end
