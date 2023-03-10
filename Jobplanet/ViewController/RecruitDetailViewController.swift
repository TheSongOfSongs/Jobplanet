//
//  RecruitDetailViewController.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/24.
//

import UIKit
import RxCocoa
import RxSwift

class RecruitDetailViewController: UIViewController, Toast {
    
    @IBOutlet weak var logoImageView: IdentifiableImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingStarView: RatingStarsView!
    @IBOutlet weak var appealsView: AppealsView!
    @IBOutlet weak var appealsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reviewView: CompanyReviewView!
    @IBOutlet weak var reviewViewHeightConstraint: NSLayoutConstraint!
    
    var recruitItem: RecruitItem?
    
    let viewModel = RecruitDetailViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    func setup() {
        guard let recruitItem = recruitItem else {
            return
        }
        
        // navigation bar
        title = recruitItem.title
        
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
        
        reviewView.delegate = {
            // TODO: 리뷰 리스트 보여주는 페이지 개발
        }
    }
    
    func bind() {
        guard let recruitItem = recruitItem else {
            return
        }
        
        let companyName = Observable.of(recruitItem.company.name)
        let input = RecruitDetailViewModel.Input(requestReviewsByCompanyName: companyName)
        let output = viewModel.transform(input: input)
        
        output.reviews
            .drive(with: self, onNext: { owner, result  in
                owner.reviewView.setup(review: result.first,
                                       totalCount: result.count,
                                       reward: recruitItem.reward
                )
                
                if result.isEmpty {
                    owner.reviewViewHeightConstraint.constant = 100
                }
            })
            .disposed(by: disposeBag)
        
        output.error
            .drive(with: self, onNext: { owner, error  in
                owner.showAndHideToastview(with: error.description)
            })
            .disposed(by: disposeBag)
    }
}
