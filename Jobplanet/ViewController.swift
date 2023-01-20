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
        
        let cell = UINib(nibName: "RecruitCollectionViewCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: "RecruitCollectionViewCell")
    }
    
    func setCollectionViewSize() {
        // TODO: 채용버튼이 선택되었을 때
        sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        minSpacing = 15
        itemsPerRow = 2
        
        // else if TODO: 기업버튼이 선택되었을 때
    }
}

// TODO: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
}

// TODO: DataSource, Delegate 채워넣기
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 채용 버튼 탭 되었을 경우
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecruitCollectionViewCell", for: indexPath) as? RecruitCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // else if TODO: 기업버튼이 선택되었을 때
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * 2 + minSpacing * (itemsPerRow - 1)
        let width = (view.frame.width - paddingSpace) / itemsPerRow
        
        // 채용 버튼 탭 되었을 경우
        // else if TODO: 기업버튼이 선택되었을 때
        return CGSize(width: width, height: width * 226 / 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}
