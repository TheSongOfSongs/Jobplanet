//
//  ViewController.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/20.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    var minSpacing: CGFloat = 15
    var itemsPerRow: CGFloat = 2
    
    let viewModel = HomeViewModel()
    let requestRecruitItems = PublishRelay<Void>()
    let listButtonSelected = BehaviorRelay(value: List.recruit)
    let disposeBag = DisposeBag()
    
    ///  '채용' 버튼 눌렸을 때 collection view 데이터소스
    var recruitItems: [RecruitItem] = []
    
    var listButtonSelectedValue: List {
        return listButtonSelected.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
        setupSearchBar()
        setupCollectionView()
        setCollectionViewSize()
        
        requestRecruitItems.accept(())
    }
    
    // MARK: setup
    func setupBinding() {
        let input = HomeViewModel.Input(requestRecruitItems: requestRecruitItems.asObservable())
        let output = viewModel.transform(input: input)
        
        output.recruitItems
            .drive(with: self,
                   onNext: { _, recruitItems in
                // TODO: collection view layout 정리
                self.recruitItems = recruitItems
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        
        listButtonSelected
            .asDriver()
            .drive(with: self,
                   onNext: { _, list in
                
                switch list {
                case .recruit:
                    self.requestRecruitItems.accept(())
                case .cell:
                    // TODO: 기업 아이템 요청
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
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
        
        let horizontalThemeCollectionViewCell = UINib(nibName: HorizontalThemeCollectionViewCell.identifier, bundle: nil)
        collectionView.register(horizontalThemeCollectionViewCell, forCellWithReuseIdentifier: HorizontalThemeCollectionViewCell.identifier)
        
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
//        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
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
        switch listButtonSelectedValue {
        case .recruit:
            return recruitItems.count
        case .cell:
            return 0 // TODO: 변경
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch listButtonSelectedValue {
        case .recruit:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecruitCollectionViewCell.identifier, for: indexPath) as? RecruitCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.setupCell(with: recruitItems[indexPath.row])
            return cell
        case .cell:
            // TODO: 데이터 종류에 맞는 cell 반환
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyCollectionViewCell.identifier, for: indexPath) as? CompanyCollectionViewCell else {
                return UICollectionViewCell()
            }
            
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalThemeCollectionViewCell.identifier, for: indexPath) as? HorizontalThemeCollectionViewCell else {
//                return UICollectionViewCell()
//            }
            
            return cell
        }
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
        switch listButtonSelectedValue {
        case .recruit:
            let paddingSpace = sectionInsets.left * 2 + minSpacing * (itemsPerRow - 1)
            let width = (view.frame.width - paddingSpace) / itemsPerRow
            return CGSize(width: width, height: width * 226 / 160)
        case .cell:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
}
