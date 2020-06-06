//
//  Levels.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-04-25.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal
import XCTest

class Levels: XCTestCase {
    func testLevels() throws {
        print("Example: Levels")
        
        /*
         In this examples we describe the concept of `levels' in BFV and CKKS and the
         related objects that represent them in Microsoft SEAL.
         
         In Microsoft SEAL a set of encryption parameters (excluding the random number
         generator) is identified uniquely by a 256-bit hash of the parameters. This
         hash is called the `ParmsId' and can be easily accessed and printed at any
         time. The hash will change as soon as any of the parameters is changed.
         
         When a SEALContext is created from a given EncryptionParameters instance,
         Microsoft SEAL automatically creates a so-called `modulus switching chain',
         which is a chain of other encryption parameters derived from the original set.
         The parameters in the modulus switching chain are the same as the original
         parameters with the exception that size of the coefficient modulus is
         decreasing going down the chain. More precisely, each parameter set in the
         chain attempts to remove the last coefficient modulus prime from the
         previous set this continues until the parameter set is no longer valid
         (e.g., PlainModulus is larger than the remaining CoeffModulus). It is easy
         to walk through the chain and access all the parameter sets. Additionally,
         each parameter set in the chain has a `chain index' that indicates its
         position in the chain so that the last set has index 0. We say that a set
         of encryption parameters, or an object carrying those encryption parameters,
         is at a higher level in the chain than another set of parameters if its the
         chain index is bigger, i.e., it is earlier in the chain.
         
         Each set of parameters in the chain involves unique pre-computations performed
         when the SEALContext is created, and stored in a SEALContext.ContextData
         object. The chain is basically a linked list of SEALContext.ContextData
         objects, and can easily be accessed through the SEALContext at any time. Each
         node can be identified by the ParmsId of its specific encryption parameters
         (PolyModulusDegree remains the same but CoeffModulus varies).
         */
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        let polyModulusDegree = 8192
        try parms.setPolynomialModulusDegree(polyModulusDegree)
        
        /*
         In this example we use a custom CoeffModulus, consisting of 5 primes of
         sizes 50, 30, 30, 50, and 50 bits. Note that this is still OK according to
         the explanation in `1_BFV_Basics.cs'. Indeed,
         
         CoeffModulus.MaxBitCount(polyModulusDegree)
         
         returns 218 (greater than 50+30+30+50+50=210).
         
         Due to the modulus switching chain, the order of the 5 primes is significant.
         The last prime has a special meaning and we call it the `special prime'. Thus,
         the first parameter set in the modulus switching chain is the only one that
         involves the special prime. All key objects, such as SecretKey, are created
         at this highest level. All data objects, such as Ciphertext, can be only at
         lower levels. The special modulus should be as large as the largest of the
         other primes in the CoeffModulus, although this is not a strict requirement.
         
         special prime +---------+
         |
         v
         CoeffModulus: { 50, 30, 30, 50, 50 }  +---+  Level 4 (all keys `key level')
         |
         |
         CoeffModulus: { 50, 30, 30, 50 }  +---+  Level 3 (highest `data level')
         |
         |
         CoeffModulus: { 50, 30, 30 }  +---+  Level 2
         |
         |
         CoeffModulus: { 50, 30 }  +---+  Level 1
         |
         |
         CoeffModulus: { 50 }  +---+  Level 0 (lowest level)
         */
        try parms.setCoefficientModulus(ASLCoefficientModulus.create(polyModulusDegree, bitSizes: [50, 30, 30, 50, 50]))
        /*
         In this example the PlainModulus does not play much of a role we choose
         some reasonable value.
         */
        try parms.setPlainModulus(ASLPlainModulus.batching(polyModulusDegree, bitSize: 20))
        
        var context = try ASLSealContext(parms)
        print(context)
        
        /*
         There are convenience method for accessing the SEALContext.ContextData for
         some of the most important levels:
         
         SEALContext.KeyContextData: access to key level ContextData
         SEALContext.FirstContextData: access to highest data level ContextData
         SEALContext.LastContextData: access to lowest level ContextData
         
         We iterate over the chain and print the ParmsId for each set of parameters.
         */
        print()
        print()
        print("Print the modulus switching chain.")
        
        /*
         First print the key level parameter information.
         */
        var contextData = context.keyContextData
        print("----> Level (chain index): {\(contextData.chainIndex)} ...... KeyContextData")
        print("      ParmsId: {\(context.keyParameterIds)}")
        print("      CoeffModulus primes: ")
        contextData.encryptionParameters.coefficientModulus.forEach {
            let prime = $0 as! ASLModulus
            print(prime)
        }
        print()
        print("\\")
        print(" \\--> ")
        
        /*
         Next iterate over the remaining (data) levels.
         */
        contextData = context.firstContextData
        while (contextData != contextData)
        {
            print("Level (chain index): {\(contextData.chainIndex)}")
            if (contextData.parametersId == context.firstParameterIds) {
                print(" ...... FirstContextData")
            } else
            {
                print()
            }
            print("      ParmsId: {\(contextData.parametersId)}")
            print("      CoeffModulus primes: ")
            contextData.encryptionParameters.coefficientModulus.forEach {
                print(($0 as! ASLModulus).uint64Value)
            }
            print()
            print("\\")
            print(" \\--> ")
            
            /*
             Step forward in the chain.
             */
            if contextData.isLastContextData {
                break
            } else {
                contextData = contextData.next
            }
        }
        print("End of chain reached")
        print()
        
        /*
         We create some keys and check that indeed they appear at the highest level.
         */
        let keygen = try ASLKeyGenerator(context: context)
        let publicKey = keygen.publicKey
        let secretKey = keygen.secretKey
        let relinKeys = try keygen.relinearizationKeysLocal()
        let galoisKeys = try keygen.galoisKeysLocal()
        print()
        print("Print the parameter IDs of generated elements.")
        print("    + publicKey:  {\(publicKey.parametersId)")
        print("    + secretKey:  {\(secretKey.parametersId)}")
        print("    + relinKeys:  \(relinKeys.parametersId)}")
        print("    + galoisKeys: {\(galoisKeys.parametersId)}")
        
        let encryptor = try ASLEncryptor(context: context, publicKey: publicKey)
        let evaluator = try ASLEvaluator(context)
        let decryptor = try ASLDecryptor(context: context, secretKey: secretKey)
        
        /*
         In the BFV scheme plaintexts do not carry a ParmsId, but ciphertexts do. Note
         how the freshly encrypted ciphertext is at the highest data level.
         */
        var plain = try ASLPlainText(polynomialString: "1x^3 + 2x^2 + 3x^1 + 4")
        
        var encrypted = try encryptor.encrypt(with: plain, destination: ASLCipherText())
        print("    + plain:      {\(plain.parametersId)} (not set in BFV)")
        print("    + encrypted:  {\(encrypted.parametersId)}")
        print()
        
        /*
         `Modulus switching' is a technique of changing the ciphertext parameters down
         in the chain. The function Evaluator.ModSwitchToNext always switches to the
         next level down the chain, whereas Evaluator.ModSwitchTo switches to a parameter
         set down the chain corresponding to a given ParmsId. However, it is impossible
         to switch up in the chain.
         */
        print()
        print("Perform modulus switching on encrypted and print.")
        contextData = context.firstContextData
        print("---->)")
        
        while !contextData.isLastContextData
        {
            print("Level (chain index): {\(contextData.chainIndex)}")
            print("      ParmsId of encrypted: {\(contextData.parametersId)}")
            print("      Noise budget at this level: {\(try decryptor.invariantNoiseBudget(encrypted))} bits")
            print("\\")
            print(" \\--> ")
            encrypted = try evaluator.modSwitch(toNextInplace: encrypted)
            contextData = contextData.next
        }
        print("Level (chain index): {\(contextData.chainIndex)}")
        print("      ParmsId of encrypted: {\(contextData.parametersId)}")
        print("      Noise budget at this level: {\(try decryptor.invariantNoiseBudget(encrypted))} bits")
        print("\\")
        print(" \\--> ")
        print("End of chain reached")
        print()
        
        /*
         At this point it is hard to see any benefit in doing this: we lost a huge
         amount of noise budget (i.e., computational power) at each switch and seemed
         to get nothing in return. Decryption still works.
         */
        print()
        print("Decrypt still works after modulus switching.")
        plain = try decryptor.decrypt(encrypted, destination: plain)
        print("    + Decryption of encrypted: {\(plain)} ...... Correct.")
        print()
        
        /*
         However, there is a hidden benefit: the size of the ciphertext depends
         linearly on the number of primes in the coefficient modulus. Thus, if there
         is no need or intention to perform any further computations on a given
         ciphertext, we might as well switch it down to the smallest (last) set of
         parameters in the chain before sending it back to the secret key holder for
         decryption.
         
         Also the lost noise budget is actually not an issue at all, if we do things
         right, as we will see below.
         
         First we recreate the original ciphertext and perform some computations.
         */
        print("Computation is more efficient with modulus switching.")
        print()
        print("Compute the eight power.")
        encrypted = try encryptor.encrypt(with: plain, destination: encrypted)
        print("    + Noise budget fresh:                  {\(try decryptor.invariantNoiseBudget(encrypted))} bits")
        encrypted = try evaluator.squareInplace(encrypted)
        encrypted = try evaluator.relinearizeInplace(encrypted, relinearizationKeys: relinKeys)
        print("    + Noise budget of the 2nd power:        {\(try decryptor.invariantNoiseBudget(encrypted))} bits")
        encrypted = try evaluator.squareInplace(encrypted)
        encrypted = try evaluator.relinearizeInplace(encrypted, relinearizationKeys: relinKeys)
        print("    + Noise budget of the 4th power:        {\(try decryptor.invariantNoiseBudget(encrypted))} bits")
        /*
         Surprisingly, in this case modulus switching has no effect at all on the
         noise budget.
         */
        encrypted = try evaluator.modSwitch(toNextInplace: encrypted)
        print("    + Noise budget after modulus switching: {\(try decryptor.invariantNoiseBudget(encrypted))} bits")
        
        
        /*
         This means that there is no harm at all in dropping some of the coefficient
         modulus after doing enough computations. In some cases one might want to
         switch to a lower level slightly earlier, actually sacrificing some of the
         noise budget in the process, to gain computational performance from having
         smaller parameters. We see from the print-out that the next modulus switch
         should be done ideally when the noise budget is down to around 25 bits.
         */
        encrypted = try evaluator.squareInplace(encrypted)
        encrypted = try evaluator.relinearizeInplace(encrypted, relinearizationKeys: relinKeys)
        print("    + Noise budget of the 8th power:        {\(try decryptor.invariantNoiseBudget(encrypted))} bits")
        encrypted = try evaluator.modSwitch(toNextInplace: encrypted)
        print("    + Noise budget after modulus switching: {\(try decryptor.invariantNoiseBudget(encrypted))} bits")
        
        /*
         At this point the ciphertext still decrypts correctly, has very small size,
         and the computation was as efficient as possible. Note that the decryptor
         can be used to decrypt a ciphertext at any level in the modulus switching
         chain.
         */
        plain = try decryptor.decrypt(encrypted, destination: plain)
        print("    + Decryption of the 8th power (hexadecimal) ...... Correct.")
        print("    {\(plain)}")
        print()
        
        /*
         In BFV modulus switching is not necessary and in some cases the user might
         not want to create the modulus switching chain, except for the highest two
         levels. This can be done by passing a bool `false' to SEALContext constructor.
         */
        context = try ASLSealContext(parms, expandModChain: false)
        
        /*
         We can check that indeed the modulus switching chain has been created only
         for the highest two levels (key level and highest data level). The following
         loop should execute only once.
         */
        print("Optionally disable modulus switching chain expansion.")
        print()
        print("Print the modulus switching chain.")
        print("----> ")
        var cursor: ASLSealContextData? = contextData.next
        
        while cursor != nil {
            
            print("Level (chain index): \(contextData.chainIndex)}")
            print("      ParmsId of encrypted: {\(contextData.parametersId)}")
            print("      CoeffModulus primes: ")
            contextData.encryptionParameters.coefficientModulus.forEach {
                print($0)
            }
            print()
            print("\\")
            print(" \\--> ")
            
            cursor = cursor?.next
            break
        }
        print("End of chain reached")
        print()
        
        /*
         It is very important to understand how this example works since in the CKKS
         scheme modulus switching has a much more fundamental purpose and the next
         examples will be difficult to understand unless these basic properties are
         totally clear.
         */
    }
}
