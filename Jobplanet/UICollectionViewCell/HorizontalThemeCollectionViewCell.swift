//
//  HorizontalThemeCollectionViewCell.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/21.
//

import UIKit

class HorizontalThemeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset.left = 20

        let cell = UINib(nibName: RecruitCollectionViewCell.identifier, bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: RecruitCollectionViewCell.identifier)
    }
}
