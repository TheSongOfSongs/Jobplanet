//
//  RecruitCompanyButtonsCollectionReusableView.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/21.
//

import UIKit
import RxCocoa
import RxSwift

class RecruitCompanyButtonsCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var recruitButton: UIButton!
    @IBOutlet weak var companyButton: UIButton!
    
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
    
    private let disposeBag = DisposeBag()
    let listButtonTapped = PublishRelay<List>()
    
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
            .bind(onNext: {
                self.listButtonTapped.accept(.recruit)
                self.setButtonUI(self.recruitButton, buttonUI: self.selectedButtonUI)
                self.setButtonUI(self.companyButton, buttonUI: self.deselectedButtonUI)
            })
            .disposed(by: disposeBag)
        
        companyButton.rx.tap
            .bind(onNext: {
                self.listButtonTapped.accept(.cell)
                self.setButtonUI(self.companyButton, buttonUI: self.selectedButtonUI)
                self.setButtonUI(self.recruitButton, buttonUI: self.self.deselectedButtonUI)
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
