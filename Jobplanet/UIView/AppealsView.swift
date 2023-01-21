//
//  AppealsView.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/21.
// 

import UIKit

class AppealsView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    
    var texts: [String] = [] {
        didSet {
            setTexts(with: texts)
        }
    }
    
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
    
    /// appeal 텍스트 값을 받아 뷰에 추가해주는 함수
    /// UILabel은 복사하기 위해 1개 갖고 있으며, 2개 이상일 경우 동적으로 UILabel을 복사하여 StackView에 추가해주는 방식으로 동작
    private func setTexts(with texts: [String]) {
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
            stackView.addArrangedSubview(label)
        }
    }
}
