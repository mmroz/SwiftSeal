//
//  ASLSealContext.h
//  AppleSeal
//
//  Created by Mark Mroz on 2019-12-29.
//  Copyright © 2019 Mark Mroz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AppleSeal/ASLEncryptionParameters.h>
#import <AppleSeal/ASLParametersIdType.h>
#import <AppleSeal/ASLSealContextData.h>
#import <AppleSeal/ASLMemoryPoolHandle.h>

/*!
 Represents a standard security level according to the HomomorphicEncryption.org
 security standard. The value sec_level_type::none signals that no standard
 security level should be imposed. The value sec_level_type::tc128 provides
 a very high level of security and is the default security level enforced by
 Microsoft SEAL when constructing a SEALContext object. Normal users should not
 have to specify the security level explicitly anywhere.
 */

typedef NS_CLOSED_ENUM(NSInteger, ASLSecurityLevel) {
    /*!
     No security level specified.
     */
    None = 0,
    /*!
     128-bit security level according to HomomorphicEncryption.org standard.
     */
    TC128,
    /*!
     192-bit security level according to HomomorphicEncryption.org standard.
     */
    TC192,
    /*!
     256-bit security level according to HomomorphicEncryption.org standard.
     */
    TC256,
};

NS_ASSUME_NONNULL_BEGIN

/*!
 
 @class ASLSealContext
 
 @brief The ASLSealContext class and wrapper for the seal::SEALContext
 
 @discussion Class to store ASLSealContext.
 
 Performs sanity checks (validation) and pre-computations for a given set of encryption
 parameters. While the EncryptionParameters class is intended to be a light-weight class
 to store the encryption parameters, the SEALContext class is a heavy-weight class that
 is constructed from a given set of encryption parameters. It validates the parameters
 for correctness, evaluates their properties, and performs and stores the results of
 several costly pre-computations.
 
 After the user has set at least the poly_modulus, coeff_modulus, and plain_modulus
 parameters in a given EncryptionParameters instance, the parameters can be validated
 for correctness and functionality by constructing an instance of SEALContext. The
 constructor of SEALContext does all of its work automatically, and concludes by
 constructing and storing an instance of the EncryptionParameterQualifiers class, with
 its flags set according to the properties of the given parameters. If the created
 instance of EncryptionParameterQualifiers has the parameters_set flag set to true, the
 given parameter set has been deemed valid and is ready to be used. If the parameters
 were for some reason not appropriately set, the parameters_set flag will be false,
 and a new SEALContext will have to be created after the parameters are corrected.
 
 By default, SEALContext creates a chain of SEALContext::ContextData instances. The
 first one in the chain corresponds to special encryption parameters that are reserved
 to be used by the various key classes (SecretKey, PublicKey, etc.). These are the exact
 same encryption parameters that are created by the user and passed to th constructor of
 SEALContext. The functions key_context_data() and key_parms_id() return the ContextData
 and the parms_id corresponding to these special parameters. The rest of the ContextData
 instances in the chain correspond to encryption parameters that are derived from the
 first encryption parameters by always removing the last one of the moduli in the
 coeff_modulus, until the resulting parameters are no longer valid, e.g., there are no
 more primes left. These derived encryption parameters are used by ciphertexts and
 plaintexts and their respective ContextData can be accessed through the
 get_context_data(parms_id_type) function. The functions first_context_data() and
 last_context_data() return the ContextData corresponding to the first and the last
 set of parameters in the "data" part of the chain, i.e., the second and the last element
 in the full chain. The chain itself is a doubly linked list, and is referred to as the
 modulus switching chain.
 
 @see EncryptionParameters for more details on the parameters.
 @see EncryptionParameterQualifiers for more details on the qualifiers.
 */
@interface ASLSealContext : NSObject

/*!
 Creates an instance of SEALContext, and performs several pre-computations
 on the given EncryptionParameters.
 
 @param encrytionParameters The encryption parameters
 @param expandModChain Determines whether the modulus switching chain
 should be created
 @param securityLevel Determines whether a specific security level should be
 enforced according to HomomorphicEncryption.org security standard
 @param pool The MemoryPoolHandle pointing to a valid memory pool
 @throws ASL_SealInvalidParameter if pool is uninitialized
 */
+ (instancetype _Nullable)sealContextWithEncrytionParameters:(ASLEncryptionParameters *)encrytionParameters
                                              expandModChain:(BOOL)expandModChain
                                               securityLevel:(ASLSecurityLevel)securityLevel
                                            memoryPoolHandle:(ASLMemoryPoolHandle*)pool
                                                       error:(NSError **)error;

/*!
 Returns the ContextData corresponding to encryption parameters that are
 used for keys.
 */

@property (nonatomic, assign, readonly) ASLSealContextData* keyContextData;

/*!
 Returns the ContextData corresponding to the first encryption parameters
 that are used for data.
 */
@property (nonatomic, assign, readonly) ASLSealContextData* firstContextData;

/*!
 Returns the ContextData corresponding to the last encryption parameters
 that are used for data.
 */
@property (nonatomic, assign, readonly) ASLSealContextData* lastContextData;

/*!
 Returns a parms_id_type corresponding to the set of encryption parameters
 that are used for keys.
 */
@property (nonatomic, assign, readonly) ASLParametersIdType keyParameterIds;

/*!
 Returns a parms_id_type corresponding to the first encryption parameters
 that are used for data.
 */
@property (nonatomic, assign, readonly) ASLParametersIdType firstParameterIds;

/*!
 Returns a parms_id_type corresponding to the last encryption parameters
 that are used for data.
 */
@property (nonatomic, assign, readonly) ASLParametersIdType lastParameterIds;

/*!
 Returns whether the encryption parameters are valid.
 */
@property (nonatomic, readonly, assign, getter=isValidEncrytionParameters) BOOL validEncrytionParameters;

/*!
 Returns whether the coefficient modulus supports keyswitching. In practice,
 support for keyswitching is required by Evaluator::relinearize,
 Evaluator::apply_galois, and all rotation and conjugation operations. For
 keyswitching to be available, the coefficient modulus parameter must consist
 of at least two prime number factors.
 */
@property (nonatomic, readonly, assign, getter=isAllowedKeySwitching) BOOL allowedKeySwitching;

/*!
 Returns the ContextData corresponding to encryption parameters with a given
 parms_id. If parameters with the given parms_id are not found then the
 function returns nullptr.
 
 @param parametersId The ASLParametersIdType of the encryption parameters
 */
- (ASLSealContextData *)contextData:(ASLParametersIdType)parametersId
                              error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
