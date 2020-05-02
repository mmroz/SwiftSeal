//
//  ASLEvaluator.h
//  AppleSeal
//
//  Created by Mark Mroz on 2020-01-12.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLCipherText.h"
#import "ASLPlainText.h"
#import "ASLMemoryPoolHandle.h"
#import "ASLRelinearizationKeys.h"
#import "ASLGaloisKeys.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 @class ASLEncryptor
 
 @brief The ASLEvaluator class and wrapper for the evaluator.h
 
 @discussion Provides operations on ciphertexts. Due to the properties of the encryption
 scheme, the arithmetic operations pass through the encryption layer to the
 underlying plaintext, changing it according to the type of the operation. Since
 the plaintext elements are fundamentally polynomials in the polynomial quotient
 ring Z_T[x]/(X^N+1), where T is the plaintext modulus and X^N+1 is the polynomial
 modulus, this is the ring where the arithmetic operations will take place.
 BatchEncoder (batching) provider an alternative possibly more convenient view
 of the plaintext elements as 2-by-(N2/2) matrices of integers modulo the plaintext
 modulus. In the batching view the arithmetic operations act on the matrices
 element-wise. Some of the operations only apply in the batching view, such as
 matrix row and column rotations. Other operations such as relinearization have
 no semantic meaning but are necessary for performance reasons.
 
 Arithmetic Operations
 The core operations are arithmetic operations, in particular multiplication
 and addition of ciphertexts. In addition to these, we also provide negation,
 subtraction, squaring, exponentiation, and multiplication and addition of
 several ciphertexts for convenience. in many cases some of the inputs to a
 computation are plaintext elements rather than ciphertexts. For this we
 provide fast "plain" operations: plain addition, plain subtraction, and plain
 multiplication.
 
 Relinearization
 One of the most important non-arithmetic operations is relinearization, which
 takes as input a ciphertext of size K+1 and relinearization keys (at least K-1
 keys are needed), and changes the size of the ciphertext down to 2 (minimum size).
 For most use-cases only one relinearization key suffices, in which case
 relinearization should be performed after every multiplication. Homomorphic
 multiplication of ciphertexts of size K+1 and L+1 outputs a ciphertext of size
 K+L+1, and the computational cost of multiplication is proportional to K*L.
 Plain multiplication and addition operations of any type do not change the
 size. Relinearization requires relinearization keys to have been generated.
 
 Rotations
 When batching is enabled, we provide operations for rotating the plaintext matrix
 rows cyclically left or right, and for rotating the columns (swapping the rows).
 Rotations require Galois keys to have been generated.
 
 Other Operations
 We also provide operations for transforming ciphertexts to NTT form and back,
 and for transforming plaintext polynomials to NTT form. These can be used in
 a very fast plain multiplication variant, that assumes the inputs to be in NTT
 form. Since the NTT has to be done in any case in plain multiplication, this
 function can be used when e.g. one plaintext input is used in several plain
 multiplication, and transforming it several times would not make sense.
 
 NTT form
 When using the BFV scheme (scheme_type::BFV), all plaintexts and ciphertexts
 should remain by default in the usual coefficient representation, i.e., not
 in NTT form. When using the CKKS scheme (scheme_type::CKKS), all plaintexts
 and ciphertexts should remain by default in NTT form. We call these scheme-
 specific NTT states the "default NTT form". Some functions, such as add, work
 even if the inputs are not in the default state, but others, such as multiply,
 will throw an exception. The output of all evaluation functions will be in
 the same state as the input(s), with the exception of the transform_to_ntt
 and transform_from_ntt functions, which change the state. Ideally, unless these
 two functions are called, all other functions should "just work".
 
 @see EncryptionParameters for more details on encryption parameters.
 @see BatchEncoder for more details on batching
 @see RelinKeys for more details on relinearization keys.
 @see GaloisKeys for more details on Galois keys.
 */

@interface ASLEvaluator : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/*!
 Creates an Evaluator instance initialized with the specified SEALContext.
 
 @param context The SEALContext
 @throws ASL_SealInvalidParameter if the context is not set or encryption
 parameters are not valid
 */

+ (instancetype _Nullable)evaluatorWith:(ASLSealContext *)context
                                  error:(NSError **)error;


-(BOOL)negate:(ASLCipherText *)encrypted
   detination:(ASLCipherText *)destination
        error:(NSError **)error;

/*!
 Negates a ciphertext.
 
 @param encrypted The ciphertext to negate
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption
 parameters
 */
-(BOOL)negateInplace:(ASLCipherText *)encrypted
               error:(NSError **)error;

