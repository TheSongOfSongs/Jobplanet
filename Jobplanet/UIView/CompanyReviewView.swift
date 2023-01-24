//
//  CompanyReviewView.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/24.
//

import UIKit

class CompanyReviewView: UIView {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var reviewContentsView: UIView!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var ratingStarsView: RatingStarsView!
    @IBOutlet weak var reviewSummaryLabel: UILabel!
    @IBOutlet weak var prosLabel: UILabel!
    @IBOutlet weak var consLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var noReviewLabel: UILabel!
    
    var delegate: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let view = Bundle.main.loadNibNamed(CompanyReviewView.identifier, owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        guard let view = Bundle.main.loadNibNamed(CompanyReviewView.identifier, owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
        commonInit()
    }
    
    func commonInit() {
        backgroundView.makeCornerRounded(radius: 15)
    }
    
    func setup(review: CellItemReview?, totalCount: Int, reward: Int) {
        rewardLabel.text = reward.withComma
        
        guard let review = review else {
            reviewContentsView.isHidden = true
            noReviewLabel.isHidden = false
            return
        }
        
        reviewSummaryLabel.text = review.reviewSummary
        prosLabel.text = review.pros
        consLabel.text = review.cons
        totalCountLabel.text = "(\(totalCount))"
        ratingStarsView.setStars(with: review.rateTotalAvg)
    }
    
    @IBAction func showMoreReviews(_ sender: UIButton) {
        delegate?()
    }
}
