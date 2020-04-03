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

/*!
 Check whether the given plaintext is valid for a given SEALContext. If the
 given SEALContext is not set, the encryption parameters are invalid, or the
 plaintext data does not match the SEALContext, this function returns false.
 Otherwise, returns true. This function only checks the metadata and not the
 plaintext data itself.
 
 @param plainText The plaintext to check
 @param context The SEALContext
 @param allowPureKeyLevel Determines whether pure key levels (i.e.,
 non-data levels) should be considered valid
 */
+(BOOL)isMetaDataValidForPlainText:(ASLPlainText*)plainText
						   context:(ASLSealContext*)context
				 allowPureKeyLevel:(BOOL)allowPureKeyLevel;

/*!
 Check whether the given plaintext is valid for a given SEALContext. If the
 given SEALContext is not set, the encryption parameters are invalid, or the
 plaintext data does not match the SEALContext, this function returns false.
 Otherwise, returns true. This function only checks the metadata and not the
 plaintext data itself.
 
 @param plainText The plaintext to check
 @param context The SEALContext
 */
+(BOOL)isMetaDataValidForPlainText:(ASLPlainText*)plainText
						   context:(ASLSealContext*)context;

/*!
 Check whether the given ciphertext is valid for a given SEALContext. If the
 given SEALContext is not set, the encryption parameters are invalid, or the
 ciphertext data does not match the SEALContext, this function returns false.
 Otherwise, returns true. This function only checks the metadata and not the
 ciphertext data itself.
 
 @param cipherText The ciphertext to check
 @param context The SEALContext
 @param allowPureKeyLevel Determines whether pure key levels (i.e.,
 non-data levels) should be considered valid
 */
+(BOOL)isMetaDataValidForCipherText:(ASLCipherText*)cipherText
							context:(ASLSealContext*)context
				  allowPureKeyLevel:(BOOL)allowPureKeyLevel;

/*!
 Check whether the given ciphertext is valid for a given SEALContext. If the
 given SEALContext is not set, the encryption parameters are invalid, or the
 ciphertext data does not match the SEALContext, this function returns false.
 Otherwise, returns true. This function only checks the metadata and not the
 ciphertext data itself.
 
 @param cipherText The ciphertext to check
 @param context The ASLSealContext
 */
+(BOOL)isMetaDataValidForCipherText:(ASLCipherText*)cipherText
							context:(ASLSealContext*)context;

/*!
 Check whether the given secret key is valid for a given SEALContext. If the
 given SEALContext is not set, the encryption parameters are invalid, or the
 secret key data does not match the SEALContext, this function returns false.
 Otherwise, returns true. This function only checks the metadata and not the
 secret key data itself.
 
 @param secretKey The secret key to check
 @param context The ASLSealContext
 */
+(BOOL)isMetaDataValidForSecretKey:(ASLSecretKey*)secretKey
						   context:(ASLSealContext*)context;

/*!
 Check whether the given public key is valid for a given SEALContext. If the
 given SEALContext is not set, the encryption parameters are invalid, or the
 public key data does not match the SEALContext, this function returns false.
 Otherwise, returns true. This function only checks the metadata and not the
 public key data itself.
 
 @param publicKey The public key to check
 @param context The ASLSealContext
 */
+(BOOL)isMetaDataValidForPublicKey:(ASLPublicKey*)publicKey
						   context:(ASLSealContext*)context;

/*!
 Check whether the given KSwitchKeys is valid for a given SEALContext. If the
 given SEALContext is not set, the encryption parameters are invalid, or the
 KSwitchKeys data does not match the SEALContext, this function returns false.
 Otherwise, returns true. This function only checks the metadata and not the
 KSwitchKeys data itself.
 
 @param kSwitchKeys The KSwitchKeys to check
 @param context The ASLSealContext
 */
+(BOOL)isMetaDataValidForKSwitchKeys:(ASLKSwitchKeys*)kSwitchKeys
							 context:(ASLSealContext*)context;

