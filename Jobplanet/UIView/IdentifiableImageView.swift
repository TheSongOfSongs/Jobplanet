//
//  IdentifiableImageView.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/23.
//

import UIKit
import Kingfisher

final class IdentifiableImageView: UIImageView {
    
    /// ReusableView에서 발생하는 이미지 깜빡임 이슈를 막기 위한 identifier
    var urlString: String?
    
    func setImage(with urlString: String) {
        self.urlString = urlString
        
        ImageCache.default.retrieveImage(forKey: urlString, options: nil) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                if let image = value.image {
                    self.image = image
                    return
                }
                
                guard let url = URL(string: urlString) else {
                    return
                }
                
                let resource = ImageResource(downloadURL: url, cacheKey: urlString)
                
                // identifier로 원하는 이미지 뷰가 맞는지 확인
                guard self.urlString == urlString else {
                    return
                }
                
                self.kf.setImage(with: resource)
            case .failure(let error):
                print(error)
            }
        }
    }
}
