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
#import  "ASLPlainText_Internal.h"
#import "ASLBigUInt_Internal.h"
#import "ASLModulus_Internal.h"
#import "NSString+CXXAdditions.h"
#import "NSError+CXXAdditions.h"

@implementation ASLIntegerEncoder {
    seal::IntegerEncoder* _integerEncoder;
}

#pragma mark - Initialization

+ (instancetype _Nullable)integerEncoderWithContext:(ASLSealContext *)context
                                              error:(NSError **)error {
    NSParameterAssert(context != nil);
    
    try {
        seal::IntegerEncoder* encryptor = new seal::IntegerEncoder(context.sealContext);
        return [[ASLIntegerEncoder alloc] initWithIntegerEncoder:encryptor];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
}

- (instancetype)initWithIntegerEncoder:(seal::IntegerEncoder *)integerEncoder {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _integerEncoder = integerEncoder;
    
    return self;
}

- (void)dealloc {
    delete _integerEncoder;
    _integerEncoder = nullptr;
}

#pragma mark - Public Methods

- (ASLPlainText*)encodeUInt64Value:(uint64_t)uInt64Value {
    seal::Plaintext value = _integerEncoder->encode(uInt64Value);
    return [[ASLPlainText alloc] initWithPlainText:value];
}

- (NSNumber*)decodeUInt32WithPlain:(ASLPlainText *)plain
                            error:(NSError **)error {
    NSParameterAssert(plain != nil);
    seal::Plaintext sealPlainText = plain.sealPlainText;
    try {
        return  [[NSNumber alloc] initWithFloat:_integerEncoder->decode_int32(sealPlainText)];
    }  catch (std::invalid_argument const &e) {
           if (error != nil) {
               *error = [NSError ASL_SealInvalidParameter:e];
           }
           return nil;
    }
}

- (NSNumber*)decodeUInt64WithPlain:(ASLPlainText *)plain
                             error:(NSError **)error {
    NSParameterAssert(plain != nil);
    seal::Plaintext sealPlainText = plain.sealPlainText;
       try {
           return  [[NSNumber alloc] initWithFloat:_integerEncoder->decode_uint64(sealPlainText)];
       }  catch (std::invalid_argument const &e) {
              if (error != nil) {
                  *error = [NSError ASL_SealInvalidParameter:e];
              }
              return nil;
       }
}

- (ASLPlainText*)encodeInt64Value:(int64_t)int64Value {
    return [[ASLPlainText alloc] initWithPlainText:_integerEncoder->encode(int64Value)];
}

- (ASLPlainText*)encodeBigUInt:(ASLBigUInt *)bigUInt {
    NSParameterAssert(bigUInt != nil);
    seal::BigUInt sealBigUInt = bigUInt.sealBigUInt;
    return [[ASLPlainText alloc]initWithPlainText:_integerEncoder->encode(sealBigUInt)];
}

- (NSNumber*)decodeInt32WithPlain:(ASLPlainText *)plain
                            error:(NSError **)error {
    NSParameterAssert(plain != nil);
    seal::Plaintext sealPlainText = plain.sealPlainText;
    try {
        return  [[NSNumber alloc] initWithFloat:_integerEncoder->decode_int32(sealPlainText)];
    }  catch (std::invalid_argument const &e) {
           if (error != nil) {
               *error = [NSError ASL_SealInvalidParameter:e];
           }
           return nil;
    }
}

- (NSNumber*)decodeInt64WithPlain:(ASLPlainText *)plain
                            error:(NSError **)error {
    NSParameterAssert(plain != nil);
       seal::Plaintext sealPlainText = plain.sealPlainText;
       try {
           return  [[NSNumber alloc] initWithFloat:_integerEncoder->decode_int64(sealPlainText)];
       }  catch (std::invalid_argument const &e) {
              if (error != nil) {
                  *error = [NSError ASL_SealInvalidParameter:e];
              }
              return nil;
       }
}

- (ASLBigUInt *)decodeBigUIntWithPlain:(ASLPlainText *)plain
                                error:(NSError **)error {
    NSParameterAssert(plain != nil);
    seal::Plaintext sealPlainText = plain.sealPlainText;
    try {
        return  [[ASLBigUInt alloc] initWithBigUInt:_integerEncoder->decode_biguint(sealPlainText)];
    }  catch (std::invalid_argument const &e) {
           if (error != nil) {
               *error = [NSError ASL_SealInvalidParameter:e];
           }
           return nil;
    }
}

- (ASLPlainText*)encodeInt32Value:(int32_t)int32Value {
    return [[ASLPlainText alloc] initWithPlainText:_integerEncoder->encode(int32Value)];
}

- (ASLPlainText*)encodeUInt32Value:(uint32_t)uInt32Value {
    return [[ASLPlainText alloc] initWithPlainText:_integerEncoder->encode(uInt32Value)];
}

- (ASLModulus *)plainModulus {
    return [[ASLModulus alloc]initWithModulus:_integerEncoder->plain_modulus()];
}

@end





