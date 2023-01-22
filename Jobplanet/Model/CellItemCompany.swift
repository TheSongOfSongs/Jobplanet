//
//  CellItemCompany.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/22.
//

import Foundation

struct CellItemCompany: CellTypeItem {
    let cellType: CellType = .company
    let logoPath: String
    let name: String
    let industryName: String
    let rateTotalAvg: Double
    let reviewSummary: String
    let interviewQuestion: String
    let salaryAvg: Double
    let updateDate: String
    
    enum CodingKeys: String, CodingKey {
        case logoPath = "logo_path"
        case name = "name"
        case industryName = "industry_name"
        case rateTotalAvg = "rate_total_avg"
        case reviewSummary = "review_summary"
        case interviewQuestion = "interview_question"
        case salaryAvg = "salary_avg"
        case updateDate = "update_date"
    }
}
