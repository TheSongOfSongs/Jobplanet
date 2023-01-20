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

    ///  채용 정보 가져오는 API가 제대로 작동하는지  확인하는 테스트
    func testRecruitAPI() throws {
        try testAPI(typeOf: .recruit)
    }
    
    ///  회사  정보 가져오는 API가 제대로 작동하는지  확인하는 테스트
    func testCompanyAPI() throws {
        try testAPI(typeOf: .cell)
    }
    
    func testAPI(typeOf list: List) throws {
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
