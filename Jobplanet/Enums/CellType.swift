//
//  Cell.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/22.
//

import Foundation

enum CellType: Codable {
    case company
    case horizontalTheme
    case review
    
    var dictionaryKey: String {
        switch self {
        case .company:
            return "CELL_TYPE_COMPANY"
        case .horizontalTheme:
            return "CELL_TYPE_HORIZONTAL_THEME"
        case .review:
            return "CELL_TYPE_REVIEW"
        }
    }
}
