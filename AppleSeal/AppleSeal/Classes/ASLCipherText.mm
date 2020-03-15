//
//  ASLCipherText.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-01.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLCipherText.h"

#include <string>
#include <stdexcept>
#include "seal/ciphertext.h"

#import "NSString+CXXAdditions.h"

#import "ASLMemoryPoolHandle.h"
#import "ASLMemoryPoolHandle_Internal.h"
#import "ASLSealContextData_Internal.h"
#import "ASLSealContext_Internal.h"

@implementation ASLCipherText {
	seal::Ciphertext _cipherText;
}

// TODO see if I need this
+ (instancetype _Nullable)cipherTextWithCipherText:(ASLCipherText *)cipherText
											  pool:(ASLMemoryPoolHandle *)pool
											 error:(NSError **)error {
	NSParameterAssert(cipherText != nil);
	NSParameterAssert(pool != nil);
	try {
		seal::Ciphertext const cipherText = seal::Ciphertext(cipherText, pool.memoryPoolHandle);
		return [[ASLCipherText alloc] initWithCipherText:cipherText];
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLCipherTextErrorDomain
												code:ASLCipherTextErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
	}
	return nil;
}

+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
								   parametersId:(ASLParametersIdType *)parametersId
								   sizeCapacity:(size_t)sizeCapacity
										   pool:(ASLMemoryPoolHandle *)pool
										  error:(NSError **)error {
	NSParameterAssert(context != nil);
	NSParameterAssert(parametersId != nil);
	NSParameterAssert(pool != nil);
	try {
		seal::parms_id_type sealParametersId = {};
		std::copy(std::begin(parametersId->block),
				  std::end(parametersId->block),
				  sealParametersId.begin());
		seal::Ciphertext const cipherText = seal::Ciphertext(context.sealContext, sealParametersId, sizeCapacity, pool.memoryPoolHandle);
		return [[ASLCipherText alloc] initWithCipherText:cipherText];
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLCipherTextErrorDomain
												code:ASLCipherTextErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
	}
	return nil;
}

+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
								   sizeCapacity:(size_t)sizeCapacity
								   parametersId:(ASLParametersIdType *)parametersId
										  error:(NSError **)error {
	NSParameterAssert(context != nil);
	NSParameterAssert(parametersId != nil);
	try {
		seal::parms_id_type sealParametersId = {};
		std::copy(std::begin(parametersId->block),
				  std::end(parametersId->block),
				  sealParametersId.begin());
		seal::Ciphertext const cipherText = seal::Ciphertext(context.sealContext, sealParametersId, sizeCapacity);
		return [[ASLCipherText alloc] initWithCipherText:cipherText];
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLCipherTextErrorDomain
												code:ASLCipherTextErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
	}
	return nil;
}

+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
								   parametersId:(ASLParametersIdType *)parametersId
										   pool:(ASLMemoryPoolHandle *)pool
										  error:(NSError **)error {
	NSParameterAssert(context != nil);
	NSParameterAssert(parametersId != nil);
	NSParameterAssert(pool != nil);
	try {
		seal::parms_id_type sealParametersId = {};
		std::copy(std::begin(parametersId->block),
				  std::end(parametersId->block),
				  sealParametersId.begin());
		seal::Ciphertext const cipherText = seal::Ciphertext(context.sealContext, sealParametersId, pool.memoryPoolHandle);
		return [[ASLCipherText alloc] initWithCipherText:cipherText];
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLCipherTextErrorDomain
												code:ASLCipherTextErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
	}
	return nil;
}

+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
								   parametersId:(ASLParametersIdType *)parametersId
										  error:(NSError **)error {
	NSParameterAssert(context != nil);
	NSParameterAssert(parametersId != nil);
	try {
		seal::parms_id_type sealParametersId = {};
		std::copy(std::begin(parametersId->block),
				  std::end(parametersId->block),
				  sealParametersId.begin());
		seal::Ciphertext const cipherText = seal::Ciphertext(context.sealContext, sealParametersId);
		return [[ASLCipherText alloc] initWithCipherText:cipherText];
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLCipherTextErrorDomain
												code:ASLCipherTextErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
	}
	return nil;
}

+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
										   pool:(ASLMemoryPoolHandle *)pool
										  error:(NSError **)error {
	NSParameterAssert(context != nil);
	NSParameterAssert(pool != nil);
	try {
		seal::Ciphertext const cipherText = seal::Ciphertext(context.sealContext, pool.memoryPoolHandle);
		return [[ASLCipherText alloc] initWithCipherText:cipherText];
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLCipherTextErrorDomain
												code:ASLCipherTextErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
	}
	return nil;
}


+ (instancetype _Nullable)cipherTextWithContext:(ASLSealContext *)context
										  error:(NSError **)error {
	NSParameterAssert(context != nil);
	try {
		seal::Ciphertext const cipherText = seal::Ciphertext(context.sealContext);
		return [[ASLCipherText alloc] initWithCipherText:cipherText];
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLCipherTextErrorDomain
												code:ASLCipherTextErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
	}
	return nil;
}

- (instancetype)initWithPool:(ASLMemoryPoolHandle *)pool {
	NSParameterAssert(pool != nil);
	return [[ASLCipherText alloc] initWithCipherText:pool.memoryPoolHandle];
}

- (instancetype)init {
	return [[ASLCipherText alloc] initWithCipherText:seal::Ciphertext()];
}

#pragma mark - ASLCipherText_Internal

- (seal::Ciphertext)sealCipherText {
	return _cipherText;
}

