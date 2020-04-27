//
//  ASLEvaluator.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-12.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLEvaluator.h"

#include "seal/evaluator.h"

#import "ASLSealContextData_Internal.h"
#import "ASLSealContext_Internal.h"
#import "ASLCipherText_Internal.h"
#import "ASLCipherText_Internal.h"
#import "ASLRelinearizationKeys_Internal.h"
#import "ASLPlainText_Internal.h"
#import "ASLGaloisKeys_Internal.h"
#import "ASLMemoryPoolHandle_Internal.h"
#import "NSString+CXXAdditions.h"
#import "NSError+CXXAdditions.h"

@implementation ASLEvaluator {
    seal::Evaluator* _evaluator;
}

#pragma mark - Initialization

+ (instancetype)evaluatorWith:(ASLSealContext *)context
                        error:(NSError **)error {
    NSParameterAssert(context != nil);
    
    try {
        seal::Evaluator* encryptor = new seal::Evaluator(context.sealContext);
        return [[ASLEvaluator alloc] initWithEvaluator:encryptor];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (instancetype)initWithEvaluator:(seal::Evaluator *)evaluator {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _evaluator = evaluator;
    
    return self;
}

- (void)dealloc {
    delete _evaluator;
    _evaluator = nullptr;
}

#pragma Public Methods

- (BOOL)negate:(ASLCipherText *)encrypted
    detination:(ASLCipherText *)destination
         error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(destination != nil);
    
    try {
        seal::Ciphertext destinationCipherText = destination.sealCipherText;
        _evaluator->negate(encrypted.sealCipherText, destinationCipherText);
        return YES;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)negateInplace:(ASLCipherText *)encrypted
               error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    
    try {
        seal::Ciphertext encryptedCipherText = encrypted.sealCipherText;
        _evaluator->negate_inplace(encryptedCipherText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
}

-(BOOL)addInplace:(ASLCipherText *)encrypted1
       encrypted2:(ASLCipherText *)encrypted2
            error:(NSError **)error {
    NSParameterAssert(encrypted1 != nil);
    NSParameterAssert(encrypted2 != nil);
    
    try {
        seal::Ciphertext constEncrypted1 = encrypted1.sealCipherText;
        _evaluator->add_inplace(constEncrypted1, encrypted2.sealCipherText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)add:(ASLCipherText *)encrypted1
encrypted2:(ASLCipherText *)encrypted2
destination:(ASLCipherText *)destination
     error:(NSError **)error {
    NSParameterAssert(encrypted1 != nil);
    NSParameterAssert(encrypted2 != nil);
    
    try {
        seal::Ciphertext constDestination = destination.sealCipherText;
        _evaluator->add(encrypted1.sealCipherText, encrypted2.sealCipherText, constDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)addMany:(NSArray<ASLCipherText *> *)encrypteds
   destination:(ASLCipherText *)destination
         error:(NSError **)error {
    NSParameterAssert(encrypteds != nil);
    NSParameterAssert(destination != nil);
    
    std::vector<seal::Ciphertext> vectorEncrypteds;
    for (ASLCipherText * const value in encrypteds) {
        vectorEncrypteds.push_back(value.sealCipherText);
    }
    
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->add_many(vectorEncrypteds, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)subInplace:(ASLCipherText *)encrypted1
       encrypted2:(ASLCipherText *)encrypted2
            error:(NSError **)error {
    NSParameterAssert(encrypted1 != nil);
    NSParameterAssert(encrypted2 != nil);
    
    seal::Ciphertext sealEncrypted1 = encrypted1.sealCipherText;
    try {
        _evaluator->sub_inplace(sealEncrypted1, encrypted2.sealCipherText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)sub:(ASLCipherText *)encrypted1
encrypted2:(ASLCipherText *)encrypted2
destination:(ASLCipherText *)destination
     error:(NSError **)error {
    NSParameterAssert(encrypted1 != nil);
    NSParameterAssert(encrypted2 != nil);
    
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->sub(encrypted1.sealCipherText, encrypted2.sealCipherText, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)multiplyInplace:(ASLCipherText *)encrypted1
            encrypted2:(ASLCipherText *)encrypted2
                 error:(NSError **)error {
    NSParameterAssert(encrypted1 != nil);
    NSParameterAssert(encrypted2 != nil);
    
    seal::Ciphertext sealEncrypted1 = encrypted1.sealCipherText;
    try {
        _evaluator->multiply_inplace(sealEncrypted1, encrypted2.sealCipherText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)multiplyInplace:(ASLCipherText *)encrypted1
            encrypted2:(ASLCipherText *)encrypted2
                  pool:(ASLMemoryPoolHandle *)pool
                 error:(NSError **)error {
    NSParameterAssert(encrypted1 != nil);
    NSParameterAssert(encrypted2 != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted1 = encrypted1.sealCipherText;
    try {
        _evaluator->multiply_inplace(sealEncrypted1, encrypted2.sealCipherText, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)multiply:(ASLCipherText *)encrypted1
     encrypted2:(ASLCipherText *)encrypted2
    destination:(ASLCipherText *)destination
           pool:(ASLMemoryPoolHandle *)pool
          error:(NSError **)error {
    NSParameterAssert(encrypted1 != nil);
    NSParameterAssert(encrypted2 != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->multiply(encrypted1.sealCipherText, encrypted2.sealCipherText, sealDestination, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)multiply:(ASLCipherText *)encrypted1
     encrypted2:(ASLCipherText *)encrypted2
    destination:(ASLCipherText *)destination
          error:(NSError **)error {
    NSParameterAssert(encrypted1 != nil);
    NSParameterAssert(encrypted2 != nil);
    NSParameterAssert(destination != nil);
    
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->multiply(encrypted1.sealCipherText, encrypted2.sealCipherText, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)squareInplace:(ASLCipherText *)encrypted
               error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->square_inplace(sealEncrypted);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)squareInplace:(ASLCipherText *)encrypted
                pool:(ASLMemoryPoolHandle *)pool
               error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->square_inplace(sealEncrypted, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)square:(ASLCipherText *)encrypted
  destination:(ASLCipherText *)destination
         pool:(ASLMemoryPoolHandle *)pool
        error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->square(encrypted.sealCipherText, sealDestination, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)square:(ASLCipherText *)encrypted
  destination:(ASLCipherText *)destination
        error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(destination != nil);
    
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->square(encrypted.sealCipherText, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)relinearizeInplace:(ASLCipherText *)encrypted
      relinearizationKeys:(ASLRelinearizationKeys *)relinearizationKeys
                    error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(relinearizationKeys != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->relinearize_inplace(sealEncrypted, relinearizationKeys.sealRelinKeys);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)relinearizeInplace:(ASLCipherText *)encrypted
      relinearizationKeys:(ASLRelinearizationKeys *)relinearizationKeys
                     pool:(ASLMemoryPoolHandle *)pool
                    error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(relinearizationKeys != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::RelinKeys sealRelinKey = relinearizationKeys.sealRelinKeys;
    try {
        _evaluator->relinearize_inplace(sealEncrypted, sealRelinKey, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)relinearize:(ASLCipherText *)encrypted
relinearizationKeys:(ASLRelinearizationKeys *)relinearizationKeys
       destination:(ASLCipherText *)destination
             error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(relinearizationKeys != nil);
    NSParameterAssert(destination != nil);
    
    seal::Ciphertext sealDestination = encrypted.sealCipherText;
    try {
        _evaluator->relinearize(encrypted.sealCipherText, relinearizationKeys.sealRelinKeys, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)relinearize:(ASLCipherText *)encrypted
relinearizationKeys:(ASLRelinearizationKeys *)relinearizationKeys
       destination:(ASLCipherText *)destination
              pool:(ASLMemoryPoolHandle *)pool
             error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(relinearizationKeys != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->relinearize(encrypted.sealCipherText, relinearizationKeys.sealRelinKeys, sealDestination, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)modSwitchToNext:(ASLCipherText *)encrypted
           destination:(ASLCipherText *)destination
                 error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(destination != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->mod_switch_to_next(sealEncrypted, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)modSwitchToNext:(ASLCipherText *)encrypted
           destination:(ASLCipherText *)destination
                  pool:(ASLMemoryPoolHandle *)pool
                 error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->mod_switch_to_next(sealEncrypted, sealDestination, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)modSwitchToNextInplace:(ASLCipherText *)encrypted
                         pool:(ASLMemoryPoolHandle *)pool
                        error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->mod_switch_to_next_inplace(sealEncrypted, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)modSwitchToNextInplace:(ASLCipherText *)encrypted
                        error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->mod_switch_to_next_inplace(sealEncrypted);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)modSwitchToNext:(ASLPlainText *)plain
                 error:(NSError **)error {
    NSParameterAssert(plain != nil);
    
    seal::Plaintext sealPlainText = plain.sealPlainText;
    try {
        _evaluator->mod_switch_to_next_inplace(sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)modSwitchToInplace:(ASLCipherText *)encrypted
             parametersId:(ASLParametersIdType)parametersId
                     pool:(ASLMemoryPoolHandle *)pool
                    error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(pool != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->mod_switch_to_inplace(sealEncrypted, sealParametersId, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)modSwitchToInplace:(ASLCipherText *)encrypted
             parametersId:(ASLParametersIdType)parametersId
                    error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    
    
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->mod_switch_to_inplace(sealEncrypted, sealParametersId);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)modSwitchTo:(ASLCipherText *)encrypted
      parametersId:(ASLParametersIdType)parametersId
       destination:(ASLCipherText *)destination
              pool:(ASLMemoryPoolHandle *)pool
             error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->mod_switch_to(sealEncrypted, sealParametersId, sealDestination, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)modSwitchTo:(ASLCipherText *)encrypted
      parametersId:(ASLParametersIdType)parametersId
       destination:(ASLCipherText *)destination
             error:(NSError **)error {
    
    NSParameterAssert(encrypted != nil);
    
    NSParameterAssert(destination != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->mod_switch_to(sealEncrypted, sealParametersId, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)modSwitchToInplaceWithPlain:(ASLPlainText *)plain
                      parametersId:(ASLParametersIdType)parametersId
                             error:(NSError **)error {
    NSParameterAssert(plain != nil);
    
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Plaintext sealPlainText = plain.sealPlainText;
    try {
        _evaluator->mod_switch_to_inplace(sealPlainText, sealParametersId);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)modSwitchToWithPlain:(ASLPlainText *)plain
               parametersId:(ASLParametersIdType)parametersId
                destination:(ASLPlainText *)destination
                      error:(NSError **)error {
    NSParameterAssert(plain != nil);
    NSParameterAssert(destination != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Plaintext sealDestination = destination.sealPlainText;
    seal::Plaintext sealPlain = plain.sealPlainText;
    try {
        _evaluator->mod_switch_to(sealPlain, sealParametersId, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rescaleToNext:(ASLCipherText *)encrypted
         destination:(ASLCipherText *)destination
                pool:(ASLMemoryPoolHandle *)pool
               error:(NSError **)error {
    
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->rescale_to_next(sealEncrypted, sealDestination, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rescaleToNext:(ASLCipherText *)encrypted
         destination:(ASLCipherText *)destination
               error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(destination != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->rescale_to_next(sealEncrypted, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rescaleToNextInplace:(ASLCipherText *)encrypted
                       pool:(ASLMemoryPoolHandle *)pool
                      error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->rescale_to_next_inplace(sealEncrypted, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rescaleToNextInplace:(ASLCipherText *)encrypted
                      error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->rescale_to_next_inplace(sealEncrypted);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rescaleToInplace:(ASLCipherText *)encrypted
           parametersId:(ASLParametersIdType)parametersId
                   pool:(ASLMemoryPoolHandle *)pool
                  error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(pool != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->rescale_to_inplace(sealEncrypted, sealParametersId, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rescaleToInplace:(ASLCipherText *)encrypted
           parametersId:(ASLParametersIdType)parametersId
                  error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->rescale_to_inplace(sealEncrypted, sealParametersId);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rescaleTo:(ASLCipherText *)encrypted
    parametersId:(ASLParametersIdType)parametersId
     destination:(ASLCipherText *)destination
            pool:(ASLMemoryPoolHandle *)pool
           error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->rescale_to(sealEncrypted, sealParametersId, sealDestination, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rescaleTo:(ASLCipherText *)encrypted
    parametersId:(ASLParametersIdType)parametersId
     destination:(ASLCipherText *)destination
           error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(destination != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->rescale_to(sealEncrypted, sealParametersId, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)multiplyMany:(NSArray<ASLCipherText*>*)encrypteds
relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
        destination:(ASLCipherText *)destination
               pool:(ASLMemoryPoolHandle *)pool
              error:(NSError **)error {
    NSParameterAssert(encrypteds != nil);
    NSParameterAssert(relinearizationKeys != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    std::vector<seal::Ciphertext> vectorEncrypteds;
    for (ASLCipherText * const value in encrypteds) {
        vectorEncrypteds.push_back(value.sealCipherText);
    }
    
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->multiply_many(vectorEncrypteds, relinearizationKeys.sealRelinKeys, sealDestination, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)multiplyMany:(NSArray<ASLCipherText*>*)encrypteds
relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
        destination:(ASLCipherText *)destination
              error:(NSError **)error {
    NSParameterAssert(encrypteds != nil);
    NSParameterAssert(relinearizationKeys != nil);
    NSParameterAssert(destination != nil);
    
    std::vector<seal::Ciphertext> vectorEncrypteds;
    for (ASLCipherText * const value in encrypteds) {
        vectorEncrypteds.push_back(value.sealCipherText);
    }
    
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->multiply_many(vectorEncrypteds, relinearizationKeys.sealRelinKeys, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)exponentiateInplace:(ASLCipherText *)encrypted
                  exponent:(uint64_t)exponent
       relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
                      pool:(ASLMemoryPoolHandle *)pool
                     error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(relinearizationKeys != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->exponentiate_inplace(sealEncrypted, exponent, relinearizationKeys.sealRelinKeys, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)exponentiateInplace:(ASLCipherText *)encrypted
                  exponent:(uint64_t)exponent
       relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
                     error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(relinearizationKeys != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->exponentiate_inplace(sealEncrypted, exponent, relinearizationKeys.sealRelinKeys);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)exponentiate:(ASLCipherText *)encrypted
           exponent:(uint64_t)exponent
relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
        destination:(ASLCipherText *)destination
               pool:(ASLMemoryPoolHandle *)pool
              error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(relinearizationKeys != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->exponentiate(sealEncrypted, exponent, relinearizationKeys.sealRelinKeys, sealDestination, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)exponentiate:(ASLCipherText *)encrypted
           exponent:(uint64_t)exponent
relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
        destination:(ASLCipherText *)destination
              error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(relinearizationKeys != nil);
    NSParameterAssert(destination != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->exponentiate(sealEncrypted, exponent, relinearizationKeys.sealRelinKeys, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)addPlainInplace:(ASLCipherText *)encrypted
                 plain:(ASLPlainText *)plain
                 error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(plain != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Plaintext sealPlainText = plain.sealPlainText;
    try {
        _evaluator->add_plain_inplace(sealEncrypted, sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)addPlain:(ASLCipherText *)encrypted
          plain:(ASLPlainText *)plain
    destination:(ASLCipherText *)destination
          error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(plain != nil);
    NSParameterAssert(destination != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->add_plain(sealEncrypted, plain.sealPlainText, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)subPlainInplace:(ASLCipherText *)encrypted
                 plain:(ASLPlainText *)plain
                 error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(plain != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->sub_plain_inplace(sealEncrypted, plain.sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)subPlain:(ASLCipherText *)encrypted
          plain:(ASLPlainText *)plain
    destination:(ASLCipherText *)destination
          error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(plain != nil);
    NSParameterAssert(destination != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->sub_plain(sealEncrypted, plain.sealPlainText, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)multiplyPlainInplace:(ASLCipherText *)encrypted
                      plain:(ASLPlainText *)plain
                       pool:(ASLMemoryPoolHandle *)pool
                      error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(plain != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->multiply_plain_inplace(sealEncrypted, plain.sealPlainText, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)multiplyPlainInplace:(ASLCipherText *)encrypted
                      plain:(ASLPlainText *)plain
                      error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(plain != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->multiply_plain_inplace(sealEncrypted, plain.sealPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}


-(BOOL)multiplyPlain:(ASLCipherText *)encrypted
               plain:(ASLPlainText *)plain
         destination:(ASLCipherText *)destination
                pool:(ASLMemoryPoolHandle *)pool
               error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(plain != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->multiply_plain(sealEncrypted, plain.sealPlainText, sealDestination, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)multiplyPlain:(ASLCipherText *)encrypted
               plain:(ASLPlainText *)plain
         destination:(ASLCipherText *)destination
               error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(plain != nil);
    NSParameterAssert(destination != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->multiply_plain(sealEncrypted, plain.sealPlainText, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)transformToNttInplace:(ASLPlainText *)plain
                parametersId:(ASLParametersIdType)parametersId
                        pool:(ASLMemoryPoolHandle *)pool
                       error:(NSError **)error {
    NSParameterAssert(plain != nil);
    NSParameterAssert(pool != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Plaintext sealPlainText = plain.sealPlainText;
    try {
        _evaluator->transform_to_ntt_inplace(sealPlainText, sealParametersId, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)transformToNttInplace:(ASLPlainText *)plain
                parametersId:(ASLParametersIdType)parametersId
                       error:(NSError **)error {
    NSParameterAssert(plain != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Plaintext sealPlainText = plain.sealPlainText;
    try {
        _evaluator->transform_to_ntt_inplace(sealPlainText, sealParametersId);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)transformToNtt:(ASLPlainText *)plain
         parametersId:(ASLParametersIdType)parametersId
       destinationNtt:(ASLPlainText *)destinationNtt
                 pool:(ASLMemoryPoolHandle *)pool
                error:(NSError **)error {
    NSParameterAssert(plain != nil);
    NSParameterAssert(destinationNtt != nil);
    NSParameterAssert(pool != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Plaintext sealPlainText = plain.sealPlainText;
    seal::Plaintext sealNttPlainText = destinationNtt.sealPlainText;
    try {
        _evaluator->transform_to_ntt(sealPlainText, sealParametersId, sealNttPlainText, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)transformToNtt:(ASLPlainText *)plain
         parametersId:(ASLParametersIdType)parametersId
       destinationNtt:(ASLPlainText *)destinationNtt
                error:(NSError **)error {
    NSParameterAssert(plain != nil);
    NSParameterAssert(destinationNtt != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Plaintext sealPlainText = plain.sealPlainText;
    seal::Plaintext sealNttPlainText = plain.sealPlainText;
    try {
        _evaluator->transform_to_ntt(sealPlainText, sealParametersId, sealNttPlainText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)transformToNttInplace:(ASLCipherText *)encrypted
                       error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->transform_to_ntt_inplace(sealEncrypted);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)transformToNtt:(ASLCipherText *)encrypted
       destinationNtt:(ASLCipherText *)destinationNtt
                error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(destinationNtt != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealNttCipherText = destinationNtt.sealCipherText;
    try {
        _evaluator->transform_to_ntt(sealEncrypted, sealNttCipherText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)transformFromNttInplace:(ASLCipherText *)encryptedNtt
                         error:(NSError **)error {
    NSParameterAssert(encryptedNtt != nil);
    
    seal::Ciphertext sealNttCipherText = encryptedNtt.sealCipherText;
    try {
        _evaluator->transform_from_ntt_inplace(sealNttCipherText);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)transformFromNtt:(ASLCipherText *)encryptedNtt
            destination:(ASLCipherText *)destination
                  error:(NSError **)error {
    NSParameterAssert(encryptedNtt != nil);
    NSParameterAssert(destination != nil);
    
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->transform_from_ntt(encryptedNtt.sealCipherText, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)applyGaloisInplace:(ASLCipherText *)encrypted
            galoisElement:(uint64_t)galoisElement
                galoisKey:(ASLGaloisKeys *)galoisKey
                     pool:(ASLMemoryPoolHandle *)pool
                    error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->apply_galois_inplace(sealEncrypted, galoisElement, galoisKey.sealGaloisKeys, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)applyGaloisInplace:(ASLCipherText *)encrypted
            galoisElement:(uint64_t)galoisElement
                galoisKey:(ASLGaloisKeys *)galoisKey
                    error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->apply_galois_inplace(sealEncrypted, galoisElement, galoisKey.sealGaloisKeys);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)applyGalois:(ASLCipherText *)encrypted
     galoisElement:(uint64_t)galoisElement
         galoisKey:(ASLGaloisKeys *)galoisKey
       destination:(ASLCipherText *)destination
              pool:(ASLMemoryPoolHandle *)pool
             error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->apply_galois(sealEncrypted, galoisElement, galoisKey.sealGaloisKeys, sealDestination, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)applyGalois:(ASLCipherText *)encrypted
     galoisElement:(uint64_t)galoisElement
         galoisKey:(ASLGaloisKeys *)galoisKey
       destination:(ASLCipherText *)destination
             error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(destination != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->apply_galois(sealEncrypted, galoisElement, galoisKey.sealGaloisKeys, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rotateRowsInplace:(ASLCipherText *)encrypted
                   steps:(int)steps
               galoisKey:(ASLGaloisKeys *)galoisKey
                    pool:(ASLMemoryPoolHandle *)pool
                   error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->rotate_rows_inplace(sealEncrypted, steps, galoisKey.sealGaloisKeys, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rotateRowsInplace:(ASLCipherText *)encrypted
                   steps:(int)steps
               galoisKey:(ASLGaloisKeys *)galoisKey
                   error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->rotate_rows_inplace(sealEncrypted, steps, galoisKey.sealGaloisKeys);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rotateRows:(ASLCipherText *)encrypted
            steps:(int)steps
        galoisKey:(ASLGaloisKeys *)galoisKey
      destination:(ASLCipherText *)destination
             pool:(ASLMemoryPoolHandle *)pool
            error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->rotate_rows(sealEncrypted, steps, galoisKey.sealGaloisKeys, sealDestination, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rotateRows:(ASLCipherText *)encrypted
            steps:(int)steps
        galoisKey:(ASLGaloisKeys *)galoisKey
      destination:(ASLCipherText *)destination
            error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(destination != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->rotate_rows(sealEncrypted, steps, galoisKey.sealGaloisKeys, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rotateColumnsInplace:(ASLCipherText *)encrypted
                  galoisKey:(ASLGaloisKeys *)galoisKey
                       pool:(ASLMemoryPoolHandle *)pool
                      error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->rotate_columns_inplace(sealEncrypted, galoisKey.sealGaloisKeys, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rotateColumnsInplace:(ASLCipherText *)encrypted
                  galoisKey:(ASLGaloisKeys *)galoisKey
                      error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->rotate_columns_inplace(sealEncrypted, galoisKey.sealGaloisKeys);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rotateColumns:(ASLCipherText *)encrypted
           galoisKey:(ASLGaloisKeys *)galoisKey
         destination:(ASLCipherText *)destination
                pool:(ASLMemoryPoolHandle *)pool
               error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->rotate_columns(sealEncrypted, galoisKey.sealGaloisKeys, sealDestination, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rotateColumns:(ASLCipherText *)encrypted
           galoisKey:(ASLGaloisKeys *)galoisKey
         destination:(ASLCipherText *)destination
               error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(destination != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->rotate_columns(sealEncrypted, galoisKey.sealGaloisKeys, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rotateVectorInplace:(ASLCipherText *)encrypted
                     steps:(int)steps
                 galoisKey:(ASLGaloisKeys *)galoisKey
                      pool:(ASLMemoryPoolHandle *)pool
                     error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->rotate_vector_inplace(sealEncrypted, steps, galoisKey.sealGaloisKeys, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rotateVectorInplace:(ASLCipherText *)encrypted
                     steps:(int)steps
                 galoisKey:(ASLGaloisKeys *)galoisKey
                     error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->rotate_vector_inplace(sealEncrypted, steps, galoisKey.sealGaloisKeys);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rotateVector:(ASLCipherText *)encrypted
              steps:(int)steps
          galoisKey:(ASLGaloisKeys *)galoisKey
        destination:(ASLCipherText *)destination
               pool:(ASLMemoryPoolHandle *)pool
              error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->rotate_vector(sealEncrypted, steps, galoisKey.sealGaloisKeys, sealDestination, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)rotateVector:(ASLCipherText *)encrypted
              steps:(int)steps
          galoisKey:(ASLGaloisKeys *)galoisKey
        destination:(ASLCipherText *)destination
              error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(destination != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->rotate_vector(sealEncrypted, steps, galoisKey.sealGaloisKeys, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)complexConjugateInplace:(ASLCipherText *)encrypted
                     galoisKey:(ASLGaloisKeys *)galoisKey
                          pool:(ASLMemoryPoolHandle *)pool
                         error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->complex_conjugate_inplace(sealEncrypted, galoisKey.sealGaloisKeys, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)complexConjugateInplace:(ASLCipherText *)encrypted
                     galoisKey:(ASLGaloisKeys *)galoisKey
                         error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->complex_conjugate_inplace(sealEncrypted, galoisKey.sealGaloisKeys);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)complexConjugate:(ASLCipherText *)encrypted
              galoisKey:(ASLGaloisKeys *)galoisKey
            destination:(ASLCipherText *)destination
                   pool:(ASLMemoryPoolHandle *)pool
                  error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(destination != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->complex_conjugate(sealEncrypted, galoisKey.sealGaloisKeys, sealDestination, pool.memoryPoolHandle);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

-(BOOL)complexConjugate:(ASLCipherText *)encrypted
              galoisKey:(ASLGaloisKeys *)galoisKey
            destination:(ASLCipherText *)destination
                  error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(destination != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealDestination = destination.sealCipherText;
    try {
        _evaluator->complex_conjugate(sealEncrypted, galoisKey.sealGaloisKeys, sealDestination);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

@end
