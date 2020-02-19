//
//  ASLIntegerEncoder.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-18.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLSealContext.h"
#import "ASLPlainText.h"
#import "ASLCipherText.h"
#import "ASLBigUInt.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLIntegerEncoder : NSObject

+ (instancetype _Nullable)integerEncoderWithContext:(ASLSealContext *)context
											  error:(NSError **)error;

- (ASLPlainText*)encodeUInt64Value:(uint64_t)uInt64Value;

- (void)encodeUInt64Value:(uint64_t)uInt64Value
			  destination:(ASLPlainText *)destination;

- (uint32_t)decodeUInt32WithPlain:(ASLPlainText *)plain
							error:(NSError **)error;

- (uint64_t)decodeUInt64WithPlain:(ASLPlainText *)plain
							error:(NSError **)error;

- (ASLPlainText*)encodeInt64Value:(int64_t)int64Value;

- (void)encodeInt64Value:(int64_t)int64Value
			 destination:(ASLPlainText *)destination;

- (ASLPlainText*)encodeBigUInt:(ASLBigUInt *)bigUInt;

- (void)encodeBigUInt:(ASLBigUInt *)bigUInt
		  destination:(ASLPlainText *)destination;

- (int32_t)decodeInt32WithPlain:(ASLPlainText *)plain
						  error:(NSError **)error;

- (int64_t)decodeInt64WithPlain:(ASLPlainText *)plain
						  error:(NSError **)error;

- (ASLBigUInt *)decodeBigUInWithPlain:(ASLPlainText *)plain
								error:(NSError **)error;

- (ASLPlainText*)encodeInt32Value:(int32_t)int32Value;

- (ASLPlainText*)encodeUInt32Value:(uint32_t)uInt32Value;

- (void)encodeInt32Value:(int32_t)int32Value
			 destination:(ASLPlainText *)destination;

- (void)encodeUInt32Value:(uint32_t)uInt32Value
			  destination:(ASLPlainText *)destination;

@property (nonatomic, readonly, assign) ASLSmallModulus* plainModulus;

@end

NS_ASSUME_NONNULL_END
