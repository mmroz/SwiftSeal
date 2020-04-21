//
//  ASLSealContextData.m
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLSealContextData.h"
#import "ASLSealContextData_Internal.h"

#include "seal/context.h"

#import "ASLEncryptionParameters_Internal.h"
#import "ASLSmallNttTables_Internal.h"

@implementation ASLSealContextData {
	std::shared_ptr<const seal::SEALContext::ContextData> _contextData;
}

#pragma mark - Initialization

- (instancetype)init {
	[NSException raise:NSInternalInconsistencyException
				format:@"%s is not a valid initializer", __PRETTY_FUNCTION__];
	return nil;
}

#pragma mark - ASLSealContextData_Internal

- (instancetype)initWithSEALContextData:(std::shared_ptr<const seal::SEALContext::ContextData>)contextData {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	_contextData = contextData;
	
	return self;
}

#pragma mark - Properties

- (ASLEncryptionParameters *)encryptionParameters {
	return [[ASLEncryptionParameters alloc] initWithEncryptionParameters:_contextData->parms()];
}

- (ASLParametersIdType)parametersId {
	auto const parameters = _contextData->parms_id();
	return ASLParametersIdTypeMake(parameters[0], parameters[1], parameters[2], parameters[3]);
}

- (const std::uint64_t*)totalCoefficientModulus {
	return _contextData->total_coeff_modulus();
}

- (NSInteger)totalCoefficientModulusBitCount {
	return _contextData->total_coeff_modulus_bit_count();
}

- (const std::uint64_t*)coefficientDividedPlainModulus {
	return _contextData->coeff_div_plain_modulus();
}

- (NSInteger)plainUpperHalfThreshold {
	return _contextData->plain_upper_half_threshold();
}

- (const std::uint64_t*)plainUpperHalfIncrement {
	return _contextData->plain_upper_half_increment();
}

- (NSInteger)upperHalfThreshold {
	return _contextData->plain_upper_half_threshold();
}

- (const std::uint64_t*)upperHalfIncrement {
	return _contextData->upper_half_increment();
}

- (const uint64_t)coefficientModPlainModulus {
    return _contextData->coeff_mod_plain_modulus();
}

- (ASLSealContextData *)previousContextData {
	return [[ASLSealContextData alloc] initWithSEALContextData:_contextData->prev_context_data()];
}

- (ASLSealContextData *)nextContextData {
	return [[ASLSealContextData alloc] initWithSEALContextData:_contextData->prev_context_data()];
}

- (NSInteger)chainIndex {
	return _contextData->chain_index();
}

- (ASLEncryptionParameterQualifiers)qualifiers {
    seal::EncryptionParameterQualifiers qualifiers = _contextData->qualifiers();
    return ASLEncryptionParameterQualifiersMake(qualifiers.parameters_set, qualifiers.using_fft, qualifiers.using_ntt, qualifiers.using_batching, qualifiers.using_fast_plain_lift, qualifiers.using_descending_modulus_chain, static_cast<int>(qualifiers.sec_level));
}

- (ASLSmallNttTables *)smallNttTables {
    auto table = _contextData->small_ntt_tables().get();
    return [[ASLSmallNttTables alloc] initWithSmallNttTables:table];
}

@end
