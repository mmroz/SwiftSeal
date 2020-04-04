//
//  ASLMemoryManagerProfile.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-30.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <AppleSeal/ASLMemoryPoolHandle.h>

/*!
 @protocol ASLMemoryManagerProfile
 
 @brief The ASLMemoryManagerProfile class and wrapper for the  seal::MMProf
 
 @discussion Class to store seal::MMProf.
 
 The MMProf is a pure virtual class that every profile for the MemoryManager
 should inherit from. The only functionality this class implements is the
 get_pool(mm_prof_opt_t) function that returns a MemoryPoolHandle pointing
 to a pool selected by internal logic optionally using the input parameter
 of type mm_prof_opt_t. The returned MemoryPoolHandle must point to a valid
 memory pool.
 */

@protocol ASLMemoryManagerProfile <NSObject>

/*!
 Returns a MemoryPoolHandle pointing to a pool selected by internal logic
 in a derived class and by the mm_prof_opt_t input parameter.
 
 */
@property (nonatomic, strong, readonly) ASLMemoryPoolHandle *memoryPoolHandle;

@end
