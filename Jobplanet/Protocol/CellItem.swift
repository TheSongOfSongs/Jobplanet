//
//  CellItem.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/22.
//

import Foundation

/// 기업 정보 API의 객체를 담기 위한 프로토콜
/// 이를 채택하고 있는 각각 다른 타입의 아이템을 배열에 담기 위함
protocol CellItem: Codable {
    var cellType: CellType { get }
}