/*!
 Adds two ciphertexts. This function adds together encrypted1 and encrypted2
 and stores the result in encrypted1.
 
 @param encrypted1 The first ciphertext to add
 @param encrypted2 The second ciphertext to add
 @throws ASL_SealInvalidParameter if encrypted1 or encrypted2 is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted1 and encrypted2 are in different
 NTT forms
 @throws ASL_SealInvalidParameter if encrypted1 and encrypted2 have different scale
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)addInplace:(ASLCipherText *)encrypted1
       encrypted2:(ASLCipherText *)encrypted2
            error:(NSError **)error;

/*!
 Adds two ciphertexts. This function adds together encrypted1 and encrypted2
 and stores the result in the destination parameter.
 
 @param encrypted1 The first ciphertext to add
 @param encrypted2 The second ciphertext to add
 @param destination The ciphertext to overwrite with the negated result
 @throws ASL_SealInvalidParameter if encrypted1 or encrypted2 is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted1 and encrypted2 are in different
 NTT forms
 @throws ASL_SealInvalidParameter if encrypted1 and encrypted2 have different scale
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)add:(ASLCipherText *)encrypted1
encrypted2:(ASLCipherText *)encrypted2
destination:(ASLCipherText *)destination
     error:(NSError **)error;

/*!
 Adds together a vector of ciphertexts and stores the result in the destination
 parameter.
 
 @param encrypteds The ciphertexts to add
 @param destination The ciphertext to overwrite with the addition result
 @throws ASL_SealInvalidParameter if encrypteds is empty
 @throws ASL_SealInvalidParameter if the encrypteds are not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if encrypteds are in different NTT forms
 @throws ASL_SealInvalidParameter if encrypteds have different scale
 @throws ASL_SealInvalidParameter if destination is one of encrypteds
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)addMany:(NSArray<ASLCipherText *> *)encrypteds
   destination:(ASLCipherText *)destination
         error:(NSError **)error;

/*!
 Subtracts two ciphertexts. This function computes the difference of encrypted1
 and encrypted2, and stores the result in encrypted1.
 
 @param encrypted1 The ciphertext to subtract from
 @param encrypted2 The ciphertext to subtract
 @throws ASL_SealInvalidParameter if encrypted1 or encrypted2 is not valid for the
 encryption parameters`
 @throws ASL_SealInvalidParameter if encrypted1 and encrypted2 are in different
 NTT forms
 @throws ASL_SealInvalidParameter if encrypted1 and encrypted2 have different scale
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)subInplace:(ASLCipherText *)encrypted1
       encrypted2:(ASLCipherText *)encrypted2
            error:(NSError **)error;

/*!
 Subtracts two ciphertexts. This function computes the difference of encrypted1
 and encrypted2 and stores the result in the destination parameter.
 
 @param encrypted1 The ciphertext to subtract from
 @param encrypted2 The ciphertext to subtract
 @param destination The ciphertext to overwrite with the negated result
 @throws ASL_SealInvalidParameter if encrypted1 or encrypted2 is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if encrypted1 and encrypted2 are in different
 NTT forms
 @throws ASL_SealInvalidParameter if encrypted1 and encrypted2 have different scale
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)sub:(ASLCipherText *)encrypted1
encrypted2:(ASLCipherText *)encrypted2
destination:(ASLCipherText *)destination
     error:(NSError **)error;

/*!
 Multiplies two ciphertexts. This functions computes the product of encrypted1
 and encrypted2 and stores the result in encrypted1. Dynamic memory allocations
 in the process are allocated from the memory pool pointed to by the given
 MemoryPoolHandle.
 
 @param encrypted1 The first ciphertext to multiply
 @param encrypted2 The second ciphertext to multiply
 @throws ASL_SealInvalidParameter if encrypted1 or encrypted2 is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if encrypted1 or encrypted2 is not in the default
 NTT form
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the output scale
 is too large for the encryption parameters
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)multiplyInplace:(ASLCipherText *)encrypted1
            encrypted2:(ASLCipherText *)encrypted2
                 error:(NSError **)error;

/*!
 @param encrypted1 The first ciphertext to multiply
 @param encrypted2 The second ciphertext to multiply
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if encrypted1 or encrypted2 is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if encrypted1 or encrypted2 is not in the default
 NTT form
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the output scale
 is too large for the encryption parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)multiplyInplace:(ASLCipherText *)encrypted1
            encrypted2:(ASLCipherText *)encrypted2
                  pool:(ASLMemoryPoolHandle *)pool
                 error:(NSError **)error;

/*!
 Multiplies two ciphertexts. This functions computes the product of encrypted1
 and encrypted2 and stores the result in the destination parameter. Dynamic
 memory allocations in the process are allocated from the memory pool pointed
 to by the given MemoryPoolHandle.
 
 @param encrypted1 The first ciphertext to multiply
 @param encrypted2 The second ciphertext to multiply
 @param destination The ciphertext to overwrite with the multiplication result
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if encrypted1 or encrypted2 is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if encrypted1 or encrypted2 is not in the default
 NTT form
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the output scale
 is too large for the encryption parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)multiply:(ASLCipherText *)encrypted1
     encrypted2:(ASLCipherText *)encrypted2
    destination:(ASLCipherText *)destination
           pool:(ASLMemoryPoolHandle *)pool
          error:(NSError **)error;

/*!
 Multiplies two ciphertexts. This functions computes the product of encrypted1
 and encrypted2 and stores the result in the destination parameter. Dynamic
 memory allocations in the process are allocated from the memory pool pointed
 to by the given MemoryPoolHandle.
 
 @param encrypted1 The first ciphertext to multiply
 @param encrypted2 The second ciphertext to multiply
 @param destination The ciphertext to overwrite with the multiplication result
 @throws ASL_SealInvalidParameter if encrypted1 or encrypted2 is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if encrypted1 or encrypted2 is not in the default
 NTT form
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the output scale
 is too large for the encryption parameters
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)multiply:(ASLCipherText *)encrypted1
     encrypted2:(ASLCipherText *)encrypted2
    destination:(ASLCipherText *)destination
          error:(NSError **)error;

/*!
 Squares a ciphertext. This functions computes the square of encrypted. Dynamic
 memory allocations in the process are allocated from the memory pool pointed
 to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to square
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the output scale
 is too large for the encryption parameters
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)squareInplace:(ASLCipherText *)encrypted
               error:(NSError **)error;

/*!
 Squares a ciphertext. This functions computes the square of encrypted. Dynamic
 memory allocations in the process are allocated from the memory pool pointed
 to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to square
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the output scale
 is too large for the encryption parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)squareInplace:(ASLCipherText *)encrypted
                pool:(ASLMemoryPoolHandle *)pool
               error:(NSError **)error;

/*!
 Squares a ciphertext. This functions computes the square of encrypted and
 stores the result in the destination parameter. Dynamic memory allocations
 in the process are allocated from the memory pool pointed to by the given
 MemoryPoolHandle.
 
 @param encrypted The ciphertext to square
 @param destination The ciphertext to overwrite with the square
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the output scale
 is too large for the encryption parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)square:(ASLCipherText *)encrypted
  destination:(ASLCipherText *)destination
         pool:(ASLMemoryPoolHandle *)pool
        error:(NSError **)error;

/*!
 Squares a ciphertext. This functions computes the square of encrypted and
 stores the result in the destination parameter. Dynamic memory allocations
 in the process are allocated from the memory pool pointed to by the given
 MemoryPoolHandle.
 
 @param encrypted The ciphertext to square
 @param destination The ciphertext to overwrite with the square
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the output scale
 is too large for the encryption parameters
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)square:(ASLCipherText *)encrypted
  destination:(ASLCipherText *)destination
        error:(NSError **)error;

/*!
 Relinearizes a ciphertext. This functions relinearizes encrypted, reducing
 its size down to 2. If the size of encrypted is K+1, the given relinearization
 keys need to have size at least K-1. Dynamic memory allocations in the
 process are allocated from the memory pool pointed to by the given
 MemoryPoolHandle.
 
 @param encrypted The ciphertext to relinearize
 @param relinearizationKeys The relinearization keys
 @throws ASL_SealInvalidParameter if encrypted or relinearizationKeys is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if relin_keys do not correspond to the top level
 parameters in the current context
 @throws ASL_SealInvalidParameter if the size of relin_keys is too small
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)relinearizeInplace:(ASLCipherText *)encrypted
      relinearizationKeys:(ASLRelinearizationKeys *)relinearizationKeys
                    error:(NSError **)error;
/*!
 Relinearizes a ciphertext. This functions relinearizes encrypted, reducing
 its size down to 2. If the size of encrypted is K+1, the given relinearization
 keys need to have size at least K-1. Dynamic memory allocations in the
 process are allocated from the memory pool pointed to by the given
 MemoryPoolHandle.
 
 @param encrypted The ciphertext to relinearize
 @param relinearizationKeys The relinearization keys
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if encrypted or relinearizationKeys is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if relin_keys do not correspond to the top level
 parameters in the current context
 @throws ASL_SealInvalidParameter if the size of relin_keys is too small
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)relinearizeInplace:(ASLCipherText *)encrypted
      relinearizationKeys:(ASLRelinearizationKeys *)relinearizationKeys
                     pool:(ASLMemoryPoolHandle *)pool
                    error:(NSError **)error;

/*!
 Relinearizes a ciphertext. This functions relinearizes encrypted, reducing
 its size down to 2, and stores the result in the destination parameter.
 If the size of encrypted is K+1, the given relinearization keys need to
 have size at least K-1. Dynamic memory allocations in the process are allocated
 from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to relinearize
 @param relinearizationKeys The relinearization keys
 @param destination The ciphertext to overwrite with the relinearized result
 @throws ASL_SealInvalidParameter if encrypted or relin_keys is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if relin_keys do not correspond to the top level
 parameters in the current context
 @throws ASL_SealInvalidParameter if the size of relin_keys is too small
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)relinearize:(ASLCipherText *)encrypted
relinearizationKeys:(ASLRelinearizationKeys *)relinearizationKeys
       destination:(ASLCipherText *)destination
             error:(NSError **)error;

/*!
 Relinearizes a ciphertext. This functions relinearizes encrypted, reducing
 its size down to 2, and stores the result in the destination parameter.
 If the size of encrypted is K+1, the given relinearization keys need to
 have size at least K-1. Dynamic memory allocations in the process are allocated
 from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to relinearize
 @param relinearizationKeys The relinearization keys
 @param destination The ciphertext to overwrite with the relinearized result
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if encrypted or relin_keys is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if relin_keys do not correspond to the top level
 parameters in the current context
 @throws ASL_SealInvalidParameter if the size of relin_keys is too small
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)relinearize:(ASLCipherText *)encrypted
relinearizationKeys:(ASLRelinearizationKeys *)relinearizationKeys
       destination:(ASLCipherText *)destination
              pool:(ASLMemoryPoolHandle *)pool
             error:(NSError **)error;

/*!
 Given a ciphertext encrypted modulo q_1...q_k, this function switches the
 modulus down to q_1...q_{k-1} and stores the result in the destination
 parameter. Dynamic memory allocations in the process are allocated from
 the memory pool pointed to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to be switched to a smaller modulus
 @param destination The ciphertext to overwrite with the modulus switched result
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if encrypted is already at lowest level
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the scale is too
 large for the new encryption parameters
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)modSwitchToNext:(ASLCipherText *)encrypted
           destination:(ASLCipherText *)destination
                 error:(NSError **)error;

/*
 @param encrypted The ciphertext to be switched to a smaller modulus
 @param destination The ciphertext to overwrite with the modulus switched result
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if encrypted is already at lowest level
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the scale is too
 large for the new encryption parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)modSwitchToNext:(ASLCipherText *)encrypted
           destination:(ASLCipherText *)destination
                  pool:(ASLMemoryPoolHandle *)pool
                 error:(NSError **)error;

/*!
 Given a ciphertext encrypted modulo q_1...q_k, this function switches the
 modulus down to q_1...q_{k-1}. Dynamic memory allocations in the process
 are allocated from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to be switched to a smaller modulus
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if encrypted is already at lowest level
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the scale is too
 large for the new encryption parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)modSwitchToNextInplace:(ASLCipherText *)encrypted
                         pool:(ASLMemoryPoolHandle *)pool
                        error:(NSError **)error;

/*!
 Given a ciphertext encrypted modulo q_1...q_k, this function switches the
 modulus down to q_1...q_{k-1}. Dynamic memory allocations in the process
 are allocated from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to be switched to a smaller modulus
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if encrypted is already at lowest level
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the scale is too
 large for the new encryption parameters
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)modSwitchToNextInplace:(ASLCipherText *)encrypted
                        error:(NSError **)error;

/*!
 Modulus switches an NTT transformed plaintext from modulo q_1...q_k down
 to modulo q_1...q_{k-1}.
 
 @param plain The plaintext to be switched to a smaller modulus
 @throws ASL_SealInvalidParameter if plain is not in NTT form
 @throws ASL_SealInvalidParameter if plain is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if plain is already at lowest level
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the scale is too
 large for the new encryption parameters
 */
