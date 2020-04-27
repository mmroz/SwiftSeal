//
//  ASLKeyGenerator.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLKeyGenerator.h"

#include "seal/keygenerator.h"

#import "ASLSealContext_Internal.h"
#import "ASLSecretKey_Internal.h"
#import "ASLPublicKey_Internal.h"
#import "ASLRelinearizationKeys_Internal.h"
#import "ASLGaloisKeys_Internal.h"
#import "NSError+CXXAdditions.h"

@implementation ASLKeyGenerator {
    seal::KeyGenerator* _keyGenerator;
}

#pragma mark - Initialization

+ (instancetype)keyGeneratorWithContext:(ASLSealContext *)context
                                  error:(NSError **)error {
    NSParameterAssert(context != nil);
    
    try {
        seal::KeyGenerator* keyGenerator = new seal::KeyGenerator(context.sealContext);
        return [[ASLKeyGenerator alloc] initWithKeyGenerator:keyGenerator];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

+ (instancetype)keyGeneratorWithContext:(ASLSealContext *)context
                              secretKey:(ASLSecretKey *)secretKey
                                  error:(NSError **)error {
    NSParameterAssert(context != nil);
    NSParameterAssert(secretKey != nil);
    try {
        seal::KeyGenerator* keyGenerator = new seal::KeyGenerator(context.sealContext, secretKey.sealSecretKey);
        return [[ASLKeyGenerator alloc] initWithKeyGenerator:keyGenerator];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

+ (instancetype _Nullable)keyGeneratorWithContext:(ASLSealContext *)context
                                        secretKey:(ASLSecretKey *)secretKey
                                        publicKey:(ASLPublicKey *)publicKey
                                            error:(NSError **)error {
    NSParameterAssert(context != nil);
    NSParameterAssert(secretKey != nil);
    NSParameterAssert(publicKey != nil);
    try {
        seal::KeyGenerator* keyGenerator = new seal::KeyGenerator(context.sealContext, secretKey.sealSecretKey, publicKey.sealPublicKey);
        return [[ASLKeyGenerator alloc] initWithKeyGenerator:keyGenerator];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (instancetype)initWithKeyGenerator:(seal::KeyGenerator *)keyGenerator {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _keyGenerator = std::move(keyGenerator);
    return self;
}

- (void)dealloc {
    delete _keyGenerator;
    _keyGenerator = nullptr;
}

#pragma mark - Public Methods

- (ASLPublicKey *)publicKey {
    return [[ASLPublicKey alloc] initWithPublicKey:_keyGenerator->public_key()];
}

- (ASLSecretKey *)secretKey {
    return [[ASLSecretKey alloc] initWithSecretKey:_keyGenerator->secret_key()];
}

- (ASLRelinearizationKeys *)relinearizationKeys:(NSError **)error {
    try {
        return [[ASLRelinearizationKeys alloc] initWithRelinearizationKeys:_keyGenerator->relin_keys()];
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
    return nil;
}

- (ASLGaloisKeys *)galoisKeys:(NSError **)error {
    try {
        return [[ASLGaloisKeys alloc] initWithGaloisKeys:_keyGenerator->galois_keys()];
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
    return nil;
}

- (ASLGaloisKeys *)galoisKeysWithGaloisElements:(NSArray<NSNumber *>*)galoisElements
                                          error:(NSError **)error {
    NSParameterAssert(galoisElements != nil);
    std::vector<std::uint64_t> galoisElementList;
    for (NSNumber * const element in galoisElements) {
        galoisElementList.push_back(element.unsignedIntValue);
    }
    try {
        return [[ASLGaloisKeys alloc] initWithGaloisKeys:_keyGenerator->galois_keys(galoisElementList)];
    }  catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLGaloisKeys *) galoisKeysWithSteps:(NSArray<NSNumber *>*)steps
                                  error:(NSError **)error {
    NSParameterAssert(steps != nil);
    std::vector<int> stepsList;
    for (NSNumber * const step in steps) {
        stepsList.push_back(step.intValue);
    }
    try {
        return [[ASLGaloisKeys alloc] initWithGaloisKeys:_keyGenerator->galois_keys(stepsList)];
    }  catch (std::logic_error const &e) {
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

- (NSData *)relinearizationKeysSaveWithError:(NSError **)error {
    std::size_t const lengthUpperBound = _keyGenerator->relin_keys().save_size(seal::Serialization::compr_mode_default);
    NSMutableData * const data = [NSMutableData dataWithLength:lengthUpperBound];
    
    try {
        std::size_t const actualLength = _keyGenerator->relin_keys_save(static_cast<std::byte *>(data.mutableBytes), lengthUpperBound);
        [data setLength:actualLength];
        return data;
    }  catch (std::logic_error const &e) {
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
}

- (NSData *)galoisKeysSaveWithError:(NSError **)error {
    std::size_t const lengthUpperBound = _keyGenerator->galois_keys().save_size(seal::Serialization::compr_mode_default);
    NSMutableData * const data = [NSMutableData dataWithLength:lengthUpperBound];
    
    try {
        std::size_t const actualLength = _keyGenerator->galois_keys_save(static_cast<std::byte *>(data.mutableBytes), lengthUpperBound);
        [data setLength:actualLength];
        return data;
    }  catch (std::logic_error const &e) {
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
}

- (NSData *)galoisKeysSaveWithSteps:(NSArray<NSNumber *> *)steps error:(NSError **)error {
    std::size_t const lengthUpperBound = _keyGenerator->galois_keys().save_size(seal::Serialization::compr_mode_default);
    NSMutableData * const data = [NSMutableData dataWithLength:lengthUpperBound];
    
    std::vector<int> valuesList;
    for (NSNumber * const step in steps) {
        valuesList.push_back(step.intValue);
    }
    
    try {
        std::size_t const actualLength = _keyGenerator->galois_keys_save(valuesList, static_cast<std::byte *>(data.mutableBytes), lengthUpperBound);
        [data setLength:actualLength];
        return data;
    }  catch (std::logic_error const &e) {
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
}

- (NSData *) galoisKeysSaveWithElements:(NSArray<NSNumber *>*)elements
                                  error:(NSError **)error {
    std::size_t const lengthUpperBound = _keyGenerator->galois_keys().save_size(seal::Serialization::compr_mode_default);
    NSMutableData * const data = [NSMutableData dataWithLength:lengthUpperBound];
    
    std::vector<std::uint64_t> valuesList;
    for (NSNumber * const element in elements) {
        valuesList.push_back(element.unsignedIntValue);
    }
    
    try {
        std::size_t const actualLength = _keyGenerator->galois_keys_save(valuesList, static_cast<std::byte *>(data.mutableBytes), lengthUpperBound);
        [data setLength:actualLength];
        return data;
    }  catch (std::logic_error const &e) {
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
}

@end
