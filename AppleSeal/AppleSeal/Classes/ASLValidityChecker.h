//
//  ASLValidityChecker.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-19.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLPlainText.h"
#import "ASLCipherText.h"
#import "ASLSealContext.h"
#import "ASLPublicKey.h"
#import "ASLSecretKey.h"
#import "ASLKSwitchKeys.h"
#import "ASLRelinearizationKeys.h"
#import "ASLGaloisKeys.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLValidityChecker : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)init NS_UNAVAILABLE;

+(BOOL)isMetaDataValidForPlainText:(ASLPlainText*)plainText
                           context:(ASLSealContext*)context
                 allowPureKeyLevel:(BOOL)allowPureKeyLevel;

+(BOOL)isMetaDataValidForPlainText:(ASLPlainText*)plainText
                           context:(ASLSealContext*)context;

+(BOOL)isMetaDataValidForCipherText:(ASLCipherText*)cipherText
                            context:(ASLSealContext*)context
                  allowPureKeyLevel:(BOOL)allowPureKeyLevel;

+(BOOL)isMetaDataValidForCipherText:(ASLCipherText*)cipherText
                            context:(ASLSealContext*)context;

+(BOOL)isMetaDataValidForSecretKey:(ASLSecretKey*)secretKey
                           context:(ASLSealContext*)context;

+(BOOL)isMetaDataValidForPublicKey:(ASLPublicKey*)publicKey
                           context:(ASLSealContext*)context;

+(BOOL)isMetaDataValidForKSwitchKeys:(ASLKSwitchKeys*)kSwitchKeys
                             context:(ASLSealContext*)context;

+(BOOL)isMetaDataValidForRelinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
                                     context:(ASLSealContext*)context;

+(BOOL)isMetaDataValidForGaloisKeys:(ASLGaloisKeys*)galoisKeys
                            context:(ASLSealContext*)context;

+(BOOL)isBufferValidForPlainText:(ASLPlainText*)plainText;

+(BOOL)isBufferValidForCipherText:(ASLCipherText*)cipherText;

+(BOOL)isBufferValidForSecretKey:(ASLSecretKey*)secretKey;

+(BOOL)isBufferValidForPublicKey:(ASLPublicKey*)publicKey;

+(BOOL)isBufferValidForKSwitchKeys:(ASLKSwitchKeys*)kSwitchKeys;

+(BOOL)isBufferValidForRelinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys;

+(BOOL)isBufferValidForGaloisKeys:(ASLGaloisKeys*)galoisKeys;

+(BOOL)isDataValidForPlainText:(ASLPlainText*)plainText
                       context:(ASLSealContext*)context;

+(BOOL)isDataValidForCipherText:(ASLCipherText*)cipherText
                        context:(ASLSealContext*)context;

+(BOOL)isDataValidForSecretKey:(ASLSecretKey*)secretKey
                       context:(ASLSealContext*)context;

+(BOOL)isDataValidForPublicKey:(ASLPublicKey*)publicKey
                       context:(ASLSealContext*)context;

+(BOOL)isDataValidForKSwitchKeys:(ASLKSwitchKeys*)kSwitchKeys
                         context:(ASLSealContext*)context;

+(BOOL)isDataValidForRelinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
                                 context:(ASLSealContext*)context;

+(BOOL)isDataValidForGaloisKeys:(ASLGaloisKeys*)galoisKeys
                        context:(ASLSealContext*)context;

+(BOOL)isValidForPlainText:(ASLPlainText*)plainText
                   context:(ASLSealContext*)context;

+(BOOL)isValidForCipherText:(ASLCipherText*)cipherText
                    context:(ASLSealContext*)context;

+(BOOL)isValidForSecretKey:(ASLSecretKey*)secretKey
                   context:(ASLSealContext*)context;

+(BOOL)isValidForPublicKey:(ASLPublicKey*)publicKey
                   context:(ASLSealContext*)context;

+(BOOL)isValidForKSwitchKeys:(ASLKSwitchKeys*)kSwitchKeys
                     context:(ASLSealContext*)context;

+(BOOL)isValidForRelinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
                             context:(ASLSealContext*)context;

+(BOOL)isValidForGaloisKeys:(ASLGaloisKeys*)galoisKeys
                    context:(ASLSealContext*)context;

@end

NS_ASSUME_NONNULL_END
