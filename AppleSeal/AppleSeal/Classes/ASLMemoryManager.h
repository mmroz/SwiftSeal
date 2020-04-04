//
//  ASLMemoryManager.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-31.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AppleSeal/ASLMemoryManagerProfile.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 Control options for MemoryManager::GetPool function. These force the MemoryManager
 to override the current MMProf and instead return a MemoryPoolHandle pointing
 to a memory pool of the indicated type.
 */
typedef NS_CLOSED_ENUM(NSInteger, ASLMemoryManagerProfileOption) {
    Default = 0,
    ForcedGlobal,
    ForceNew,
    ForceThreadLocal,
};

/*!
 @class ASLMemoryManager
 
 @brief The ASLMemoryManager class and wrapper for the  seal::MemoryManager
 
 @discussion Class to store seal::MemoryManager.
 
 The MemoryManager class can be used to create instances of MemoryPoolHandle
 based on a given "profile". A profile is implemented by inheriting from the
 MMProf class (pure virtual) and encapsulates internal logic for deciding which
 memory pool to use.
 */
@interface ASLMemoryManager : NSObject

/*!
 Sets the current profile to a given one and returns a unique_ptr pointing
 to the previously set profile.
 
 @param newProfile Pointer to a new memory manager profile
 @throws ASLSealErrorCodeInvalidParameter if mm_prof is nullptr
 */
- (id<ASLMemoryManagerProfile>)switchProfile:(id<ASLMemoryManagerProfile>)newProfile;

/*!
 Returns a MemoryPoolHandle pointing to a new thread-safe memory pool.
 
 @param profileOption  A parameter used to provide additional
 instructions to the memory manager profile for internal logic.
 @param clearOnDestruction Indicates whether the memory pool data
 should be cleared when destroyed. This can be important when memory pools
 are used to store private data.
 */
- (ASLMemoryPoolHandle *)memoryPoolHandleWithProfileOption:(ASLMemoryManagerProfileOption)profileOption
                                        clearOnDestruction:(BOOL)clearOnDestruction;

/*!
 Returns a MemoryPoolHandle according to the currently set memory manager
 profile and prof_opt. The following values for prof_opt have an effect
 independent of the current profile:
 */
- (ASLMemoryPoolHandle *)memoryPoolHandle;

@end

NS_ASSUME_NONNULL_END
