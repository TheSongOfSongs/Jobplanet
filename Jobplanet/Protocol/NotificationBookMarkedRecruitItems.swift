//
//  NotificationBookMarkedRecruitItems.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/25.
//

import UIKit

protocol NotificationBookMarkedRecruitItems: NotificationUserInfoForViewModel {
    func updateBookMarkedRecruitIds(notification: Notification)
}
