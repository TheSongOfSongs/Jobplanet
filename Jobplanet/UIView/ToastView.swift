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
    
    func commonInit() {
        backgroundView.makeCornerRounded(radius: 15)
    }
    
    func setText(with text: String) {
        toastLabel.text = text
    }
}
