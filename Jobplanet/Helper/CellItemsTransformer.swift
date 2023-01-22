//
//  CellItemsTransformer.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/22.
//

import Foundation

struct CellItemsTransformer {
    
    typealias JSONObject = NetworkService.JSONObject
    
    /// key 값 cell_items로 value인 cell_items를 배열 형태로 가져오는 함수
    /// Data > [JSONObject]
    func transformDataToArrayOfJSONObject(_ data: Data) throws -> Result<[JSONObject], APIServiceError> {
        guard let dict = try JSONSerialization.jsonObject(with: data) as? JSONObject,
              let cellItems = dict["cell_items"] as? [JSONObject] else {
            return .failure(.failedDecoding)
        }
        
        return .success(cellItems)
    }
}
