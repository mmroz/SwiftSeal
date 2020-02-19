//
//  ASLMemoryPoolHandle.m
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-30.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLMemoryPoolHandle.h"
#import "ASLMemoryPoolHandle_Internal.h"

#include "seal/memorymanager.h"

@implementation ASLMemoryPoolHandle {
	seal::MemoryPoolHandle _memoryPoolHandle;
}

#pragma mark - Initialization

- (instancetype)initWithMemoryPoolHandle:(seal::MemoryPoolHandle)memoryPoolHandle {
	self = [super init];
	if (self == nil) {
		return nil;
	}
	
	_memoryPoolHandle = std::move(memoryPoolHandle);
	
	return self;
}

- (instancetype)init {
	[NSException raise:NSInternalInconsistencyException
				format:@"%s is not a valid initializer", __PRETTY_FUNCTION__];
	return nil;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [[ASLMemoryPoolHandle allocWithZone:zone] initWithMemoryPoolHandle:_memoryPoolHandle];
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
	if (self == object) {
	  return YES;
	}

	if (![object isKindOfClass:[ASLMemoryPoolHandle class]]) {
	  return NO;
	}

	return [self isEqualToMemoryPoolHandle:(ASLMemoryPoolHandle *)object];
}

#pragma mark - Static Methods

+ (ASLMemoryPoolHandle *)global {
	static ASLMemoryPoolHandle * globalHandle;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		globalHandle = [[ASLMemoryPoolHandle alloc] initWithMemoryPoolHandle:seal::MemoryPoolHandle::Global()];
	});
	return globalHandle;
}

+ (ASLMemoryPoolHandle *)threadLocal {
	static ASLMemoryPoolHandle * threadLocal;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		threadLocal = [[ASLMemoryPoolHandle alloc] initWithMemoryPoolHandle:seal::MemoryPoolHandle::ThreadLocal()];
	});
	return threadLocal;
}

+ (ASLMemoryPoolHandle *)createNew:(BOOL)clearOnDestruction {
	static ASLMemoryPoolHandle * handle;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		handle = [[ASLMemoryPoolHandle alloc] initWithMemoryPoolHandle:seal::MemoryPoolHandle::New(clearOnDestruction)];
	});
	return handle;
}

#pragma mark - Properties

- (size_t)poolCount {
	return _memoryPoolHandle.pool_count();
}

- (size_t)allocatedByteCount {
	return _memoryPoolHandle.alloc_byte_count();
}

- (long)useCount {
	return _memoryPoolHandle.use_count();
}

- (BOOL)isInitialized {
	if (_memoryPoolHandle) {
		return YES;
	} else {
		return NO;
	}
}

#pragma mark - Public Methods

- (BOOL)isEqualToMemoryPoolHandle:(ASLMemoryPoolHandle *)other {
	NSParameterAssert(other != nil);
	if (other == nil) {
		return NO;
	} else {
		return _memoryPoolHandle == other->_memoryPoolHandle;
	}
}

#pragma mark - Properties - Internal

- (seal::MemoryPoolHandle)memoryPoolHandle {
	return _memoryPoolHandle;
}

@end
