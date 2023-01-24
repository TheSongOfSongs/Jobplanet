//
//  RecruitDetailViewController.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/24.
//

import UIKit
import RxCocoa
import RxSwift

class RecruitDetailViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: IdentifiableImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingStarView: RatingStarsView!
    @IBOutlet weak var appealsView: AppealsView!
    @IBOutlet weak var appealsViewHeightConstraint: NSLayoutConstraint!
    
    var recruitItem: RecruitItem?
    
    let viewModel = RecruitDetailViewModel()
    
    let disposeBag = DisposeBag()
    private let recruitItemRelay = PublishRelay<RecruitItem>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        guard let recruitItem = recruitItem else {
            return
        }
        
        // navigation bar
        title = recruitItem.title
        navigationController?.navigationBar.topItem?.title = ""
        
        // view
        titleLabel.text = recruitItem.title
        companyNameLabel.text = recruitItem.company.name
        
        let rating = recruitItem.company.maxRatings ?? 0.0
        ratingLabel.text = "\(rating)"
        ratingStarView.setStars(with: rating)
        
        logoImageView.makeCornerRounded(radius: 5)
        logoImageView.addBorder(color: .jpGray3, width: 1)
        logoImageView.setImage(with: recruitItem.company.logoPath)
        
        let appeals = recruitItem.appeals.filter({ !$0.isEmpty })
        appealsView.texts = appeals
        appealsViewHeightConstraint.constant = appeals.isEmpty ? 0 : 20
    }
    
    func bind() {
        let companyName = recruitItemRelay.map({ $0.company.name })
        let input = RecruitDetailViewModel.Input(requestReviewsByCompanyName: companyName)
        viewModel.transform(input: input)
            .reviews
            .compactMap({ $0.first })
            .drive(with: self, onNext: { _, result  in
                
            })
            .disposed(by: disposeBag)
    }
}