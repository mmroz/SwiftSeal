//
//  ASLBaseConverter.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-04-21.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLBaseConverter.h"

#include <seal/util/rns.h>

#import "ASLMemoryPoolHandle_Internal.h"
#import "ASLRnsBase_Internal.h"
#import "ASLModulus_Internal.h"
#import "ASLBaseConverter_Internal.h"
#import "NSString+CXXAdditions.h"
#import "NSError+CXXAdditions.h"

@implementation ASLBaseConverter {
    seal::util::BaseConverter * _baseConverter;
    BOOL _freeWhenDone;
}

# pragma mark - Initialization

+ (instancetype)baseConverterWithPool:(ASLMemoryPoolHandle *)pool
                                iBase:(ASLRnsBase *)iBase
                                oBase:(ASLRnsBase *)oBase error:(NSError **)error {
    const seal::util::RNSBase sealOBase = *oBase.rnsBase;
    seal::util::BaseConverter * converter = new seal::util::BaseConverter(*iBase.rnsBase, sealOBase, pool.memoryPoolHandle);
    
    try {
        return [[ASLBaseConverter alloc] initWithBaseConverter:converter freeWhenDone:false];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
}

// TODO - 💩 this class has its memory handled by another class
- (void)dealloc {
    if (_freeWhenDone) {
        delete _baseConverter;
        _baseConverter = nullptr;
    }
}

#pragma mark - ASLRnsBase_Internal

- (seal::util::BaseConverter *)baseConverter {
    return _baseConverter;
}

- (instancetype)initWithBaseConverter:(seal::util::BaseConverter *)baseConverter
                         freeWhenDone:(BOOL)freeWhenDone {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    _baseConverter = std::move(baseConverter);
    _freeWhenDone = freeWhenDone;

    return self;
}

# pragma mark - Properties

- (ASLRnsBase *)iBase {
    seal::util::RNSBase * base = new seal::util::RNSBase(_baseConverter->ibase());
    return [[ASLRnsBase alloc] initWithRnsBase:base freeWhenDone:true];
}

- (ASLRnsBase *)oBase {
    seal::util::RNSBase * base = new seal::util::RNSBase(_baseConverter->obase());
    return [[ASLRnsBase alloc] initWithRnsBase:base freeWhenDone:true];
}

- (size_t)iBaseSize {
    return _baseConverter->ibase_size();
}

- (size_t)oBaseSize {
    return _baseConverter->obase_size();
}

- (NSNumber *)fastConvert:(NSNumber *)input
                   output:(NSNumber *)output
                     pool:(ASLMemoryPoolHandle *)pool {
    const std::uint64_t * inputPointer = new std::uint64_t(input.unsignedLongLongValue);
    std::uint64_t * outputPointer = new std::uint64_t(output.unsignedLongLongValue);
    _baseConverter->fast_convert(inputPointer, outputPointer, pool.memoryPoolHandle);
    return [[NSNumber alloc] initWithUnsignedLongLong:static_cast<unsigned long long>(*outputPointer)];
}

- (NSNumber *)fastConvertArray:(NSNumber *)input
                          size:(size_t)size
                        output:(NSNumber *)output
                          pool:(ASLMemoryPoolHandle *)pool {
    const std::uint64_t * inputPointer = new std::uint64_t(input.unsignedLongLongValue);
    std::uint64_t * outputPointer = new std::uint64_t(output.unsignedLongLongValue);
    _baseConverter->fast_convert_array(inputPointer, size, outputPointer, pool.memoryPoolHandle);
    return [[NSNumber alloc] initWithUnsignedLongLong:static_cast<unsigned long long>(*outputPointer)];
}

@end
