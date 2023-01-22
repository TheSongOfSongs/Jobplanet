//
//  CellItemReview.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/22.
//

import Foundation

struct CellItemReview: CellTypeItem {
    let cellType: CellType = .review
    let logoPath: String
    let name: String
    let industyrName: String
    let rateTotalAvg: Double
    let reviewSummary: String
    let cons: String
    let pros: String
    let updateDate: String
    
    enum CodingKeys: String, CodingKey {
        case logoPath = "logo_path"
        case name = "name"
        case industyrName = "industry_name"
        case rateTotalAvg = "rate_total_avg"
        case reviewSummary = "review_summary"
        case cons = "cons"
        case pros = "pros"
        case updateDate = "update_date"
    }
}
