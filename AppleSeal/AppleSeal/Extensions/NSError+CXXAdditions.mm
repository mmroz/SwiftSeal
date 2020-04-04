//
//  NSError+NSError_CXXAdditions.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-19.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "NSError+CXXAdditions.h"

#import "NSString+CXXAdditions.h"

NSString * const ASLSealErrorErrorDomain = @"ASLSealErrorErrorDomain";

@implementation NSError (NSError_CXXAdditions)

+ (instancetype)ASL_SealInvalidParameter:(const std::exception &)exception {
	NSString * const whichParameter = [NSString stringWithUTF8String:exception.what()];
	return [[NSError alloc] initWithDomain:ASLSealErrorErrorDomain
										code:ASLSealErrorCodeInvalidParameter
									userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
}

+ (instancetype)ASL_SealLogicError:(const std::exception &)exception {
	NSString * const whichParameter = [NSString stringWithUTF8String:exception.what()];
	return [[NSError alloc] initWithDomain:ASLSealErrorErrorDomain
										code:ASLSealErrorCodeLogicError
									userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
}

+ (instancetype)ASL_SealRuntimeError:(const std::exception &)exception {
    NSString * const whichParameter = [NSString stringWithUTF8String:exception.what()];
    return [[NSError alloc] initWithDomain:ASLSealErrorErrorDomain
                                        code:ASLSealErrorCodeRuntimeError
                                    userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
}

@end
