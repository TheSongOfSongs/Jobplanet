//
//  RecruitCollectionViewCell.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/20.
//

import UIKit
import Kingfisher

class RecruitCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: IdentifiableImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var appealsView: AppealsView!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var bookMarkBlackView: UIView!
    @IBOutlet weak var bookMarkImageView: UIImageView!
    @IBOutlet weak var appealsViewFrameHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var appealsViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bookMarkView: UIView!
    
    let bookMarkOffImage = UIImage(named: "icon_bookmark_off")
    let bookMarkOnImage = UIImage(named: "icon_bookmark_on")
    var bookMarkDelegate: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.makeCornerRounded(radius: 8)
        titleLabel.setLineHeight(lineHeight: 24)
        bookMarkBlackView.makeCornerRounded(radius: 4)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelDownloadImage()
        imageView.image = nil
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize,
                                                                          withHorizontalFittingPriority: .required,
                                                                          verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
    func setupCell(with item: RecruitItem) {
        titleLabel.text = item.title
        companyNameLabel.text = item.company.name
        rewardLabel.text = "축하금: \(item.reward.withComma)원"
        imageView.setImage(with: item.imageURLString)
        
        if let highestRating = item.company.maxRatings {
            ratingsLabel.text = "\(highestRating)"
        } else {
            ratingsLabel.text = "-"
        }
        
        let appeals = item
            .appeals
            .filter({ !$0.isEmpty })
        
        if !appeals.isEmpty {
            appealsView.texts = appeals
            appealsViewFrameHeightConstraint.constant = 20
            appealsViewTopConstraint.constant = 5
        } else {
            appealsViewFrameHeightConstraint.constant = 0
            appealsViewTopConstraint.constant = 0
        }
    }
    
    @IBAction func bookMark(_ sender: UIButton) {
        bookMarkDelegate?()
    }
}

extension RecruitCollectionViewCell: CellImageDownloadCancelling {
    func cancelDownloadImage() {
        imageView.kf.cancelDownloadTask()
    }
}
