//
//  ASLBigUInt.m
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-28.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import "ASLBigUInt.h"

#include <string>
#include <stdexcept>
#include "seal/biguint.h"

#import "ASLBigUInt_Internal.h"
#import "NSString+CXXAdditions.h"
#import "NSError+CXXAdditions.h"

@implementation ASLBigUInt {
    seal::BigUInt _bigUInt;
}

#pragma mark - Initialization

+ (instancetype)bigUIntWithBitCount:(NSInteger)bitCount error:(NSError **)error {
    try {
        seal::BigUInt const bigUInt = seal::BigUInt(static_cast<int>(bitCount));
        return [[ASLBigUInt alloc] initWithBigUInt:bigUInt];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

+ (instancetype)bigUIntWithHexValue:(NSString *)hexValue error:(NSError **)error {
    NSParameterAssert(hexValue != nil);
    
    std::string const hexValueString = (hexValue.length > 0
                                        ? hexValue.stdString
                                        : "");
    try {
        seal::BigUInt const bigUInt = seal::BigUInt(hexValueString);
        return [[ASLBigUInt alloc] initWithBigUInt:bigUInt];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}
+ (instancetype)bigUIntWithBitCount:(NSInteger)bitCount
                        scalarValue:(uint64_t)value
                              error:(NSError **)error {
    try {
        seal::BigUInt const bigUInt = seal::BigUInt(static_cast<int>(bitCount), value);
        return [[ASLBigUInt alloc] initWithBigUInt:bigUInt];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

+ (instancetype)bigUIntWithBitCount:(NSInteger)bitCount
                       scalarValues:(uint64_t *)values
                              error:(NSError **)error {
    try {
        seal::BigUInt const bigUInt = seal::BigUInt(static_cast<int>(bitCount), values);
        return [[ASLBigUInt alloc] initWithBigUInt:bigUInt];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

+ (instancetype)bigUIntWithBitCount:(NSInteger)bitCount
                           hexValue:(NSString *)hexValue
                              error:(NSError **)error {
    NSParameterAssert(hexValue != nil);
    
    std::string const hexValueString = (hexValue.length > 0
                                        ? hexValue.stdString
                                        : "");
    try {
        seal::BigUInt const bigUInt = seal::BigUInt(static_cast<int>(bitCount), hexValueString);
        return [[ASLBigUInt alloc] initWithBigUInt:bigUInt];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[ASLBigUInt class]]) {
        return NO;
    }
    
    return [self isEqualToBigUInt:(ASLBigUInt *)object];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSData * const encodedValueData = [coder decodeDataObject];
    if (encodedValueData.length == 0) {
        return nil;
    }
    
    seal::BigUInt encodedBigUInt;
    std::byte const * bytes = static_cast<std::byte const *>(encodedValueData.bytes);
    std::size_t const length = static_cast<std::size_t const>(encodedValueData.length);
    encodedBigUInt.load(bytes, length);
    return [self initWithBigUInt:encodedBigUInt];
}


- (void)encodeWithCoder:(NSCoder *)coder {
    std::size_t const lengthUpperBound = _bigUInt.save_size(seal::Serialization::compr_mode_default);
    NSMutableData * const data = [NSMutableData dataWithLength:lengthUpperBound];
    std::size_t const actualLength = _bigUInt.save(static_cast<std::byte *>(data.mutableBytes), lengthUpperBound);
    [data setLength:actualLength];
    [coder encodeDataObject:data];
}

#pragma mark - Public Methods

- (BOOL)isEqualToBigUInt:(ASLBigUInt *)other {
    NSParameterAssert(other != nil);
    if (other == nil) {
        return NO;
    } else {
        return _bigUInt == other->_bigUInt;
    }
}

- (NSComparisonResult)compare:(ASLBigUInt *)other {
    NSParameterAssert(other != nil);
    if (other == nil) {
        return NSOrderedSame;
    } else if (_bigUInt == other->_bigUInt) {
        return NSOrderedSame;
    } else if (_bigUInt < other->_bigUInt) {
        return NSOrderedAscending;
    } else {
        return NSOrderedDescending;
    }
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[ASLBigUInt allocWithZone:zone] initWithBigUInt:_bigUInt];
}

#pragma mark - Properties

- (BOOL)isAlias {
    return _bigUInt.is_alias();
}

- (NSInteger)bitCount {
    return _bigUInt.bit_count();
}

- (uint64_t *)data {
    return _bigUInt.data();
}

- (size_t)byteCount {
    return _bigUInt.byte_count();
}

- (size_t)uint64Count {
    return _bigUInt.uint64_count();
}

- (NSInteger)significantBitCount {
    return _bigUInt.significant_bit_count();
}

- (double)doubleValue {
    return _bigUInt.to_double();
}

- (NSString *)stringValue {
    return [NSString ASL_stringWithStdString:_bigUInt.to_string()];
}

- (NSString *)decimalStringValue {
    return [NSString ASL_stringWithStdString:_bigUInt.to_dec_string()];
}

- (BOOL)isZero {
    return _bigUInt.is_zero();
}

- (uint8_t)byteAtIndex:(NSInteger)index {
    try {
        return static_cast<uint8_t>(_bigUInt[index]);
    } catch (...) {
        [NSException raise:NSRangeException
                    format:@"Index %@ out of bounds", @(index)];
    }
    return 0;
}

#pragma mark - Public Methods

- (void)setZero {
    _bigUInt.set_zero();
}

- (ASLBigUInt *)dividingRemainderWithBigUIntModulus:(ASLBigUInt *)bigUIntModulus
                                          remainder:(ASLBigUInt *)remainder
                                              error:(NSError **)error {
    try {
        const seal::BigUInt operand = bigUIntModulus.sealBigUInt;
        seal::BigUInt remainderOperand = remainder.sealBigUInt;
        seal::BigUInt result = _bigUInt.divrem(operand, remainderOperand);
        return [[ASLBigUInt alloc] initWithBigUInt:result];
        
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
}

- (ASLBigUInt *)dividingRemainderWithScalarModulus:(uint64_t)scalarModulus
                                         remainder:(ASLBigUInt *)remainder
                                             error:(NSError **)error {
    try {
        seal::BigUInt remainderOperand = remainder.sealBigUInt;
        seal::BigUInt result = _bigUInt.divrem(scalarModulus, remainderOperand);
        return [[ASLBigUInt alloc] initWithBigUInt:result];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
}

- (ASLBigUInt *)moduloInvertWithBigUIntModulus:(ASLBigUInt *)bigUIntModulus
                                         error:(NSError **)error {
    try {
        seal::BigUInt modulus = bigUIntModulus.sealBigUInt;
        seal::BigUInt result =  _bigUInt.modinv(modulus);
        return [[ASLBigUInt alloc] initWithBigUInt:result];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
}

- (ASLBigUInt *)moduloInvertWithScalarModulus:(uint64_t)scalarModulus
                                        error:(NSError **)error {
    try {
        seal::BigUInt result =   _bigUInt.modinv(scalarModulus);
        return [[ASLBigUInt alloc] initWithBigUInt:result];
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
}

- (BOOL)tryModuloInvertWithBigUIntModulus:(ASLBigUInt *)bigUIntModulus
                                  inverse:(ASLBigUInt *)inverse
                                    error:(NSError **)error {
    try {
        const seal::BigUInt modulus = bigUIntModulus.sealBigUInt;
        seal::BigUInt inverseModulus = inverse.sealBigUInt;
        return  _bigUInt.trymodinv(modulus, inverseModulus);
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)tryModuloInvertWithScalarModulus:(uint64_t)scalarModulus
                                 inverse:(ASLBigUInt *)inverse
                                   error:(NSError **)error {
    try {
        seal::BigUInt inverseModulus = inverse.sealBigUInt;
        return _bigUInt.trymodinv(scalarModulus, inverseModulus);
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
    return NO;
}

+ (ASLBigUInt *) createNewWithValue:(uint64_t)value {
    return [[ASLBigUInt alloc] initWithBigUInt:seal::BigUInt().of(value)];
}

- (BOOL)duplicateTo:(ASLBigUInt *)destination
              error:(NSError **)error {
    try {
        seal::BigUInt sealDestination = destination.sealBigUInt;
        _bigUInt.duplicate_to(sealDestination);
        return YES;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

- (BOOL)duplicateFrom:(ASLBigUInt *)value
                error:(NSError **)error{
    try {
        const seal::BigUInt sealDestination = value.sealBigUInt;
        _bigUInt.duplicate_from(sealDestination);
        return YES;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
}

- (BOOL)resize:(int)bitCount
         error:(NSError **)error {
    try {
        _bigUInt.resize(static_cast<int>(bitCount));
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
    return NO;
}

- (ASLBigUInt *)negate {
    return [[ASLBigUInt alloc] initWithBigUInt:_bigUInt.operator-()];
}

- (ASLBigUInt *)invert {
    return [[ASLBigUInt alloc] initWithBigUInt:_bigUInt.operator~()];
}

- (ASLBigUInt *)incremenet:(NSError **)error {
    try {
        return [[ASLBigUInt alloc] initWithBigUInt:_bigUInt.operator~()];
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
    return nil;
}

- (ASLBigUInt *)decrement:(NSError **)error {
    try {
        return [[ASLBigUInt alloc] initWithBigUInt:_bigUInt.operator~()];
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return nil;
    }
    return nil;
}

- (ASLBigUInt *)bigUIntByAddingBigUInt:(ASLBigUInt *)bigUInt {
    const seal::BigUInt operand = bigUInt.sealBigUInt;
    return [[ASLBigUInt alloc] initWithBigUInt: _bigUInt.operator+(operand)];
}

- (ASLBigUInt *)bigUIntByAddingScalar:(uint64_t)scalar {
    return [[ASLBigUInt alloc] initWithBigUInt: _bigUInt.operator+(scalar)];
}

- (ASLBigUInt *)bigUIntByDividingBigUInt:(ASLBigUInt *)bigUInt error:(NSError **)error {
    try {
        const seal::BigUInt operand = bigUInt.sealBigUInt;
        return [[ASLBigUInt alloc] initWithBigUInt: _bigUInt.operator/=(operand)];;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLBigUInt *)bigUIntByDividingScalar:(uint64_t)scalar
                                  error:(NSError **)error {
    try {
        return [[ASLBigUInt alloc] initWithBigUInt: _bigUInt.operator/=(scalar)];;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return nil;
    }
    return nil;
}

- (ASLBigUInt *)bigUIntByBitwiseAndBigUInt:(ASLBigUInt *)bigUInt {
    const seal::BigUInt operand = bigUInt.sealBigUInt;
    return [[ASLBigUInt alloc] initWithBigUInt: _bigUInt.operator&=(operand)];
}

- (ASLBigUInt *)bigUIntByBitwiseAndScalar:(uint64_t)scalar {
    return [[ASLBigUInt alloc] initWithBigUInt: _bigUInt.operator&=(scalar)];
}

- (ASLBigUInt *)bigUIntBySubtractingBigUInt:(ASLBigUInt *)bigUInt {
    const seal::BigUInt operand = bigUInt.sealBigUInt;
    return [[ASLBigUInt alloc] initWithBigUInt: _bigUInt.operator-(operand)];
}

- (ASLBigUInt *)bigUIntBySubtractingScalar:(uint64_t)scalar {
    return [[ASLBigUInt alloc] initWithBigUInt: _bigUInt.operator-(scalar)];
}

- (ASLBigUInt *)bigUIntByBitwiseXOrBigUInt:(ASLBigUInt *)bigUInt {
    const seal::BigUInt operand = bigUInt.sealBigUInt;
    return [[ASLBigUInt alloc] initWithBigUInt: _bigUInt.operator^(operand)];
}

- (ASLBigUInt *)bigUIntByBitwiseXOrScalar:(uint64_t)scalar {
    return [[ASLBigUInt alloc] initWithBigUInt: _bigUInt.operator^(scalar)];
}

- (ASLBigUInt *)bigUIntByBitwiseOrBigUInt:(ASLBigUInt *)bigUInt {
    const seal::BigUInt operand = bigUInt.sealBigUInt;
    return [[ASLBigUInt alloc] initWithBigUInt: _bigUInt.operator|(operand)];
}

- (ASLBigUInt *)bigUIntByBitwiseOrScalar:(uint64_t)scalar {
    return [[ASLBigUInt alloc] initWithBigUInt: _bigUInt.operator^(scalar)];
}

- (ASLBigUInt *)bigUIntByLeftShift:(int)shift {
    return [[ASLBigUInt alloc] initWithBigUInt: _bigUInt.operator<<(shift)];
}

- (ASLBigUInt *)bigUIntByRightShift:(int)shift {
    return [[ASLBigUInt alloc] initWithBigUInt: _bigUInt.operator>>(shift)];
}

- (BOOL)alias:(NSInteger)bitCount
 scalarValues:(uint64_t *)value
        error:(NSError **)error {
    try {
        _bigUInt.alias(static_cast<int>(bitCount), value);
        return YES;
    } catch (std::invalid_argument const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealInvalidParameter:e];
        }
        return NO;
    }
    return NO;
}

- (BOOL)unalias:(NSError **)error {
    try {
        _bigUInt.unalias();
        return YES;
    } catch (std::logic_error const &e) {
        if (error != nil) {
            *error = [NSError ASL_SealLogicError:e];
        }
        return NO;
    }
    return NO;
}

#pragma mark - ASLBigUInt_Internal

- (seal::BigUInt)sealBigUInt {
    return _bigUInt;
}

- (instancetype)initWithBigUInt:(seal::BigUInt)bigUInt {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _bigUInt = std::move(bigUInt);
    
    return self;
}

@end
