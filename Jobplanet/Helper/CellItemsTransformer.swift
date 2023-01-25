//
//  CellItemsTransformer.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/22.
//

import Foundation

/// JSON 형태로 받아오는 데이터를 가공하여 모델화시켜주는 구조체
struct CellItemsTransformer {
    
    let decoder = JSONDecoder()
    
    enum JSONObjectKey: String {
        case cellItems = "cell_items"
        case cellType = "cell_type"
    }
    
    /// key 값 cell_items로 value인 cell_items를 배열 형태로 가져오는 함수
    /// Data > [JSONObject]
    func transformDataToJSONObjects(_ data: Data) throws -> Result<[JSONObject], APIServiceError> {
        guard let dict = try JSONSerialization.jsonObject(with: data) as? JSONObject,
              let cellItems = dict[JSONObjectKey.cellItems.rawValue] as? [JSONObject] else {
            return .failure(.failedDecoding)
        }
        
        return .success(cellItems)
    }
    
    /// [JSONObject] > [Celltem]
    func transformJSONObjectsToCellItems(_ jsonObjects: [JSONObject]) throws -> [CellItem] {
        var result: [CellItem] = []
        
        for jsonObject in jsonObjects {
            guard let cellType = jsonObject[JSONObjectKey.cellType.rawValue] as? String else {
                continue
            }
            
            switch cellType {
            case CellType.horizontalTheme.dictionaryKey:
                let item: CellHorizontalThemeItem = try CellHorizontalThemeItem.decode(with: jsonObject)
                result.append(item)
            case CellType.review.dictionaryKey:
                let item: CellReviewItem = try CellReviewItem.decode(with: jsonObject)
                result.append(item)
            case CellType.company.dictionaryKey:
                let item: CellCompanyItem = try CellCompanyItem.decode(with: jsonObject)
                result.append(item)
            default:
                continue
            }
        }
        
        return result
    }
    
    /// [JSONObject] > [CellItemReview]
    func transformJSONObjectsToCellItemReviews(_ jsonObjects: [JSONObject], with companyName: String) throws -> [CellReviewItem] {
        var result: [CellReviewItem] = []
        
        for jsonObject in jsonObjects {
            guard let cellType = jsonObject[JSONObjectKey.cellType.rawValue] as? String,
                  cellType == CellType.review.dictionaryKey else {
                continue
            }
            
            let item: CellReviewItem = try CellReviewItem.decode(with: jsonObject)
            
            if item.name == companyName {
                result.append(item)
            }
        }
    
        return result
    }
}
