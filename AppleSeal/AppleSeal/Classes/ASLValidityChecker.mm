//
//  ASLValidityChecker.mm
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-19.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLValidityChecker.h"

#include "seal/valcheck.h"

#import "ASLPlainText_Internal.h"
#import "ASLCipherText_Internal.h"
#import "ASLSealContext_Internal.h"
#import "ASLSecretKey_Internal.h"
#import "ASLPublicKey_Internal.h"
#import "ASLKSwitchKeys_Internal.h"
#import "ASLRelinearizationKeys_Internal.h"
#import "ASLGaloisKeys_Internal.h"

@implementation ASLValidityChecker

+(BOOL)isMetaDataValidForPlainText:(ASLPlainText*)plainText
							context:(ASLSealContext*)context
				 allowPureKeyLevel:(BOOL)allowPureKeyLevel {
	return seal::is_metadata_valid_for(plainText.sealPlainText, context.sealContext, allowPureKeyLevel);
}

+(BOOL)isMetaDataValidForPlainText:(ASLPlainText*)plainText
						   context:(ASLSealContext*)context {
	return seal::is_metadata_valid_for(plainText.sealPlainText, context.sealContext);
}

+(BOOL)isMetaDataValidForCipherText:(ASLCipherText*)cipherText
							 context:(ASLSealContext*)context
				  allowPureKeyLevel:(BOOL)allowPureKeyLevel {
	return seal::is_metadata_valid_for(cipherText.sealCipherText, context.sealContext, allowPureKeyLevel);
}

+(BOOL)isMetaDataValidForCipherText:(ASLCipherText*)cipherText
							context:(ASLSealContext*)context {
	return seal::is_metadata_valid_for(cipherText.sealCipherText, context.sealContext);
}

+(BOOL)isMetaDataValidForSecretKey:(ASLSecretKey*)secretKey
						   context:(ASLSealContext*)context {
	return seal::is_metadata_valid_for(secretKey.sealSecretKey, context.sealContext);
}

+(BOOL)isMetaDataValidForPublicKey:(ASLPublicKey*)publicKey
						   context:(ASLSealContext*)contex {
	return seal::is_metadata_valid_for(publicKey.sealPublicKey, contex.sealContext);
}

+(BOOL)isMetaDataValidForKSwitchKeys:(ASLKSwitchKeys*)kSwitchKeys
							 context:(ASLSealContext*)context {
	return seal::is_metadata_valid_for(kSwitchKeys.sealKSwitchKeys, context.sealContext);
}

+(BOOL)isMetaDataValidForRelinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
									 context:(ASLSealContext*)context {
	return seal::is_metadata_valid_for(relinearizationKeys.sealRelinKeys, context.sealContext);
}

+(BOOL)isMetaDataValidForGaloisKeys:(ASLGaloisKeys*)galoisKeys
							context:(ASLSealContext*)context {
	return seal::is_metadata_valid_for(galoisKeys.sealGaloisKeys, context.sealContext);
}

+(BOOL)isBufferValidForPlainText:(ASLPlainText*)plainText {
	return seal::is_buffer_valid(plainText.sealPlainText);
}

+(BOOL)isBufferValidForCipherText:(ASLCipherText*)cipherText {
	return seal::is_buffer_valid(cipherText.sealCipherText);
}

+(BOOL)isBufferValidForSecretKey:(ASLSecretKey*)secretKey {
	return seal::is_buffer_valid(secretKey.sealSecretKey);
}

+(BOOL)isBufferValidForPublicKey:(ASLPublicKey*)publicKey {
	return seal::is_buffer_valid(publicKey.sealPublicKey);
}

+(BOOL)isBufferValidForKSwitchKeys:(ASLKSwitchKeys*)kSwitchKeys {
	return seal::is_buffer_valid(kSwitchKeys.sealKSwitchKeys);
}

+(BOOL)isBufferValidForRelinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys {
	return seal::is_buffer_valid(relinearizationKeys.sealRelinKeys);
}

+(BOOL)isBufferValidForGaloisKeys:(ASLGaloisKeys*)galoisKeys {
	return seal::is_buffer_valid(galoisKeys.sealGaloisKeys);
}

+(BOOL)isDataValidForPlainText:(ASLPlainText*)plainText
					   context:(ASLSealContext*)context {
	return seal::is_data_valid_for(plainText.sealPlainText, context.sealContext);
}

+(BOOL)isDataValidForCipherText:(ASLCipherText*)cipherText
						context:(ASLSealContext*)context {
	return seal::is_data_valid_for(cipherText.sealCipherText, context.sealContext);
}

+(BOOL)isDataValidForSecretKey:(ASLSecretKey*)secretKey
					   context:(ASLSealContext*)context {
	return seal::is_data_valid_for(secretKey.sealSecretKey, context.sealContext);
}

+(BOOL)isDataValidForPublicKey:(ASLPublicKey*)publicKey
					   context:(ASLSealContext*)context {
	return seal::is_data_valid_for(publicKey.sealPublicKey, context.sealContext);
}

+(BOOL)isDataValidForKSwitchKeys:(ASLKSwitchKeys*)kSwitchKeys
						  context:(ASLSealContext*)context{
	return seal::is_data_valid_for(kSwitchKeys.sealKSwitchKeys, context.sealContext);
}
+(BOOL)isDataValidForRelinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
								 context:(ASLSealContext*)context {
	return seal::is_data_valid_for(relinearizationKeys.sealRelinKeys, context.sealContext);
}

+(BOOL)isDataValidForGaloisKeys:(ASLGaloisKeys*)galoisKeys
						context:(ASLSealContext*)context {
	return seal::is_data_valid_for(galoisKeys.sealGaloisKeys, context.sealContext);
}

+(BOOL)isValidForPlainText:(ASLPlainText*)plainText
				   context:(ASLSealContext*)context {
	return seal::is_data_valid_for(plainText.sealPlainText, context.sealContext);
}

+(BOOL)isValidForCipherText:(ASLCipherText*)cipherText
					context:(ASLSealContext*)context {
	return seal::is_valid_for(cipherText.sealCipherText, context.sealContext);
}

+(BOOL)isValidForSecretKey:(ASLSecretKey*)secretKey
				   context:(ASLSealContext*)context {
	return seal::is_valid_for(secretKey.sealSecretKey, context.sealContext);
}

+(BOOL)isValidForPublicKey:(ASLPublicKey*)publicKey
				   context:(ASLSealContext*)context {
	return seal::is_valid_for(publicKey.sealPublicKey, context.sealContext);
}
+(BOOL)isValidForKSwitchKeys:(ASLKSwitchKeys*)kSwitchKeys
					 context:(ASLSealContext*)context {
	return seal::is_valid_for(kSwitchKeys.sealKSwitchKeys, context.sealContext);
}

+(BOOL)isValidForRelinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
							 context:(ASLSealContext*)context {
	return seal::is_valid_for(relinearizationKeys.sealRelinKeys, context.sealContext);
}

+(BOOL)isValidForGaloisKeys:(ASLGaloisKeys*)galoisKeys
					context:(ASLSealContext*)context {
	return seal::is_valid_for(galoisKeys.sealGaloisKeys, context.sealContext);
}

@end
