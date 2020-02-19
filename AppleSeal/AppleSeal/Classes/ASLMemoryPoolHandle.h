//
//  ASLMemoryPoolHandle.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-30.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASLMemoryPoolHandle : NSObject <NSCopying>

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)init NS_UNAVAILABLE;

+ (ASLMemoryPoolHandle *) global;
+ (ASLMemoryPoolHandle *) threadLocal;
+ (ASLMemoryPoolHandle *) createNew:(BOOL)clearOnDestruction;

@property (nonatomic, readonly, assign) size_t poolCount;

@property (nonatomic, readonly, assign) size_t allocatedByteCount;

@property (nonatomic, readonly, assign) long useCount;

@property (nonatomic, readonly, assign, getter=isInitialized) BOOL initialized;

- (BOOL)isEqualToMemoryPoolHandle:(ASLMemoryPoolHandle *)other;


@end

NS_ASSUME_NONNULL_END