/*!
 Check whether the given RelinKeys is valid for a given SEALContext. If the
 given SEALContext is not set, the encryption parameters are invalid, or the
 RelinKeys data does not match the SEALContext, this function returns false.
 Otherwise, returns true. This function only checks the metadata and not the
 RelinKeys data itself.
 
 @param relinearizationKeys The ASLRelinearizationKeys to check
 @param context The ASLSealContext
 */
+(BOOL)isMetaDataValidForRelinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
									 context:(ASLSealContext*)context;

/*!
 Check whether the given GaloisKeys is valid for a given SEALContext. If the
 given SEALContext is not set, the encryption parameters are invalid, or the
 GaloisKeys data does not match the SEALContext, this function returns false.
 Otherwise, returns true. This function only checks the metadata and not the
 GaloisKeys data itself.
 
 @param galoisKeys The ASLGaloisKeys to check
 @param context The SEALContext
 */
+(BOOL)isMetaDataValidForGaloisKeys:(ASLGaloisKeys*)galoisKeys
							context:(ASLSealContext*)context;

/*!
 Check whether the given plaintext data buffer is valid for a given SEALContext.
 If the given SEALContext is not set, the encryption parameters are invalid,
 or the plaintext data buffer does not match the SEALContext, this function
 returns false. Otherwise, returns true. This function only checks the size of
 the data buffer and not the plaintext data itself.
 
 @param plainText The ASLPlainText to check
 */
+(BOOL)isBufferValidForPlainText:(ASLPlainText*)plainText;

/*!
 Check whether the given ciphertext data buffer is valid for a given SEALContext.
 If the given SEALContext is not set, the encryption parameters are invalid,
 or the ciphertext data buffer does not match the SEALContext, this function
 returns false. Otherwise, returns true. This function only checks the size of
 the data buffer and not the ciphertext data itself.
 
 @param cipherText The ASLCipherText to check
 */
+(BOOL)isBufferValidForCipherText:(ASLCipherText*)cipherText;

/*!
 Check whether the given secret key data buffer is valid for a given SEALContext.
 If the given SEALContext is not set, the encryption parameters are invalid,
 or the secret key data buffer does not match the SEALContext, this function
 returns false. Otherwise, returns true. This function only checks the size of
 the data buffer and not the secret key data itself.
 
 @param secretKey The ASLSecretKey to check
 */
+(BOOL)isBufferValidForSecretKey:(ASLSecretKey*)secretKey;

/*!
 Check whether the given public key data buffer is valid for a given SEALContext.
 If the given SEALContext is not set, the encryption parameters are invalid,
 or the public key data buffer does not match the SEALContext, this function
 returns false. Otherwise, returns true. This function only checks the size of
 the data buffer and not the public key data itself.
 
 @param publicKey The public key to check
 */
+(BOOL)isBufferValidForPublicKey:(ASLPublicKey*)publicKey;

/*!
 Check whether the given KSwitchKeys data buffer is valid for a given SEALContext.
 If the given SEALContext is not set, the encryption parameters are invalid,
 or the KSwitchKeys data buffer does not match the SEALContext, this function
 returns false. Otherwise, returns true. This function only checks the size of
 the data buffer and not the KSwitchKeys data itself.
 
 @param kSwitchKeys The ASLKSwitchKeys to check
 */
+(BOOL)isBufferValidForKSwitchKeys:(ASLKSwitchKeys*)kSwitchKeys;

/*!
 Check whether the given RelinKeys data buffer is valid for a given SEALContext.
 If the given SEALContext is not set, the encryption parameters are invalid,
 or the RelinKeys data buffer does not match the SEALContext, this function
 returns false. Otherwise, returns true. This function only checks the size of
 the data buffer and not the RelinKeys data itself.
 
 @param in The RelinKeys to check
 */
+(BOOL)isBufferValidForRelinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys;

