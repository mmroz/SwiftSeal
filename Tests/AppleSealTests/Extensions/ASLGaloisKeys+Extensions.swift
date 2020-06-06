//
//  ASLGaloisKeys+Extensions.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-04-23.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal

extension ASLGaloisKeys {
    func hasKey(_ galoisElement: NSNumber) throws -> Bool {
        return try Bool(truncating: hasKey(galoisElement))
    }
}
