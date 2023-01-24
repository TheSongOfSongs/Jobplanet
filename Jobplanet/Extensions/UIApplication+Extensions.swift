//
//  UIApplication+Extensions.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/25.
//

import UIKit

extension UIApplication {
    var safeAreaInsets: UIEdgeInsets? {
        return UIApplication.shared
            .connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow})
            .first?
            .safeAreaInsets
    }
}
