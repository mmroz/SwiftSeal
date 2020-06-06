//
//  NSString+CXXAdditions.m
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-28.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "NSString+CXXAdditions.h"

@implementation NSString (CXXAdditions)

+ (instancetype)ASL_stringWithStdString:(std::string const &)input {
	return [NSString stringWithUTF8String:input.c_str()];
}

+ (instancetype)ASL_stringWithBool:(const BOOL &)input {
    return [NSString stringWithString: input ? @"YES" : @"NO"];
}

- (std::string)stdString {
	return std::string(self.UTF8String);
}

@end
