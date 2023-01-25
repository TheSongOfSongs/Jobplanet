//
//  RecruitItem.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/20.
//

import Foundation

struct RecruitItem: Codable {
    let id: Int
    let title: String
    let reward: Int
    let appeal: String
    let imageURLString: String
    let company: Company
    
    /// 채용 아이템 북마크 여부로 채용정보API에는 존재하지 않는 프로퍼티
    var isBookMarked = false
    
    var appeals: [String] {
        return appeal
            .components(separatedBy: ", ")
            .map({ String($0) })
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case reward = "reward"
        case appeal = "appeal"
        case imageURLString = "image_url"
        case company = "company"
    }
    
    mutating func updateIsBookMarked(_ isBookMarked: Bool) {
        self.isBookMarked = isBookMarked
    }
}
