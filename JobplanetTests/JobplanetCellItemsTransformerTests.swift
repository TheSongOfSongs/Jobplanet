//
//  JobplanetCellItemsTransformerTests.swift
//  JobplanetTests
//
//  Created by Jinhyang Kim on 2023/01/22.
//

import XCTest
@testable import Jobplanet

final class JobplanetCellItemsTransformerTests: XCTestCase {
    
    var transformer: CellItemsTransformer!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        transformer = CellItemsTransformer()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        transformer = nil
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func test_transformDataToArrayOfJSONObject() throws {
        // given
        let testBundle = Bundle(for: type(of: self))
        let filePath = testBundle.path(forResource: "MockData1_cell", ofType: "json")!
        let fileURL = URL(fileURLWithPath: filePath)
        let data = try Data(contentsOf: fileURL)
        
        // when
        let result = try transformer.transformDataToArrayOfJSONObject(data)
        
        // then
        switch result {
        case .success(let items):
            XCTAssertEqual(items.count, 14)
            XCTAssertEqual(items.first!["cell_type"] as! String, "CELL_TYPE_COMPANY")
            XCTAssertEqual(items.first!["salary_avg"] as! Int, 3483)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
}
