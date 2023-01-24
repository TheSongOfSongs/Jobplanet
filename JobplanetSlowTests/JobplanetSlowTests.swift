//
//  JobplanetSlowTests.swift
//  JobplanetTests
//
//  Created by Jinhyang Kim on 2023/01/20.
//

import XCTest
@testable import Jobplanet

/// 비동기로 실행되는 함수에 관한 테스트
final class JobplanetSlowTests: XCTestCase {
    
    var urlSession: URLSession!

    override func setUpWithError() throws {
        try super.setUpWithError()
        urlSession = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        urlSession = nil
        try super.tearDownWithError()
    }

    func test_채용API가_제대로_동작하는지() throws {
        try test_List타입에_따라_API가_제대로_동작하는지(typeOf: .recruit)
    }
    
    func test_기업API가_제대로_동작하는지() throws {
        try test_List타입에_따라_API가_제대로_동작하는지(typeOf: .cell)
    }
    
    func test_List타입에_따라_API가_제대로_동작하는지(typeOf list: List) throws {
        // given
        let url = NetworkService.urlBuilder(of: list).url!
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = urlSession.dataTask(with: url) { _, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 3)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
}
