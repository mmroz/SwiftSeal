//
//  ASLIntegerEncoder.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLIntegerEncoder.h"

#include "seal/intencoder.h"

#import  "ASLSealContext_Internal.h"

// TODO - implement this when I figure out the pointer stuff

@implementation ASLIntegerEncoder {
	std::shared_ptr<seal::IntegerEncoder> _integerEncoder;
}

#pragma mark - Initialization

//+ (instancetype)integerEncoderWithContext:(ASLSealContext *)context
//									error:(NSError **)error {
//	NSParameterAssert(context != nil);
//	try {
//		auto encoder = std::make_shared<seal::IntegerEncoder>(std::move(seal::IntegerEncoder(context.sealContext)));
//		return [[ASLIntegerEncoder alloc] initWithIntegerEncoder:encoder];
//	} catch (std::invalid_argument const &e) {
//		if (error != nil) {
//			NSString * const whichParameter = [NSString stringWithUTF8String:e.what()];
//			*error = [[NSError alloc] initWithDomain:ASLBatchEncoderErrorDomain
//												code:ASLBatchEncoderErrorCodeInvalidParameter
//											userInfo:@{NSDebugDescriptionErrorKey : whichParameter}];
//		}
//		return nil;
//	}
//}
//
//- (instancetype)initWithIntegerEncoder:(std::shared_ptr<seal::IntegerEncoder>)integerEncoder {
//	self = [super init];
//	if (self == nil) {
//		return nil;
//	}
//
//	_integerEncoder = integerEncoder;
//
//	return self;
//}


@end





