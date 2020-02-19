//
//  ASLEvaluator.m
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-12.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLEvaluator.h"

#include "seal/evaluator.h"

// TODO - implement this when I figure out the pointer stuff

@implementation ASLEvaluator {
	std::shared_ptr<seal::Evaluator> _evaluator;
}

//#pragma mark - Initialization
//
//- (instancetype)initWithEncryptor:(std::shared_ptr<seal::Encryptor>)encryptor {
//	self = [super init];
//	if (self == nil) {
//		return nil;
//	}
//
//	_encryptor = encryptor;
//
//	return self;
//}

@end
