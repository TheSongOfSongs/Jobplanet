//
//  NetworkService.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/20.
//

import Foundation

final class NetworkService {
    
    typealias JSONObject = [String: Any]
    
    var session: URLSessionProtocol
    
    private let decoder = JSONDecoder()
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func recruitItems() async throws -> Result<[RecruitItem], APIServiceError> {
        let result = try await data(of: .recruit)
        
        switch result {
        case .success(let data):
            do {
                let recruitItems = try decoder.decode(RecruitItems.self, from: data).recruitItems
                return .success(recruitItems)
            } catch {
                return .failure(.failedDecoding)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func cellItems() async throws -> Result<[JSONObject], APIServiceError> {
        let result = try await data(of: .cell)
        
        switch result {
        case .success(let data):
            guard let dict = try JSONSerialization.jsonObject(with: data) as? JSONObject,
                  let cellItems = dict["cell_items"] as? [JSONObject] else {
                return .failure(.failedDecoding)
            }
            
            return .success(cellItems)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    static func urlBuilder(of list: List) -> URLComponents {
        let path: String = {
            let lastPath: String = {
                switch list {
                case .recruit:
                    return "/test_data_recruit_items.json"
                case .cell:
                    return "/test_data_cell_items.json"
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


extension NetworkService {
    private func data(of list: List) async throws -> Result<Data, APIServiceError> {
        let urlComponents = NetworkService.urlBuilder(of: list)
        
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
}