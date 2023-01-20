//
//  NetworkService.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/20.
//

import Foundation

final class NetworkService {
    
    func itemsLists(_ type: List) async throws -> Result<Data, APIServiceError> {
        let urlComponents = urlBuilder(of: type)
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            return .failure(.invalidResponse)
        }
        
        guard response.statusCode == 200 else {
            return .failure(.failedRequest)
        }
        
        return .success(data)
    }
    
    private func urlBuilder(of list: List) -> URLComponents {
        let path: String = {
            let lastPath: String = {
                switch list {
                case .recruit:
                    return "/test_data_recruit_items.json"
                case .company:
                    return "/test_data_recruit_items.json"
                }
            }()
            
            return "/mobile-config" + lastPath
        }()
        
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = "jpassets.jobplanet.co.kr"
        urlBuilder.path = path
        
        return urlBuilder
    }
}
