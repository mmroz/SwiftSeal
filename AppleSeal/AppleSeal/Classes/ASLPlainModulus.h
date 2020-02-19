//
//  ASLPlainModulus.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLSmallModulus.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLPlainModulus : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)init NS_UNAVAILABLE;

// TODO - add erros to these methods

+ (ASLSmallModulus* _Nullable)batching:(size_t)polynomialModulusDegree
					 bitSize:(int)bitSize
					   error:(NSError **)error;

+ (NSArray<ASLSmallModulus*>* _Nullable)batching:(size_t)polynomialModulusDegree
							  bitSizes:(NSArray<NSNumber*>*)bitSizes
								 error:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
