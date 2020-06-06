//
//  ASLPlainText_Internal.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-05.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import "ASLPlainText.h"

#include "seal/plaintext.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASLPlainText ()

/// Returns a copy of the small modulus backing the receiver.
@property (nonatomic, assign, readonly) seal::Plaintext sealPlainText;

- (instancetype)initWithPlainText:(seal::Plaintext)plainText;


@end

NS_ASSUME_NONNULL_END
