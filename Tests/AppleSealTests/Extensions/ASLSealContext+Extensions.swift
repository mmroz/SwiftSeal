//
//  ASLSealContext+Extensions.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-04-23.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal

// TODO - remove this and add the objc code

extension ASLSealContext {
    
    static func bfvDefault() -> ASLSealContext {
        let parms = ASLEncryptionParameters(schemeType: .BFV)
        let polyModulusDegree = 4096
        try! parms.setPolynomialModulusDegree(polyModulusDegree)
        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        try! parms.setPlainModulus(ASLModulus(value: 1024))
        return try! ASLSealContext(parms)
    }
    
    static func ckksDefault() -> ASLSealContext  {
        let parms = ASLEncryptionParameters(schemeType: .CKKS)
        let polyModulusDegree = 8192
        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        return try! ASLSealContext(parms)
    }
    
    
    convenience init(_ encryptionParameters: ASLEncryptionParameters, expandModChain: Bool = true, securityLevel: ASLSecurityLevel = .TC128, handle: ASLMemoryPoolHandle = ASLMemoryPoolHandle(clearOnDestruction: true)) throws {
        try self.init(encrytionParameters: encryptionParameters, expandModChain: expandModChain, securityLevel: securityLevel, memoryPoolHandle: handle)
    }
}
