//
//  CompanyDetailViewController.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/24.
//

import UIKit

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
    
    var company: CellItemCompany?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
}
