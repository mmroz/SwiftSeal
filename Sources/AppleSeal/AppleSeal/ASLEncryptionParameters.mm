//
//  ASLEncryptionParameters.m
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLEncryptionParameters.h"

#include <string>
#include <stdexcept>
#include "seal/encryptionparams.h"

#import "ASLModulus.h"
#import "ASLModulus_Internal.h"
#import "ASLEncryptionParameters_Internal.h"
#import "NSString+CXXAdditions.h"
#import "NSError+CXXAdditions.h"

static std::uint8_t sealSchemeFromASLSchemeType(ASLSchemeType schemeType) {
    switch(schemeType) {
        case ASLSchemeTypeNone:
            return static_cast<uint8_t>(seal::scheme_type::none);
        case ASLSchemeTypeBFV:
            return static_cast<uint8_t>(seal::scheme_type::BFV);
        case ASLSchemeTypeCKKS:
            return static_cast<uint8_t>(seal::scheme_type::CKKS);
    }
}

@implementation ASLEncryptionParameters {
    seal::EncryptionParameters _encryptionParameters;
}

#pragma mark - Initialization

+ (instancetype)encryptionParametersWithSchemeType:(ASLSchemeType)schemeType {
    seal::EncryptionParameters const encryptionParameters = seal::EncryptionParameters(sealSchemeFromASLSchemeType(schemeType));
    return [[ASLEncryptionParameters alloc] initWithEncryptionParameters:encryptionParameters];
}

+ (instancetype)encryptionParametersWithScheme:(uint8_t)scheme
                                         error:(NSError **)error {
    try {
        seal::EncryptionParameters const encryptionParameters = seal::EncryptionParameters(scheme);
        return [[ASLEncryptionParameters alloc] initWithEncryptionParameters:encryptionParameters];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSData * const encodedValueData = [coder decodeDataObject];
    if (encodedValueData.length == 0) {
        return nil;
    }
    
    seal::EncryptionParameters encodedEncryptionParameters;
    std::byte const * bytes = static_cast<std::byte const *>(encodedValueData.bytes);
    std::size_t const length = static_cast<std::size_t const>(encodedValueData.length);
    
    try {
        encodedEncryptionParameters.load(bytes, length);
        return [self initWithEncryptionParameters:encodedEncryptionParameters];
    } catch (std::exception const &e) {
        return nil;
    }
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
    std::size_t const lengthUpperBound = _encryptionParameters.save_size(seal::Serialization::compr_mode_default);
    NSMutableData * const data = [NSMutableData dataWithLength:lengthUpperBound];
    std::size_t const actualLength = _encryptionParameters.save(static_cast<std::byte *>(data.mutableBytes), lengthUpperBound);
    [data setLength:actualLength];
    [coder encodeDataObject:data];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[ASLEncryptionParameters allocWithZone:zone] initWithEncryptionParameters:_encryptionParameters];
}

#pragma mark - Properties

- (size_t)polynomialModulusDegree {
    return _encryptionParameters.poly_modulus_degree();
}

- (NSArray<ASLModulus *> *)coefficientModulus {
    std::vector<seal::Modulus> const &modulusList = _encryptionParameters.coeff_modulus();
    NSMutableArray * const coefficientModulus = [NSMutableArray arrayWithCapacity:modulusList.size()];
    
    for (auto iter = modulusList.begin(); iter != modulusList.end(); ++iter) {
        ASLModulus * const modulus = [[ASLModulus alloc] initWithModulus:*iter];
        [coefficientModulus addObject:modulus];
    }
    
    return coefficientModulus;
}

- (ASLModulus *)plainModulus {
    return [[ASLModulus alloc] initWithModulus:_encryptionParameters.plain_modulus()];
}

- (ASLSchemeType)scheme {
    switch(_encryptionParameters.scheme()) {
        case seal::scheme_type::none:
            return ASLSchemeTypeNone;
        case seal::scheme_type::BFV:
            return ASLSchemeTypeBFV;
        case seal::scheme_type::CKKS:
            return ASLSchemeTypeCKKS;
    }
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[ASLEncryptionParameters class]]) {
        return NO;
    }
    
    return [self isEqualToEncryptionParameters:(ASLEncryptionParameters *)object];
}

- (NSString *)description
{
    NSString * scheme;
    switch (self.scheme) {
        case ASLSchemeTypeNone:
            scheme = @"None";
            break;
        case ASLSchemeTypeBFV:
            scheme = @"BFV";
            break;
        case ASLSchemeTypeCKKS:
            scheme = @"CKKS";
            break;
    }
    
    NSString * polyModulus = [NSString stringWithFormat:@"%zu",self.polynomialModulusDegree];
    
    NSString * coeffModulus = [self.coefficientModulus componentsJoinedByString:@", "];
    
    NSString * plainModulus = self.plainModulus.description;
    
    
    return [NSString stringWithFormat:@"scheme: %@, polynmial modulus degree %@, Coefficient Modulus %@, Plain Modulus %@", scheme, polyModulus, coeffModulus, plainModulus];
}

#pragma mark - Public Methods

- (BOOL)isEqualToEncryptionParameters:(ASLEncryptionParameters *)other {
    NSParameterAssert(other != nil);
    if (other == nil) {
        return NO;
    } else {
        return _encryptionParameters == other->_encryptionParameters;
    }
}

- (BOOL)setPolynomialModulusDegree:(size_t)polynomialModulusDegree
                             error:(NSError **)error {
    try {
        _encryptionParameters.set_poly_modulus_degree(polynomialModulusDegree);
        return YES;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)setCoefficientModulus:(NSArray<ASLModulus *> *)coefficientModulus
                        error:(NSError **)error {
    std::vector<seal::Modulus> modulusList;
    for (ASLModulus * const modulus in coefficientModulus) {
        modulusList.push_back(modulus.modulus);
    }
    
    try {
        _encryptionParameters.set_coeff_modulus(modulusList);
        return YES;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)setPlainModulus:(ASLModulus *)plainModulus
                  error:(NSError **)error {
    NSParameterAssert(plainModulus != nil);
    
    try {
        _encryptionParameters.set_plain_modulus(plainModulus.modulus);
        return YES;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)setPlainModulusWithInteger:(uint64_t)plainModulus
                             error:(NSError **)error {
    
    try {
            _encryptionParameters.set_plain_modulus(plainModulus);
           return YES;
       } catch (std::invalid_argument const &e) {
           if (error != nil) {
               *error = [NSError ASL_SealInvalidParameter:e];
           }
           return NO;
       }
     return NO;
}

#pragma mark - ASLEncrytionParameters_Internal

- (instancetype)initWithEncryptionParameters:(seal::EncryptionParameters)encryptionParameters {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _encryptionParameters = std::move(encryptionParameters);
    
    return self;
}

- (seal::EncryptionParameters)sealEncryptionParams {
    return _encryptionParameters;
}

@end
