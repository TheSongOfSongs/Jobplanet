//
//  UIViewController+Extensions.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/21.
//

import UIKit

extension UIViewController {
    class var identifier: String {
        return String(describing: self)
    }
}
