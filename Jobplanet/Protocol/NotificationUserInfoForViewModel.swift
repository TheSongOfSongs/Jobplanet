//
//  NotificationViewModel.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/25.
//

import Foundation

protocol NotificationUserInfoForViewModel where Self: ViewModel {
    var identifierKey: String { get }
    var identifier: String { get }
    
    func setObserver()
    func removeObserver()
}

extension NotificationUserInfoForViewModel {
    var identifierKey: String {
        return "identifier"
    }
    
    var identifier: String {
        return Self.identifier
    }
}
