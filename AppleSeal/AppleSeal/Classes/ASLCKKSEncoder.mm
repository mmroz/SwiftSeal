//
//  ASLCKKSEncoder.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-05.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLCKKSEncoder.h"

#include "seal/ckks.h"

#import "ASLSealContext_Internal.h"
#import "ASLPlainText_Internal.h"
#import "ASLMemoryPoolHandle_Internal.h"
#import "ASLComplexType_Internal.h"
#import "ASLComplexType.h"

@implementation ASLCKKSEncoder {
	std::shared_ptr<seal::CKKSEncoder> _ckksEncoder;
}

#pragma mark - Initialization

+ (instancetype)ckksEncoderWithContext:(ASLSealContext *)context error:(NSError **)error {
	return [[ASLCKKSEncoder alloc] initWithCkksEncoder:seal::CKKSEncoder(context.sealContext)];
}

- (instancetype)initWithCkksEncoder:(seal::CKKSEncoder)ckksEncoder {
	self = [super init];
	if (self == nil) {
		return nil;
	}
	
	_ckksEncoder = std::make_shared<seal::CKKSEncoder>(std::move(ckksEncoder));
	
	return self;
}

#pragma mark - Properties

- (size_t)slot_count {
	return _ckksEncoder->slot_count();
}

#pragma mark - Public Methods

- (BOOL)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
				  parametersId:(ASLParametersIdType)parametersId
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
						 error:(NSError **)error {
	
	// TODO - add error handling
	
	std::vector<double> doubleValuesList(static_cast<size_t>(values.count));
	for (NSNumber * const value in values) {
		doubleValuesList.push_back(value.doubleValue);
	}
	const std::vector<double> constDoubleValues = doubleValuesList;
	
	seal::parms_id_type sealParametersId = {};
	std::copy(std::begin(parametersId.block),
			  std::end(parametersId.block),
			  sealParametersId.begin());
	
	auto sealPlainText = destination.sealPlainText;
	_ckksEncoder->encode(constDoubleValues, sealParametersId, scale, sealPlainText);
	
	return YES;
}

- (BOOL)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
				  parametersId:(ASLParametersIdType)parametersId
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
						  pool:(ASLMemoryPoolHandle*)pool
						 error:(NSError **)error {
	
	// TODO - add error handling
	
	std::vector<double> doubleValuesList(static_cast<size_t>(values.count));
	for (NSNumber * const value in values) {
		doubleValuesList.push_back(value.doubleValue);
	}
	const std::vector<double> constDoubleValues = doubleValuesList;
	
	seal::parms_id_type sealParametersId = {};
	std::copy(std::begin(parametersId.block),
			  std::end(parametersId.block),
			  sealParametersId.begin());
	
	auto sealPlainText = destination.sealPlainText;
	_ckksEncoder->encode(constDoubleValues, sealParametersId, scale, sealPlainText, pool.memoryPoolHandle);
	
	return YES;
}

- (BOOL)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
				   parametersId:(ASLParametersIdType)parametersId
						  scale:(double)scale
					destination:(ASLPlainText *)destination
						  error:(NSError **)error {
	
	// TODO - add error handling
	
	std::vector<std::complex<double>> doubleValuesList(static_cast<size_t>(values.count));
	for (ASLComplexType * const value in values) {
		doubleValuesList.push_back(value.complex);
	}
	
	seal::parms_id_type sealParametersId = {};
	std::copy(std::begin(parametersId.block),
			  std::end(parametersId.block),
			  sealParametersId.begin());
	
	auto sealPlainText = destination.sealPlainText;
	_ckksEncoder->encode(doubleValuesList, sealParametersId, scale, sealPlainText);
	
	return YES;
}

- (BOOL)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
				   parametersId:(ASLParametersIdType)parametersId
						  scale:(double)scale
					destination:(ASLPlainText *)destination
						   pool:(ASLMemoryPoolHandle *)pool
						  error:(NSError **)error {
	
	// TODO - add error handling
	
	std::vector<std::complex<double>> doubleValuesList(static_cast<size_t>(values.count));
	for (ASLComplexType * const value in values) {
		doubleValuesList.push_back(value.complex);
	}
	
	seal::parms_id_type sealParametersId = {};
	std::copy(std::begin(parametersId.block),
			  std::end(parametersId.block),
			  sealParametersId.begin());
	
	auto sealPlainText = destination.sealPlainText;
	_ckksEncoder->encode(doubleValuesList, sealParametersId, scale, sealPlainText, pool.memoryPoolHandle);
	
	return YES;
}

