//
//  CellItemCompany.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/22.
//

import Foundation

struct CellItemCompany: CellItem {
    let cellType: CellType = .company
    let logoPath: String
    let name: String
    let industryName: String
    let rateTotalAvg: Double
    let reviewSummary: String
    let interviewQuestion: String
    let salaryAvg: Int
    private let updateDateFullVersion: String
    
    enum CodingKeys: String, CodingKey {
        case logoPath = "logo_path"
        case name = "name"
        case industryName = "industry_name"
        case rateTotalAvg = "rate_total_avg"
        case reviewSummary = "review_summary"
        case interviewQuestion = "interview_question"
        case salaryAvg = "salary_avg"
        case updateDateFullVersion = "update_date"
    }
    
    var updateDate: String {
        if updateDateFullVersion.count < 10 {
            return updateDateFullVersion
        } else {
            let index = updateDateFullVersion.index(updateDateFullVersion.startIndex, offsetBy: 10)
            return String(updateDateFullVersion[..<index])
        }
    }
}