-(BOOL)modSwitchToNext:(ASLPlainText *)plain
                 error:(NSError **)error;

/*!
 Given a ciphertext encrypted modulo q_1...q_k, this function switches the
 modulus down until the parameters reach the given parms_id. Dynamic memory
 allocations in the process are allocated from the memory pool pointed to
 by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to be switched to a smaller modulus
 @param parametersId The target parms_id
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is already at lower level in modulus chain
 than the parameters corresponding to parms_id
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the scale is too
 large for the new encryption parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)modSwitchToInplace:(ASLCipherText *)encrypted
             parametersId:(ASLParametersIdType)parametersId
                     pool:(ASLMemoryPoolHandle *)pool
                    error:(NSError **)error;

/*!
 Given a ciphertext encrypted modulo q_1...q_k, this function switches the
 modulus down until the parameters reach the given parms_id. Dynamic memory
 allocations in the process are allocated from the memory pool pointed to
 by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to be switched to a smaller modulus
 @param parametersId The target parms_id
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is already at lower level in modulus chain
 than the parameters corresponding to parms_id
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the scale is too
 large for the new encryption parameters
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)modSwitchToInplace:(ASLCipherText *)encrypted
             parametersId:(ASLParametersIdType)parametersId
                    error:(NSError **)error;
/*!
 Given a ciphertext encrypted modulo q_1...q_k, this function switches the
 modulus down until the parameters reach the given parms_id and stores the
 result in the destination parameter. Dynamic memory allocations in the process
 are allocated from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to be switched to a smaller modulus
 @param parametersId The target parms_id
 @param destination The ciphertext to overwrite with the modulus switched result
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is already at lower level in modulus chain
 than the parameters corresponding to parms_id
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the scale is too
 large for the new encryption parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)modSwitchTo:(ASLCipherText *)encrypted
      parametersId:(ASLParametersIdType)parametersId
       destination:(ASLCipherText *)destination
              pool:(ASLMemoryPoolHandle *)pool
             error:(NSError **)error;

/*!
 Given a ciphertext encrypted modulo q_1...q_k, this function switches the
 modulus down until the parameters reach the given parms_id and stores the
 result in the destination parameter. Dynamic memory allocations in the process
 are allocated from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to be switched to a smaller modulus
 @param parametersId The target parms_id
 @param destination The ciphertext to overwrite with the modulus switched result
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is already at lower level in modulus chain
 than the parameters corresponding to parms_id
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the scale is too
 large for the new encryption parameters
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)modSwitchTo:(ASLCipherText *)encrypted
      parametersId:(ASLParametersIdType)parametersId
       destination:(ASLCipherText *)destination
             error:(NSError **)error;

/*!
 Given an NTT transformed plaintext modulo q_1...q_k, this function switches
 the modulus down until the parameters reach the given parms_id.
 
 @param plain The plaintext to be switched to a smaller modulus
 @param parametersId The target parms_id
 @throws ASL_SealInvalidParameter if plain is not in NTT form
 @throws ASL_SealInvalidParameter if plain is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if plain is already at lower level in modulus chain
 than the parameters corresponding to parms_id
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the scale is too
 large for the new encryption parameters
 */
-(BOOL)modSwitchToInplaceWithPlain:(ASLPlainText *)plain
                      parametersId:(ASLParametersIdType)parametersId
                             error:(NSError **)error;

/*!
 Given an NTT transformed plaintext modulo q_1...q_k, this function switches
 the modulus down until the parameters reach the given parms_id and stores
 the result in the destination parameter.
 
 @param plain The plaintext to be switched to a smaller modulus
 @param parametersId The target parms_id
 @param destination The plaintext to overwrite with the modulus switched result
 @throws ASL_SealInvalidParameter if plain is not in NTT form
 @throws ASL_SealInvalidParameter if plain is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if plain is already at lower level in modulus chain
 than the parameters corresponding to parms_id
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the scale is too
 large for the new encryption parameters
 */
-(ASLPlainText * _Nullable)modSwitchToWithPlain:(ASLPlainText *)plain
               parametersId:(ASLParametersIdType)parametersId
                destination:(ASLPlainText *)destination
                      error:(NSError **)error;

