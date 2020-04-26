//
//  ASLMemoryPoolHandle.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-30.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 
 @class ASLMemoryPoolHandle
 
 @brief The ASLMemoryPoolHandle class and wrapper for the  seal::MemoryPoolHandle
 
 @discussion Class to store seal::MemoryPoolHandle.
 
 Manages a shared pointer to a memory pool. Microsoft SEAL uses memory pools
 for improved performance due to the large number of memory allocations
 needed by the homomorphic encryption operations, and the underlying polynomial
 arithmetic. The library automatically creates a shared global memory pool
 that is used for all dynamic allocations by default, and the user can
 optionally create any number of custom memory pools to be used instead.
 
 Uses in Multi-Threaded Applications
 Sometimes the user might want to use specific memory pools for dynamic
 allocations in certain functions. For example, in heavily multi-threaded
 applications allocating concurrently from a shared memory pool might lead
 to significant performance issues due to thread contention. For these cases
 Microsoft SEAL provides overloads of the functions that take a MemoryPoolHandle
 as an additional argument, and uses the associated memory pool for all dynamic
 allocations inside the function. Whenever these functions are called, the
 user can then simply pass a thread-local MemoryPoolHandle to be used.
 
 Thread-Unsafe Memory Pools
 While memory pools are by default thread-safe, in some cases it suffices
 to have a memory pool be thread-unsafe. To get a little extra performance,
 the user can optionally create such thread-unsafe memory pools and use them
 just as they would use thread-safe memory pools.
 
 Initialized and Uninitialized Handles
 A MemoryPoolHandle has to be set to point either to the global memory pool,
 or to a new memory pool. If this is not done, the MemoryPoolHandle is
 said to be uninitialized, and cannot be used. Initialization simple means
 assigning MemoryPoolHandle::Global() or MemoryPoolHandle::New() to it.
 
 Managing Lifetime
 Internally, the MemoryPoolHandle wraps an std::shared_ptr pointing to
 a memory pool class. Thus, as long as a MemoryPoolHandle pointing to
 a particular memory pool exists, the pool stays alive. Classes such as
 Evaluator and Ciphertext store their own local copies of a MemoryPoolHandle
 to guarantee that the pool stays alive as long as the managing object
 itself stays alive. The global memory pool is implemented as a global
 std::shared_ptr to a memory pool class, and is thus expected to stay
 alive for the entire duration of the program execution. Note that it can
 be problematic to create other global objects that use the memory pool
 e.g. in their constructor, as one would have to ensure the initialization
 order of these global variables to be correct (i.e. global memory pool
 first).
 */
@interface ASLMemoryPoolHandle : NSObject <NSCopying>

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)init NS_UNAVAILABLE;

+ (instancetype)memoryPoolHandleWithClearOnDestruction:(BOOL)clearOnDestruction;

/*!
 Returns a MemoryPoolHandle pointing to the global memory pool.
 */
+ (ASLMemoryPoolHandle *) global;

/*!
 Returns a MemoryPoolHandle pointing to the thread-local memory pool.
 */
+ (ASLMemoryPoolHandle *) threadLocal;

/*!
 Returns a MemoryPoolHandle pointing to a new thread-safe memory pool.
 
 @param clearOnDestruction Indicates whether the memory pool data
 should be cleared when destroyed. This can be important when memory pools
 are used to store private data.
 */
//+ (ASLMemoryPoolHandle *) createNew:(BOOL)clearOnDestruction;

/*!
 Returns the number of different allocation sizes. This function returns
 the number of different allocation sizes the memory pool pointed to by
 the current MemoryPoolHandle has made. For example, if the memory pool has
 only allocated two allocations of sizes 128 KB, this function returns 1.
 If it has instead allocated one allocation of size 64 KB and one of 128 KB,
 this function returns 2.
 */
@property (nonatomic, readonly, assign) size_t poolCount;

/*!
 Returns the size of allocated memory. This functions returns the total
 amount of memory (in bytes) allocated by the memory pool pointed to by
 the current MemoryPoolHandle.
 */
@property (nonatomic, readonly, assign) size_t allocatedByteCount;

/*!
 Returns the number of MemoryPoolHandle objects sharing this memory pool.
 */
@property (nonatomic, readonly, assign) long useCount;

/*!
 Returns whether the MemoryPoolHandle is initialized.
 */
@property (nonatomic, readonly, assign, getter=isInitialized) BOOL initialized;

- (BOOL)isEqualToMemoryPoolHandle:(ASLMemoryPoolHandle *)other;

@end

NS_ASSUME_NONNULL_END