/*!
 Check whether the given GaloisKeys data buffer is valid for a given SEALContext.
 If the given SEALContext is not set, the encryption parameters are invalid,
 or the GaloisKeys data buffer does not match the SEALContext, this function
 returns false. Otherwise, returns true. This function only checks the size of
 the data buffer and not the GaloisKeys data itself.
 
 @param galoisKeys The RelinKeys to check
 */
+(BOOL)isBufferValidForGaloisKeys:(ASLGaloisKeys*)galoisKeys;

/*!
 Check whether the given plaintext data is valid for a given SEALContext.
 If the given SEALContext is not set, the encryption parameters are invalid,
 or the plaintext data does not match the SEALContext, this function returns
 false. Otherwise, returns true. This function can be slow, as it checks the
 correctness of the entire plaintext data buffer.
 
 @param plainText The plaintext to check
 @param context The SEALContext
 */
+(BOOL)isDataValidForPlainText:(ASLPlainText*)plainText
					   context:(ASLSealContext*)context;

/*!
 Check whether the given ciphertext data is valid for a given SEALContext.
 If the given SEALContext is not set, the encryption parameters are invalid,
 or the ciphertext data does not match the SEALContext, this function returns
 false. Otherwise, returns true. This function can be slow, as it checks the
 correctness of the entire ciphertext data buffer.
 
 @param cipherText The ciphertext to check
 @param context The SEALContext
 */
+(BOOL)isDataValidForCipherText:(ASLCipherText*)cipherText
						context:(ASLSealContext*)context;

/*!
 Check whether the given secret key data is valid for a given SEALContext.
 If the given SEALContext is not set, the encryption parameters are invalid,
 or the secret key data does not match the SEALContext, this function returns
 false. Otherwise, returns true. This function can be slow, as it checks the
 correctness of the entire secret key data buffer.
 
 @param secretKey The secret key to check
 @param context The SEALContext
 */
+(BOOL)isDataValidForSecretKey:(ASLSecretKey*)secretKey
					   context:(ASLSealContext*)context;

/*!
 Check whether the given public key data is valid for a given SEALContext.
 If the given SEALContext is not set, the encryption parameters are invalid,
 or the public key data does not match the SEALContext, this function returns
 false. Otherwise, returns true. This function can be slow, as it checks the
 correctness of the entire public key data buffer.
 
 @param publicKey The public key to check
 @param context The SEALContext
 */
+(BOOL)isDataValidForPublicKey:(ASLPublicKey*)publicKey
					   context:(ASLSealContext*)context;

/*!
 Check whether the given KSwitchKeys data is valid for a given SEALContext.
 If the given SEALContext is not set, the encryption parameters are invalid,
 or the KSwitchKeys data does not match the SEALContext, this function returns
 false. Otherwise, returns true. This function can be slow, as it checks the
 correctness of the entire KSwitchKeys data buffer.
 
 @param in The KSwitchKeys to check
 @param context The SEALContext
 */
+(BOOL)isDataValidForKSwitchKeys:(ASLKSwitchKeys*)kSwitchKeys
						 context:(ASLSealContext*)context;

/*!
 Check whether the given RelinKeys data is valid for a given SEALContext.
 If the given SEALContext is not set, the encryption parameters are invalid,
 or the RelinKeys data does not match the SEALContext, this function returns
 false. Otherwise, returns true. This function can be slow, as it checks the
 correctness of the entire RelinKeys data buffer.
 
 @param relinearizationKeys The RelinKeys to check
 @param context The SEALContext
 */
+(BOOL)isDataValidForRelinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
								 context:(ASLSealContext*)context;

/*!
 Check whether the given GaloisKeys data is valid for a given SEALContext.
 If the given SEALContext is not set, the encryption parameters are invalid,
 or the GaloisKeys data does not match the SEALContext, this function returns
 false. Otherwise, returns true. This function can be slow, as it checks the
 correctness of the entire GaloisKeys data buffer.
 
 @param galoisKeys The ASLGaloisKeys to check
 @param context The SEALContext
 */