/*!
 Given a ciphertext encrypted modulo q_1...q_k, this function switches the
 modulus down to q_1...q_{k-1}, scales the message down accordingly, and
 stores the result in the destination parameter. Dynamic memory allocations
 in the process are allocated from the memory pool pointed to by the given
 MemoryPoolHandle.
 
 @param encrypted The ciphertext to be switched to a smaller modulus
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @param destination The ciphertext to overwrite with the modulus switched result
 @throws ASL_SealInvalidParameter if the scheme is invalid for rescaling
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if encrypted is already at lowest level
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)rescaleToNext:(ASLCipherText *)encrypted
         destination:(ASLCipherText *)destination
                pool:(ASLMemoryPoolHandle *)pool
               error:(NSError **)error;

/*!
 Given a ciphertext encrypted modulo q_1...q_k, this function switches the
 modulus down to q_1...q_{k-1}, scales the message down accordingly, and
 stores the result in the destination parameter. Dynamic memory allocations
 in the process are allocated from the memory pool pointed to by the given
 MemoryPoolHandle.
 
 @param encrypted The ciphertext to be switched to a smaller modulus
 @param destination The ciphertext to overwrite with the modulus switched result
 @throws ASL_SealInvalidParameter if the scheme is invalid for rescaling
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if encrypted is already at lowest level
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)rescaleToNext:(ASLCipherText *)encrypted
         destination:(ASLCipherText *)destination
               error:(NSError **)error;
/*!
 Given a ciphertext encrypted modulo q_1...q_k, this function switches the
 modulus down to q_1...q_{k-1} and scales the message down accordingly. Dynamic
 memory allocations in the process are allocated from the memory pool pointed
 to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to be switched to a smaller modulus
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if the scheme is invalid for rescaling
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if encrypted is already at lowest level
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)rescaleToNextInplace:(ASLCipherText *)encrypted
                       pool:(ASLMemoryPoolHandle *)pool
                      error:(NSError **)error;
/*!
 Given a ciphertext encrypted modulo q_1...q_k, this function switches the
 modulus down to q_1...q_{k-1} and scales the message down accordingly. Dynamic
 memory allocations in the process are allocated from the memory pool pointed
 to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to be switched to a smaller modulus
 @throws ASL_SealInvalidParameter if the scheme is invalid for rescaling
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if encrypted is already at lowest level
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)rescaleToNextInplace:(ASLCipherText *)encrypted
                      error:(NSError **)error;

/*!
 Given a ciphertext encrypted modulo q_1...q_k, this function switches the
 modulus down until the parameters reach the given parms_id and scales the
 message down accordingly. Dynamic memory allocations in the process are
 allocated from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to be switched to a smaller modulus
 @param parametersId The target parms_id
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if the scheme is invalid for rescaling
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is already at lower level in modulus chain
 than the parameters corresponding to parms_id
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)rescaleToInplace:(ASLCipherText *)encrypted
           parametersId:(ASLParametersIdType)parametersId
                   pool:(ASLMemoryPoolHandle *)pool
                  error:(NSError **)error;

/*!
 Given a ciphertext encrypted modulo q_1...q_k, this function switches the
 modulus down until the parameters reach the given parms_id and scales the
 message down accordingly. Dynamic memory allocations in the process are
 allocated from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to be switched to a smaller modulus
 @param parametersId The target parms_id
 @throws ASL_SealInvalidParameter if the scheme is invalid for rescaling
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is already at lower level in modulus chain
 than the parameters corresponding to parms_id
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)rescaleToInplace:(ASLCipherText *)encrypted
           parametersId:(ASLParametersIdType)parametersId
                  error:(NSError **)error;

/*!
 Given a ciphertext encrypted modulo q_1...q_k, this function switches the
 modulus down until the parameters reach the given parms_id, scales the message
 down accordingly, and stores the result in the destination parameter. Dynamic
 memory allocations in the process are allocated from the memory pool pointed
 to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to be switched to a smaller modulus
 @param parametersId The target parms_id
 @param destination The ciphertext to overwrite with the modulus switched result
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if the scheme is invalid for rescaling
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is already at lower level in modulus chain
 than the parameters corresponding to parms_id
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)rescaleTo:(ASLCipherText *)encrypted
    parametersId:(ASLParametersIdType)parametersId
     destination:(ASLCipherText *)destination
            pool:(ASLMemoryPoolHandle *)pool
           error:(NSError **)error;

/*!
 Given a ciphertext encrypted modulo q_1...q_k, this function switches the
 modulus down until the parameters reach the given parms_id, scales the message
 down accordingly, and stores the result in the destination parameter. Dynamic
 memory allocations in the process are allocated from the memory pool pointed
 to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to be switched to a smaller modulus
 @param parametersId The target parms_id
 @param destination The ciphertext to overwrite with the modulus switched result
 @throws ASL_SealInvalidParameter if the scheme is invalid for rescaling
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if parms_id is not valid for the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is already at lower level in modulus chain
 than the parameters corresponding to parms_id
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)rescaleTo:(ASLCipherText *)encrypted
    parametersId:(ASLParametersIdType)parametersId
     destination:(ASLCipherText *)destination
           error:(NSError **)error;

/*!
 Multiplies several ciphertexts together. This function computes the product
 of several ciphertext given as an NSArray and stores the result in the
 destination parameter. The multiplication is done in a depth-optimal order,
 and relinearization is performed automatically after every multiplication
 in the process. In relinearization the given relinearization keys are used.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle.
 
 @param encrypteds The ciphertexts to multiply
 @param relinearizationKeys The relinearization keys
 @param destination The ciphertext to overwrite with the multiplication result
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealLogicError if scheme is not scheme_type::BFV
 @throws ASL_SealInvalidParameter if encrypteds is empty
 @throws ASL_SealInvalidParameter if the ciphertexts or relin_keys are not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if encrypteds are not in the default NTT form
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the output scale
 is too large for the encryption parameters
 @throws ASL_SealInvalidParameter if the size of relin_keys is too small
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)multiplyMany:(NSArray<ASLCipherText*>*)encrypteds
relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
        destination:(ASLCipherText *)destination
               pool:(ASLMemoryPoolHandle *)pool
              error:(NSError **)error;

/*!
 Multiplies several ciphertexts together. This function computes the product
 of several ciphertext given as an NSArray and stores the result in the
 destination parameter. The multiplication is done in a depth-optimal order,
 and relinearization is performed automatically after every multiplication
 in the process. In relinearization the given relinearization keys are used.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle.
 
 @param encrypteds The ciphertexts to multiply
 @param relinearizationKeys The relinearization keys
 @param destination The ciphertext to overwrite with the multiplication result
 @throws ASL_SealLogicError if scheme is not scheme_type::BFV
 @throws ASL_SealInvalidParameter if encrypteds is empty
 @throws ASL_SealInvalidParameter if the ciphertexts or relin_keys are not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if encrypteds are not in the default NTT form
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the output scale
 is too large for the encryption parameters
 @throws ASL_SealInvalidParameter if the size of relin_keys is too small
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)multiplyMany:(NSArray<ASLCipherText*>*)encrypteds
relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
        destination:(ASLCipherText *)destination
              error:(NSError **)error;

/*!
 Exponentiates a ciphertext. This functions raises encrypted to a power.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle. The exponentiation is done
 in a depth-optimal order, and relinearization is performed automatically
 after every multiplication in the process. In relinearization the given
 relinearization keys are used.
 
 @param encrypted The ciphertext to exponentiate
 @param exponent The power to raise the ciphertext to
 @param relinearizationKeys The relinearization keys
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealLogicError if scheme is not scheme_type::BFV
 @throws ASL_SealInvalidParameter if encrypted or relin_keys is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the output scale
 is too large for the encryption parameters
 @throws ASL_SealInvalidParameter if exponent is zero
 @throws ASL_SealInvalidParameter if the size of relin_keys is too small
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)exponentiateInplace:(ASLCipherText *)encrypted
                  exponent:(uint64_t)exponent
       relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
                      pool:(ASLMemoryPoolHandle *)pool
                     error:(NSError **)error;

/*!
 Exponentiates a ciphertext. This functions raises encrypted to a power.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle. The exponentiation is done
 in a depth-optimal order, and relinearization is performed automatically
 after every multiplication in the process. In relinearization the given
 relinearization keys are used.
 
 @param encrypted The ciphertext to exponentiate
 @param exponent The power to raise the ciphertext to
 @param relinearizationKeys The relinearization keys
 @throws ASL_SealLogicError if scheme is not scheme_type::BFV
 @throws ASL_SealInvalidParameter if encrypted or relin_keys is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the output scale
 is too large for the encryption parameters
 @throws ASL_SealInvalidParameter if exponent is zero
 @throws ASL_SealInvalidParameter if the size of relin_keys is too small
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)exponentiateInplace:(ASLCipherText *)encrypted
                  exponent:(uint64_t)exponent
       relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
                     error:(NSError **)error;

/*!
 Exponentiates a ciphertext. This functions raises encrypted to a power and
 stores the result in the destination parameter. Dynamic memory allocations
 in the process are allocated from the memory pool pointed to by the given
 MemoryPoolHandle. The exponentiation is done in a depth-optimal order, and
 relinearization is performed automatically after every multiplication in
 the process. In relinearization the given relinearization keys are used.
 
 @param encrypted The ciphertext to exponentiate
 @param exponent The power to raise the ciphertext to
 @param relinearizationKeys The relinearization keys
 @param destination The ciphertext to overwrite with the power
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealLogicError if scheme is not scheme_type::BFV
 @throws ASL_SealInvalidParameter if encrypted or relin_keys is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the output scale
 is too large for the encryption parameters
 @throws ASL_SealInvalidParameter if exponent is zero
 @throws ASL_SealInvalidParameter if the size of relin_keys is too small
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)exponentiate:(ASLCipherText *)encrypted
           exponent:(uint64_t)exponent
relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
        destination:(ASLCipherText *)destination
               pool:(ASLMemoryPoolHandle *)pool
              error:(NSError **)error;

/*!
 Exponentiates a ciphertext. This functions raises encrypted to a power and
 stores the result in the destination parameter. Dynamic memory allocations
 in the process are allocated from the memory pool pointed to by the given
 MemoryPoolHandle. The exponentiation is done in a depth-optimal order, and
 relinearization is performed automatically after every multiplication in
 the process. In relinearization the given relinearization keys are used.
 
 @param encrypted The ciphertext to exponentiate
 @param exponent The power to raise the ciphertext to
 @param relinearizationKeys The relinearization keys
 @param destination The ciphertext to overwrite with the power
 @throws ASL_SealLogicError if scheme is not scheme_type::BFV
 @throws ASL_SealInvalidParameter if encrypted or relin_keys is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the output scale
 is too large for the encryption parameters
 @throws ASL_SealInvalidParameter if exponent is zero
 @throws ASL_SealInvalidParameter if the size of relin_keys is too small
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)exponentiate:(ASLCipherText *)encrypted
           exponent:(uint64_t)exponent
relinearizationKeys:(ASLRelinearizationKeys*)relinearizationKeys
        destination:(ASLCipherText *)destination
              error:(NSError **)error;

/*!
 Adds a ciphertext and a plaintext. The plaintext must be valid for the current
 encryption parameters.
 
 @param encrypted The ciphertext to add
 @param plain The plaintext to add
 @throws ASL_SealInvalidParameter if encrypted or plain is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if encrypted or plain is in NTT form
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)addPlainInplace:(ASLCipherText *)encrypted
                 plain:(ASLPlainText *)plain
                 error:(NSError **)error;

/*!
 Adds a ciphertext and a plaintext. This function adds a ciphertext and
 a plaintext and stores the result in the destination parameter. The plaintext
 must be valid for the current encryption parameters.
 
 @param encrypted The ciphertext to add
 @param plain The plaintext to add
 @param destination The ciphertext to overwrite with the addition result
 @throws ASL_SealInvalidParameter if encrypted or plain is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if encrypted or plain is in NTT form
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)addPlain:(ASLCipherText *)encrypted
          plain:(ASLPlainText *)plain
    destination:(ASLCipherText *)destination
          error:(NSError **)error;

/*!
 Subtracts a plaintext from a ciphertext. The plaintext must be valid for the
 current encryption parameters.
 
 @param encrypted The ciphertext to subtract from
 @param plain The plaintext to subtract
 @throws ASL_SealInvalidParameter if encrypted or plain is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if encrypted or plain is in NTT form
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)subPlainInplace:(ASLCipherText *)encrypted
                 plain:(ASLPlainText *)plain
                 error:(NSError **)error;

/*!
 Subtracts a plaintext from a ciphertext. This function subtracts a plaintext
 from a ciphertext and stores the result in the destination parameter. The
 plaintext must be valid for the current encryption parameters.
 
 @param encrypted The ciphertext to subtract from
 @param plain The plaintext to subtract
 @param destination The ciphertext to overwrite with the subtraction result
 @throws ASL_SealInvalidParameter if encrypted or plain is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if encrypted or plain is in NTT form
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)subPlain:(ASLCipherText *)encrypted
          plain:(ASLPlainText *)plain
    destination:(ASLCipherText *)destination
          error:(NSError **)error;

/*!
 Multiplies a ciphertext with a plaintext. The plaintext must be valid for the
 current encryption parameters, and cannot be identially 0. Dynamic memory
 allocations in the process are allocated from the memory pool pointed to by
 the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to multiply
 @param plain The plaintext to multiply
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if the encrypted or plain is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted and plain are in different NTT forms
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the output
 scale is too large for the encryption parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)multiplyPlainInplace:(ASLCipherText *)encrypted
                      plain:(ASLPlainText *)plain
                       pool:(ASLMemoryPoolHandle *)pool
                      error:(NSError **)error;

/*!
 Multiplies a ciphertext with a plaintext. The plaintext must be valid for the
 current encryption parameters, and cannot be identially 0. Dynamic memory
 allocations in the process are allocated from the memory pool pointed to by
 the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to multiply
 @param plain The plaintext to multiply
 @throws ASL_SealInvalidParameter if the encrypted or plain is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted and plain are in different NTT forms
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the output
 scale is too large for the encryption parameters
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)multiplyPlainInplace:(ASLCipherText *)encrypted
                      plain:(ASLPlainText *)plain
                      error:(NSError **)error;

/*!
 Multiplies a ciphertext with a plaintext. This function multiplies
 a ciphertext with a plaintext and stores the result in the destination
 parameter. The plaintext must be a valid for the current encryption parameters,
 and cannot be identially 0. Dynamic memory allocations in the process are
 allocated from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to multiply
 @param plain The plaintext to multiply
 @param destination The ciphertext to overwrite with the multiplication result
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if the encrypted or plain is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted and plain are in different NTT forms
 @throws ASL_SealInvalidParameter if plain is zero
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the output
 scale is too large for the encryption parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)multiplyPlain:(ASLCipherText *)encrypted
               plain:(ASLPlainText *)plain
         destination:(ASLCipherText *)destination
                pool:(ASLMemoryPoolHandle *)pool
               error:(NSError **)error;

/*!
 Multiplies a ciphertext with a plaintext. This function multiplies
 a ciphertext with a plaintext and stores the result in the destination
 parameter. The plaintext must be a valid for the current encryption parameters,
 and cannot be identially 0. Dynamic memory allocations in the process are
 allocated from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to multiply
 @param plain The plaintext to multiply
 @param destination The ciphertext to overwrite with the multiplication result
 @throws ASL_SealInvalidParameter if the encrypted or plain is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if encrypted and plain are in different NTT forms
 @throws ASL_SealInvalidParameter if plain is zero
 @throws ASL_SealInvalidParameter if, when using scheme_type::CKKS, the output
 scale is too large for the encryption parameters
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)multiplyPlain:(ASLCipherText *)encrypted
               plain:(ASLPlainText *)plain
         destination:(ASLCipherText *)destination
               error:(NSError **)error;

/*!
 Transforms a plaintext to NTT domain. This functions applies the Number
 Theoretic Transform to a plaintext by first embedding integers modulo the
 plaintext modulus to integers modulo the coefficient modulus and then
 performing David Harvey's NTT on the resulting polynomial. The transformation
 is done with respect to encryption parameters corresponding to a given parms_id.
 For the operation to be valid, the plaintext must have degree less than
 poly_modulus_degree and each coefficient must be less than the plaintext
 modulus, i.e., the plaintext must be a valid plaintext under the current
 encryption parameters. Dynamic memory allocations in the process are allocated
 from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param plain The plaintext to transform
 @param parametersId The parms_id with respect to which the NTT is done
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if plain is already in NTT form
 @throws ASL_SealInvalidParameter if plain or parms_id is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
-(BOOL)transformToNttInplace:(ASLPlainText *)plain
                parametersId:(ASLParametersIdType)parametersId
                        pool:(ASLMemoryPoolHandle *)pool
                       error:(NSError **)error;

/*!
 Transforms a plaintext to NTT domain. This functions applies the Number
 Theoretic Transform to a plaintext by first embedding integers modulo the
 plaintext modulus to integers modulo the coefficient modulus and then
 performing David Harvey's NTT on the resulting polynomial. The transformation
 is done with respect to encryption parameters corresponding to a given parms_id.
 For the operation to be valid, the plaintext must have degree less than
 poly_modulus_degree and each coefficient must be less than the plaintext
 modulus, i.e., the plaintext must be a valid plaintext under the current
 encryption parameters. Dynamic memory allocations in the process are allocated
 from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param plain The plaintext to transform
 @param parametersId The parms_id with respect to which the NTT is done
 @throws ASL_SealInvalidParameter if plain is already in NTT form
 @throws ASL_SealInvalidParameter if plain or parms_id is not valid for the
 encryption parameters
 */
