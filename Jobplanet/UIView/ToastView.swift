//
//  ToastView.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/24.
//

import UIKit

class ToastView: UIView {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var toastLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let view = Bundle.main.loadNibNamed(ToastView.identifier, owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        guard let view = Bundle.main.loadNibNamed(ToastView.identifier, owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
        commonInit()
    }
    
    static let shared: ToastView = {
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
        return toastView
    }()
    
    func commonInit() {
        backgroundView.makeCornerRounded(radius: 15)
    }
    
    func showToast(with text: String, view: UIView) {
        toastLabel.text = text
        
        view.addSubview(self)
        
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        } completion: { success in
            guard success else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.2) {
                    self.alpha = 0
                } completion: { _ in
                    self.removeFromSuperview()
                }
            }
        }
    }
}
