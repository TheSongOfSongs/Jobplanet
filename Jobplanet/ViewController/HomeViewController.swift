//
//  HomeViewController.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/20.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let viewModel = HomeViewModel()
    let requestRecruitItems = PublishRelay<Void>()
    let requestCellItems = PublishRelay<Void>()
    let requestItemsBySearching = PublishRelay<(String, List)>()
    let listButtonSelected = BehaviorRelay(value: List.recruit)
    let disposeBag = DisposeBag()
    
    ///  '채용' 버튼 눌렸을 때 collection view 데이터소스
    var recruitItems: [RecruitItem] = []
    
    /// '기업' 버튼 눌렸을 때 collection view 데이터소스
    var cellItems: [CellItem] = []
    
    var refreshControl = UIRefreshControl()
    
    var listButtonSelectedValue: List {
        return listButtonSelected.value
    }
    
    lazy var recruitCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let minSpacing: CGFloat = 15
        let itemsPerRow: CGFloat = 2
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInset
        layout.minimumInteritemSpacing = minSpacing
        
        let paddingSpace = sectionInset.left * 2.0 + minSpacing * (itemsPerRow - 1.0)
        let width = (view.frame.width - paddingSpace) / itemsPerRow
        layout.itemSize = CGSize(width: width, height: width * 226 / 160)
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 70)
        return layout
    }()
    
    lazy var companyCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: view.frame.width, height: .zero)
        layout.sectionInset = .zero
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 70)
        return layout
    }()
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
        setupSearchBar()
        setCollectionViewSize(with: listButtonSelectedValue)
        setupCollectionView()
        setupRefreshControll()
    }
    
    // MARK: setup
    func setupBinding() {
        let input = HomeViewModel
            .Input(requestRecruitItems: requestRecruitItems.asObservable(),
                   requestCellItems: requestCellItems.asObservable(),
                   requestRecruitItemsBySearching: requestItemsBySearching.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.recruitItems
            .drive(with: self,
                   onNext: { _, recruitItems in
                self.recruitItems = recruitItems
                self.collectionView.reloadData()
                self.setCollectionViewSize(with: .recruit)
                self.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        output.cellItems
            .drive(with: self, onNext: { _, cellItems in
                self.cellItems = cellItems
                self.setCollectionViewSize(with: .cell)
                self.collectionView.reloadData()
                self.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        listButtonSelected
            .asDriver()
            .drive(with: self,
                   onNext: { _, list in
                self.activityIndicatorView.startAnimating()
                self.requestItems()
                self.cancelImageDownloadingOfCells()
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
    
    func setCollectionViewSize(with list: List) {
        collectionView.collectionViewLayout = {
            switch list {
            case .recruit:
                return recruitCollectionViewFlowLayout
            case .cell:
                return companyCollectionViewFlowLayout
            }
        }()
    }
    
    func setupRefreshControll() {
        refreshControl.addTarget(self, action: #selector(reloadCollectionView), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc func reloadCollectionView() {
        activityIndicatorView.startAnimating()
        listButtonSelected.accept(listButtonSelectedValue)
    }
    
    func endRefreshing() {
        activityIndicatorView.stopAnimating()
        refreshControl.endRefreshing()
    }
    
    func cancelImageDownloadingOfCells() {
        let cells = collectionView.visibleCells.compactMap({ $0 as? CellImageDownloadCancelling })
        cells.forEach { cell in
            cell.cancelDownloadImage()
        }
    }
    
    func requestItems() {
        let selectedButton = listButtonSelectedValue
        
        // 검색어가 있을 때
        if let searchTerm = searchBar.text,
           !searchTerm.isEmpty {
            requestItemsBySearching.accept((searchTerm, selectedButton))
            return
        }
        
        // 검색어가 없을 때
        switch selectedButton {
        case .recruit:
            requestRecruitItems.accept(())
        case .cell:
            requestCellItems.accept(())
        }
    }
}