-(BOOL)transformToNttInplace:(ASLPlainText *)plain
                parametersId:(ASLParametersIdType)parametersId
                       error:(NSError **)error;

/*!
 Transforms a plaintext to NTT domain. This functions applies the Number
 Theoretic Transform to a plaintext by first embedding integers modulo the
 plaintext modulus to integers modulo the coefficient modulus and then
 performing David Harvey's NTT on the resulting polynomial. The transformation
 is done with respect to encryption parameters corresponding to a given
 parms_id. The result is stored in the destination_ntt parameter. For the
 operation to be valid, the plaintext must have degree less than poly_modulus_degree
 and each coefficient must be less than the plaintext modulus, i.e., the plaintext
 must be a valid plaintext under the current encryption parameters. Dynamic
 memory allocations in the process are allocated from the memory pool pointed
 to by the given MemoryPoolHandle.
 
 @param plain The plaintext to transform
 @param parametersId The parms_id with respect to which the NTT is done
 @param destinationNtt The plaintext to overwrite with the transformed result
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if plain is already in NTT form
 @throws ASL_SealInvalidParameter if plain or parms_id is not valid for the
 encryption parameters
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
-(BOOL)transformToNtt:(ASLPlainText *)plain
         parametersId:(ASLParametersIdType)parametersId
       destinationNtt:(ASLPlainText *)destinationNtt
                 pool:(ASLMemoryPoolHandle *)pool
                error:(NSError **)error;

/*!
 Transforms a plaintext to NTT domain. This functions applies the Number
 Theoretic Transform to a plaintext by first embedding integers modulo the
 plaintext modulus to integers modulo the coefficient modulus and then
 performing David Harvey's NTT on the resulting polynomial. The transformation
 is done with respect to encryption parameters corresponding to a given
 parms_id. The result is stored in the destination_ntt parameter. For the
 operation to be valid, the plaintext must have degree less than poly_modulus_degree
 and each coefficient must be less than the plaintext modulus, i.e., the plaintext
 must be a valid plaintext under the current encryption parameters. Dynamic
 memory allocations in the process are allocated from the memory pool pointed
 to by the given MemoryPoolHandle.
 
 @param plain The plaintext to transform
 @param parametersId The parms_id with respect to which the NTT is done
 @param destinationNtt The plaintext to overwrite with the transformed result
 @throws ASL_SealInvalidParameter if plain is already in NTT form
 @throws ASL_SealInvalidParameter if plain or parms_id is not valid for the
 encryption parameters
 */
