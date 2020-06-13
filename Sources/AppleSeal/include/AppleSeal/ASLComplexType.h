//
//  ASLComplexType.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-10.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// TODO - replace this with _Complex from complex.h

@interface ASLComplexType : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithReal:(double)real
				   imaginary:(double)imaginary;


@property (nonatomic, readonly, assign) double real;

@property (nonatomic, readonly, assign) double imaginary;

@end

NS_ASSUME_NONNULL_END
