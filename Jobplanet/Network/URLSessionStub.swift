//
//  URLSessionStub.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/20.
//

import Foundation

typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

class URLSessionStub: URLSessionProtocol {
    
    typealias Response = (stubbedData: Data?, stubbedResponse: URLResponse?, stubbedError: Error?)
    
    private let stubbedData: Data?
    private let stubbedResponse: URLResponse?
    private let stubbedError: Error?
    
    public init(response: Response) {
        self.stubbedData = response.stubbedData
        self.stubbedResponse = response.stubbedResponse
        self.stubbedError = response.stubbedError
    }
    
    public func dataTask(with url: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTaskProtocol {
        return URLSessionDataTaskStub(stubbedData: stubbedData,
                                      stubbedResponse: stubbedResponse,
                                      stubbedError: stubbedError,
                                      completionHandler: completionHandler)
    }
    
    static func make(data: Data?, response: URLResponse?, error: Error? = nil) -> URLSessionStub {
        let urlSessionStub: URLSessionStub = {
            let urlSessionStubResponse: URLSessionStub.Response = (stubbedData: data,
                                                                   stubbedResponse: response,
                                                                   stubbedError: error)
            
            return URLSessionStub(response: urlSessionStubResponse)
        }()
        return urlSessionStub
    }
}

class URLSessionDataTaskStub: URLSessionDataTaskProtocol {
    private let stubbedData: Data?
    private let stubbedResponse: URLResponse?
    private let stubbedError: Error?
    private let completionHandler: DataTaskCompletionHandler?
    
    init(configuration: URLSessionConfiguration = .default,
         stubbedData: Data?,
         stubbedResponse: URLResponse?,
         stubbedError: Error?,
         completionHandler: DataTaskCompletionHandler?) {
        self.stubbedData = stubbedData
        self.stubbedResponse = stubbedResponse
        self.stubbedError = stubbedError
        self.completionHandler = completionHandler
    }
    
    func resume() {
        completionHandler?(stubbedData, stubbedResponse, stubbedError)
    }
}
