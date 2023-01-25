//
//  Toast.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/24.
//

import UIKit

protocol Toast where Self: UIViewController {
    var view: UIView! { get }
}

extension Toast {
    func showAndHideToastview(with text: String) {
        ToastView.shared.showToast(with: text, view: view)
    }
}
