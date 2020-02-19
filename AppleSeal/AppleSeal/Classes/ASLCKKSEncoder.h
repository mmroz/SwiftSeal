//
//  ASLCKKSEncoder.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-05.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLSealContext.h"
#import "ASLPlainText.h"
#import "ASLMemoryPoolHandle.h"
#import "ASLComplexType.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLCKKSEncoder : NSObject

+ (instancetype _Nullable)ckksEncoderWithContext:(ASLSealContext *)context
										   error:(NSError **)error;

@property (nonatomic, readonly, assign) size_t slot_count;

- (BOOL)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
				  parametersId:(ASLParametersIdType)parametersId
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
						 error:(NSError **)error;

- (BOOL)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
				  parametersId:(ASLParametersIdType)parametersId
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
						  pool:(ASLMemoryPoolHandle*)pool
						 error:(NSError **)error;

- (BOOL)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
				   parametersId:(ASLParametersIdType)parametersId
						  scale:(double)scale
					destination:(ASLPlainText *)destination
						  error:(NSError **)error;

- (BOOL)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
				   parametersId:(ASLParametersIdType)parametersId
						  scale:(double)scale
					destination:(ASLPlainText *)destination
						   pool:(ASLMemoryPoolHandle *)pool
						  error:(NSError **)error;

- (BOOL)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
						 error:(NSError **)error;

- (BOOL)encodeWithDoubleValues:(NSArray<NSNumber *> *)values
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
						  pool:(ASLMemoryPoolHandle *)pool
						 error:(NSError **)error;

- (BOOL)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
						  scale:(double)scale
					destination:(ASLPlainText *)destination
						  error:(NSError **)error;

- (BOOL)encodeWithComplexValues:(NSArray<ASLComplexType *>*)values
						  scale:(double)scale
					destination:(ASLPlainText *)destination
						   pool:(ASLMemoryPoolHandle *)pool
						  error:(NSError **)error;

- (BOOL)encodeWithDoubleValue:(double)value
				 parametersId:(ASLParametersIdType)parametersId
						scale:(double)scale
				  destination:(ASLPlainText *)destination
						error:(NSError **)error;

- (BOOL)encodeWithDoubleValue:(double)value
				 parametersId:(ASLParametersIdType)parametersId
						scale:(double)scale
				  destination:(ASLPlainText *)destination
						 pool:(ASLMemoryPoolHandle *)pool
						error:(NSError **)error;

- (BOOL)encodeWithDoubleValue:(double)value
						scale:(double)scale
				  destination:(ASLPlainText *)destination
						error:(NSError **)error;

- (BOOL)encodeWithDoubleValue:(double)value
						scale:(double)scale
				  destination:(ASLPlainText *)destination
						 pool:(ASLMemoryPoolHandle *)pool
						error:(NSError **)error;

- (BOOL)encodeWithComplexValue:(ASLComplexType *)complexValue
				  parametersId:(ASLParametersIdType)parametersId
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
						 error:(NSError **)error;

- (BOOL)encodeWithComplexValue:(ASLComplexType *)complexValue
				  parametersId:(ASLParametersIdType)parametersId
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
						  pool:(ASLMemoryPoolHandle *)pool
						 error:(NSError **)error;

- (BOOL)encodeWithComplexValue:(ASLComplexType *)complexValue
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
						 error:(NSError **)error;

- (BOOL)encodeWithComplexValue:(ASLComplexType *)complexValue
						 scale:(double)scale
				   destination:(ASLPlainText *)destination
						  pool:(ASLMemoryPoolHandle *)pool
						 error:(NSError **)error;

- (BOOL)encodeWithLongValue:(long)longValue
			   parametersId:(ASLParametersIdType)parametersId
				destination:(ASLPlainText *)destination
					  error:(NSError **)error;

- (BOOL)encodeWithLongValue:(long)longValue
				destination:(ASLPlainText *)destination
					  error:(NSError **)error;

- (BOOL)decode:(ASLPlainText *)plainText
   destination:(NSArray<NSNumber *> *)destination
		 error:(NSError **)error;

- (BOOL)decode:(ASLPlainText *)plainText
   destination:(NSArray<NSNumber *> *)destination
		  pool:(ASLMemoryPoolHandle *)pool
		 error:(NSError **)error;

- (BOOL)decodeWithDoubleValues:(ASLPlainText *)plainText
				   destination:(NSArray<NSNumber *> *)destination
						 error:(NSError **)error;

- (BOOL)decodeWithComplexValues:(ASLPlainText *)plainText
					destination:(NSArray<ASLComplexType *>*)destination
						   pool:(ASLMemoryPoolHandle *)pool
						  error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
