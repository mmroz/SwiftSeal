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

/*!
 @class ASLGaloisKeys
 
 @brief The ASLGaloisKeys class and wrapper for the  galoiskeys.h
 
 @discussion Class to store Galois keys.
 
 Slot Rotations
 Galois keys are used together with batching (BatchEncoder). If the polynomial modulus
 is a polynomial of degree N, in batching the idea is to view a plaintext polynomial as
 a 2-by-(N/2) matrix of integers modulo plaintext modulus. Normal homomorphic computations
 operate on such encrypted matrices element (slot) wise. However, special rotation
 operations allow us to also rotate the matrix rows cyclically in either direction, and
 rotate the columns (swap the rows). These operations require the Galois keys.
 
 Thread Safety
 In general, reading from GaloisKeys is thread-safe as long as no other thread is
 concurrently mutating it. This is due to the underlying data structure storing the
 Galois keys not being thread-safe.
 */
@interface ASLGaloisKeys : ASLKSwitchKeys <NSCopying>

/*!
 Returns the index of a Galois key in the backing KSwitchKeys instance that
 corresponds to the given Galois element, assuming that it exists in the
 backing KSwitchKeys.
 
 @param galoisElement The Galois element
 @throws ASL_SealInvalidParameter if galois_elt is not valid
 */
-(NSNumber * _Nullable)getIndex:(NSNumber*)galoisElement
            error:(NSError **)error;

/*!
 Returns whether a Galois key corresponding to a given Galois element exists.
 
 @param galoisElement The Galois element
 @throws ASL_SealInvalidParameter if galoisElement is not valid
 */
-(NSNumber * _Nullable)hasKey:(NSNumber*)galoisElement
        error:(NSError **)error;

/*!
 Returns a const reference to a Galois key. The returned Galois key corresponds
 to the given Galois element.
 
 @param galoisElement The Galois element
 @throws ASL_SealInvalidParameter if the key corresponding to galois_elt does not exist
 */
-(NSArray<ASLPublicKey*>* _Nullable)key:(NSNumber*)galoisElement
                        error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
