//
//  ASLKeyGenerator.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLPublicKey.h"
#import "ASLSecretKey.h"
#import "ASLGaloisKeys.h"
#import "ASLRelinearizationKeys.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLKeyGenerator : NSObject

+ (instancetype _Nullable)keyGeneratorWithContext:(ASLSealContext *)context
											error:(NSError **)error;

+ (instancetype _Nullable)keyGeneratorWithContext:(ASLSealContext *)context
										secretKey:(ASLSecretKey *)secretKey
											error:(NSError **)error;

+ (instancetype _Nullable)keyGeneratorWithContext:(ASLSealContext *)context
										secretKey:(ASLSecretKey *)secretKey
										publicKey:(ASLPublicKey *)publicKey
											error:(NSError **)error;

@property (nonatomic, readonly, assign) ASLPublicKey* publicKey;

@property (nonatomic, readonly, assign) ASLSecretKey* secretKey;


- (ASLRelinearizationKeys *)ASLRelinearizationKeys:(NSError **)error;

- (ASLGaloisKeys *)galoisKeys:(NSError **)error;

- (ASLGaloisKeys *)galoisKeysWithGaloisElements:(NSArray<NSNumber *>*)galoisElements
										  error:(NSError **)error;

- (ASLGaloisKeys *)galoisKeysWithSteps:(NSArray<NSNumber *>*)steps
								 error:(NSError **)error;

// TODO - handle saving

@end

NS_ASSUME_NONNULL_END
