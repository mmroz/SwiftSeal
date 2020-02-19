//
//  ASLKeyGenerator.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLKeyGenerator.h"

#include "seal/keygenerator.h"


// TODO - implement this when I figure out the pointer stuff

@implementation ASLKeyGenerator {
	std::shared_ptr<seal::KeyGenerator> _keyGenerator;
}

#pragma mark - Initialization

//- (instancetype)initWithKeyGenerator:(seal::KeyGenerator *)keyGenerator {
//	self = [super init];
//	if (self == nil) {
//		return nil;
//	}
//
//	_keyGenerator = std::make_shared<seal::KeyGenerator>(std::move(keyGenerator));
//
//	return self;
//}

@end
