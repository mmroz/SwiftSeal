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
#import "ASLKeyGenerator_Internal.h"
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

- (void)dealloc {
    delete _keyGenerator;
    _keyGenerator = nullptr;
}

#pragma mark ASLKeyGenerator_Internal.h

- (instancetype)initWithKeyGenerator:(seal::KeyGenerator *)keyGenerator {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _keyGenerator = std::move(keyGenerator);
    return self;
}

#pragma mark - Public Methods

- (ASLPublicKey *)publicKey {
    ASLPublicKey * publicKey = [[ASLPublicKey alloc] initWithPublicKey:_keyGenerator->public_key()];
    return publicKey;
}

- (ASLSecretKey *)secretKey {
    ASLSecretKey * secretkey = [[ASLSecretKey alloc] initWithSecretKey:_keyGenerator->secret_key()];
    return secretkey;
}

- (ASLRelinearizationKeys *)relinearizationKeysLocal:(NSError **)error {
    try {
        ASLRelinearizationKeys * keys = [[ASLRelinearizationKeys alloc] initWithRelinearizationKeys:_keyGenerator->relin_keys_local()];
        return keys;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
    return nil;
}

- (ASLSerializableRelineraizationKeys *)relinearizationKeys:(NSError **)error {
    try {
        seal::Serializable<seal::RelinKeys> keys = _keyGenerator->relin_keys();
        return [[ASLSerializableRelineraizationKeys alloc] initWithSerializableRelinearizationKey:keys];
    }  catch (std::invalid_argument const &e) {
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

- (ASLGaloisKeys *)galoisKeysLocalWithGaloisElements:(NSArray<NSNumber *> *)galoisElements error:(NSError **)error {
    NSParameterAssert(galoisElements != nil);
    std::vector<std::uint32_t> galoisElementList;
    for (NSNumber * const element in galoisElements) {
        galoisElementList.push_back(element.unsignedIntValue);
    }
    try {
        return [[ASLGaloisKeys alloc] initWithGaloisKeys:_keyGenerator->galois_keys_local(galoisElementList)];
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

- (ASLSerializableGaloisKeys *)galoisKeysWithGaloisElements:(NSArray<NSNumber *> *)galoisElements error:(NSError **)error {
    NSParameterAssert(galoisElements != nil);
    std::vector<std::uint32_t> galoisElementList;
    for (NSNumber * const element in galoisElements) {
        galoisElementList.push_back(element.unsignedIntValue);
    }
    try {
        seal::Serializable<seal::GaloisKeys> keys = _keyGenerator->galois_keys(galoisElementList);
        return [[ASLSerializableGaloisKeys alloc] initWithSerializableGaloisKey:keys];
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

- (ASLGaloisKeys *)galoisKeysLocalWithSteps:(NSArray<NSNumber *>*)steps
                                      error:(NSError **)error {
    NSParameterAssert(steps != nil);
    std::vector<int> stepsList;
    for (NSNumber * const step in steps) {
        stepsList.push_back(step.intValue);
    }
    try {
        return [[ASLGaloisKeys alloc] initWithGaloisKeys:_keyGenerator->galois_keys_local(stepsList)];
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


- (ASLSerializableGaloisKeys * _Nullable) galoisKeysWithSteps:(NSArray<NSNumber *>*)steps
                                            error:(NSError **)error {
    NSParameterAssert(steps != nil);
    std::vector<int> stepsList;
    for (NSNumber * const step in steps) {
        stepsList.push_back(step.intValue);
    }
    try {
        seal::Serializable<seal::GaloisKeys> keys = _keyGenerator->galois_keys(stepsList);
        return [[ASLSerializableGaloisKeys alloc] initWithSerializableGaloisKey:keys];

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


- (ASLGaloisKeys *)galoisKeysLocal:(NSError **)error {
    try {
        return [[ASLGaloisKeys alloc] initWithGaloisKeys:_keyGenerator->galois_keys_local()];
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
    return nil;
}

- (ASLSerializableGaloisKeys *)galoisKeys:(NSError **)error {
    try {
        return [[ASLSerializableGaloisKeys alloc] initWithSerializableGaloisKey:_keyGenerator->galois_keys()];
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

@end
