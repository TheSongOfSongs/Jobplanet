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
        let toastView: ToastView = {
            let leftPadding: CGFloat = 20
            let bottomPadding = UIApplication.shared
                .connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow})
                .first?
                .safeAreaInsets
                .bottom
            let screenBounds = UIScreen.main.bounds
            let toastViewFrame = CGRect(x: leftPadding,
                                        y: screenBounds.height - (bottomPadding ?? 0) - 100,
                                        width: screenBounds.width - leftPadding*2,
                                        height: 50)
            let toastView = ToastView(frame: toastViewFrame)
            toastView.alpha = 0
            toastView.setText(with: text)
            view.addSubview(toastView)
            return toastView
        }()
        
        
        UIView.animate(withDuration: 0.2) {
            toastView.alpha = 1
        } completion: { success in
            guard success else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.2) {
                    toastView.alpha = 0
                } completion: { _ in
                    toastView.removeFromSuperview()
                }
            }
        }
    }
}

