//
//  ASLPublicKey.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-11.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLPublicKey.h"

#include "seal/publickey.h"

#import "ASLParametersIdType.h"
#import "ASLCipherText.h"
#import "ASLMemoryPoolHandle.h"
#import "ASLMemoryPoolHandle_Internal.h"
#import "ASLCipherText_Internal.h"
#import "ASLSealContext_Internal.h"
#import "ASLPublicKey_Internal.h"
#import "NSError+CXXAdditions.h"

static seal::compr_mode_type sealComprModeTypeFromASLCompressionModeType(ASLCompressionModeType compressionModeType) {
	switch(compressionModeType) {
		case CompressionNone:
			return seal::compr_mode_type::none;
		case CompressionDeflate:
            // TODO - fix this
            return seal::compr_mode_type::none;
			//return seal::compr_mode_type::deflate;
	}
}

@implementation ASLPublicKey {
	seal::PublicKey _publicKey;
}

#pragma mark - Initiaiziation

- (instancetype)init {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	_publicKey = seal::PublicKey();
	return self;
}

#pragma mark - Public Properties

- (ASLCipherText *)cipherTextData {
	return [[ASLCipherText alloc] initWithCipherText:_publicKey.data()];
}

- (ASLParametersIdType)parametersId {
	auto const parameters = _publicKey.parms_id();
	return ASLParametersIdTypeMake(parameters[0], parameters[1], parameters[2], parameters[3]);
}

- (ASLMemoryPoolHandle *)pool {
	return [[ASLMemoryPoolHandle alloc] initWithMemoryPoolHandle:_publicKey.pool()];
}

#pragma mark - ASLPublicKey_Internal

- (seal::PublicKey)sealPublicKey {
	return _publicKey;
}

- (instancetype)initWithPublicKey:(seal::PublicKey)publicKey {
	self = [super init];
	if (self == nil) {
		return nil;
	}
	
	_publicKey = std::move(publicKey);
	
	return self;
}

#pragma mark - Public Methods

- (long long)saveSize:(ASLCompressionModeType)compressionModeType
				error:(NSError **)error {
	try {
		return _publicKey.save_size(sealComprModeTypeFromASLCompressionModeType(compressionModeType));
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
		}
		return 0;
	}  catch (std::logic_error const &e) {
		if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
		}
		return 0;
	}
    return 0;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [[ASLPublicKey allocWithZone:zone] initWithPublicKey:_publicKey];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
    std::size_t const lengthUpperBound = _publicKey.save_size(seal::Serialization::compr_mode_default);
    NSMutableData * const data = [NSMutableData dataWithLength:lengthUpperBound];
    std::size_t const actualLength = _publicKey.save(static_cast<std::byte *>(data.mutableBytes), lengthUpperBound);
    [data setLength:actualLength];
    [coder encodeDataObject:data];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
   // Intentially left blank
    return nil;
}

- (instancetype)initWithData:(NSData *)data
                     context:(ASLSealContext *)context
                       error:(NSError **)error{
     seal::PublicKey encodedPublicKey;
     std::byte const * bytes = static_cast<std::byte const *>(data.bytes);
     std::size_t const length = static_cast<std::size_t const>(data.length);

    try {
        encodedPublicKey.load(context.sealContext, bytes, length);
         return [self initWithPublicKey:encodedPublicKey];
    } catch (std::logic_error const &e) {
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
