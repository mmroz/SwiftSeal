//
//  ASLMemoryManagerProfileThreadLocal.m
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-31.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLMemoryManagerProfileThreadLocal.h"
#import "ASLMemoryManagerProfileThreadLocal_Internal.h"

#include <memory>
#include "seal/memorymanager.h"

#import "ASLMemoryManagerProfile_Internal.h"
#import "ASLMemoryPoolHandle.h"
#import "ASLMemoryPoolHandle_Internal.h"

@implementation ASLMemoryManagerProfileThreadLocal {
	std::unique_ptr<seal::MMProfThreadLocal> _memoryManagerProfile;
}

#pragma mark - Initialization

- (instancetype)init {
	self = [super init];
	if (!self) {
		return nil;
	}

	_memoryManagerProfile = std::make_unique<seal::MMProfThreadLocal>(seal::MMProfThreadLocal());
	return self;
}

#pragma mark - ASLMemoryManagerProfile

- (ASLMemoryPoolHandle *)memoryPoolHandle {
	return [[ASLMemoryPoolHandle alloc] initWithMemoryPoolHandle:_memoryManagerProfile->get_pool(0x0)];
}

@end
 
@implementation ASLMemoryManagerProfileThreadLocal (ASLMemoryManagerProfile_Internal)

- (instancetype)initWithMMProfThreadLocal:(std::unique_ptr<seal::MMProfThreadLocal>)mmProfThreadLocal {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	_memoryManagerProfile = std::move(mmProfThreadLocal);

	return self;
}

#pragma mark - ASLMemoryManagerProfile_Internal

- (std::unique_ptr<seal::MMProf>)takeMemoryProfile {
	return std::move(_memoryManagerProfile);
}
@end
