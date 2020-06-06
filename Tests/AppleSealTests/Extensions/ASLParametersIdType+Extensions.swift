//
//  ASLParametersIdType+Extensions.swift
//  AppleSealTests
//
//  Created by Mark Mroz on 2020-04-23.
//  Copyright © 2020 Mark Mroz. All rights reserved.
//

import AppleSeal

extension ASLParametersIdType: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return ASLParametersIdTypeIsEqual(lhs, rhs)
    }
}
