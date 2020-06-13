//
//  ASLRelinearizationKeys.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLRelinearizationKeys.h"

#include "seal/relinkeys.h"

#import "ASLPublicKey_Internal.h"
#import "ASLRelinearizationKeys_Internal.h"
#import "NSError+CXXAdditions.h"

@implementation ASLRelinearizationKeys {
    seal::RelinKeys _relinearizationKeys;
}

#pragma mark - initializers

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _relinearizationKeys = seal::RelinKeys();
    
    return self;
}

#pragma mark - Public Methods

- (NSNumber *)getIndex:(size_t)index
                 error:(NSError **)error; {
    NSParameterAssert(index >= 2);
    
    try {
        return [[NSNumber alloc]initWithFloat:_relinearizationKeys.get_index(index)];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (NSNumber *)hasKey:(size_t)key
               error:(NSError **)error;{
    NSParameterAssert(key >= 2);
    
    try {
        return [[NSNumber alloc]initWithBool:_relinearizationKeys.has_key(key)];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (NSArray<ASLPublicKey *> *)keyWithKeyPower:(size_t)keyPower
                                       error:(NSError **)error;{
    NSMutableArray * publicKeyVector = [[NSMutableArray alloc] init];
    NSParameterAssert(keyPower >= 2);
    
    try {
        for (seal::PublicKey const & publicKey:
             _relinearizationKeys.key(keyPower)) {
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
    return nil;
}

#pragma mark - ASLRelinearizationKeys_Internal.h

- (seal::RelinKeys)sealRelinKeys {
    return _relinearizationKeys;
}

- (instancetype)initWithRelinearizationKeys:(seal::RelinKeys)relinearizationKeys {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _relinearizationKeys = std::move(relinearizationKeys);
    
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
    std::size_t const lengthUpperBound = _relinearizationKeys.save_size(seal::Serialization::compr_mode_default);
    NSMutableData * const data = [NSMutableData dataWithLength:lengthUpperBound];
    std::size_t const actualLength = _relinearizationKeys.save(static_cast<std::byte *>(data.mutableBytes), lengthUpperBound);
    [data setLength:actualLength];
    [coder encodeDataObject:data];
}

// TODO - see if I need this
//- (instancetype)initWithCoder:(NSCoder *)coder {
//    NSData * const encodedValueData = [coder decodeDataObject];
//    if (encodedValueData.length == 0) {
//        return nil;
//    }
//
//    seal::RelinKeys encodedRelinearizationKeysy;
//    std::byte const * bytes = static_cast<std::byte const *>(encodedValueData.bytes);
//    std::size_t const length = static_cast<std::size_t const>(encodedValueData.length);
//    //encodedRelinearizationKeysy.load(<#std::shared_ptr<SEALContext> context#>, <#std::istream &stream#>)
//    return [self initWithRelinearizationKeys:encodedRelinearizationKeysy];
//}


@end

@implementation ASLSerializableRelineraizationKeys {
    seal::Serializable<seal::RelinKeys> *_serializableKeys;
}

- (instancetype)initWithSerializableRelinearizationKey:(seal::Serializable<seal::RelinKeys>)serializableKeys {
    self = [super init];
    if (!self) {
        return nil;
    }
    _serializableKeys = std::move(&serializableKeys);
    return self;
}

- (void)dealloc {
    // TODO - crashes
//    delete _serializableKeys;
//     _serializableKeys = nullptr;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    std::size_t const lengthUpperBound = _serializableKeys->save_size();
    NSMutableData * const data = [NSMutableData dataWithLength:lengthUpperBound];
    std::size_t const actualLength = _serializableKeys->save(static_cast<std::byte *>(data.mutableBytes), lengthUpperBound);
    [data setLength:actualLength];
    [coder encodeDataObject:data];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
   // Intentially left blank
}
@end
