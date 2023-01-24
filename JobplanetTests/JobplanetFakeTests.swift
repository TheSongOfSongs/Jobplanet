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
