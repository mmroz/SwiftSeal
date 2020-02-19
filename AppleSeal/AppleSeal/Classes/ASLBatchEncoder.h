//
//  ASLBatchEncoder.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-10.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <memory>

#import "ASLSealContext.h"
#import "ASLPlainText.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ASLBatchEncoderErrorDomain;

typedef NS_CLOSED_ENUM(NSInteger, ASLBatchEncoderErrorCode) {
	ASLBatchEncoderErrorCodeUnknown = 0,
	ASLBatchEncoderErrorCodeInvalidParameter,
	ASLBatchEncoderErrorCodeLogicError,
};

@interface ASLBatchEncoder : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (instancetype _Nullable)batchEncoderWithContext:(ASLSealContext *)context
											error:(NSError **)error;

@property (nonatomic, readonly, assign) size_t slot_count;

// TODO - handle the unsgned case
//- (BOOL)encodeWithUnsignedValues:(NSArray<std::uint64_t>*)unsignedValues
//					 destination:(ASLPlainText *)destination
//						   error:(NSError **)error;

- (BOOL)encodeWithValues:(NSArray<NSNumber *>*)values
				   destination:(ASLPlainText *)destination
						 error:(NSError **)error;

- (BOOL)encodeWithPlainText:(ASLPlainText*)plainText
					  error:(NSError **)error;

- (BOOL)encodeWithPlainText:(ASLPlainText*)plainText
					   pool:(ASLMemoryPoolHandle *)pool
					  error:(NSError **)error;

// TODO - handle the unsgned case
//- (BOOL)decodeWithPlainText:(ASLPlainText*)plainText
//		unsignedDestination:(NSArray<std::uint64_t>*)unsignedDestination
//					  error:(NSError **)error;
//
//- (BOOL)decodeWithPlainText:(ASLPlainText*)plainText
//		unsignedDestination:(NSArray<std::uint64_t>*)unsignedDestination
//					   pool:(ASLMemoryPoolHandle *)pool
//					  error:(NSError **)error;

- (BOOL)decodeWithPlainText:(ASLPlainText*)plainText
		  Destination:(NSArray<NSNumber *>*)destination
					  error:(NSError **)error;

- (BOOL)decodeWithPlainText:(ASLPlainText*)plainText
		  destination:(NSArray<NSNumber *>*)destination
					   pool:(ASLMemoryPoolHandle *)pool
					  error:(NSError **)error;

- (BOOL)decodeWithPlainText:(ASLPlainText*)plainText
					  error:(NSError **)error;

- (BOOL)decodeWithPlainText:(ASLPlainText*)plainText
					   pool:(ASLMemoryPoolHandle *)pool
					  error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
