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
    
    
    func testTransformArrayOfJSONObjectOfCellTypeItem() throws {
        // given
        let jsonObjects: [JSONObject] = mockData1_cell_JSONObjects
        
        // when
        let result = try transformer.transformArrayOfJSONObjectToArrayOfCellItem(jsonObjects)
        
        // then
        let cellItemReview = result.filter({ $0 is CellReviewItem })
        let cellItemHorizontalThemes = result.filter({ $0 is CellHorizontalThemeItem })
        
        XCTAssertEqual(result.count, 14)
        XCTAssertEqual(cellItemHorizontalThemes.count, 2)
        XCTAssertEqual(cellItemReview.count, 3)
        XCTAssertEqual((result.first as! CellCompanyItem).salaryAvg, 3483)
    }
    
    func testTransformArrayOfJSONObjectToArrayOfCellItemReview() throws {
        let jsonObjects: [JSONObject] = mockData1_cell_JSONObjects
        let result = try transformer.transformArrayOfJSONObjectToArrayOfCellItemReview(jsonObjects)

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result.first!.rateTotalAvg, 4.25)
        XCTAssertEqual(result.first!.updateDate, "2022-06-01T11:01:11.000+09:00")
        XCTAssertEqual(result.last!.rateTotalAvg, 2.52)
        XCTAssertEqual(result.last!.updateDate, "2021-12-21T19:02:11.000+09:00")
    }
}
