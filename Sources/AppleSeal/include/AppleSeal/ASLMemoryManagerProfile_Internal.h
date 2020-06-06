//
//  ASLMemoryManagerProfile_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-30.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <AppleSeal/ASLMemoryManagerProfile.h>

#include "seal/memorymanager.h"

@protocol ASLMemoryManagerProfile_Internal <ASLMemoryManagerProfile>

- (std::unique_ptr<seal::MMProf>)takeMemoryProfile;

@end
