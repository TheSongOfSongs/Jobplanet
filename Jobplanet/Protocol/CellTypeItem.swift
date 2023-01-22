//
//  CellTypeItem.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/22.
//

import Foundation

protocol CellTypeItem: Codable {
    var cellType: CellType { get }
}
