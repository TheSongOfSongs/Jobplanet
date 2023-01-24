//
//  JobplanetFakeTests.swift
//  JobplanetTests
//
//  Created by Jinhyang Kim on 2023/01/20.
//

import XCTest
@testable import Jobplanet

final class JobplanetFakeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func test_채용Data를_RecruitItem배열로_변환() async throws {
        // 문서로 저장된 MockData 가져오기
        let testBundle = Bundle(for: type(of: self))
        let filePath = testBundle.path(forResource: "MockData1_recruit", ofType: "json")!
        let fileURL = URL(fileURLWithPath: filePath)
        let data = try Data(contentsOf: fileURL)
        
        // Mock URLSession 만들기
        let urlSessionStub: URLSessionStub = {
            let url = NetworkService.urlBuilder(of: .recruit).url!
            let response = HTTPURLResponse(url: url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)

            return URLSessionStub.make(data: data,
                                       response: response)
        }()
        
        let networkService = NetworkService(session: urlSessionStub)
        
        var result: [RecruitItem]?
        if case let .success(items) = try await networkService.recruitItems() {
            result = items
        }
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.count, 9)
        XCTAssertEqual(result!.first!.title, "[잡플래닛] iOS 앱개발")
    }
}
