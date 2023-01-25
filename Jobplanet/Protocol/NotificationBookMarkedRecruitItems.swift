//
//  NotificationBookMarkedRecruitItems.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/25.
//

import UIKit

protocol NotificationBookMarkedRecruitItems: NotificationUserInfoForViewModel {
    /// notification을 통하여 북마크 저장/삭제 이벤트가 발생했을 때 호출되는 메서드
    /// 자신의 뷰모델에서 방송된 이벤트에 대해서는 스킵
    func updateBookMarkedRecruitIds(notification: Notification)
}
