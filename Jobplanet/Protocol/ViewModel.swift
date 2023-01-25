//
//  ViewModel.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/25.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

extension ViewModel {
    static var identifier: String {
        return String(describing: self)
    }
}
