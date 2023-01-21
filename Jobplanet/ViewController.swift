//
//  ViewController.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    var minSpacing: CGFloat = 15
    var itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupCollectionView()
        setCollectionViewSize()
    }
    
    // MARK: setup
    func setupSearchBar() {
        searchBar.delegate = self
        
        let image = UIImage(named: "img_logo_search")
        searchBar.setImage(image, for: .search, state: .normal)
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.searchTextField.backgroundColor = .clear
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let recruitCollectionViewCell = UINib(nibName: RecruitCollectionViewCell.identifier, bundle: nil)
        collectionView.register(recruitCollectionViewCell, forCellWithReuseIdentifier: RecruitCollectionViewCell.identifier)
        
        let companyCollectionViewCell = UINib(nibName: CompanyCollectionViewCell.identifier, bundle: nil)
        collectionView.register(companyCollectionViewCell, forCellWithReuseIdentifier: CompanyCollectionViewCell.identifier)
        
        let reusableView = UINib(nibName: RecruitCompanyButtonsCollectionReusableView.identifier, bundle: nil)
        collectionView.register(reusableView,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: RecruitCompanyButtonsCollectionReusableView.identifier)
    }
    
    func setCollectionViewSize() {
        // TODO: 채용/기업 버튼 선택되었을 때 처리
        sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        minSpacing = 15
        itemsPerRow = 2
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
//        sectionInsets = UIEdgeInsets.zero
//        minSpacing = 0
//        itemsPerRow = 1
//        let companyFlowLayout = UICollectionViewFlowLayout()
//        companyFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        collectionView.collectionViewLayout = companyFlowLayout
//        collectionView.contentInsetAdjustmentBehavior = .always
    }
}

// TODO: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
}

// TODO: DataSource, Delegate 채워넣기
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: 채용/기업 버튼 선택되었을 때 처리
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecruitCollectionViewCell.identifier, for: indexPath) as? RecruitCollectionViewCell else {
            return UICollectionViewCell()
        }
        
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyCollectionViewCell.identifier, for: indexPath) as? CompanyCollectionViewCell else {
//            return UICollectionViewCell()
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: RecruitCompanyButtonsCollectionReusableView.identifier,
                                                                               for: indexPath) as? RecruitCompanyButtonsCollectionReusableView else {
            return UICollectionReusableView()
        }
        return headerView
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 채용 버튼 탭 되었을 경우
        let paddingSpace = sectionInsets.left * 2 + minSpacing * (itemsPerRow - 1)
        let width = (view.frame.width - paddingSpace) / itemsPerRow
        return CGSize(width: width, height: width * 226 / 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
}
