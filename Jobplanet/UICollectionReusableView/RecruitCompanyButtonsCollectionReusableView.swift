//
//  RecruitCompanyButtonsCollectionReusableView.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/21.
//

import UIKit
import RxSwift

class RecruitCompanyButtonsCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var recruitButton: UIButton!
    @IBOutlet weak var companyButton: UIButton!
    
    var delegate: ((List) -> Void)?
    
    struct ButtonUIInformation {
        let titleColor: UIColor
        let backgroundColor: UIColor
        let borderColor: UIColor
        let borderWidth: CGFloat = 1
        let font: UIFont
    }
    
    private let selectedButtonUI = ButtonUIInformation(titleColor: .white,
                                                       backgroundColor: .jpGreen,
                                                       borderColor: .clear,
                                                       font: .systemFont(ofSize: 15, weight: .bold))
    private let deselectedButtonUI = ButtonUIInformation(titleColor: .jpGray1,
                                                         backgroundColor: .white,
                                                         borderColor: .jpGray3,
                                                         font: .systemFont(ofSize: 15, weight: .regular))
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        bind()
    }
    
    func setupUI() {
        setButtonUI(recruitButton, buttonUI: selectedButtonUI)
        setButtonUI(companyButton, buttonUI: deselectedButtonUI)
        recruitButton.makeCornerRounded(radius: 15)
        companyButton.makeCornerRounded(radius: 15)
    }
    
    func bind() {
        recruitButton.rx.tap
            .withUnretained(self)
            .bind(with: self, onNext: { owner, _ in
                owner.delegate?(.recruit)
                owner.setButtonUI(owner.recruitButton, buttonUI: owner.selectedButtonUI)
                owner.setButtonUI(owner.companyButton, buttonUI: owner.deselectedButtonUI)
            })
            .disposed(by: disposeBag)
        
        companyButton.rx.tap
            .withUnretained(self)
            .bind(with: self, onNext: { owner, _ in
                owner.delegate?(.cell)
                owner.setButtonUI(owner.companyButton, buttonUI: owner.selectedButtonUI)
                owner.setButtonUI(owner.recruitButton, buttonUI: owner.deselectedButtonUI)
            })
            .disposed(by: disposeBag)
    }
    
    func setButtonUI(_ button: UIButton, buttonUI: ButtonUIInformation) {
        button.setTitleColor(buttonUI.titleColor, for: .normal)
        button.backgroundColor = buttonUI.backgroundColor
        button.addBorder(color: buttonUI.borderColor, width: buttonUI.borderWidth)
        button.titleLabel?.font = buttonUI.font
    }
}
