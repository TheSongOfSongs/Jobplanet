//
//  AppealsView.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/21.
// 

import UIKit

class AppealsView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    
    var texts: [String] = []
    let fontSize: CGFloat = 11
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let view = Bundle.main.loadNibNamed(AppealsView.identifier, owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        guard let view = Bundle.main.loadNibNamed(AppealsView.identifier, owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
        commonInit()
    }
    
    func commonInit() { }
    
    override func layoutSubviews() {
        setTexts(with: texts)
    }

    /// appeal 텍스트 값을 받아 뷰에 추가해주는 함수
    private func setTexts(with texts: [String]) {
        stackView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        var width: CGFloat = 0
        
        for text in texts {
            let label: PaddingLabel = {
                let label = PaddingLabel()
                label.font = UIFont.systemFont(ofSize: fontSize)
                label.textColor = .jpGray2
                label.addBorder(color: UIColor.jpGray3, width: 1)
                label.makeCornerRounded(radius: 4)
                return label
            }()
            
            label.text = text
            width += label.intrinsicContentSize.width + 4
            
            if width > frame.width {
                break
            }
            
            stackView.addArrangedSubview(label)
        }
    }
}