- (BOOL)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
						 error:(NSError **)error {
	
	// TODO - add error handling
	
	std::vector<double> doubleValuesList(static_cast<size_t>(values.count));
	for (NSNumber * const value in values) {
		doubleValuesList.push_back(value.doubleValue);
	}
	const std::vector<double> constDoubleValues = doubleValuesList;
	
	auto sealPlainText = destination.sealPlainText;
	_ckksEncoder->encode(constDoubleValues, scale, sealPlainText);
	
	return YES;
}

- (BOOL)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
						  pool:(ASLMemoryPoolHandle *)pool
						 error:(NSError **)error {
	// TODO - add error handling
	
	std::vector<double> doubleValuesList(static_cast<size_t>(values.count));
	for (NSNumber * const value in values) {
		doubleValuesList.push_back(value.doubleValue);
	}
	const std::vector<double> constDoubleValues = doubleValuesList;
	
	auto sealPlainText = destination.sealPlainText;
	_ckksEncoder->encode(constDoubleValues, scale, sealPlainText, pool.memoryPoolHandle);
	
	return YES;
}

- (BOOL)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
						  scale:(double)scale
					destination:(ASLPlainText *)destination
						  error:(NSError **)error {
	
	// TODO - add error handling
	
	std::vector<std::complex<double>> doubleValuesList(static_cast<size_t>(values.count));
	for (ASLComplexType * const value in values) {
		doubleValuesList.push_back(value.complex);
	}
	
	auto sealPlainText = destination.sealPlainText;
	_ckksEncoder->encode(doubleValuesList, scale, sealPlainText);
	
	return YES;
}

- (BOOL)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
						  scale:(double)scale
					destination:(ASLPlainText *)destination
						   pool:(ASLMemoryPoolHandle *)pool
						  error:(NSError **)error {
	
	// TODO - add error handling
	
	std::vector<std::complex<double>> doubleValuesList(static_cast<size_t>(values.count));
	for (ASLComplexType * const value in values) {
		doubleValuesList.push_back(value.complex);
	}
	
	auto sealPlainText = destination.sealPlainText;
	_ckksEncoder->encode(doubleValuesList, scale, sealPlainText, pool.memoryPoolHandle);
	
	return YES;
}

- (BOOL)encodeWithDoubleValue:(double)value
				 parametersId:(ASLParametersIdType)parametersId
						scale:(double)scale
				  destination:(ASLPlainText *)destination
						error:(NSError **)error {
	
	// TODO - add error handling
	
	seal::parms_id_type sealParametersId = {};
	std::copy(std::begin(parametersId.block),
			  std::end(parametersId.block),
			  sealParametersId.begin());
	
	auto sealPlainText = destination.sealPlainText;
	
	_ckksEncoder->encode(value, sealParametersId, scale, sealPlainText);
	
	return YES;
}

- (BOOL)encodeWithDoubleValue:(double)value
				 parametersId:(ASLParametersIdType)parametersId
						scale:(double)scale
				  destination:(ASLPlainText *)destination
						 pool:(ASLMemoryPoolHandle *)pool
						error:(NSError **)error {
	
	// TODO - add error handling
	
	seal::parms_id_type sealParametersId = {};
	std::copy(std::begin(parametersId.block),
			  std::end(parametersId.block),
			  sealParametersId.begin());
	
	auto sealPlainText = destination.sealPlainText;
	
	_ckksEncoder->encode(value, sealParametersId, scale, sealPlainText);
	
	return YES;
}

- (BOOL)encodeWithDoubleValue:(double)value
						scale:(double)scale
				  destination:(ASLPlainText *)destination
						error:(NSError **)error {
	// TODO - add error handling
	
	auto sealPlainText = destination.sealPlainText;
	
	_ckksEncoder->encode(value, scale, sealPlainText);
	
	return YES;
}

- (BOOL)encodeWithDoubleValue:(double)value
						scale:(double)scale
				  destination:(ASLPlainText *)destination
						 pool:(ASLMemoryPoolHandle *)pool
						error:(NSError **)error {
	// TODO - add error handling
	
	auto sealPlainText = destination.sealPlainText;
	
	_ckksEncoder->encode(value, scale, sealPlainText, pool.memoryPoolHandle);
	
	return YES;
}

