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

- (ASLCipherText *)negate:(ASLCipherText *)encrypted
         error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    
    try {
        seal::Ciphertext destinationCipherText = seal::Ciphertext();
        _evaluator->negate(encrypted.sealCipherText, destinationCipherText);
        return [[ASLCipherText alloc] initWithCipherText:destinationCipherText];
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
     return nil;
}

-(ASLCipherText *)negateInplace:(ASLCipherText *)encrypted
               error:(NSError **)error {
    
    NSParameterAssert(encrypted != nil);
    
    try {
        seal::Ciphertext encryptedCipherText = encrypted.sealCipherText;
        _evaluator->negate_inplace(encryptedCipherText);
        return [[ASLCipherText alloc] initWithCipherText:encryptedCipherText];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

-(ASLCipherText *)addInplace:(ASLCipherText *)encrypted1
       encrypted2:(ASLCipherText *)encrypted2
            error:(NSError **)error {
    
    NSParameterAssert(encrypted1 != nil);
    NSParameterAssert(encrypted2 != nil);
    
    try {
        seal::Ciphertext sealEncrypted1 = encrypted1.sealCipherText;
        _evaluator->add_inplace(sealEncrypted1, encrypted2.sealCipherText);
        return [[ASLCipherText alloc]initWithCipherText:sealEncrypted1];
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

-(ASLCipherText * _Nullable)add:(ASLCipherText *)encrypted1
encrypted2:(ASLCipherText *)encrypted2
     error:(NSError **)error {
    
    NSParameterAssert(encrypted1 != nil);
    NSParameterAssert(encrypted2 != nil);
    
    try {
        seal::Ciphertext destination = seal::Ciphertext();
        _evaluator->add(encrypted1.sealCipherText, encrypted2.sealCipherText, destination);
        return [[ASLCipherText alloc]initWithCipherText:destination];
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
    return nil;
}

-(ASLCipherText * _Nullable)addMany:(NSArray<ASLCipherText *> *)encrypteds
         error:(NSError **)error {
    
    NSParameterAssert(encrypteds != nil);
    
    std::vector<seal::Ciphertext> vectorEncrypteds;
    for (ASLCipherText * const value in encrypteds) {
        vectorEncrypteds.push_back(value.sealCipherText);
    }
    
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->add_many(vectorEncrypteds, destination);
       return [[ASLCipherText alloc]initWithCipherText:destination];
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
    return nil;
}

-(ASLCipherText *)subInplace:(ASLCipherText *)encrypted1
       encrypted2:(ASLCipherText *)encrypted2
            error:(NSError **)error {
    NSParameterAssert(encrypted1 != nil);
    NSParameterAssert(encrypted2 != nil);
    
    seal::Ciphertext sealEncrypted1 = encrypted1.sealCipherText;
    try {
        _evaluator->sub_inplace(sealEncrypted1, encrypted2.sealCipherText);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted1];
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

-(ASLCipherText * _Nullable)sub:(ASLCipherText *)encrypted1
encrypted2:(ASLCipherText *)encrypted2
     error:(NSError **)error {
    NSParameterAssert(encrypted1 != nil);
    NSParameterAssert(encrypted2 != nil);
    
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->sub(encrypted1.sealCipherText, encrypted2.sealCipherText, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText *)multiplyInplace:(ASLCipherText *)encrypted1
            encrypted2:(ASLCipherText *)encrypted2
                 error:(NSError **)error {
    NSParameterAssert(encrypted1 != nil);
    NSParameterAssert(encrypted2 != nil);
    
    seal::Ciphertext sealEncrypted1 = encrypted1.sealCipherText;
    try {
        _evaluator->multiply_inplace(sealEncrypted1, encrypted2.sealCipherText);
        return [[ASLCipherText alloc]initWithCipherText:sealEncrypted1];
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

-(ASLCipherText *)multiplyInplace:(ASLCipherText *)encrypted1
            encrypted2:(ASLCipherText *)encrypted2
                  pool:(ASLMemoryPoolHandle *)pool
                 error:(NSError **)error {
    NSParameterAssert(encrypted1 != nil);
    NSParameterAssert(encrypted2 != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted1 = encrypted1.sealCipherText;
    try {
        _evaluator->multiply_inplace(sealEncrypted1, encrypted2.sealCipherText, pool.memoryPoolHandle);
        return [[ASLCipherText alloc]initWithCipherText:sealEncrypted1];;
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

-(ASLCipherText * _Nullable)multiply:(ASLCipherText *)encrypted1
     encrypted2:(ASLCipherText *)encrypted2
           pool:(ASLMemoryPoolHandle *)pool
          error:(NSError **)error {
    
    NSParameterAssert(encrypted1 != nil);
    NSParameterAssert(encrypted2 != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext destination = seal::Ciphertext();
    
    try {
        _evaluator->multiply(encrypted1.sealCipherText, encrypted2.sealCipherText, destination, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:destination];;
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

-(ASLCipherText * _Nullable)multiply:(ASLCipherText *)encrypted1
     encrypted2:(ASLCipherText *)encrypted2
    
          error:(NSError **)error {
    NSParameterAssert(encrypted1 != nil);
    NSParameterAssert(encrypted2 != nil);
    
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->multiply(encrypted1.sealCipherText, encrypted2.sealCipherText, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];;
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

-(ASLCipherText *)squareInplace:(ASLCipherText *)encrypted
               error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->square_inplace(sealEncrypted);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText *)squareInplace:(ASLCipherText *)encrypted
                pool:(ASLMemoryPoolHandle *)pool
               error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->square_inplace(sealEncrypted, pool.memoryPoolHandle);
         return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText * _Nullable)square:(ASLCipherText *)encrypted
  
         pool:(ASLMemoryPoolHandle *)pool
        error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->square(encrypted.sealCipherText, destination, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText * _Nullable)square:(ASLCipherText *)encrypted
        error:(NSError **)error {
    
    NSParameterAssert(encrypted != nil);
    
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->square(encrypted.sealCipherText, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText *)relinearizeInplace:(ASLCipherText *)encrypted
      relinearizationKeys:(ASLRelinearizationKeys *)relinearizationKeys
                    error:(NSError **)error {
    
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(relinearizationKeys != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->relinearize_inplace(sealEncrypted, relinearizationKeys.sealRelinKeys);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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
    return nil;
}

-(ASLCipherText *)relinearizeInplace:(ASLCipherText *)encrypted
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
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText * _Nullable)relinearize:(ASLCipherText *)encrypted
relinearizationKeys:(ASLRelinearizationKeys *)relinearizationKeys
             error:(NSError **)error {
    
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(relinearizationKeys != nil);
    
    seal::Ciphertext destination = encrypted.sealCipherText;
    
    try {
        _evaluator->relinearize(encrypted.sealCipherText, relinearizationKeys.sealRelinKeys, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText * _Nullable)relinearize:(ASLCipherText *)encrypted
relinearizationKeys:(ASLRelinearizationKeys *)relinearizationKeys
       
              pool:(ASLMemoryPoolHandle *)pool
             error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(relinearizationKeys != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->relinearize(encrypted.sealCipherText, relinearizationKeys.sealRelinKeys, destination, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText * _Nullable)modSwitchToNext:(ASLCipherText *)encrypted
           
                 error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->mod_switch_to_next(sealEncrypted, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText * _Nullable)modSwitchToNext:(ASLCipherText *)encrypted
           
                  pool:(ASLMemoryPoolHandle *)pool
                 error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->mod_switch_to_next(sealEncrypted, destination, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText *)modSwitchToNextInplace:(ASLCipherText *)encrypted
                         pool:(ASLMemoryPoolHandle *)pool
                        error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->mod_switch_to_next_inplace(sealEncrypted, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText * _Nullable)modSwitchToNextInplace:(ASLCipherText *)encrypted
                        error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->mod_switch_to_next_inplace(sealEncrypted);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLPlainText * _Nullable)modSwitchToNextWithPlain:(ASLPlainText *)plain
                 error:(NSError **)error {
    NSParameterAssert(plain != nil);
    
    seal::Plaintext sealPlainText = plain.sealPlainText;
    try {
        _evaluator->mod_switch_to_next_inplace(sealPlainText);
        return [[ASLPlainText alloc] initWithPlainText:sealPlainText];
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

-(ASLCipherText *)modSwitchToInplace:(ASLCipherText *)encrypted
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
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText *)modSwitchToInplace:(ASLCipherText *)encrypted
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
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText * _Nullable)modSwitchTo:(ASLCipherText *)encrypted
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
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->mod_switch_to(sealEncrypted, sealParametersId, destination, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText * _Nullable)modSwitchTo:(ASLCipherText *)encrypted
      parametersId:(ASLParametersIdType)parametersId
       
             error:(NSError **)error {
    
    NSParameterAssert(encrypted != nil);
    
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->mod_switch_to(sealEncrypted, sealParametersId, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLPlainText *)modSwitchToInplaceWithPlain:(ASLPlainText *)plain
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
        return [[ASLPlainText alloc] initWithPlainText:sealPlainText];
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

-(ASLPlainText * _Nullable)modSwitchToWithPlain:(ASLPlainText *)plain
               parametersId:(ASLParametersIdType)parametersId
                      error:(NSError **)error {
    NSParameterAssert(plain != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Plaintext destination = seal::Plaintext();
    seal::Plaintext sealPlain = plain.sealPlainText;
    
    try {
        _evaluator->mod_switch_to(sealPlain, sealParametersId, destination);
        return [[ASLPlainText alloc] initWithPlainText:destination];
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

-(ASLCipherText * _Nullable)rescaleToNext:(ASLCipherText *)encrypted
                pool:(ASLMemoryPoolHandle *)pool
               error:(NSError **)error {
    
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->rescale_to_next(sealEncrypted, destination, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText * _Nullable)rescaleToNext:(ASLCipherText *)encrypted
         
               error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->rescale_to_next(sealEncrypted, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText *)rescaleToNextInplace:(ASLCipherText *)encrypted
                       pool:(ASLMemoryPoolHandle *)pool
                      error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->rescale_to_next_inplace(sealEncrypted, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText *)rescaleToNextInplace:(ASLCipherText *)encrypted
                      error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->rescale_to_next_inplace(sealEncrypted);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText *)rescaleToInplace:(ASLCipherText *)encrypted
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
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText *)rescaleToInplace:(ASLCipherText *)encrypted
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
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText * _Nullable)rescaleTo:(ASLCipherText *)encrypted
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
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->rescale_to(sealEncrypted, sealParametersId, destination, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText * _Nullable)rescaleTo:(ASLCipherText *)encrypted
    parametersId:(ASLParametersIdType)parametersId
     
           error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->rescale_to(sealEncrypted, sealParametersId, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText * _Nullable)multiplyMany:(NSArray<ASLCipherText*>*)encrypteds
relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
        
               pool:(ASLMemoryPoolHandle *)pool
              error:(NSError **)error {
    NSParameterAssert(encrypteds != nil);
    NSParameterAssert(relinearizationKeys != nil);
    NSParameterAssert(pool != nil);
    
    std::vector<seal::Ciphertext> vectorEncrypteds;
    for (ASLCipherText * const value in encrypteds) {
        vectorEncrypteds.push_back(value.sealCipherText);
    }
    
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->multiply_many(vectorEncrypteds, relinearizationKeys.sealRelinKeys, destination, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText * _Nullable)multiplyMany:(NSArray<ASLCipherText*>*)encrypteds
relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
        
              error:(NSError **)error {
    NSParameterAssert(encrypteds != nil);
    NSParameterAssert(relinearizationKeys != nil);
    
    std::vector<seal::Ciphertext> vectorEncrypteds;
    for (ASLCipherText * const value in encrypteds) {
        vectorEncrypteds.push_back(value.sealCipherText);
    }
    
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->multiply_many(vectorEncrypteds, relinearizationKeys.sealRelinKeys, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText *)exponentiateInplace:(ASLCipherText *)encrypted
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
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText *)exponentiateInplace:(ASLCipherText *)encrypted
                  exponent:(uint64_t)exponent
       relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
                     error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(relinearizationKeys != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->exponentiate_inplace(sealEncrypted, exponent, relinearizationKeys.sealRelinKeys);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText * _Nullable)exponentiate:(ASLCipherText *)encrypted
           exponent:(uint64_t)exponent
relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
        
               pool:(ASLMemoryPoolHandle *)pool
              error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(relinearizationKeys != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->exponentiate(sealEncrypted, exponent, relinearizationKeys.sealRelinKeys, destination, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText * _Nullable)exponentiate:(ASLCipherText *)encrypted
           exponent:(uint64_t)exponent
relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
        
              error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(relinearizationKeys != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->exponentiate(sealEncrypted, exponent, relinearizationKeys.sealRelinKeys, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText *)addPlainInplace:(ASLCipherText *)encrypted
                 plain:(ASLPlainText *)plain
                 error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(plain != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Plaintext sealPlainText = plain.sealPlainText;
    try {
        _evaluator->add_plain_inplace(sealEncrypted, sealPlainText);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText * _Nullable)addPlain:(ASLCipherText *)encrypted
          plain:(ASLPlainText *)plain
    
          error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(plain != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->add_plain(sealEncrypted, plain.sealPlainText, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText *)subPlainInplace:(ASLCipherText *)encrypted
                 plain:(ASLPlainText *)plain
                 error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(plain != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->sub_plain_inplace(sealEncrypted, plain.sealPlainText);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText * _Nullable)subPlain:(ASLCipherText *)encrypted
          plain:(ASLPlainText *)plain
    
          error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(plain != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->sub_plain(sealEncrypted, plain.sealPlainText, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText *)multiplyPlainInplace:(ASLCipherText *)encrypted
                      plain:(ASLPlainText *)plain
                       pool:(ASLMemoryPoolHandle *)pool
                      error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(plain != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->multiply_plain_inplace(sealEncrypted, plain.sealPlainText, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText *)multiplyPlainInplace:(ASLCipherText *)encrypted
                      plain:(ASLPlainText *)plain
                      error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(plain != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->multiply_plain_inplace(sealEncrypted, plain.sealPlainText);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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


-(ASLCipherText * _Nullable)multiplyPlain:(ASLCipherText *)encrypted
               plain:(ASLPlainText *)plain
         
                pool:(ASLMemoryPoolHandle *)pool
               error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(plain != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->multiply_plain(sealEncrypted, plain.sealPlainText, destination, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText * _Nullable)multiplyPlain:(ASLCipherText *)encrypted
               plain:(ASLPlainText *)plain
         
               error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(plain != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->multiply_plain(sealEncrypted, plain.sealPlainText, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLPlainText *)transformToNttInplace:(ASLPlainText *)plain
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
        return [[ASLPlainText alloc] initWithPlainText:sealPlainText];
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

-(ASLPlainText *)transformToNttInplace:(ASLPlainText *)plain
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
        return [[ASLPlainText alloc] initWithPlainText:sealPlainText];
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

-(ASLPlainText *)transformToNtt:(ASLPlainText *)plain
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
        return [[ASLPlainText alloc] initWithPlainText:sealNttPlainText];
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

-(ASLPlainText *)transformToNtt:(ASLPlainText *)plain
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
    seal::Plaintext sealNttPlainText = destinationNtt.sealPlainText;
    try {
        _evaluator->transform_to_ntt(sealPlainText, sealParametersId, sealNttPlainText);
        return [[ASLPlainText alloc] initWithPlainText:sealNttPlainText];
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

-(ASLCipherText *)transformToNttInplace:(ASLCipherText *)encrypted
                       error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->transform_to_ntt_inplace(sealEncrypted);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText *)transformToNtt:(ASLCipherText *)encrypted
       destinationNtt:(ASLCipherText *)destinationNtt
                error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(destinationNtt != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext sealNttCipherText = destinationNtt.sealCipherText;
    try {
        _evaluator->transform_to_ntt(sealEncrypted, sealNttCipherText);
        return [[ASLCipherText alloc] initWithCipherText:sealNttCipherText];
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

-(ASLCipherText *)transformFromNttInplace:(ASLCipherText *)encryptedNtt
                         error:(NSError **)error {
    NSParameterAssert(encryptedNtt != nil);
    
    seal::Ciphertext sealNttCipherText = encryptedNtt.sealCipherText;
    try {
        _evaluator->transform_from_ntt_inplace(sealNttCipherText);
        return [[ASLCipherText alloc] initWithCipherText:sealNttCipherText];
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

-(ASLCipherText * _Nullable)transformFromNtt:(ASLCipherText *)encryptedNtt
            
                  error:(NSError **)error {
    NSParameterAssert(encryptedNtt != nil);
    
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->transform_from_ntt(encryptedNtt.sealCipherText, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText *)applyGaloisInplace:(ASLCipherText *)encrypted
            galoisElement:(uint64_t)galoisElement
                galoisKey:(ASLGaloisKeys *)galoisKey
                     pool:(ASLMemoryPoolHandle *)pool
                    error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->apply_galois_inplace(sealEncrypted, static_cast<std::uint32_t>(galoisElement), galoisKey.sealGaloisKeys, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText *)applyGaloisInplace:(ASLCipherText *)encrypted
            galoisElement:(uint64_t)galoisElement
                galoisKey:(ASLGaloisKeys *)galoisKey
                    error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->apply_galois_inplace(sealEncrypted, static_cast<std::uint32_t>(galoisElement), galoisKey.sealGaloisKeys);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText * _Nullable)applyGalois:(ASLCipherText *)encrypted
     galoisElement:(uint64_t)galoisElement
         galoisKey:(ASLGaloisKeys *)galoisKey
       
              pool:(ASLMemoryPoolHandle *)pool
             error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->apply_galois(sealEncrypted, static_cast<std::uint32_t>(galoisElement), galoisKey.sealGaloisKeys, destination, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText * _Nullable)applyGalois:(ASLCipherText *)encrypted
     galoisElement:(uint64_t)galoisElement
         galoisKey:(ASLGaloisKeys *)galoisKey
       
             error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->apply_galois(sealEncrypted, static_cast<std::uint32_t>(galoisElement), galoisKey.sealGaloisKeys, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText *)rotateRowsInplace:(ASLCipherText *)encrypted
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
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText *)rotateRowsInplace:(ASLCipherText *)encrypted
                   steps:(int)steps
               galoisKey:(ASLGaloisKeys *)galoisKey
                   error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->rotate_rows_inplace(sealEncrypted, steps, galoisKey.sealGaloisKeys);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText * _Nullable)rotateRows:(ASLCipherText *)encrypted
            steps:(int)steps
        galoisKey:(ASLGaloisKeys *)galoisKey
      
             pool:(ASLMemoryPoolHandle *)pool
            error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->rotate_rows(sealEncrypted, steps, galoisKey.sealGaloisKeys, destination, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText * _Nullable)rotateRows:(ASLCipherText *)encrypted
            steps:(int)steps
        galoisKey:(ASLGaloisKeys *)galoisKey
      
            error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->rotate_rows(sealEncrypted, steps, galoisKey.sealGaloisKeys, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText *)rotateColumnsInplace:(ASLCipherText *)encrypted
                  galoisKey:(ASLGaloisKeys *)galoisKey
                       pool:(ASLMemoryPoolHandle *)pool
                      error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->rotate_columns_inplace(sealEncrypted, galoisKey.sealGaloisKeys, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText *)rotateColumnsInplace:(ASLCipherText *)encrypted
                  galoisKey:(ASLGaloisKeys *)galoisKey
                      error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->rotate_columns_inplace(sealEncrypted, galoisKey.sealGaloisKeys);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText * _Nullable)rotateColumns:(ASLCipherText *)encrypted
           galoisKey:(ASLGaloisKeys *)galoisKey
         
                pool:(ASLMemoryPoolHandle *)pool
               error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->rotate_columns(sealEncrypted, galoisKey.sealGaloisKeys, destination, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText * _Nullable)rotateColumns:(ASLCipherText *)encrypted
           galoisKey:(ASLGaloisKeys *)galoisKey
         
               error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->rotate_columns(sealEncrypted, galoisKey.sealGaloisKeys, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText *)rotateVectorInplace:(ASLCipherText *)encrypted
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
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText *)rotateVectorInplace:(ASLCipherText *)encrypted
                     steps:(int)steps
                 galoisKey:(ASLGaloisKeys *)galoisKey
                     error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->rotate_vector_inplace(sealEncrypted, steps, galoisKey.sealGaloisKeys);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText * _Nullable)rotateVector:(ASLCipherText *)encrypted
              steps:(int)steps
          galoisKey:(ASLGaloisKeys *)galoisKey
        
               pool:(ASLMemoryPoolHandle *)pool
              error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->rotate_vector(sealEncrypted, steps, galoisKey.sealGaloisKeys, destination, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText * _Nullable)rotateVector:(ASLCipherText *)encrypted
              steps:(int)steps
          galoisKey:(ASLGaloisKeys *)galoisKey
        
              error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->rotate_vector(sealEncrypted, steps, galoisKey.sealGaloisKeys, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText *)complexConjugateInplace:(ASLCipherText *)encrypted
                     galoisKey:(ASLGaloisKeys *)galoisKey
                          pool:(ASLMemoryPoolHandle *)pool
                         error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->complex_conjugate_inplace(sealEncrypted, galoisKey.sealGaloisKeys, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText *)complexConjugateInplace:(ASLCipherText *)encrypted
                     galoisKey:(ASLGaloisKeys *)galoisKey
                         error:(NSError **)error {
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    try {
        _evaluator->complex_conjugate_inplace(sealEncrypted, galoisKey.sealGaloisKeys);
        return [[ASLCipherText alloc] initWithCipherText:sealEncrypted];
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

-(ASLCipherText * _Nullable)complexConjugate:(ASLCipherText *)encrypted
              galoisKey:(ASLGaloisKeys *)galoisKey
                   pool:(ASLMemoryPoolHandle *)pool
                  error:(NSError **)error {
    
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _evaluator->complex_conjugate(sealEncrypted, galoisKey.sealGaloisKeys, destination, pool.memoryPoolHandle);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

-(ASLCipherText * _Nullable)complexConjugate:(ASLCipherText *)encrypted
              galoisKey:(ASLGaloisKeys *)galoisKey
                  error:(NSError **)error {
    
    NSParameterAssert(encrypted != nil);
    NSParameterAssert(galoisKey != nil);
    
    seal::Ciphertext sealEncrypted = encrypted.sealCipherText;
    seal::Ciphertext destination = seal::Ciphertext();
    
    try {
        _evaluator->complex_conjugate(sealEncrypted, galoisKey.sealGaloisKeys, destination);
        return [[ASLCipherText alloc] initWithCipherText:destination];
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

@end
