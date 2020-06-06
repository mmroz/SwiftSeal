//
//  ASLKSwitchKeys.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-12.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLKSwitchKeys.h"

#include "seal/publickey.h"
#include "seal/kswitchkeys.h"

#import "ASLPublicKey_Internal.h"
#import "ASLMemoryPoolHandle.h"
#import "ASLMemoryPoolHandle_Internal.h"
#import "ASLKSwitchKeys_Internal.h"
#import "ASLSecretKey_Internal.h"
#import "ASLSealContext_Internal.h"
#import "NSError+CXXAdditions.h"

@implementation ASLKSwitchKeys {
	seal::KSwitchKeys _kSiwtchKeys;
}

#pragma mark - initializers

- (instancetype)initWithKSwitchKeys:(seal::KSwitchKeys)kSwitckKeys {
	self = [super init];
	if (self == nil) {
		return nil;
	}
	
	_kSiwtchKeys = std::move(kSwitckKeys);
	
	return self;
}

- (instancetype)init {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	_kSiwtchKeys = seal::KSwitchKeys();
	
	return self;
}

#pragma mark - ASLKSwitchKeys_Internal

- (seal::KSwitchKeys)sealKSwitchKeys {
	return _kSiwtchKeys;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [[ASLKSwitchKeys allocWithZone:zone] initWithKSwitchKeys:_kSiwtchKeys];
}

#pragma mark - Public Properties

- (size_t)size {
	return _kSiwtchKeys.size();
}

- (NSArray<NSArray<ASLPublicKey *> *> *)data {
	NSMutableArray * publicKeyMatrix = [[NSMutableArray alloc] init];
	for (auto dataVectors: _kSiwtchKeys.data()) {
		NSMutableArray * publicKeyRow = [[NSMutableArray alloc] init];
		for (seal::PublicKey& publicKey: dataVectors) {
			ASLPublicKey* aslPublicKey = [[ASLPublicKey alloc] initWithPublicKey:publicKey];
			[publicKeyRow addObject:aslPublicKey];
		}
		[publicKeyMatrix addObject:publicKeyRow];
	}
	return publicKeyMatrix;
}

- (ASLParametersIdType)parametersId {
	auto const parameters = _kSiwtchKeys.parms_id();
	return ASLParametersIdTypeMake(parameters[0], parameters[1], parameters[2], parameters[3]);
}

- (ASLMemoryPoolHandle *)pool {
	return [[ASLMemoryPoolHandle alloc] initWithMemoryPoolHandle:_kSiwtchKeys.pool()];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
    std::size_t const lengthUpperBound = _kSiwtchKeys.save_size(seal::Serialization::compr_mode_default);
    NSMutableData * const data = [NSMutableData dataWithLength:lengthUpperBound];
    std::size_t const actualLength = _kSiwtchKeys.save(static_cast<std::byte *>(data.mutableBytes), lengthUpperBound);
    [data setLength:actualLength];
    [coder encodeDataObject:data];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
   // Intentionally left blank
    return nil;
}

- (instancetype)initWithData:(NSData *)data
                     context:(ASLSealContext *)context
                       error:(NSError **)error{
     seal::KSwitchKeys encodedkSwitchKeys;
     std::byte const * bytes = static_cast<std::byte const *>(data.bytes);
     std::size_t const length = static_cast<std::size_t const>(data.length);

    try {
        encodedkSwitchKeys.load(context.sealContext, bytes, length);
         return [self initWithKSwitchKeys:encodedkSwitchKeys];
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
