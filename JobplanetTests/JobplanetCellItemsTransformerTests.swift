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

    func test_Data를_JSONObject배열로_변환() throws {
        let testBundle = Bundle(for: type(of: self))
        let filePath = testBundle.path(forResource: "MockData1_cell", ofType: "json")!
        let fileURL = URL(fileURLWithPath: filePath)
        let data = try Data(contentsOf: fileURL)
        let result = try transformer.transformDataToJSONObjects(data)
        
        switch result {
        case .success(let items):
            XCTAssertEqual(items.count, 14)
            XCTAssertEqual(items.first!["cell_type"] as! String, "CELL_TYPE_COMPANY")
            XCTAssertEqual(items.first!["salary_avg"] as! Int, 3483)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_JSONObject배열을_CellTypeItem으로_변환() throws {
        let jsonObjects: [JSONObject] = mockData1_cell_JSONObjects
        let result = try transformer.transformJSONObjectsToCellItems(jsonObjects)
        let cellItemReview = result.filter({ $0 is CellReviewItem })
        let cellItemHorizontalThemes = result.filter({ $0 is CellHorizontalThemeItem })
        
        XCTAssertEqual(result.count, 14)
        XCTAssertEqual(cellItemHorizontalThemes.count, 2)
        XCTAssertEqual(cellItemReview.count, 3)
        XCTAssertEqual((result.first as! CellCompanyItem).salaryAvg, 3483)
    }
    
    func test_JSONObjects배열에서_CellItemReview배열로_변환_후_회사명으로_필터링() throws {
        let jsonObjects: [JSONObject] = mockData1_cell_JSONObjects
        let result = try transformer.transformJSONObjectsToCellItemReviews(jsonObjects, with: "퀄컴씨디엠에이테크날러지코리아")
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result.first!.rateTotalAvg, 4.25)
        XCTAssertEqual(result.last!.updateDate, "2021-12-21T19:02:11.000+09:00")
    }
}