-(BOOL)transformToNtt:(ASLPlainText *)plain
         parametersId:(ASLParametersIdType)parametersId
       destinationNtt:(ASLPlainText *)destinationNtt
                error:(NSError **)error;

/*!
 Transforms a ciphertext to NTT domain. This functions applies David Harvey's
 Number Theoretic Transform separately to each polynomial of a ciphertext.
 
 @param encrypted The ciphertext to transform
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if encrypted is already in NTT form
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)transformToNttInplace:(ASLCipherText *)encrypted
                       error:(NSError **)error;

/*!
 Transforms a ciphertext to NTT domain. This functions applies David Harvey's
 Number Theoretic Transform separately to each polynomial of a ciphertext.
 The result is stored in the destination_ntt parameter.
 
 @param encrypted The ciphertext to transform
 @param destinationNtt The ciphertext to overwrite with the transformed result
 @throws ASL_SealInvalidParameter if encrypted is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if encrypted is already in NTT form
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)transformToNtt:(ASLCipherText *)encrypted
       destinationNtt:(ASLCipherText *)destinationNtt
                error:(NSError **)error;

/*!
 Transforms a ciphertext back from NTT domain. This functions applies the
 inverse of David Harvey's Number Theoretic Transform separately to each
 polynomial of a ciphertext.
 
 @param encryptedNtt The ciphertext to transform
 @throws ASL_SealInvalidParameter if encrypted_ntt is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if encrypted_ntt is not in NTT form
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)transformFromNttInplace:(ASLCipherText *)encryptedNtt
                         error:(NSError **)error;

/*!
 Transforms a ciphertext back from NTT domain. This functions applies the
 inverse of David Harvey's Number Theoretic Transform separately to each
 polynomial of a ciphertext. The result is stored in the destination parameter.
 
 @param encryptedNtt The ciphertext to transform
 @param destination The ciphertext to overwrite with the transformed result
 @throws ASL_SealInvalidParameter if encrypted_ntt is not valid for the encryption
 parameters
 @throws ASL_SealInvalidParameter if encrypted_ntt is not in NTT form
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)transformFromNtt:(ASLCipherText *)encryptedNtt
            destination:(ASLCipherText *)destination
                  error:(NSError **)error;

/*!
 Applies a Galois automorphism to a ciphertext. To evaluate the Galois
 automorphism, an appropriate set of Galois keys must also be provided.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle.
 
 The desired Galois automorphism is given as a Galois element, and must be
 an odd integer in the interval [1, M-1], where M = 2*N, and N = poly_modulus_degree.
 Used with batching, a Galois element 3^i % M corresponds to a cyclic row
 rotation i steps to the left, and a Galois element 3^(N/2-i) % M corresponds
 to a cyclic row rotation i steps to the right. The Galois element M-1 corresponds
 to a column rotation (row swap) in BFV, and complex conjugation in CKKS.
 In the polynomial view (not batching), a Galois automorphism by a Galois
 element p changes Enc(plain(x)) to Enc(plain(x^p)).
 
 @param encrypted The ciphertext to apply the Galois automorphism to
 @param galoisElement The Galois element
 @param galoisKey The Galois keys
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if the Galois element is not valid
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)applyGaloisInplace:(ASLCipherText *)encrypted
            galoisElement:(uint64_t)galoisElement
                galoisKey:(ASLGaloisKeys *)galoisKey
                     pool:(ASLMemoryPoolHandle *)pool
                    error:(NSError **)error;

/*!
 Applies a Galois automorphism to a ciphertext. To evaluate the Galois
 automorphism, an appropriate set of Galois keys must also be provided.
 Dynamic memory allocations in the process are allocated from the memory
 pool pointed to by the given MemoryPoolHandle.
 
 The desired Galois automorphism is given as a Galois element, and must be
 an odd integer in the interval [1, M-1], where M = 2*N, and N = poly_modulus_degree.
 Used with batching, a Galois element 3^i % M corresponds to a cyclic row
 rotation i steps to the left, and a Galois element 3^(N/2-i) % M corresponds
 to a cyclic row rotation i steps to the right. The Galois element M-1 corresponds
 to a column rotation (row swap) in BFV, and complex conjugation in CKKS.
 In the polynomial view (not batching), a Galois automorphism by a Galois
 element p changes Enc(plain(x)) to Enc(plain(x^p)).
 
 @param encrypted The ciphertext to apply the Galois automorphism to
 @param galoisElement The Galois element
 @param galoisKey The Galois keys
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if the Galois element is not valid
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)applyGaloisInplace:(ASLCipherText *)encrypted
            galoisElement:(uint64_t)galoisElement
                galoisKey:(ASLGaloisKeys *)galoisKey
                    error:(NSError **)error;

/*!
 Applies a Galois automorphism to a ciphertext and writes the result to the
 destination parameter. To evaluate the Galois automorphism, an appropriate
 set of Galois keys must also be provided. Dynamic memory allocations in
 the process are allocated from the memory pool pointed to by the given
 MemoryPoolHandle.
 
 The desired Galois automorphism is given as a Galois element, and must be
 an odd integer in the interval [1, M-1], where M = 2*N, and N = poly_modulus_degree.
 Used with batching, a Galois element 3^i % M corresponds to a cyclic row
 rotation i steps to the left, and a Galois element 3^(N/2-i) % M corresponds
 to a cyclic row rotation i steps to the right. The Galois element M-1 corresponds
 to a column rotation (row swap) in BFV, and complex conjugation in CKKS.
 In the polynomial view (not batching), a Galois automorphism by a Galois
 element p changes Enc(plain(x)) to Enc(plain(x^p)).
 
 @param encrypted The ciphertext to apply the Galois automorphism to
 @param galoisElement The Galois element
 @param galoisKey The Galois keys
 @param destination The ciphertext to overwrite with the result
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if the Galois element is not valid
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)applyGalois:(ASLCipherText *)encrypted
     galoisElement:(uint64_t)galoisElement
         galoisKey:(ASLGaloisKeys *)galoisKey
       destination:(ASLCipherText *)destination
              pool:(ASLMemoryPoolHandle *)pool
             error:(NSError **)error;

/*!
 Applies a Galois automorphism to a ciphertext and writes the result to the
 destination parameter. To evaluate the Galois automorphism, an appropriate
 set of Galois keys must also be provided. Dynamic memory allocations in
 the process are allocated from the memory pool pointed to by the given
 MemoryPoolHandle.
 
 The desired Galois automorphism is given as a Galois element, and must be
 an odd integer in the interval [1, M-1], where M = 2*N, and N = poly_modulus_degree.
 Used with batching, a Galois element 3^i % M corresponds to a cyclic row
 rotation i steps to the left, and a Galois element 3^(N/2-i) % M corresponds
 to a cyclic row rotation i steps to the right. The Galois element M-1 corresponds
 to a column rotation (row swap) in BFV, and complex conjugation in CKKS.
 In the polynomial view (not batching), a Galois automorphism by a Galois
 element p changes Enc(plain(x)) to Enc(plain(x^p)).
 
 @param encrypted The ciphertext to apply the Galois automorphism to
 @param galoisElement The Galois element
 @param galoisKey The Galois keys
 @param destination The ciphertext to overwrite with the result
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if the Galois element is not valid
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)applyGalois:(ASLCipherText *)encrypted
     galoisElement:(uint64_t)galoisElement
         galoisKey:(ASLGaloisKeys *)galoisKey
       destination:(ASLCipherText *)destination
             error:(NSError **)error;

/*!
 Rotates plaintext matrix rows cyclically. When batching is used with the
 BFV scheme, this function rotates the encrypted plaintext matrix rows
 cyclically to the left (steps > 0) or to the right (steps < 0). Since
 the size of the batched matrix is 2-by-(N/2), where N is the degree of
 the polynomial modulus, the number of steps to rotate must have absolute
 value at most N/2-1. Dynamic memory allocations in the process are allocated
 from the memory pool pointed to by the given MemoryPoolHandle.
 
 
 @param encrypted The ciphertext to rotate
 @param steps The number of steps to rotate (negative left, positive right)
 @param galoisKey The Galois keys
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealLogicError if scheme is not scheme_type::BFV
 @throws ASL_SealLogicError if the encryption parameters do not support batching
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if steps has too big absolute value
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)rotateRowsInplace:(ASLCipherText *)encrypted
                   steps:(int)steps
               galoisKey:(ASLGaloisKeys *)galoisKey
                    pool:(ASLMemoryPoolHandle *)pool
                   error:(NSError **)error;

/*!
 Rotates plaintext matrix rows cyclically. When batching is used with the
 BFV scheme, this function rotates the encrypted plaintext matrix rows
 cyclically to the left (steps > 0) or to the right (steps < 0). Since
 the size of the batched matrix is 2-by-(N/2), where N is the degree of
 the polynomial modulus, the number of steps to rotate must have absolute
 value at most N/2-1. Dynamic memory allocations in the process are allocated
 from the memory pool pointed to by the given MemoryPoolHandle.
 
 
 @param encrypted The ciphertext to rotate
 @param steps The number of steps to rotate (negative left, positive right)
 @param galoisKey The Galois keys
 @throws ASL_SealLogicError if scheme is not scheme_type::BFV
 @throws ASL_SealLogicError if the encryption parameters do not support batching
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if steps has too big absolute value
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)rotateRowsInplace:(ASLCipherText *)encrypted
                   steps:(int)steps
               galoisKey:(ASLGaloisKeys *)galoisKey
                   error:(NSError **)error;

/*!
 Rotates plaintext matrix rows cyclically. When batching is used with the
 BFV scheme, this function rotates the encrypted plaintext matrix rows
 cyclically to the left (steps > 0) or to the right (steps < 0) and writes
 the result to the destination parameter. Since the size of the batched
 matrix is 2-by-(N/2), where N is the degree of the polynomial modulus,
 the number of steps to rotate must have absolute value at most N/2-1. Dynamic
 memory allocations in the process are allocated from the memory pool pointed
 to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to rotate
 @param steps The number of steps to rotate (negative left, positive right)
 @param galoisKey The Galois keys
 @param destination The ciphertext to overwrite with the rotated result
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealLogicError if scheme is not scheme_type::BFV
 @throws ASL_SealLogicError if the encryption parameters do not support batching
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is in NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if steps has too big absolute value
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)rotateRows:(ASLCipherText *)encrypted
            steps:(int)steps
        galoisKey:(ASLGaloisKeys *)galoisKey
      destination:(ASLCipherText *)destination
             pool:(ASLMemoryPoolHandle *)pool
            error:(NSError **)error;

/*!
 Rotates plaintext matrix rows cyclically. When batching is used with the
 BFV scheme, this function rotates the encrypted plaintext matrix rows
 cyclically to the left (steps > 0) or to the right (steps < 0) and writes
 the result to the destination parameter. Since the size of the batched
 matrix is 2-by-(N/2), where N is the degree of the polynomial modulus,
 the number of steps to rotate must have absolute value at most N/2-1. Dynamic
 memory allocations in the process are allocated from the memory pool pointed
 to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to rotate
 @param steps The number of steps to rotate (negative left, positive right)
 @param galoisKey The Galois keys
 @param destination The ciphertext to overwrite with the rotated result
 @throws ASL_SealLogicError if scheme is not scheme_type::BFV
 @throws ASL_SealLogicError if the encryption parameters do not support batching
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is in NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if steps has too big absolute value
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)rotateRows:(ASLCipherText *)encrypted
            steps:(int)steps
        galoisKey:(ASLGaloisKeys *)galoisKey
      destination:(ASLCipherText *)destination
            error:(NSError **)error;

/*!
 Rotates plaintext matrix columns cyclically. When batching is used with
 the BFV scheme, this function rotates the encrypted plaintext matrix
 columns cyclically. Since the size of the batched matrix is 2-by-(N/2),
 where N is the degree of the polynomial modulus, this means simply swapping
 the two rows. Dynamic memory allocations in the process are allocated from
 the memory pool pointed to by the given MemoryPoolHandle.
 
 
 @param encrypted The ciphertext to rotate
 @param galoisKey The Galois keys
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealLogicError if scheme is not scheme_type::BFV
 @throws ASL_SealLogicError if the encryption parameters do not support batching
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is in NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)rotateColumnsInplace:(ASLCipherText *)encrypted
                  galoisKey:(ASLGaloisKeys *)galoisKey
                       pool:(ASLMemoryPoolHandle *)pool
                      error:(NSError **)error;

/*!
 Rotates plaintext matrix columns cyclically. When batching is used with
 the BFV scheme, this function rotates the encrypted plaintext matrix
 columns cyclically. Since the size of the batched matrix is 2-by-(N/2),
 where N is the degree of the polynomial modulus, this means simply swapping
 the two rows. Dynamic memory allocations in the process are allocated from
 the memory pool pointed to by the given MemoryPoolHandle.
 
 
 @param encrypted The ciphertext to rotate
 @param galoisKey The Galois keys
 @throws ASL_SealLogicError if scheme is not scheme_type::BFV
 @throws ASL_SealLogicError if the encryption parameters do not support batching
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is in NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)rotateColumnsInplace:(ASLCipherText *)encrypted
                  galoisKey:(ASLGaloisKeys *)galoisKey
                      error:(NSError **)error;

/*!
 Rotates plaintext matrix columns cyclically. When batching is used with
 the BFV scheme, this function rotates the encrypted plaintext matrix columns
 cyclically, and writes the result to the destination parameter. Since the
 size of the batched matrix is 2-by-(N/2), where N is the degree of the
 polynomial modulus, this means simply swapping the two rows. Dynamic memory
 allocations in the process are allocated from the memory pool pointed to
 by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to rotate
 @param galoisKey The Galois keys
 @param destination The ciphertext to overwrite with the rotated result
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealLogicError if scheme is not scheme_type::BFV
 @throws ASL_SealLogicError if the encryption parameters do not support batching
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is in NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)rotateColumns:(ASLCipherText *)encrypted
           galoisKey:(ASLGaloisKeys *)galoisKey
         destination:(ASLCipherText *)destination
                pool:(ASLMemoryPoolHandle *)pool
               error:(NSError **)error;

/*!
 Rotates plaintext matrix columns cyclically. When batching is used with
 the BFV scheme, this function rotates the encrypted plaintext matrix columns
 cyclically, and writes the result to the destination parameter. Since the
 size of the batched matrix is 2-by-(N/2), where N is the degree of the
 polynomial modulus, this means simply swapping the two rows. Dynamic memory
 allocations in the process are allocated from the memory pool pointed to
 by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to rotate
 @param galoisKey The Galois keys
 @param destination The ciphertext to overwrite with the rotated result
 @throws ASL_SealLogicError if scheme is not scheme_type::BFV
 @throws ASL_SealLogicError if the encryption parameters do not support batching
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is in NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)rotateColumns:(ASLCipherText *)encrypted
           galoisKey:(ASLGaloisKeys *)galoisKey
         destination:(ASLCipherText *)destination
               error:(NSError **)error;

/*!
 Rotates plaintext vector cyclically. When using the CKKS scheme, this function
 rotates the encrypted plaintext vector cyclically to the left (steps > 0)
 or to the right (steps < 0). Since the size of the batched matrix is
 2-by-(N/2), where N is the degree of the polynomial modulus, the number
 of steps to rotate must have absolute value at most N/2-1. Dynamic memory
 allocations in the process are allocated from the memory pool pointed to
 by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to rotate
 @param steps The number of steps to rotate (negative left, positive right)
 @param galoisKey The Galois keys
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealLogicError if scheme is not scheme_type::CKKS
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if steps has too big absolute value
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)rotateVectorInplace:(ASLCipherText *)encrypted
                     steps:(int)steps
                 galoisKey:(ASLGaloisKeys *)galoisKey
                      pool:(ASLMemoryPoolHandle *)pool
                     error:(NSError **)error;

/*!
 Rotates plaintext vector cyclically. When using the CKKS scheme, this function
 rotates the encrypted plaintext vector cyclically to the left (steps > 0)
 or to the right (steps < 0). Since the size of the batched matrix is
 2-by-(N/2), where N is the degree of the polynomial modulus, the number
 of steps to rotate must have absolute value at most N/2-1. Dynamic memory
 allocations in the process are allocated from the memory pool pointed to
 by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to rotate
 @param steps The number of steps to rotate (negative left, positive right)
 @param galoisKey The Galois keys
 @throws ASL_SealLogicError if scheme is not scheme_type::CKKS
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is not in the default NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if steps has too big absolute value
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)rotateVectorInplace:(ASLCipherText *)encrypted
                     steps:(int)steps
                 galoisKey:(ASLGaloisKeys *)galoisKey
                     error:(NSError **)error;

/*!
 Rotates plaintext vector cyclically. When using the CKKS scheme, this function
 rotates the encrypted plaintext vector cyclically to the left (steps > 0)
 or to the right (steps < 0) and writes the result to the destination parameter.
 Since the size of the batched matrix is 2-by-(N/2), where N is the degree
 of the polynomial modulus, the number of steps to rotate must have absolute
 value at most N/2-1. Dynamic memory allocations in the process are allocated
 from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to rotate
 @param steps The number of steps to rotate (negative left, positive right)
 @param galoisKey The Galois keys
 @param destination The ciphertext to overwrite with the rotated result
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealLogicError if scheme is not scheme_type::CKKS
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is in NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if steps has too big absolute value
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)rotateVector:(ASLCipherText *)encrypted
              steps:(int)steps
          galoisKey:(ASLGaloisKeys *)galoisKey
        destination:(ASLCipherText *)destination
               pool:(ASLMemoryPoolHandle *)pool
              error:(NSError **)error;

/*!
 Rotates plaintext vector cyclically. When using the CKKS scheme, this function
 rotates the encrypted plaintext vector cyclically to the left (steps > 0)
 or to the right (steps < 0) and writes the result to the destination parameter.
 Since the size of the batched matrix is 2-by-(N/2), where N is the degree
 of the polynomial modulus, the number of steps to rotate must have absolute
 value at most N/2-1. Dynamic memory allocations in the process are allocated
 from the memory pool pointed to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to rotate
 @param steps The number of steps to rotate (negative left, positive right)
 @param galoisKey The Galois keys
 @param destination The ciphertext to overwrite with the rotated result
 @throws ASL_SealLogicError if scheme is not scheme_type::CKKS
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is in NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if steps has too big absolute value
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)rotateVector:(ASLCipherText *)encrypted
              steps:(int)steps
          galoisKey:(ASLGaloisKeys *)galoisKey
        destination:(ASLCipherText *)destination
              error:(NSError **)error;

/*!
 Complex conjugates plaintext slot values. When using the CKKS scheme, this
 function complex conjugates all values in the underlying plaintext. Dynamic
 memory allocations in the process are allocated from the memory pool pointed
 to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to rotate
 @param galoisKey The Galois keys
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealLogicError if scheme is not scheme_type::CKKS
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is in NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)complexConjugateInplace:(ASLCipherText *)encrypted
                     galoisKey:(ASLGaloisKeys *)galoisKey
                          pool:(ASLMemoryPoolHandle *)pool
                         error:(NSError **)error;

/*!
 Complex conjugates plaintext slot values. When using the CKKS scheme, this
 function complex conjugates all values in the underlying plaintext. Dynamic
 memory allocations in the process are allocated from the memory pool pointed
 to by the given MemoryPoolHandle.
 
 @param encrypted The ciphertext to rotate
 @param galoisKey The Galois keys
 @throws ASL_SealLogicError if scheme is not scheme_type::CKKS
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is in NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(BOOL)complexConjugateInplace:(ASLCipherText *)encrypted
                     galoisKey:(ASLGaloisKeys *)galoisKey
                         error:(NSError **)error;

/*!
 Complex conjugates plaintext slot values. When using the CKKS scheme, this
 function complex conjugates all values in the underlying plaintext, and
 writes the result to the destination parameter. Dynamic memory allocations
 in the process are allocated from the memory pool pointed to by the given
 MemoryPoolHandle.
 
 @param encrypted The ciphertext to rotate
 @param galoisKey The Galois keys
 @param destination The ciphertext to overwrite with the rotated result
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealLogicError if scheme is not scheme_type::CKKS
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is in NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealInvalidParameter if pool is uninitialized
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)complexConjugate:(ASLCipherText *)encrypted
              galoisKey:(ASLGaloisKeys *)galoisKey
            destination:(ASLCipherText *)destination
                   pool:(ASLMemoryPoolHandle *)pool
                  error:(NSError **)error;

/*!
 Complex conjugates plaintext slot values. When using the CKKS scheme, this
 function complex conjugates all values in the underlying plaintext, and
 writes the result to the destination parameter. Dynamic memory allocations
 in the process are allocated from the memory pool pointed to by the given
 MemoryPoolHandle.
 
 @param encrypted The ciphertext to rotate
 @param galoisKey The Galois keys
 @param destination The ciphertext to overwrite with the rotated result
 @throws ASL_SealLogicError if scheme is not scheme_type::CKKS
 @throws ASL_SealInvalidParameter if encrypted or galois_keys is not valid for
 the encryption parameters
 @throws ASL_SealInvalidParameter if galois_keys do not correspond to the top
 level parameters in the current context
 @throws ASL_SealInvalidParameter if encrypted is in NTT form
 @throws ASL_SealInvalidParameter if encrypted has size larger than 2
 @throws ASL_SealInvalidParameter if necessary Galois keys are not present
 @throws ASL_SealLogicError if keyswitching is not supported by the context
 @throws ASL_SealLogicError if result ciphertext is transparent
 */
-(ASLCipherText * _Nullable)complexConjugate:(ASLCipherText *)encrypted
              galoisKey:(ASLGaloisKeys *)galoisKey
            destination:(ASLCipherText *)destination
                  error:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
