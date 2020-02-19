//
//  ASLDecryptor.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-11.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLSealContext.h"
#import "ASLSecretKey.h"
#import "ASLCipherText.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ASLDecryptorErrorDomain;

typedef NS_CLOSED_ENUM(NSInteger, ASLDecryptorErrorCode) {
	ASLDecryptorErrorCodeUnknown = 0,
	ASLDecryptorErrorCodeInvalidParameter,
	ASLDecryptorErrorCodeLogicError,
	ASLDecryptorErrorCodeRuntimeError,
};

@interface ASLDecryptor : NSObject

+ (instancetype _Nullable)decryptorWithContext:(ASLSealContext *)context
										secretKey:(ASLSecretKey *)secretKey
											error:(NSError **)error;

- (BOOL)decrypt:(ASLCipherText *)encrypted
		 destination:(ASLPlainText *)destination
			   error:(NSError **)error;

- (int)invariantNoiseBudget:(ASLCipherText *)cipherText
					  error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
