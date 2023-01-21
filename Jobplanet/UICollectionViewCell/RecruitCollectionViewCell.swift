//
//  RecruitCollectionViewCell.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/20.
//

import UIKit

class RecruitCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var appealsView: AppealsView!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var ratingsRabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.makeCornerRounded(radius: 8)
        titleLabel.setLineHeight(lineHeight: 24)
    }
}
