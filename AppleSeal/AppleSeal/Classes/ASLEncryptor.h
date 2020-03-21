//
//  ASLEncryptor.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-11.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLSealContext.h"
#import "ASLPublicKey.h"
#import "ASLSecretKey.h"
#import "ASLParametersIdType.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ASLEncryptorErrorDomain;

typedef NS_CLOSED_ENUM(NSInteger, ASLEncryptorErrorCode) {
	ASLEncryptorErrorCodeUnknown = 0,
	ASLEncryptorErrorCodeInvalidParameter,
	ASLEncryptorErrorCodeLogicError,
	ASLEncryptorErrorCodeRuntimeError,
};

@interface ASLEncryptor : NSObject <NSCoding>

+ (instancetype _Nullable)encryptorWithContext:(ASLSealContext *)context
									 publicKey:(ASLPublicKey *)publicKey
										 error:(NSError **)error;

+ (instancetype _Nullable)encryptorWithContext:(ASLSealContext *)context
									 secretKey:(ASLSecretKey *)secretKey
										 error:(NSError **)error;

+ (instancetype _Nullable)encryptorWithContext:(ASLSealContext *)context
									 publicKey:(ASLPublicKey *)publicKey
									 secretKey:(ASLSecretKey *)secretKey
										 error:(NSError **)error;

- (BOOL)encryptWithPlainText:(ASLPlainText *)plainText
				  cipherText:(ASLCipherText *)cipherText;

- (BOOL)encryptWithPlainText:(ASLPlainText *)plainText
				  cipherText:(ASLCipherText *)cipherText
						pool:(ASLMemoryPoolHandle *)pool;

-(BOOL)encryptZeroWithCipherText:(ASLCipherText *)cipherText;

-(BOOL)encryptZeroWithCipherText:(ASLCipherText *)cipherText
							pool:(ASLMemoryPoolHandle *)pool;

-(BOOL)encryptZeroWithParametersId:(ASLParametersIdType)parametersId
						cipherText:(ASLCipherText *)cipherText;

-(BOOL)encryptZeroWithParametersId:(ASLParametersIdType)parametersId
						cipherText:(ASLCipherText *)cipherText
							  pool:(ASLMemoryPoolHandle *)pool;

-(BOOL)encryptSymmetricWithWithPlainText:(ASLPlainText *)plainText
							  cipherText:(ASLCipherText *)cipherText;

-(BOOL)encryptSymmetricWithWithPlainText:(ASLPlainText *)plainText
							  cipherText:(ASLCipherText *)cipherText
									pool:(ASLMemoryPoolHandle *)pool;

-(BOOL)encryptZeroSymmetricWithDestination:(ASLCipherText *)destination;

-(BOOL)encryptZeroSymmetricWithDestination:(ASLCipherText *)destination
									  pool:(ASLMemoryPoolHandle *)pool;

-(BOOL)encryptZeroSymmetricWithParametersId:(ASLParametersIdType)parametersId
								destination:(ASLCipherText *)destination;

-(BOOL)encryptZeroSymmetricWithParametersId:(ASLParametersIdType)parametersId
								destination:(ASLCipherText *)destination
									   pool:(ASLMemoryPoolHandle *)pool;

//  TODO - add save and load function

// TODO - fix naming of this

- (BOOL)setPublicKey:(ASLPublicKey *)publicKey
			   error:(NSError **)error;

- (BOOL)setSecretKey:(ASLSecretKey *)secretKey
			   error:(NSError **)error;


@end

NS_ASSUME_NONNULL_END
