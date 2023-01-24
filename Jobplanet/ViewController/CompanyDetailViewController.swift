//
//  CompanyDetailViewController.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/24.
//

import UIKit
import RxCocoa
import RxSwift

class CompanyDetailViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: IdentifiableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var industryNameLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var reviewSummaryLabel: UILabel!
    @IBOutlet weak var salaryAvgLabel: UILabel!
    @IBOutlet weak var interviewQuestionLabel: UILabel!
    @IBOutlet weak var reviewView: CompanyReviewView!
    @IBOutlet weak var reviewViewHeightConstraint: NSLayoutConstraint!
    
    var company: CellItemCompany?

    let viewModel = CompanyDetailViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    func setup() {
        guard let company = company else {
            return
        }
        
        // navigation bar
        title = company.name
        navigationController?.navigationBar.topItem?.title = ""
        
        // view
        logoImageView.setImage(with: company.logoPath)
        nameLabel.text = company.name
        ratingLabel.text = "\(company.rateTotalAvg)"
        industryNameLabel.text = company.industryName
        updateDateLabel.text = company.updateDate
        reviewSummaryLabel.text = company.reviewSummary
        salaryAvgLabel.text = company.salaryAvg.withComma
        interviewQuestionLabel.text = company.interviewQuestion
        
        // reviewView delegate 설정
        reviewView.delegate = {
            // TODO: 리뷰 리스트 보여주는 페이지 개발
        }
    }
    
    func bind() {
        guard let companyName = company?.name else {
            return
        }
        
        let companyNameEvent = Observable.of(companyName)
        let input = CompanyDetailViewModel.Input(requestReviewsRecruitsByCompanyName: companyNameEvent)
        viewModel.transform(input: input)
            .reviews
            .drive(with: self, onNext: { _, reviews in
                self.reviewView.setup(review: reviews.first,
                                      totalCount: reviews.count)
                
                if reviews.isEmpty {
                    self.reviewViewHeightConstraint.constant = 60
                }
            })
            .disposed(by: disposeBag)
    }
}
