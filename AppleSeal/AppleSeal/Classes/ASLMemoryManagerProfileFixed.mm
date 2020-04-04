//
//  ASLMemoryManagerProfileFixed.m
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-30.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLMemoryManagerProfileFixed.h"
#import "ASLMemoryManagerProfileFixed_Internal.h"

#include <memory>
#include "seal/memorymanager.h"

#import "ASLMemoryManagerProfile_Internal.h"
#import "ASLMemoryPoolHandle.h"
#import "ASLMemoryPoolHandle_Internal.h"
#import "NSError+CXXAdditions.h"

@implementation ASLMemoryManagerProfileFixed {
	std::unique_ptr<seal::MMProfFixed> _memoryManagerProfile;
}

#pragma mark - Initialization

+ (instancetype _Nullable)ASLMemoryManagerProfileFixedWithPool:(ASLMemoryPoolHandle *)pool
														 error:(NSError **)error {
	NSParameterAssert(pool != nil);
	seal::MemoryPoolHandle const memoryPoolHandle = pool.memoryPoolHandle;
	seal::MMProfFixed managerProfileFixed = seal::MMProfFixed(memoryPoolHandle);
	auto memoryManagerProfileFixed = std::make_unique<seal::MMProfFixed>(managerProfileFixed);
	
	try {
		return [[ASLMemoryManagerProfileFixed alloc] initWithMemoryManagerProfileFixed:std::move(memoryManagerProfileFixed)];
	} catch (std::invalid_argument const &e) {
		if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
		}
		return nil;
	}
}

- (instancetype)initWithMemoryManagerProfileFixed:(std::unique_ptr<seal::MMProfFixed>)managerProfileFixed {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	_memoryManagerProfile = std::move(managerProfileFixed);
	
	return self;
}

- (instancetype)init {
	[NSException raise:NSInternalInconsistencyException
				format:@"%s is not a valid initializer", __PRETTY_FUNCTION__];
	return nil;
}

#pragma mark - ASLMemoryManagerProfile

- (ASLMemoryPoolHandle *)memoryPoolHandle {
	return [[ASLMemoryPoolHandle alloc] initWithMemoryPoolHandle:_memoryManagerProfile->get_pool(0x0)];
}
@end

@implementation ASLMemoryManagerProfileFixed (ASLMemoryManagerProfile_Internal)

- (instancetype)initWithMMProfFixed:(std::unique_ptr<seal::MMProfFixed>)mmProfFixed {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	_memoryManagerProfile = std::move(mmProfFixed);

	return self;
}

#pragma mark - ASLMemoryManagerProfile_Internal

- (std::unique_ptr<seal::MMProf>)takeMemoryProfile {
	return std::move(_memoryManagerProfile);
}

@end
