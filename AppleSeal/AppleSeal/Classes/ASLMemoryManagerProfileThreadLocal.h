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

@interface ASLMemoryManagerProfileThreadLocal : NSObject <ASLMemoryManagerProfile>

@end

NS_ASSUME_NONNULL_END
