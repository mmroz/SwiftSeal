//
//  NSString+CXXAdditions.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-28.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <string>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CXXAdditions)

+ (instancetype)ASL_stringWithStdString:(std::string const &)input;

- (std::string)stdString;

@end

NS_ASSUME_NONNULL_END
