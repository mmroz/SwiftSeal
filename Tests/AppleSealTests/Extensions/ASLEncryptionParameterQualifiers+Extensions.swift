//
//  ASLEncryptionParameterQualifiers+Extensions.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-04-23.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal

extension ASLEncryptionParameterQualifiers: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return ASLEncryptionParameterQualifiersIsEqual(lhs, rhs)
    }
    
    var aslSecurityLevel: ASLSecurityLevel {
        return ASLSecurityLevel(rawValue: Int(securityLevel))!
    }
    
    init(isParametersSet: Bool, isUsingFFT: Bool, isUsingNNT: Bool, isUsingBatching: Bool, isUsingFastPlainLift: Bool, isUsingDescendingModulusChain: Bool, securityLevel: ASLSecurityLevel) {
        self.init()
        self.isParametersSet = isParametersSet
        self.isUsingFFT = isUsingFFT
        self.isUsingNNT = isUsingNNT
        self.isUsingBatching = isUsingBatching
        self.isUsingDescendingModulusChain = isUsingDescendingModulusChain
        self.securityLevel = Int32(securityLevel.rawValue)
    }
}
