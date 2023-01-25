//
//  MyViewController.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/25.
//

import UIKit

class MyViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var recruits: [RecruitItem] = []
    
    let sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    let minSpacing: CGFloat = 15
    let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    
    // MARK: - setup
    func setupCollectionView() {
        let recruitCollectionViewCell = UINib(nibName: RecruitCollectionViewCell.identifier, bundle: nil)
        collectionView.register(recruitCollectionViewCell, forCellWithReuseIdentifier: RecruitCollectionViewCell.identifier)
    }
}
