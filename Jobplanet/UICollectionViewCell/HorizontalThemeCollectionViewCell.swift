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
    
    var recruitItems: [RecruitItem] = []
    var delegate: ((RecruitItem) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        let cell = UINib(nibName: RecruitCollectionViewCell.identifier, bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: RecruitCollectionViewCell.identifier)
    }
    
    func setupCell(with horizontalTheme: CellHorizontalThemeItem) {
        sectionTitleLabel.text = horizontalTheme.sectionTitle
        recruitItems = horizontalTheme.recommendRecruit ?? []
        collectionView.reloadData()
    }
}
