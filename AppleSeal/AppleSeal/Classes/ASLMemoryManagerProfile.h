//
//  ASLMemoryManagerProfile.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-30.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <AppleSeal/ASLMemoryPoolHandle.h>

@protocol ASLMemoryManagerProfile <NSObject>

@property (nonatomic, strong, readonly) ASLMemoryPoolHandle *memoryPoolHandle;

@end
