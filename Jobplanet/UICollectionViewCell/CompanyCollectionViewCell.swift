//
//  CompanyCollectionViewCell.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/21.
//

import UIKit

class CompanyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateTotalAvgLabel: UILabel!
    @IBOutlet weak var industryLabel: UILabel!
    @IBOutlet weak var reviewSummaryLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var interviewQuestionLabel: UILabel!
    @IBOutlet weak var salaryAvgLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        logoImageView.addBorder(color: .jpGray3, width: 1)
        logoImageView.makeCornerRounded(radius: 4)
        nameLabel.setLineHeight(lineHeight: 25)
        reviewSummaryLabel.setLineHeight(lineHeight: 26)
        interviewQuestionLabel.setLineHeight(lineHeight: 25)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize,
                                                                          withHorizontalFittingPriority: .defaultHigh,
                                                                          verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
    func setupCell(with item: CellItemCompany) {
        logoImageView.setImage(with: item.logoPath)
        nameLabel.text = item.name
        rateTotalAvgLabel.text = "\(item.rateTotalAvg)"
        industryLabel.text = item.industryName
        reviewSummaryLabel.text = item.reviewSummary
        updateDateLabel.text = item.updateDate
        interviewQuestionLabel.text = item.interviewQuestion
        salaryAvgLabel.text = "\(item.salaryAvg.withComma)"
    }
}
