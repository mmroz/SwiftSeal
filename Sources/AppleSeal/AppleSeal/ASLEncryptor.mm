//
//  ASLEncryptor.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-11.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLEncryptor.h"

#include "seal/encryptor.h"

#import "ASLSealContext_Internal.h"
#import "ASLPublicKey_Internal.h"
#import "ASLSecretKey_Internal.h"
#import "ASLPlainText_Internal.h"
#import "ASLCipherText_Internal.h"
#import "ASLMemoryPoolHandle_Internal.h"
#import "NSString+CXXAdditions.h"
#import "NSError+CXXAdditions.h"

@implementation ASLEncryptor {
    seal::Encryptor* _encryptor;
}

#pragma mark - Initialization

+ (instancetype)encryptorWithContext:(ASLSealContext *)context
                           publicKey:(ASLPublicKey *)publicKey
                               error:(NSError **)error {
    NSParameterAssert(context != nil);
    NSParameterAssert(publicKey != nil);
    
    try {
        seal::Encryptor* encryptor = new seal::Encryptor(context.sealContext, publicKey.sealPublicKey);
        return [[ASLEncryptor alloc] initWithBatchEncryptor:encryptor];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}

+ (instancetype)encryptorWithContext:(ASLSealContext *)context
                           secretKey:(ASLSecretKey *)secretKey
                               error:(NSError **)error {
    NSParameterAssert(context != nil);
    NSParameterAssert(secretKey != nil);
    
    try {
        seal::Encryptor* encryptor = new seal::Encryptor(context.sealContext, secretKey.sealSecretKey);
        return [[ASLEncryptor alloc] initWithBatchEncryptor:encryptor];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}

+ (instancetype)encryptorWithContext:(ASLSealContext *)context
                           publicKey:(ASLPublicKey *)publicKey
                           secretKey:(ASLSecretKey *)secretKey
                               error:(NSError **)error {
    NSParameterAssert(context != nil);
    NSParameterAssert(secretKey != nil);
    NSParameterAssert(publicKey != nil);
    
    try {
        seal::Encryptor* encryptor = new seal::Encryptor(context.sealContext, publicKey.sealPublicKey, secretKey.sealSecretKey);
        return [[ASLEncryptor alloc] initWithBatchEncryptor:encryptor];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}

- (instancetype)initWithBatchEncryptor:(seal::Encryptor *)encryptor {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _encryptor = encryptor;
    
    return self;
}

- (void)dealloc {
    delete _encryptor;
    _encryptor = nullptr;
}

#pragma mark - Public Methods

- (ASLCipherText *)encryptWithPlainText:(ASLPlainText *)plainText
                                  error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    
    seal::Ciphertext destination = seal::Ciphertext();
    
    try {
        _encryptor->encrypt(plainText.sealPlainText, destination);
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
    return nil;
}

- (ASLCipherText *)encryptWithPlainText:(ASLPlainText *)plainText
                                   pool:(ASLMemoryPoolHandle *)pool
                                  error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext destination = seal::Ciphertext();
    try {
        _encryptor->encrypt(plainText.sealPlainText, destination, pool.memoryPoolHandle);
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
    return nil;
}

-(ASLCipherText *)encryptZeroWithCipherText:(ASLCipherText *)cipherText
                                      error:(NSError **)error {
    NSParameterAssert(cipherText != nil);
    
    seal::Ciphertext sealCipherText = cipherText.sealCipherText;
    try {
        _encryptor->encrypt_zero(sealCipherText);
        return [[ASLCipherText alloc]initWithCipherText:sealCipherText];
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
    return nil;
}

-(ASLCipherText *)encryptZeroWithCipherText:(ASLCipherText *)cipherText
                                       pool:(ASLMemoryPoolHandle *)pool
                                      error:(NSError **)error {
    NSParameterAssert(cipherText != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealCipherText = cipherText.sealCipherText;
    try {
        _encryptor->encrypt_zero(sealCipherText, pool.memoryPoolHandle);
        return [[ASLCipherText alloc]initWithCipherText:sealCipherText];
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
    return nil;
}

-(ASLCipherText *)encryptZeroWithParametersId:(ASLParametersIdType)parametersId
                                   cipherText:(ASLCipherText *)cipherText
                                        error:(NSError **)error {
    NSParameterAssert(cipherText != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    seal::Ciphertext sealCipherText = cipherText.sealCipherText;
    
    try {
        _encryptor->encrypt_zero(sealParametersId, sealCipherText);
        return [[ASLCipherText alloc]initWithCipherText:sealCipherText];
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

-(ASLCipherText *)encryptZeroWithParametersId:(ASLParametersIdType)parametersId
                                   cipherText:(ASLCipherText *)cipherText
                                         pool:(ASLMemoryPoolHandle *)pool
                                        error:(NSError **)error {
    NSParameterAssert(cipherText != nil);
    NSParameterAssert(pool != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    seal::Ciphertext sealCipherText = cipherText.sealCipherText;
    
    try {
        _encryptor->encrypt_zero(sealParametersId, sealCipherText, pool.memoryPoolHandle);
        return [[ASLCipherText alloc]initWithCipherText:sealCipherText];
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

-(ASLCipherText *)encryptSymmetricWithPlainText:(ASLPlainText *)plainText
                                     cipherText:(ASLCipherText *)cipherText
                                          error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    NSParameterAssert(cipherText != nil);
    
    seal::Ciphertext sealCipherText = cipherText.sealCipherText;
    
    try {
        _encryptor->encrypt_symmetric(plainText.sealPlainText, sealCipherText);
        return [[ASLCipherText alloc]initWithCipherText:sealCipherText];
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

-(ASLCipherText *)encryptSymmetricWithPlainText:(ASLPlainText *)plainText
                                     cipherText:(ASLCipherText *)cipherText
                                           pool:(ASLMemoryPoolHandle *)pool
                                          error:(NSError **)error {
    NSParameterAssert(plainText != nil);
    NSParameterAssert(cipherText != nil);
    
    seal::Ciphertext sealCipherText = cipherText.sealCipherText;
    
    try {
        _encryptor->encrypt_symmetric(plainText.sealPlainText, sealCipherText, pool.memoryPoolHandle);
        return [[ASLCipherText alloc]initWithCipherText:sealCipherText];
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

-(ASLCipherText *)encryptZeroSymmetricWithCipherText:(ASLCipherText *)cipherText
                                               error:(NSError **)error {
    NSParameterAssert(cipherText != nil);
    
    seal::Ciphertext sealCipherText = cipherText.sealCipherText;
    
    try {
        _encryptor->encrypt_zero_symmetric(sealCipherText);
        return [[ASLCipherText alloc]initWithCipherText:sealCipherText];
    }  catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
    return nil;
}

-(ASLCipherText *)encryptZeroSymmetricWithCipherText:(ASLCipherText *)cipherText
                                                pool:(ASLMemoryPoolHandle *)pool
                                               error:(NSError **)error {
    NSParameterAssert(cipherText != nil);
    NSParameterAssert(pool != nil);
    
    seal::Ciphertext sealCipherText = cipherText.sealCipherText;
    
    try {
        _encryptor->encrypt_zero_symmetric(sealCipherText, pool.memoryPoolHandle);
        return [[ASLCipherText alloc]initWithCipherText:sealCipherText];
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

-(ASLCipherText *)encryptZeroSymmetricWithParametersId:(ASLParametersIdType)parametersId
                                                 error:(NSError **)error {
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    seal::Ciphertext sealCipherText = seal::Ciphertext();
    
    try {
        _encryptor->encrypt_zero_symmetric(sealParametersId, sealCipherText);
        return [[ASLCipherText alloc]initWithCipherText:sealCipherText];
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

-(ASLCipherText *)encryptZeroSymmetricWithParametersId:(ASLParametersIdType)parametersId
                                                  pool:(ASLMemoryPoolHandle *)pool
                                                 error:(NSError **)error {
    NSParameterAssert(pool != nil);
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    seal::Ciphertext sealCipherText = seal::Ciphertext();
    
    try {
        _encryptor->encrypt_zero_symmetric(sealParametersId, sealCipherText, pool.memoryPoolHandle);
        return [[ASLCipherText alloc]initWithCipherText:sealCipherText];
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

- (ASLSerializableCipherText *)encryptSerializableSymmetricWithPlain:(ASLPlainText *)plain
                                                                pool:(ASLMemoryPoolHandle *)pool
                                                               error:(NSError **)error {
    const seal::Plaintext sealPlainText = plain.sealPlainText;
    try {
        seal::Serializable<seal::Ciphertext> serializableText = _encryptor->encrypt_symmetric(sealPlainText, pool.memoryPoolHandle);
        return [[ASLSerializableCipherText alloc] initWithSerializableCipherText:serializableText];
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

- (ASLSerializableCipherText *)encryptSerializableSymmetricWithPlain:(ASLPlainText *)plain
                                                               error:(NSError **)error {
    const seal::Plaintext sealPlainText = plain.sealPlainText;
    try {
        seal::Serializable<seal::Ciphertext> serializableText = _encryptor->encrypt_symmetric(sealPlainText);
        return [[ASLSerializableCipherText alloc] initWithSerializableCipherText:serializableText];
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

- (ASLSerializableCipherText *)encryptSerializableZeroSymmetricWithParametersId:(ASLParametersIdType)parametersId
                                                                           pool:(ASLMemoryPoolHandle *)pool
                                                                          error:(NSError **)error {
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    try {
        seal::Serializable<seal::Ciphertext> serializableText = _encryptor->encrypt_zero_symmetric(sealParametersId, pool.memoryPoolHandle);
        return [[ASLSerializableCipherText alloc] initWithSerializableCipherText:serializableText];
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

- (ASLSerializableCipherText *)encryptSerializableZeroSymmetricWithParametersId:(ASLParametersIdType)parametersId
                                                                          error:(NSError **)error {
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    try {
        seal::Serializable<seal::Ciphertext> serializableText = _encryptor->encrypt_zero_symmetric(sealParametersId);
        return [[ASLSerializableCipherText alloc] initWithSerializableCipherText:serializableText];
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

-(ASLSerializableCipherText *)encryptSerializableZeroSymmetricWithPool:(ASLMemoryPoolHandle *)pool
                                                                 error:(NSError **)error {
    try {
        seal::Serializable<seal::Ciphertext> serializableText = _encryptor->encrypt_zero_symmetric(pool.memoryPoolHandle);
        return [[ASLSerializableCipherText alloc] initWithSerializableCipherText:serializableText];
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

- (ASLSerializableCipherText *)encryptSerializableZeroSymmetricWithError:(NSError **)error {
    try {
        seal::Serializable<seal::Ciphertext> serializableText = _encryptor->encrypt_zero_symmetric();
        return [[ASLSerializableCipherText alloc] initWithSerializableCipherText:serializableText];
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

- (ASLCipherText *)encryptZeroSymmetricWithPool:(ASLParametersIdType)parametersId
                                           pool:(ASLMemoryPoolHandle *)pool
                                          error:(NSError **)error {
    
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    seal::Ciphertext destination = seal::Ciphertext();
    
    try {
        _encryptor->encrypt_zero_symmetric(sealParametersId, destination, pool.memoryPoolHandle);
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

- (BOOL)setPublicKey:(ASLPublicKey *)publicKey
               error:(NSError **)error {
    NSParameterAssert(publicKey != nil);
    
    try {
        _encryptor->set_public_key(publicKey.sealPublicKey);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
}

- (BOOL)setSecretKey:(ASLSecretKey *)secretKey
               error:(NSError **)error {
    NSParameterAssert(secretKey != nil);
    
    try {
        _encryptor->set_secret_key(secretKey.sealSecretKey);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
}

@end
