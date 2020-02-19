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

typedef NS_CLOSED_ENUM(NSInteger, ASLMemoryManagerProfileOption) {
	Default = 0,
	ForcedGlobal,
	ForceNew,
	ForceThreadLocal,
};

@interface ASLMemoryManager : NSObject

- (id<ASLMemoryManagerProfile>)switchProfile:(id<ASLMemoryManagerProfile>)newProfile;

- (ASLMemoryPoolHandle *)memoryPoolHandleWithProfileOption:(ASLMemoryManagerProfileOption)profileOption
										clearOnDestruction:(BOOL)clearOnDestruction;
- (ASLMemoryPoolHandle *)memoryPoolHandle;

@end

NS_ASSUME_NONNULL_END
