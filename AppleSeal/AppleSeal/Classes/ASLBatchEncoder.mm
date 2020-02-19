//
//  ASLBatchEncoder.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-10.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLBatchEncoder.h"

#include "seal/batchencoder.h"

#import "ASLEncryptionParameters.h"
#import "ASLSealContextData.h"
#import "ASLSealContextData_Internal.h"
#import "ASLSealContext_Internal.h"
#import "ASLEncryptionParameters_Internal.h"

#import "ASLPlainText_Internal.h"
#import "ASLMemoryPoolHandle_Internal.h"

NSString * const ASLBatchEncoderErrorDomain = @"ASLBatchEncodertErrorDomain";

@implementation ASLBatchEncoder {
	seal::BatchEncoder* _batchEncoder;
}

#pragma mark - Initialization

+ (instancetype)batchEncoderWithContext:(ASLSealContext *)context error:(NSError **)error {
	NSParameterAssert(context != nil);

	try {
		seal::BatchEncoder* batchEncoder = new seal::BatchEncoder(context.sealContext);
		return [[ASLBatchEncoder alloc] initWithBatchEncoder:batchEncoder];
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLBatchEncoderErrorDomain
												code:ASLBatchEncoderErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
		return nil;
	}
}

- (instancetype)initWithBatchEncoder:(seal::BatchEncoder *)batchEncoder {
	self = [super init];
	if (self == nil) {
		return nil;
	}
	_batchEncoder = batchEncoder;

	return self;
}

- (void)dealloc {
	delete _batchEncoder;
	_batchEncoder = nullptr;
}

#pragma mark - Properties

- (size_t)slot_count {
	return _batchEncoder->slot_count();
}

#pragma mark - Public Methods

- (BOOL)encodeWithValues:(NSArray<NSNumber *> *)values destination:(ASLPlainText *)destination error:(NSError **)error {

	std::vector<std::uint64_t> valuesList(static_cast<size_t>(values.count));
	for (NSNumber * const value in values) {
		valuesList.push_back(value.intValue);
	}
	const std::vector<uint64_t> constValuesValues = valuesList;

	auto sealPlainText = destination.sealPlainText;

	try {
		_batchEncoder->encode(constValuesValues, sealPlainText);
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLBatchEncoderErrorDomain
												code:ASLBatchEncoderErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
		return NO;
	}
	return NO;
}

- (BOOL)encodeWithPlainText:(ASLPlainText*)plainText
					  error:(NSError **)error {
	NSParameterAssert(plainText != nil);

	auto sealPlainText = plainText.sealPlainText;
	try {
		_batchEncoder->encode(sealPlainText);
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLBatchEncoderErrorDomain
												code:ASLBatchEncoderErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
		return NO;
	}
	return NO;
}

- (BOOL)encodeWithPlainText:(ASLPlainText*)plainText
					   pool:(ASLMemoryPoolHandle *)pool
					  error:(NSError **)error {
	NSParameterAssert(plainText != nil);
	NSParameterAssert(pool != nil);

	auto sealPlainText = plainText.sealPlainText;
	try {
		_batchEncoder->encode(sealPlainText, pool.memoryPoolHandle);
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLBatchEncoderErrorDomain
												code:ASLBatchEncoderErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
		return NO;
	}
	return NO;
}

- (BOOL)decodeWithPlainText:(ASLPlainText*)plainText
				Destination:(NSArray<NSNumber *>*)destination
					  error:(NSError **)error {
	NSParameterAssert(plainText != nil);
	NSParameterAssert(destination != nil);

	std::vector<std::uint64_t> destinationValuesList(static_cast<size_t>(destination.count));
	for (NSNumber * const value in destination) {
		destinationValuesList.push_back(value.intValue);
	}

	auto sealPlainText = plainText.sealPlainText;

	try {
		_batchEncoder->decode(sealPlainText, destinationValuesList);
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLBatchEncoderErrorDomain
												code:ASLBatchEncoderErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
		return NO;
	}
	return NO;
}

- (BOOL)decodeWithPlainText:(ASLPlainText*)plainText
				destination:(NSArray<NSNumber *>*)destination
					   pool:(ASLMemoryPoolHandle *)pool
					  error:(NSError **)error {
	NSParameterAssert(plainText != nil);
	NSParameterAssert(destination != nil);
	NSParameterAssert(pool != nil);

	std::vector<std::uint64_t> destinationValuesList(static_cast<size_t>(destination.count));
	for (NSNumber * const value in destination) {
		destinationValuesList.push_back(value.intValue);
	}

	auto sealPlainText = plainText.sealPlainText;

	try {
		_batchEncoder->decode(sealPlainText, destinationValuesList, pool.memoryPoolHandle);
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLBatchEncoderErrorDomain
												code:ASLBatchEncoderErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
		return NO;
	}
	return NO;
}

- (BOOL)decodeWithPlainText:(ASLPlainText*)plainText
					  error:(NSError **)error {
	NSParameterAssert(plainText != nil);

	auto sealPlainText = plainText.sealPlainText;

	try {
		_batchEncoder->decode(sealPlainText);
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLBatchEncoderErrorDomain
												code:ASLBatchEncoderErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
		return NO;
	}
	return NO;
}

- (BOOL)decodeWithPlainText:(ASLPlainText*)plainText
					   pool:(ASLMemoryPoolHandle *)pool
					  error:(NSError **)error {
	NSParameterAssert(plainText != nil);
	NSParameterAssert(pool != nil);

	auto sealPlainText = plainText.sealPlainText;

	try {
		_batchEncoder->decode(sealPlainText, pool.memoryPoolHandle);
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
			*error = [[NSError alloc] initWithDomain:ASLBatchEncoderErrorDomain
												code:ASLBatchEncoderErrorCodeInvalidParameter
											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
		}
		return NO;
	}
	return NO;
}

@end
