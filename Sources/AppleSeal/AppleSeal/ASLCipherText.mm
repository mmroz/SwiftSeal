//
//  ASLCipherText.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-01.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLCipherText.h"

#include <string>
#include <stdexcept>
#include "seal/ciphertext.h"
#include "seal/serializable.h"

#import "ASLMemoryPoolHandle.h"
#import "ASLMemoryPoolHandle_Internal.h"
#import "ASLSealContextData_Internal.h"
#import "ASLSealContext_Internal.h"
#import "NSString+CXXAdditions.h"
#import "NSError+CXXAdditions.h"

@implementation ASLCipherText {
    seal::Ciphertext _cipherText;
}

+ (instancetype _Nullable)cipherTextWithCipherText:(ASLCipherText *)cipherText
                                              pool:(ASLMemoryPoolHandle *)pool
                                             error:(NSError **)error {
    NSParameterAssert(cipherText != nil);
    NSParameterAssert(pool != nil);
    try {
        seal::Ciphertext const cipherText = seal::Ciphertext(cipherText, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:cipherText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
                                   parametersId:(ASLParametersIdType)parametersId
                                   sizeCapacity:(size_t)sizeCapacity
                                           pool:(ASLMemoryPoolHandle *)pool
                                          error:(NSError **)error {
    NSParameterAssert(context != nil);
    NSParameterAssert(pool != nil);
    try {
        seal::parms_id_type sealParametersId = {};
        std::copy(std::begin(parametersId.block),
                  std::end(parametersId.block),
                  sealParametersId.begin());
        seal::Ciphertext const cipherText = seal::Ciphertext(context.sealContext, sealParametersId, sizeCapacity, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:cipherText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
                                   sizeCapacity:(size_t)sizeCapacity
                                   parametersId:(ASLParametersIdType)parametersId
                                          error:(NSError **)error {
    NSParameterAssert(context != nil);
    
    seal::parms_id_type sealParametersId = {};
           std::copy(std::begin(parametersId.block),
                     std::end(parametersId.block),
                     sealParametersId.begin());
    try {
        seal::Ciphertext const cipherText = seal::Ciphertext(context.sealContext, sealParametersId, sizeCapacity);
        return [[ASLCipherText alloc] initWithCipherText:cipherText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
                                   parametersId:(ASLParametersIdType)parametersId
                                           pool:(ASLMemoryPoolHandle *)pool
                                          error:(NSError **)error {
    NSParameterAssert(context != nil);
    NSParameterAssert(pool != nil);
    try {
        seal::parms_id_type sealParametersId = {};
        std::copy(std::begin(parametersId.block),
                  std::end(parametersId.block),
                  sealParametersId.begin());
        seal::Ciphertext const cipherText = seal::Ciphertext(context.sealContext, sealParametersId, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:cipherText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
                                   parametersId:(ASLParametersIdType)parametersId
                                          error:(NSError **)error {
    NSParameterAssert(context != nil);
    try {
        seal::parms_id_type sealParametersId = {};
        std::copy(std::begin(parametersId.block),
                  std::end(parametersId.block),
                  sealParametersId.begin());
        seal::Ciphertext const cipherText = seal::Ciphertext(context.sealContext, sealParametersId);
        return [[ASLCipherText alloc] initWithCipherText:cipherText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
                                           pool:(ASLMemoryPoolHandle *)pool
                                          error:(NSError **)error {
    NSParameterAssert(context != nil);
    NSParameterAssert(pool != nil);
    try {
        seal::Ciphertext const cipherText = seal::Ciphertext(context.sealContext, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:cipherText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}


+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
                                          error:(NSError **)error {
    NSParameterAssert(context != nil);
    try {
        seal::Ciphertext const cipherText = seal::Ciphertext(context.sealContext);
        return [[ASLCipherText alloc] initWithCipherText:cipherText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (instancetype)initWithPool:(ASLMemoryPoolHandle *)pool {
    NSParameterAssert(pool != nil);
    return [[ASLCipherText alloc] initWithCipherText:pool.memoryPoolHandle];
}

- (instancetype)init {
    return [[ASLCipherText alloc] initWithCipherText:seal::Ciphertext()];
}

#pragma mark - ASLCipherText_Internal

- (seal::Ciphertext)sealCipherText {
    return _cipherText;
}

- (instancetype)initWithCipherText:(seal::Ciphertext)cipherText {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _cipherText = std::move(cipherText);
    
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
     seal::Ciphertext encodedCipherText;
     std::byte const * bytes = static_cast<std::byte const *>(data.bytes);
     std::size_t const length = static_cast<std::size_t const>(data.length);

    try {
        encodedCipherText.load(context.sealContext, bytes, length);
         return [self initWithCipherText:encodedCipherText];
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
    std::size_t const lengthUpperBound = _cipherText.save_size(seal::Serialization::compr_mode_default);
    NSMutableData * const data = [NSMutableData dataWithLength:lengthUpperBound];
    std::size_t const actualLength = _cipherText.save(static_cast<std::byte *>(data.mutableBytes), lengthUpperBound);
    [data setLength:actualLength];
    [coder encodeDataObject:data];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[ASLCipherText allocWithZone:zone] initWithCipherText:_cipherText];
}

#pragma mark - NSObject

- (NSString *)description
{
    auto const parameters = _cipherText.parms_id();
    ASLParametersIdType params = ASLParametersIdTypeMake(parameters[0], parameters[1], parameters[2], parameters[3]);
    return [NSString stringWithFormat:@"Scale: %f, Size: %lu, Capacity: %lu, Param Ids: %@, Is NTT: %@, Is Transparent: %@", _cipherText.scale(), _cipherText.size(), _cipherText.size_capacity(), ASLParametersIdTypeDescription(params), [NSString ASL_stringWithBool:_cipherText.is_ntt_form()], [NSString ASL_stringWithBool:_cipherText.is_ntt_form()]];
}

#pragma mark - Properies


- (NSArray<NSNumber *> *)intArray {
    std::size_t arraySize = _cipherText.int_array().size();
    
    NSMutableArray<NSNumber *> * results = [[NSMutableArray alloc] initWithCapacity:arraySize];
    
    int i=0;
    for (i = 0; i < arraySize; i++)
    {
         NSNumber * value = [[NSNumber alloc] initWithLongLong:_cipherText.int_array()[i]];
        [results insertObject:value atIndex:i];
    }
    
    return results;
}

- (size_t)coefficientModulusSize {
    return _cipherText.coeff_modulus_size();
}

- (size_t)polynomialModulusDegree {
    return _cipherText.poly_modulus_degree();
}

- (size_t)size {
    return _cipherText.size();
}

- (size_t)sizeCapacity {
    return _cipherText.size_capacity();
}

- (BOOL)isTransparent {
    return _cipherText.is_transparent();
}

- (BOOL)isNntForm {
    return _cipherText.is_ntt_form();
}

- (ASLParametersIdType)parametersId {
    auto const parameters = _cipherText.parms_id();
    return ASLParametersIdTypeMake(parameters[0], parameters[1], parameters[2], parameters[3]);
}

- (double)scale {
    return _cipherText.scale();
}

-(void)setScale:(NSNumber*)scale{
    _cipherText.scale() = scale.doubleValue;
}

- (ASLMemoryPoolHandle *)pool {
    return [[ASLMemoryPoolHandle alloc] initWithMemoryPoolHandle:_cipherText.pool()];
}

#pragma mark - Public Methods

- (BOOL)reserve:(ASLSealContext *)context
   parametersId:(ASLParametersIdType)parametersId
   sizeCapacity:(size_t)sizeCapacity
          error:(NSError **)error {
    NSParameterAssert(context != nil);
    NSParameterAssert(sizeCapacity >= 2);
    try {
        
        seal::parms_id_type sealParametersId = {};
        std::copy(std::begin(parametersId.block),
                  std::end(parametersId.block),
                  sealParametersId.begin());
        
        _cipherText.reserve(context.sealContext, sealParametersId, sizeCapacity);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)reserve:(ASLSealContext *)context
   sizeCapacity:(size_t)sizeCapacity
          error:(NSError **)error {
    NSParameterAssert(context != nil);
    try {
        _cipherText.reserve(context.sealContext, sizeCapacity);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)reserve:(size_t)sizeCapacity
          error:(NSError **)error {
    try {
        _cipherText.reserve(sizeCapacity);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
} catch (std::logic_error const &e) {
    if (error != nil) {
        *error = [NSError ASL_SealLogicError:e];
    }
    return NO;
    
    return NO;
}

- (BOOL)resize:(ASLSealContext *)context
  parametersId:(ASLParametersIdType)parametersId
  sizeCapacity:(size_t)size
         error:(NSError **)error {
    NSParameterAssert(context != nil);
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    try {
        _cipherText.resize(context.sealContext, sealParametersId, size);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    
    return NO;
}

- (BOOL)resize:(ASLSealContext *)context
  sizeCapacity:(size_t)size
         error:(NSError **)error {
    NSParameterAssert(context != nil);
    try {
        _cipherText.resize(context.sealContext, size);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    
    return NO;
}

- (BOOL)resize:(size_t)size
         error:(NSError **)error {
    try {
        _cipherText.resize(size);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

-(void)returnMemoryToPool {
    _cipherText.release();
}

- (NSNumber *)polynomialCoefficientAtIndex:(size_t)index
                                     error:(NSError **)error {
    try {
        uint64_t valueAtIndex = static_cast<uint64_t>(_cipherText[index]);
        return [[NSNumber alloc] initWithLong:valueAtIndex];
    } catch (...) {
        [NSException raise:NSRangeException
                    format:@"Index %@ out of bounds", @(index)];
    }
    return 0;
}

@end

@implementation ASLSerializableCipherText {
    seal::Serializable<seal::Ciphertext> *_serializableCipherText;
}

- (instancetype)initWithSerializableCipherText:(seal::Serializable<seal::Ciphertext>)serializableCipherText {
    self = [super init];
    if (!self) {
        return nil;
    }
    _serializableCipherText = new seal::Serializable<seal::Ciphertext>(std::move(serializableCipherText));
    return self;
}

- (void)dealloc {
    delete _serializableCipherText;
     _serializableCipherText = nullptr;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    std::size_t const lengthUpperBound = _serializableCipherText->save_size();
    NSMutableData * const data = [NSMutableData dataWithLength:lengthUpperBound];
    std::size_t const actualLength = _serializableCipherText->save(static_cast<std::byte *>(data.mutableBytes), lengthUpperBound);
    [data setLength:actualLength];
    [coder encodeDataObject:data];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    [NSException raise:NSInternalInconsistencyException
                format:@"Method %s is not implemented, use initWithData:context:error: instead", __PRETTY_FUNCTION__];
    return nil;
}

@end
