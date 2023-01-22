//
//  RecommendRecruit.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/20.
//

import Foundation

struct RecommendRecruit: Codable {
    let id: Int
    let title: String
    let reward: Int
    let appeal: String
    let imageURLString: String
    let company: Company
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case reward = "reward"
        case appeal = "appeal"
        case imageURLString = "image_url"
        case company = "company"
    }
}
