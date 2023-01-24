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
    @IBOutlet weak var emptyResultLabel: UILabel!
    @IBOutlet weak var whiteOpaqueView: UIView!
    
    let viewModel = HomeViewModel()
    let requestRecruitItems = PublishRelay<Void>()
    let requestCellItems = PublishRelay<Void>()
    let requestItemsBySearching = PublishRelay<(HomeViewModel.SearchCondition)>()
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
        
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
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
                   onNext: { owner, recruitItems in
                owner.recruitItems = recruitItems
                owner.setCollectionViewSize(with: .recruit)
                owner.endRefreshing()
                owner.emptyResultLabel.isHidden = !recruitItems.isEmpty
            })
            .disposed(by: disposeBag)
        
        output.cellItems
            .drive(with: self, onNext: { owner, cellItems in
                owner.cellItems = cellItems
                owner.setCollectionViewSize(with: .cell)
                owner.endRefreshing()
                owner.emptyResultLabel.isHidden = !cellItems.isEmpty
            })
            .disposed(by: disposeBag)
        
        listButtonSelected
            .asDriver()
            .drive(with: self,
                   onNext: { owner, list in
                owner.activityIndicatorView.startAnimating()
                owner.requestItems()
                owner.cancelImageDownloadingOfCells()
            })
            .disposed(by: disposeBag)
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        
        let image = UIImage(named: "img_logo_search")
        searchBar.setImage(image, for: .search, state: .normal)
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.setValue("취소", forKey: "cancelButtonText")
        searchBar.tintColor = .jpGray2
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
        let newLayout: UICollectionViewLayout = {
            switch list {
            case .recruit:
                return recruitCollectionViewFlowLayout
            case .cell:
                return companyCollectionViewFlowLayout
            }
        }()
        
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.collectionViewLayout = newLayout
        collectionView.collectionViewLayout.invalidateLayout()
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
    
    func pushRecruitDetailViewController(with recruitItem: RecruitItem) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: RecruitDetailViewController.identifier) as? RecruitDetailViewController else {
            return
        }
        
        detailVC.recruitItem = recruitItem
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func pushCompanyDetailViewController(with companyItem: CellItemCompany) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: CompanyDetailViewController.identifier) as? CompanyDetailViewController else {
            return
        }
        
        detailVC.company = companyItem
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
