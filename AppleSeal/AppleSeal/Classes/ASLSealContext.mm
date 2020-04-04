//
//  ASLSealContext.m
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLSealContext.h"

#include "seal/context.h"

#include <memory>

#import "ASLSealContextData.h"
#import "ASLSealContextData_Internal.h"
#import "ASLSealContext_Internal.h"
#import "ASLMemoryPoolHandle.h"
#import "ASLEncryptionParameters_Internal.h"
#import "NSError+CXXAdditions.h"

static seal::sec_level_type sealSecurityLevelFromASLSecurityLevel(ASLSecurityLevel securityLevel) {
    switch(securityLevel) {
        case None:
            return seal::sec_level_type::none;
        case TC128:
            return seal::sec_level_type::tc128;
        case TC192:
            return seal::sec_level_type::tc192;
        case TC256:
            return seal::sec_level_type::tc256;
    }
}

@implementation ASLSealContext {
    std::shared_ptr<seal::SEALContext> _sealContext;
}

#pragma mark - Initialization

+ (instancetype _Nullable)sealContextWithEncrytionParameters:(ASLEncryptionParameters *)encrytionParameters
  expandModChain:(BOOL)expandModChain
   securityLevel:(ASLSecurityLevel)securityLevel
memoryPoolHandle:(ASLMemoryPoolHandle*)pool
                                                       error:(NSError **)error {
    try {
        return [[ASLSealContext alloc] initWithEncryptionParameters:encrytionParameters.sealEncryptionParams expandModChain:expandModChain securityLevel:sealSecurityLevelFromASLSecurityLevel(securityLevel)];
    }  catch (std::invalid_argument const &e) {
           if (error != nil) {
               *error = [NSError ASL_SealInvalidParameter:e];
           }
           return nil;
       }
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    seal::EncryptionParameters const parameters = seal::EncryptionParameters();
    _sealContext = seal::SEALContext::Create(parameters);
    return self;
}

#pragma mark - Properties

// TODO - impletment

- (ASLSealContextData *)keyContextData {
    return [[ASLSealContextData alloc] initWithSEALContextData:_sealContext->key_context_data()];
}

- (ASLSealContextData *)firstContextData {
    return [[ASLSealContextData alloc] initWithSEALContextData:_sealContext->first_context_data()];
}

- (ASLSealContextData *)lastContextData {
    return [[ASLSealContextData alloc] initWithSEALContextData:_sealContext->last_context_data()];
}

- (ASLParametersIdType)keyParameterIds {
    auto const parameters = _sealContext->key_parms_id();
    return ASLParametersIdTypeMake(parameters[0], parameters[1], parameters[2], parameters[3]);
}

- (ASLParametersIdType)firstParameterIds {
    auto const parameters = _sealContext->first_parms_id();
    return ASLParametersIdTypeMake(parameters[0], parameters[1], parameters[2], parameters[3]);
}

- (ASLParametersIdType)lastParameterIds {
    auto const parameters = _sealContext->last_parms_id();
    return ASLParametersIdTypeMake(parameters[0], parameters[1], parameters[2], parameters[3]);
}

- (BOOL)isAllowedKeySwitching {
    return _sealContext->using_keyswitching();
}

- (BOOL)isValidEncrytionParameters {
    return _sealContext->parameters_set();
}

#pragma mark - Public Methods

- (ASLSealContextData *)contextData:(ASLParametersIdType)parametersId
                              error:(NSError **)error {
    seal::parms_id_type sealParametersId = {};
    std::copy(std::begin(parametersId.block),
              std::end(parametersId.block),
              sealParametersId.begin());
    
    
    
    return [[ASLSealContextData alloc] initWithSEALContextData:_sealContext->get_context_data(sealParametersId)];
}

#pragma mark - ASLSealContext_Internal

- (instancetype)initWithEncryptionParameters:(seal::EncryptionParameters)encryptionParameters
                              expandModChain:(BOOL)expandModChain
                               securityLevel:(seal::sec_level_type)securityLevel {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _sealContext = seal::SEALContext::Create(encryptionParameters, expandModChain, securityLevel);
    
    return self;
}

- (instancetype)initWithEncryptionParameters:(seal::EncryptionParameters)encryptionParameters
                              expandModChain:(BOOL)expandModChain {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _sealContext = seal::SEALContext::Create(encryptionParameters, expandModChain, seal::sec_level_type::tc128);
    
    return self;
}

- (instancetype)initWithEncryptionParameters:(seal::EncryptionParameters)encryptionParameters
                               securityLevel:(seal::sec_level_type)securityLevel {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _sealContext = seal::SEALContext::Create(encryptionParameters, true, securityLevel);
    
    return self;
}

- (instancetype)initWithEncryptionParameters:(seal::EncryptionParameters)encryptionParameters {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _sealContext = seal::SEALContext::Create(encryptionParameters);
    
    return self;
}

- (std::shared_ptr<seal::SEALContext>)sealContext {
    return _sealContext;
}

@end
