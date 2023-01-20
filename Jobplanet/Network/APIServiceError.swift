//
//  APIServiceError.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/20.
//

import Foundation

enum APIServiceError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
    case invalidURL
    case unknown
    
    var description: String {
        switch self {
        case .noData:
            return "데이터가 존재하지 않습니다"
        case .failedRequest:
            return "네트워크 연결을 확인해주세요"
        case .invalidData:
            return "데이터가 유효하지 않습니다"
        case .invalidResponse, .invalidURL, .unknown:
            return "관리자에게 문의해주세요"
        }
    }
}
