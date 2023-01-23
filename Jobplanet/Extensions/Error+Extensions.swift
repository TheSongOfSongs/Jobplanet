//
//  Error+Extensions.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/23.
//

import Foundation

extension Error {
    var errorCode: Int {
        return (self as NSError).code
    }
}
