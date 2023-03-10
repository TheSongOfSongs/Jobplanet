//
//  CompanyDetailViewController.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/24.
//

import UIKit
import RxCocoa
import RxSwift

class CompanyDetailViewController: UIViewController, Toast {
    
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
    @IBOutlet weak var recruitsCollectionView: UICollectionView!
    @IBOutlet weak var recruitsCollectionViewHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var noRecruitsLabel: UILabel!
    
    var company: CellCompanyItem?
    var recruitItems: [RecruitItem] = []
    var delegate: ((RecruitItem) -> Void)?

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
        
        // view
        logoImageView.setImage(with: company.logoPath)
        logoImageView.addBorder(color: .jpGray3, width: 1)
        logoImageView.makeCornerRounded(radius: 5)
        nameLabel.text = company.name
        ratingLabel.text = "\(company.rateTotalAvg)"
        industryNameLabel.text = company.industryName
        updateDateLabel.text = company.updateDate
        reviewSummaryLabel.text = company.reviewSummary
        salaryAvgLabel.text = company.salaryAvg.withComma
        interviewQuestionLabel.text = company.interviewQuestion
        
        reviewView.delegate = {
            // TODO: 리뷰 리스트 보여주는 페이지 개발
        }
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let cell = UINib(nibName: RecruitCollectionViewCell.identifier, bundle: nil)
        recruitsCollectionView.register(cell, forCellWithReuseIdentifier: RecruitCollectionViewCell.identifier)
        recruitsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func bind() {
        guard let companyName = company?.name else {
            return
        }
        
        let companyNameEvent = Observable.of(companyName)
        let input = CompanyDetailViewModel.Input(requestReviewsAndRecruitsByCompanyName: companyNameEvent)
        let output = viewModel.transform(input: input)
        
        output.reviews
            .drive(with: self, onNext: { owner, reviews in
                owner.reviewView.setup(review: reviews.first,
                                       totalCount: reviews.count)
                
                if reviews.isEmpty {
                    owner.reviewViewHeightConstraint.constant = 60
                }
            })
            .disposed(by: disposeBag)
        
        output.recruits
            .drive(with: self, onNext: { owner, recruitItems in
                guard !recruitItems.isEmpty else {
                    owner.noRecruitsLabel.isHidden = false
                    owner.recruitsCollectionViewHeightConstriant.constant = 20
                    return
                }
                
                owner.recruitItems = recruitItems
                owner.recruitsCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.error
            .drive(with: self, onNext: { owner, error in
                owner.showAndHideToastview(with: error.description)
            })
            .disposed(by: disposeBag)
    }
}
