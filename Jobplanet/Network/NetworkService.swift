//
//  NetworkService.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/20.
//

import Foundation

/// API 통신을 담당하는 클래스
final class NetworkService {
    
    var session: URLSessionProtocol
    
    private let decoder = JSONDecoder()
    private let networkConnectionManager = NetworkConnectionManager.shared
    
    /// 현재 실행되는 네트워킹 테스크를 담는 프로퍼티
    /// 이후 task를 취소하기 위해 사용됨
    var currentTask: Task<(Data, URLResponse), Error>?
    
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
    
    func cellItems() async throws -> Result<Data, APIServiceError> {
        return try await data(of: .cell)
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
        currentTask?.cancel()
        
        guard networkConnectionManager.isReachable else {
            return .failure(.disconnectedNetwork)
        }
        
        guard let url = NetworkService.urlBuilder(of: list).url else {
            return .failure(.invalidURL)
        }
        
        currentTask = Task { () -> (Data, URLResponse) in
            return try await URLSession.shared.data(from: url)
        }
        
        do {
            guard let currentTask = currentTask else {
                return .failure(.failedRequest)
            }
            
            let (data, response) = try await currentTask.value
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            guard response.statusCode == 200 else {
                return .failure(.failedRequest)
            }
            
            guard !currentTask.isCancelled else {
                return .failure(.cancelled)
            }
            
            return .success(data)
        } catch let error {
            if error.errorCode == NSURLErrorCancelled {
                return .failure(.cancelled)
            }
            
            return .failure(error as? APIServiceError ?? .unknown)
        }
    }
}
