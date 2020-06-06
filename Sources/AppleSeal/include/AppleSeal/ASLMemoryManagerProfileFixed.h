//
//  ASLMemoryManagerProfileFixed.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-30.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AppleSeal/ASLMemoryManagerProfile.h>
#import <AppleSeal/ASLMemoryPoolHandle.h>

NS_ASSUME_NONNULL_BEGIN

/*!
@class ASLMemoryManagerProfileFixed

@brief The ASLMemoryManagerProfileFixed class and wrapper for the  seal::MMProfFixed

@discussion Class to store seal::MMProfFixed.

A memory manager profile that always returns a MemoryPoolHandle pointing to
specific memory pool.
*/

@interface ASLMemoryManagerProfileFixed : NSObject <ASLMemoryManagerProfile>

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/*!
Creates a new MMProfFixed. The MemoryPoolHandle given as argument is returned
by every call to get_pool(mm_prof_opt_t).

@param pool The MemoryPoolHandle pointing to a valid memory pool
@throws ASL_SealInvalidParameter if pool is uninitialized
*/
+ (instancetype _Nullable)ASLMemoryManagerProfileFixedWithPool:(ASLMemoryPoolHandle *)pool
														 error:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
