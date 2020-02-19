//
//  ASLMemoryManager.m
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-31.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLMemoryManager.h"

#include "seal/memorymanager.h"

#import "ASLMemoryPoolHandle.h"
#import "ASLMemoryPoolHandle_Internal.h"

#import "ASLMemoryManagerProfileGlobal.h"
#import "ASLMemoryManagerProfileGlobal_Internal.h"
#import "ASLMemoryManagerProfileFixed.h"
#import "ASLMemoryManagerProfileFixed_Internal.h"
#import "ASLMemoryManagerProfileThreadLocal.h"
#import "ASLMemoryManagerProfileThreadLocal_Internal.h"

static std::uint64_t sealProfOptFromASLProfileOption(ASLMemoryManagerProfileOption profileOption) {
	switch(profileOption) {
		case Default:
			return static_cast<uint64_t>(seal::mm_prof_opt::DEFAULT);
		case ForcedGlobal:
			return static_cast<uint8_t>(seal::mm_prof_opt::FORCE_GLOBAL);
		case ForceNew:
			return static_cast<uint8_t>(seal::mm_prof_opt::FORCE_NEW);
		case ForceThreadLocal:
			return static_cast<uint8_t>(seal::mm_prof_opt::FORCE_THREAD_LOCAL);
	}
}

@implementation ASLMemoryManager

#pragma mark - Public Methods

- (id<ASLMemoryManagerProfile>)switchProfile:(id<ASLMemoryManagerProfile>)newProfile {
	NSParameterAssert(newProfile != nil);
	NSParameterAssert([newProfile conformsToProtocol:@protocol(ASLMemoryManagerProfile_Internal)]);
	if (newProfile == nil ||
		![newProfile conformsToProtocol:@protocol(ASLMemoryManagerProfile_Internal)]) {
		return nil;
	}

	std::unique_ptr<seal::MMProf> newProfileReference = [((id<ASLMemoryManagerProfile_Internal>)newProfile) takeMemoryProfile];
	seal::MMProf *value = newProfileReference.release();
	std::unique_ptr<seal::MMProf> oldProfileReference = seal::MemoryManager::SwitchProfile(&*value);

	seal::MMProf *oldProfile = oldProfileReference.release();
	
	seal::MMProfGlobal *global = dynamic_cast<seal::MMProfGlobal *const>(oldProfile);
	if (global != nullptr) {
		return [[ASLMemoryManagerProfileGlobal alloc] initWithMMProfGlobal:std::make_unique<seal::MMProfGlobal>(std::move(*global))];
	}
	
	seal::MMProfThreadLocal *threadLocal = dynamic_cast<seal::MMProfThreadLocal *const>(oldProfile);
	if (threadLocal != nullptr) {
		return [[ASLMemoryManagerProfileThreadLocal alloc] initWithMMProfThreadLocal:std::make_unique<seal::MMProfThreadLocal>(std::move(*threadLocal))];
	}

	return nil;
}

- (ASLMemoryPoolHandle *)memoryPoolHandleWithProfileOption:(ASLMemoryManagerProfileOption)profileOption
										clearOnDestruction:(BOOL)clearOnDestruction {
	seal::MemoryPoolHandle const memoryManagerProfile = seal::MemoryManager::GetPool(sealProfOptFromASLProfileOption(profileOption), clearOnDestruction);
	return [[ASLMemoryPoolHandle alloc] initWithMemoryPoolHandle:memoryManagerProfile];
}

- (ASLMemoryPoolHandle *)memoryPoolHandle {
	return [[ASLMemoryPoolHandle alloc] initWithMemoryPoolHandle:seal::MemoryManager::GetPool()];
}
@end
