//
//  UIImageView+Extensions.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/22.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String) {
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
                self.kf.setImage(with: resource)
            case .failure(let error):
                print(error)
            }
        }
    }
}
