//
//  CellItemsTransformer.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/22.
//

import Foundation

struct CellItemsTransformer {
    
    let decoder = JSONDecoder()
    
    /// key 값 cell_items로 value인 cell_items를 배열 형태로 가져오는 함수
    /// Data > [JSONObject]
    func transformDataToArrayOfJSONObject(_ data: Data) throws -> Result<[JSONObject], APIServiceError> {
        guard let dict = try JSONSerialization.jsonObject(with: data) as? JSONObject,
              let cellItems = dict["cell_items"] as? [JSONObject] else {
            return .failure(.failedDecoding)
        }
        
        return .success(cellItems)
    }
    
    /// [JSONObject] > [Celltem]
    func transformArrayOfJSONObjectToArrayOfCellItem(_ jsonObjects: [JSONObject]) throws -> [CellItem] {
        var result: [CellItem] = []
        
        for jsonObject in jsonObjects {
            guard let cellType = jsonObject["cell_type"] as? String else {
                continue
            }
            
            switch cellType {
            case CellType.horizontalTheme.dictionaryKey:
                let item: CellItemHorizontalTheme = try CellItemHorizontalTheme.decode(with: jsonObject)
                result.append(item)
            case CellType.review.dictionaryKey:
                let item: CellItemReview = try CellItemReview.decode(with: jsonObject)
                result.append(item)
            case CellType.company.dictionaryKey:
                let item: CellItemCompany = try CellItemCompany.decode(with: jsonObject)
                result.append(item)
            default:
                continue
            }
        }
        
        return result
    }
    
    /// [JSONObject] > [CellItemReview]
    func transformArrayOfJSONObjectToArrayOfCellItemReview(_ jsonObjects: [JSONObject], with companyName: String) throws -> [CellItemReview] {
        var result: [CellItemReview] = []
        
        for jsonObject in jsonObjects {
            guard let cellType = jsonObject["cell_type"] as? String,
                  cellType == CellType.review.dictionaryKey else {
                continue
            }
            
            let item: CellItemReview = try CellItemReview.decode(with: jsonObject)
            
            if item.name == companyName {
                result.append(item)
            }
        }
    
        return result
    }
}