//
//  CellItemHorizontalTheme.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/22.
//

import Foundation

struct CellItemHorizontalTheme: CellItem {
    
    var cellType: CellType = .horizontalTheme
    let count: Int?
    let sectionTitle: String?
    let recommendRecruit: [RecruitItem]?
    
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case sectionTitle = "section_title"
        case recommendRecruit = "recommend_recruit"
    }
}

