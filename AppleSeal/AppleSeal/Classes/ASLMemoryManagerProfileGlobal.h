//
//  ASLMemoryManagerProfileGlobal.h
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
@class ASLMemoryManagerProfileGlobal

@brief The ASLMemoryManagerProfileGlobal class and wrapper for the  seal::MMProfGlobal

@discussion Class to store seal::MMProfGlobal.

A memory manager profile that always returns a MemoryPoolHandle pointing to
the global memory pool. Microsoft SEAL uses this memory manager profile by default.
*/

@interface ASLMemoryManagerProfileGlobal : NSObject <ASLMemoryManagerProfile>

@end

NS_ASSUME_NONNULL_END
