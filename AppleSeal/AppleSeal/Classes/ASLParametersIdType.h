//
//  ASLParametersIdType.h
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
	unsigned long long block[4];
} ASLParametersIdType;

static inline ASLParametersIdType ASLParametersIdTypeMake(unsigned long long a, unsigned long long b, unsigned long long c, unsigned long long d) {
	return (ASLParametersIdType) {
		.block = { a, b, c, d }
	};
}

static inline uint64_t ASLParametersIdTypeHash(ASLParametersIdType value) {
	return value.block[0] ^ value.block[1] ^ value.block[2] ^ value.block[3];
}

static inline BOOL ASLParametersIdTypeIsEqual(ASLParametersIdType lhs, ASLParametersIdType rhs) {
	return ((lhs.block[0] == rhs.block[0]) &&
			(lhs.block[1] == rhs.block[1]) &&
			(lhs.block[2] == rhs.block[2]) &&
			(lhs.block[3] == rhs.block[3]));
}

#if defined __cplusplus
}
#endif

NS_ASSUME_NONNULL_END