+(BOOL)isDataValidForGaloisKeys:(ASLGaloisKeys*)galoisKeys
						context:(ASLSealContext*)context;

/*!
 Check whether the given plaintext is valid for a given SEALContext. If the
 given SEALContext is not set, the encryption parameters are invalid, or the
 plaintext data does not match the SEALContext, this function returns false.
 Otherwise, returns true. This function can be slow as it checks the validity
 of all metadata and of the entire plaintext data buffer.
 
 @param plainText The ASLPlainText to check
 @param context The SEALContext
 */
+(BOOL)isValidForPlainText:(ASLPlainText*)plainText
				   context:(ASLSealContext*)context;

/*!
 Check whether the given ciphertext is valid for a given SEALContext. If the
 given SEALContext is not set, the encryption parameters are invalid, or the
 ciphertext data does not match the SEALContext, this function returns false.
 Otherwise, returns true. This function can be slow as it checks the validity
 of all metadata and of the entire ciphertext data buffer.
 
 @param cipherText The ciphertext to check
 @param context The SEALContext
 */
+(BOOL)isValidForCipherText:(ASLCipherText*)cipherText
					context:(ASLSealContext*)context;

/*!
 Check whether the given secret key is valid for a given SEALContext. If the
 given SEALContext is not set, the encryption parameters are invalid, or the
 secret key data does not match the SEALContext, this function returns false.
 Otherwise, returns true. This function can be slow as it checks the validity
 of all metadata and of the entire secret key data buffer.
 
 @param secretKey The ASLSecretKey to check
 @param context The SEALContext
 */
+(BOOL)isValidForSecretKey:(ASLSecretKey*)secretKey
				   context:(ASLSealContext*)context;

/*!
 Check whether the given public key is valid for a given SEALContext. If the
 given SEALContext is not set, the encryption parameters are invalid, or the
 public key data does not match the SEALContext, this function returns false.
 Otherwise, returns true. This function can be slow as it checks the validity
 of all metadata and of the entire public key data buffer.
 
 @param publicKey The ASLPublicKey to check
 @param context The SEALContext
 */
+(BOOL)isValidForPublicKey:(ASLPublicKey*)publicKey
				   context:(ASLSealContext*)context;

/*!
 Check whether the given KSwitchKeys is valid for a given SEALContext. If
 the given SEALContext is not set, the encryption parameters are invalid,
 or the KSwitchKeys data does not match the SEALContext, this function returns
 false. Otherwise, returns true. This function can be slow as it checks the validity
 of all metadata and of the entire KSwitchKeys data buffer.
 
 @param kSwitchKeys The ASLKSwitchKeys to check
 @param context The SEALContext
 */
+(BOOL)isValidForKSwitchKeys:(ASLKSwitchKeys*)kSwitchKeys
					 context:(ASLSealContext*)context;

/*!
 Check whether the given RelinKeys is valid for a given SEALContext. If the
 given SEALContext is not set, the encryption parameters are invalid, or the
 RelinKeys data does not match the SEALContext, this function returns false.
 Otherwise, returns true. This function can be slow as it checks the validity
 of all metadata and of the entire RelinKeys data buffer.
 
 @param relinearizationKeys The ASLRelinearizationKeys to check
 @param context The SEALContext
 */
+(BOOL)isValidForRelinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
							 context:(ASLSealContext*)context;

/*!
 Check whether the given GaloisKeys is valid for a given SEALContext. If the
 given SEALContext is not set, the encryption parameters are invalid, or the
 GaloisKeys data does not match the SEALContext, this function returns false.
 Otherwise, returns true. This function can be slow as it checks the validity
 of all metadata and of the entire GaloisKeys data buffer.
 
 @param galoisKeys The ASLGaloisKeys to check
 @param context The SEALContext
 */
+(BOOL)isValidForGaloisKeys:(ASLGaloisKeys*)galoisKeys
					context:(ASLSealContext*)context;

@end

NS_ASSUME_NONNULL_END