- (BOOL)encodeWithComplexValue:(ASLComplexType *)complexValue
				  parametersId:(ASLParametersIdType)parametersId
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
						 error:(NSError **)error {
	// TODO - add error handling
	
	seal::parms_id_type sealParametersId = {};
	std::copy(std::begin(parametersId.block),
			  std::end(parametersId.block),
			  sealParametersId.begin());
	
	auto sealPlainText = destination.sealPlainText;
	
	_ckksEncoder->encode(complexValue.complex, sealParametersId, scale, sealPlainText);
	
	return YES;
}

- (BOOL)encodeWithComplexValue:(ASLComplexType *)complexValue
				  parametersId:(ASLParametersIdType)parametersId
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
						  pool:(ASLMemoryPoolHandle *)pool
						 error:(NSError **)error {
	
	// TODO - add error handling
	
	seal::parms_id_type sealParametersId = {};
	std::copy(std::begin(parametersId.block),
			  std::end(parametersId.block),
			  sealParametersId.begin());
	
	auto sealPlainText = destination.sealPlainText;
	
	_ckksEncoder->encode(complexValue.complex, sealParametersId, scale, sealPlainText, pool.memoryPoolHandle);
	
	return YES;
}

- (BOOL)encodeWithComplexValue:(ASLComplexType *)complexValue
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
						 error:(NSError **)error {
	// TODO - add error handling
	
	auto sealPlainText = destination.sealPlainText;
	
	_ckksEncoder->encode(complexValue.complex, scale, sealPlainText);
	
	return YES;
}

- (BOOL)encodeWithComplexValue:(ASLComplexType *)complexValue
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
						  pool:(ASLMemoryPoolHandle *)pool
						 error:(NSError **)error {
	
	// TODO - add error handling
	
	auto sealPlainText = destination.sealPlainText;
	
	_ckksEncoder->encode(complexValue.complex, scale, sealPlainText, pool.memoryPoolHandle);
	
	return YES;
}

- (BOOL)encodeWithLongValue:(long)longValue
			   parametersId:(ASLParametersIdType)parametersId
				destination:(ASLPlainText *)destination
					  error:(NSError **)error {
	
	// TODO - add error handling
	
	seal::parms_id_type sealParametersId = {};
	std::copy(std::begin(parametersId.block),
			  std::end(parametersId.block),
			  sealParametersId.begin());
	
	auto sealPlainText = destination.sealPlainText;
	
	_ckksEncoder->encode(longValue, sealParametersId, sealPlainText);
	
	return YES;
}

- (BOOL)encodeWithLongValue:(long)longValue
				destination:(ASLPlainText *)destination
					  error:(NSError **)error {
	// TODO - add error handling
	
	auto sealPlainText = destination.sealPlainText;
	
	_ckksEncoder->encode(longValue, sealPlainText);
	return YES;
}

- (BOOL)decode:(ASLPlainText *)plainText
   destination:(NSArray<NSNumber *> *)destination
		 error:(NSError **)error {
	// TODO - add error handling
	
	auto const sealPlainText = plainText.sealPlainText;
	
	std::vector<double> doubleValuesList(static_cast<size_t>(destination.count));
	for (NSNumber * const value in destination) {
		doubleValuesList.push_back(value.doubleValue);
	}
	const std::vector<double> constDoubleValues = doubleValuesList;
	
	// TODO - fix this
	//_ckksEncoder->decode(sealPlainText, constDoubleValues)
	
	return YES;
}

- (BOOL)decode:(ASLPlainText *)plainText
   destination:(NSArray<NSNumber *> *)destination
		  pool:(ASLMemoryPoolHandle *)pool
		 error:(NSError **)error {
	// TODO - implement
	
	return YES;
}

- (BOOL)decodeWithDoubleValues:(ASLPlainText *)plainText
				   destination:(NSArray<NSNumber *> *)destination
						 error:(NSError **)error {
	// TODO - implement
	
	return YES;
}

- (BOOL)decodeWithComplexValues:(ASLPlainText *)plainText
					destination:(NSArray<ASLComplexType *>*)destination
						   pool:(ASLMemoryPoolHandle *)pool
						  error:(NSError **)error {
	// TODO - implement
	
	return YES;
}
@end
