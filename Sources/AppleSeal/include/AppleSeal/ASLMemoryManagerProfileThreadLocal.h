//
//  ASLMemoryManagerProfileThreadLocal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-31.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AppleSeal/ASLMemoryManagerProfile.h>
#import <AppleSeal/ASLMemoryPoolHandle.h>

NS_ASSUME_NONNULL_BEGIN

/*!
@class ASLMemoryManagerProfileThreadLocal

@brief The ASLMemoryManagerProfileThreadLocal class and wrapper for the  seal::MMProfThreadLocal

@discussion Class to store seal::MMProfThreadLocal.

A memory manager profile that always returns a MemoryPoolHandle pointing to
the thread-local memory pool. This profile should be used with care, as any
memory allocated by it will be released once the thread exits. In other words,
the thread-local memory pool cannot be used to share memory across different
threads. On the other hand, this profile can be useful when a very high number
of threads doing simultaneous allocations would cause contention in the
global memory pool.
*/
@interface ASLMemoryManagerProfileThreadLocal : NSObject <ASLMemoryManagerProfile>

@end

NS_ASSUME_NONNULL_END
