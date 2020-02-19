//
//  ASLGaloisKeys.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLKSwitchKeys.h"
#import "ASLPublicKey.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLGaloisKeys : ASLKSwitchKeys

// TODO handle errors in these methods

-(size_t)getIndex:(NSNumber*)index;

-(BOOL)hasKey:(NSNumber*)key;

-(NSArray<ASLPublicKey*>*)keyWithKeyPower:(NSNumber*)keyPower;

@end

NS_ASSUME_NONNULL_END
