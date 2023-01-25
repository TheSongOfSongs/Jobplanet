//
//  NotificationViewModel.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/25.
//

import Foundation

/// 뷰모델에서 Notification을 사용할 때, userInfo로 보내는 딕셔너리 객체를 위한 프로토콜
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
