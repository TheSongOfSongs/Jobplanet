//
//  RecruitItems.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/20.
//

import Foundation

struct RecruitItems: Codable {
    let recruitItems: [RecruitItem]
    
    enum CodingKeys: String, CodingKey {
        case recruitItems = "recruit_items"
    }
}
