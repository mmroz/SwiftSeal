//
//  ASLGaloisKeys.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLGaloisKeys.h"

#include "seal/galoiskeys.h"

#import "ASLPublicKey_Internal.h"
#import "ASLGaloisKeys_Internal.h"
#import "NSString+CXXAdditions.h"
#import "NSError+CXXAdditions.h"

@implementation ASLGaloisKeys  {
    seal::GaloisKeys _galoisKeys;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _galoisKeys = seal::GaloisKeys();
    return self;
}

#pragma mark - Public Methods

-(NSNumber *)getIndex:(NSNumber*)galoisElement
                error:(NSError **)error {
    NSParameterAssert(galoisElement != nil);
    NSParameterAssert(galoisElement.intValue >= 2);
    
    try {
        return [[NSNumber alloc] initWithUnsignedLongLong:_galoisKeys.get_index(galoisElement.intValue)];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}

-(NSNumber *)hasKey:(NSNumber*)galoisElement
              error:(NSError **)error {
    NSParameterAssert(galoisElement != nil);
    NSParameterAssert(galoisElement.intValue >= 2);
    try {
        return [[NSNumber alloc]initWithBool:_galoisKeys.has_key(galoisElement.intValue)];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}

-(NSArray<ASLPublicKey*>*)key:(NSNumber *)galoisElement
                        error:(NSError **)error {
    NSParameterAssert(galoisElement != nil);
    NSParameterAssert(galoisElement.intValue >= 2);
    try {
        NSMutableArray * publicKeyVector = [[NSMutableArray alloc] init];
        for (seal::PublicKey const & publicKey: _galoisKeys.key(galoisElement.intValue)) {
            ASLPublicKey* aslPublicKey = [[ASLPublicKey alloc] initWithPublicKey:publicKey];
            [publicKeyVector addObject:aslPublicKey];
        }
        return publicKeyVector;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}

- (id)objectForKeyedSubscript:(NSNumber *)key {
    NSError *error = nil;
    NSArray<ASLPublicKey *> * const value = [self key:key
                                                error:&error];
    if (value == nil) {
        [NSException raise:NSRangeException
                    format:@"Key %@ out of range", key];
    } else {
        return value;
    }
}

#pragma mark - ASLGaloisKeys_Internal

- (seal::GaloisKeys)sealGaloisKeys {
    return _galoisKeys;
}

- (instancetype)initWithGaloisKeys:(seal::GaloisKeys)sealGaloisKeys {
    self = [super init];
       if (self == nil) {
           return nil;
       }
       
       _galoisKeys = std::move(sealGaloisKeys);

       return self;
}

@end

@implementation ASLSerializableGaloisKeys {
    seal::Serializable<seal::GaloisKeys> *_serializableKeys;
}

- (instancetype)initWithSerializableGaloisKey:(seal::Serializable<seal::GaloisKeys>)serializableKeys {
    self = [super init];
    if (!self) {
        return nil;
    }
    _serializableKeys = std::move(&serializableKeys);
    return self;
}

- (void)dealloc {
    delete _serializableKeys;
     _serializableKeys = nullptr;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    std::size_t const lengthUpperBound = _serializableKeys->save_size();
    NSMutableData * const data = [NSMutableData dataWithLength:lengthUpperBound];
    std::size_t const actualLength = _serializableKeys->save(static_cast<std::byte *>(data.mutableBytes), lengthUpperBound);
    [data setLength:actualLength];
    [coder encodeDataObject:data];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    // Intentially left blank
}


@end
