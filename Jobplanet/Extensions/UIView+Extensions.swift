//
//  UIView+Extensions.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/20.
//

import UIKit

extension UIView {
    class var identifier: String {
        return String(describing: self)
    }
    
    func makeCornerRounded(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func addBorder(color: UIColor, width: CGFloat) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}
