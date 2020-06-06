//
//  ASLEncryptionParameterQualifiers.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-31.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#if defined __cplusplus
extern "C" {
#endif

typedef struct {
    bool isParametersSet;
    bool isUsingFFT;
    bool isUsingNNT;
    bool isUsingBatching;
    bool isUsingFastPlainLift;
    bool isUsingDescendingModulusChain;
    int securityLevel;
    
} ASLEncryptionParameterQualifiers;

static inline ASLEncryptionParameterQualifiers ASLEncryptionParameterQualifiersMake(bool isParametersSet, bool isUsingFFT, bool isUsingNNT, bool isUsingBatching, bool isUsingFastPlainLift, bool isUsingDescendingModulusChain, int securityLevel) {
    return (ASLEncryptionParameterQualifiers) {
        .isParametersSet = isParametersSet,
        .isUsingFFT = isUsingFFT,
        .isUsingNNT = isUsingNNT,
        .isUsingBatching = isUsingBatching,
        .isUsingFastPlainLift = isUsingFastPlainLift,
        .isUsingDescendingModulusChain = isUsingDescendingModulusChain,
        .securityLevel = securityLevel
    };
}

static inline BOOL ASLEncryptionParameterQualifiersIsEqual(ASLEncryptionParameterQualifiers lhs, ASLEncryptionParameterQualifiers rhs) {
    return ((lhs.isParametersSet == rhs.isParametersSet) &&
            (lhs.isUsingFFT == rhs.isUsingFFT) &&
            (lhs.isUsingNNT == rhs.isUsingNNT) &&
            (lhs.isUsingBatching == rhs.isUsingBatching) &&
            (lhs.isUsingFastPlainLift == rhs.isUsingFastPlainLift) &&
            (lhs.isUsingDescendingModulusChain == rhs.isUsingDescendingModulusChain) &&
            (lhs.securityLevel == rhs.securityLevel));
}

#if defined __cplusplus
}
#endif

NS_ASSUME_NONNULL_END

