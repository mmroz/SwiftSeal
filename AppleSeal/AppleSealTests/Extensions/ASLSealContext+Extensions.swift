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
    convenience init(_ encryptionParameters: ASLEncryptionParameters, expandModChain: Bool = true, securityLevel: ASLSecurityLevel = .TC128, handle: ASLMemoryPoolHandle = ASLMemoryPoolHandle(clearOnDestruction: true)) throws {
        try self.init(encrytionParameters: encryptionParameters, expandModChain: expandModChain, securityLevel: securityLevel, memoryPoolHandle: handle)
    }
    
    static let bfvDefault: ASLSealContext = {
       let parms = ASLEncryptionParameters(schemeType: .BFV)
        
        let polyModulusDegree = 4096
        try! parms.setPolynomialModulusDegree(polyModulusDegree)
        
        try! parms.setCoefficientModulus(ASLCoefficientModulus.bfvDefault(polyModulusDegree))
        
        try! parms.setPlainModulus(ASLSmallModulus(value: 1024))
        
        return try! ASLSealContext(parms)
    }()
}
