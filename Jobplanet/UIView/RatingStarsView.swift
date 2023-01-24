//
//  RatingStarsView.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/24.
//

import UIKit

class RatingStarsView: UIView {
    
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!
    
    let fillStarImage = UIImage(systemName: "star.fill")
    let halfFillStarImage = UIImage(systemName: "star.fill.left")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let view = Bundle.main.loadNibNamed(RatingStarsView.identifier, owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        guard let view = Bundle.main.loadNibNamed(RatingStarsView.identifier, owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
        commonInit()
    }
    
    func commonInit() { }
    
    func setStars(with rating: Double) {
        switch rating {
        case 5:
            setFullStarImageViews(imageViews: [star1ImageView, star2ImageView, star3ImageView, star4ImageView, star5ImageView])
        case 4:
            setFullStarImageViews(imageViews: [star1ImageView, star2ImageView, star3ImageView, star4ImageView])
        case 3:
            setFullStarImageViews(imageViews: [star1ImageView, star2ImageView, star3ImageView])
        case 2:
            setFullStarImageViews(imageViews: [star1ImageView, star2ImageView])
        case 1:
            setFullStarImageViews(imageViews: [star1ImageView])
        case 0:
            break
        case _ where rating > 4:
            setFullStarImageViews(imageViews: [star1ImageView, star2ImageView, star3ImageView, star4ImageView])
            star5ImageView.image = halfFillStarImage
        case _ where rating > 3:
            setFullStarImageViews(imageViews: [star1ImageView, star2ImageView, star3ImageView])
            star4ImageView.image = halfFillStarImage
        case _ where rating > 2:
            setFullStarImageViews(imageViews: [star1ImageView, star2ImageView])
            star3ImageView.image = halfFillStarImage
        case _ where rating > 1:
            setFullStarImageViews(imageViews: [star1ImageView])
            star2ImageView.image = halfFillStarImage
        case _ where rating > 0:
            star1ImageView.image = halfFillStarImage
        default:
            break
        }
    }
    
    private func setFullStarImageViews(imageViews: [UIImageView]) {
        imageViews.forEach({
            $0.image = fillStarImage
        })
    }
}