- (instancetype)initWithCipherText:(seal::Ciphertext)cipherText {
	self = [super init];
	if (self == nil) {
		return nil;
	}
	
	_cipherText = std::move(cipherText);
	
	return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder {
	NSData * const encodedValueData = [coder decodeDataObject];
	if (encodedValueData.length == 0) {
		return nil;
	}

	seal::Ciphertext encodedCipherText;
	std::byte const * bytes = static_cast<std::byte const *>(encodedValueData.bytes);
	std::size_t const length = static_cast<std::size_t const>(encodedValueData.length);
//	encodedCipherText.load(bytes, length); TODO - uh oh
	return [self initWithCipherText:encodedCipherText];
}


- (void)encodeWithCoder:(NSCoder *)coder {
	std::size_t const lengthUpperBound = _cipherText.save_size(seal::Serialization::compr_mode_default);
	NSMutableData * const data = [NSMutableData dataWithLength:lengthUpperBound];
	std::size_t const actualLength = _cipherText.save(static_cast<std::byte *>(data.mutableBytes), lengthUpperBound);
	[data setLength:actualLength];
	[coder encodeDataObject:data];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [[ASLCipherText allocWithZone:zone] initWithCipherText:_cipherText];
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
	if (self == object) {
	  return YES;
	}

	if (![object isKindOfClass:[ASLCipherText class]]) {
	  return NO;
	}

	return [self isEqualToCipherText:(ASLCipherText *)object];
}

#pragma mark - Properies

- (NSInteger)intArray {
    return _cipherText.int_array()
}

- (size_t)coefficientModulusCount {
	return _cipherText.coeff_mod_count();
}

- (size_t)polynomialModulusDegree {
	return _cipherText.poly_modulus_degree();
}

- (size_t)size {
	return _cipherText.size();
}

- (size_t)sizeCapacity {
	return _cipherText.size_capacity();
}

- (BOOL)isTransparent {
	return _cipherText.is_transparent();
}

- (BOOL)isNntForm {
	return _cipherText.is_ntt_form();
}

- (ASLParametersIdType)parametersId {
	auto const parameters = _cipherText.parms_id();
	return ASLParametersIdTypeMake(parameters[0], parameters[1], parameters[2], parameters[3]);
}

- (double)scale {
	return _cipherText.scale();
}

- (ASLMemoryPoolHandle *)pool {
	return [[ASLMemoryPoolHandle alloc] initWithMemoryPoolHandle:_cipherText.pool()];
}

#pragma mark - Public Methods

- (BOOL)isEqualToCipherText:(ASLCipherText *)other {
	
	// TODO - implement this
	
	NSParameterAssert(other != nil);
	if (other == nil) {
		return NO;
	} else {
		return NO;
//		return _cipherText == other->_cipherText;
	}
}

- (BOOL)reserve:(ASLSealContext *)context
   parametersId:(ASLParametersIdType)parametersId
   sizeCapacity:(size_t)sizeCapacity
		  error:(NSError **)error {
	NSParameterAssert(context != nil);
	try {
		
		seal::parms_id_type sealParametersId = {};
		std::copy(std::begin(parametersId.block),
				  std::end(parametersId.block),
				  sealParametersId.begin());

		_cipherText.reserve(context.sealContext, sealParametersId, sizeCapacity);
		return YES;
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLCipherTextErrorDomain
												code:ASLCipherTextErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
		return NO;
	}
	return NO;
}

- (BOOL)reserve:(ASLSealContext *)context
   sizeCapacity:(size_t)sizeCapacity
		  error:(NSError **)error {
	NSParameterAssert(context != nil);
	try {
		_cipherText.reserve(context.sealContext, sizeCapacity);
		return YES;
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLCipherTextErrorDomain
												code:ASLCipherTextErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
		return NO;
	}
	return NO;
}

- (BOOL)reserve:(size_t)sizeCapacity
		  error:(NSError **)error {
	try {
		_cipherText.reserve(sizeCapacity);
		return YES;
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLCipherTextErrorDomain
												code:ASLCipherTextErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
		return NO;
	} catch (std::logic_error const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLCipherTextErrorDomain
												code:ASLCipherTextErrorCodeLogicError
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
		return NO;
	}
	return NO;
}

- (BOOL)resize:(ASLSealContext *)context
  parametersId:(ASLParametersIdType)parametersId
  sizeCapacity:(size_t)size
		 error:(NSError **)error {
	NSParameterAssert(context != nil);
	seal::parms_id_type sealParametersId = {};
	std::copy(std::begin(parametersId.block),
			  std::end(parametersId.block),
			  sealParametersId.begin());
	try {
		_cipherText.resize(context.sealContext, sealParametersId, size);
		return YES;
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLCipherTextErrorDomain
												code:ASLCipherTextErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
		return NO;
	}
	return NO;
}

- (BOOL)resize:(ASLSealContext *)context
  sizeCapacity:(size_t)size
		 error:(NSError **)error {
	NSParameterAssert(context != nil);
	try {
		_cipherText.resize(context.sealContext, size);
		return YES;
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLCipherTextErrorDomain
												code:ASLCipherTextErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
		return NO;
	}
	return NO;
}

- (BOOL)resize:(size_t)size
		 error:(NSError **)error {
	try {
		_cipherText.resize(size);
		return YES;
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLCipherTextErrorDomain
												code:ASLCipherTextErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
		return NO;
	}
	return NO;
}

-(void)returnMemoryToPool {
	_cipherText.release();
}

- (uint64_t)polynomialCoefficientAtIndex:(size_t)index
								   error:(NSError **)error {
	try {
		return static_cast<uint64_t>(_cipherText[index]);
	} catch (...) {
		[NSException raise:NSRangeException
					format:@"Index %@ out of bounds", @(index)];
	}
	return 0;
}

@end
