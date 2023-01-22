//
//  Company.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/20.
//

import Foundation

struct Company: Codable {
    let name: String
    let logoPath: String
    let ratings: [Rating]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case logoPath = "logo_path"
        case ratings = "ratings"
    }
    
    var maxRatings: Double? {
        return ratings.map { $0.rating }.max()
    }
}
