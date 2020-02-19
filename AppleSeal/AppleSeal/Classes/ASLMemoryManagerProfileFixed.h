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

extern NSString * const ASLMemoryManagerProfileFixedErrorDomain;

typedef NS_CLOSED_ENUM(NSInteger, ASLMemoryManagerProfileFixedErrorCode) {
	ASLMemoryManagerProfileFixedErrorCodeUnknown = 0,
	ASLMemoryManagerProfileFixedInvalidParameter,
};

@interface ASLMemoryManagerProfileFixed : NSObject <ASLMemoryManagerProfile>

+ (instancetype _Nullable)ASLMemoryManagerProfileFixedWithPool:(ASLMemoryPoolHandle *)pool
														 error:(NSError **)error;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
