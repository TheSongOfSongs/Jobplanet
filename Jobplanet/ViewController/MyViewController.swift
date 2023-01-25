//
//  MyViewController.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/25.
//

import UIKit
import RxSwift
import RxCocoa

class MyViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    let viewModel = MyViewModel()
    
    var recruits: [RecruitItem] = []
    
    let sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    let minSpacing: CGFloat = 15
    let itemsPerRow: CGFloat = 2
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupBinding()
    }
    
    
    // MARK: - setup
    func setupBinding() {
        let input = MyViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.recruitItems
            .drive(with: self, onNext: { owner, recruitItems in
                owner.recruits = recruitItems
                owner.collectionView.reloadData()
                owner.noDataLabel.isHidden = !recruitItems.isEmpty
            })
            .disposed(by: disposeBag)
    }
    
    func setupCollectionView() {
        let recruitCollectionViewCell = UINib(nibName: RecruitCollectionViewCell.identifier, bundle: nil)
        collectionView.register(recruitCollectionViewCell, forCellWithReuseIdentifier: RecruitCollectionViewCell.identifier)
    }
}
