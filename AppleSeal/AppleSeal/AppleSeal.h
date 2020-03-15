//
//  AppleSeal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-28.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for AppleSeal.
FOUNDATION_EXPORT double AppleSealVersionNumber;

//! Project version string for AppleSeal.
FOUNDATION_EXPORT const unsigned char AppleSealVersionString[];

#import <AppleSeal/ASLBigUInt.h>
#import <AppleSeal/ASLSmallModulus.h>
#import <AppleSeal/ASLSealContext.h>
#import <AppleSeal/ASLSealContextData.h>
#import <AppleSeal/ASLEncryptionParameters.h>
#import <AppleSeal/ASLMemoryPoolHandle.h>
#import <AppleSeal/ASLMemoryManagerProfileGlobal.h>
#import <AppleSeal/ASLMemoryManagerProfileFixed.h>
#import <AppleSeal/ASLMemoryManagerProfileThreadLocal.h>
#import <AppleSeal/ASLMemoryManager.h>
#import <AppleSeal/ASLBatchEncoder.h>
#import <AppleSeal/ASLParametersIdType.h>
#import <AppleSeal/ASLPlainText.h>
#import <AppleSeal/ASLCipherText.h>
#import <AppleSeal/ASLCKKSEncoder.h>
#import <AppleSeal/ASLComplexType.h>
#import <AppleSeal/ASLSecretKey.h>
#import <AppleSeal/ASLPublicKey.h>
#import <AppleSeal/ASLKSwitchKeys.h>
#import <AppleSeal/ASLRelinearizationKeys.h>
#import <AppleSeal/ASLGaloisKeys.h>
#import <AppleSeal/ASLCoefficientModulus.h>
#import <AppleSeal/ASLPlainModulus.h>
#import <AppleSeal/ASLValidityChecker.h>
