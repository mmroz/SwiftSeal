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
}
