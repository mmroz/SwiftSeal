//
//  ASLMemoryManagerProfileGlobal.m
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-30.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLMemoryManagerProfileGlobal.h"
#import "ASLMemoryManagerProfileGlobal_Internal.h"

#include <memory>
#include "seal/memorymanager.h"

#import "ASLMemoryManagerProfile_Internal.h"
#import "ASLMemoryPoolHandle.h"
#import "ASLMemoryPoolHandle_Internal.h"

@implementation ASLMemoryManagerProfileGlobal {
	std::unique_ptr<seal::MMProfGlobal> _memoryManagerProfile;
}

#pragma mark - Initialization

- (instancetype)init {
	self = [super init];
	if (!self) {
		return nil;
	}

	_memoryManagerProfile = std::make_unique<seal::MMProfGlobal>(seal::MMProfGlobal());

	return self;
}

#pragma mark - ASLMemoryManagerProfile

- (ASLMemoryPoolHandle *)memoryPoolHandle {
	return [[ASLMemoryPoolHandle alloc] initWithMemoryPoolHandle:_memoryManagerProfile->get_pool(0x0)];
}

@end

@implementation ASLMemoryManagerProfileGlobal (ASLMemoryManagerProfile_Internal)

- (instancetype)initWithMMProfGlobal:(std::unique_ptr<seal::MMProfGlobal>)mmProfGlobal {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	_memoryManagerProfile = std::move(mmProfGlobal);

	return self;
}

#pragma mark - ASLMemoryManagerProfile_Internal

- (std::unique_ptr<seal::MMProf>)takeMemoryProfile {
	return std::move(_memoryManagerProfile);
}

@end
