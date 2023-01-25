//
//  JobPlanetUserDefaultsHelperTest.swift
//  JobplanetTests
//
//  Created by Jinhyang Kim on 2023/01/25.
//

import XCTest
@testable import Jobplanet

final class JobPlanetUserDefaultsHelperTest: XCTestCase {
    
    var helper: UserDefaultsHelper!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        helper = UserDefaultsHelper()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        // 테스트를 위해 기기에 저장한 UserDefaults 삭제해주기
        UserDefaultKeys.allCases.forEach { key in
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
        
        helper = nil
    }
    
    func test_UserDefatuls에_Int배열을_잘_저장하는지() throws {
        let key = UserDefaultKeys.recruitIdsBookMarkOn
        let value = [10, 800, 1000, 90]
        UserDefaultsHelper.setData(value: value, key: key)
        
        let data = UserDefaults.standard.array(forKey: key.rawValue) as? [Int]
        
        XCTAssertEqual(data, value)
    }
    
    func test_UserDefatuls에_Int배열을_잘_가져오는지() throws {
        let value = [0, 90, 1000, 88, 70]
        let key = UserDefaultKeys.recruitIdsBookMarkOn
        UserDefaults.standard.set(value, forKey: key.rawValue)
        
        let data = UserDefaultsHelper.getData(type: [Int].self, forKey: key)
        
        XCTAssertEqual(data, value)
    }
    
    func test_key값이_다를_때_UserDefatuls에_String배열_가져오는_것을_실패하는지() throws {
        let value = [1, 70, 9]
        let key = "TEST"
        UserDefaults.standard.set(value, forKey: key)
        
        let data = UserDefaultsHelper.getData(type: [Int].self, forKey: UserDefaultKeys.recruitIdsBookMarkOn)
        
        XCTAssertNotEqual(data, value)
    }
}
