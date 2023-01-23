//
//  HomeViewController+UICollectionView.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/22.
//

import UIKit
import RxSwift


// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch listButtonSelectedValue {
        case .recruit:
            return recruitItems.count
        case .cell:
            return cellItems.count
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
            let cellItem = cellItems[indexPath.row]
            
            if cellItem is CellItemCompany {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyCollectionViewCell.identifier, for: indexPath) as? CompanyCollectionViewCell,
                      let cellItem = cellItem as? CellItemCompany else {
                    return UICollectionViewCell()
                }
                
                cell.setupCell(with: cellItem)
                return cell
            } else if cellItem is CellItemReview {
                // TODO: 추후 CompanyReview에 관한 기획 후, 개발 예정
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyCollectionViewCell.identifier, for: indexPath) as? CompanyCollectionViewCell else {
                    return UICollectionViewCell()
                }
                return cell
            } else if cellItem is CellItemHorizontalTheme {
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalThemeCollectionViewCell.identifier, for: indexPath) as? HorizontalThemeCollectionViewCell,
                      let cellItem = cellItem as? CellItemHorizontalTheme else {
                    return UICollectionViewCell()
                }
                
                cell.setupCell(with: cellItem)
                return cell
            }
            
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: RecruitCompanyButtonsCollectionReusableView.identifier,
                                                                               for: indexPath) as? RecruitCompanyButtonsCollectionReusableView else {
            return UICollectionReusableView()
        }
        
        headerView.delegate = { [weak self] list in
            self?.listButtonSelected.accept(list)
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let identifer: String = {
            switch listButtonSelectedValue {
            case .recruit:
                return RecruitCollectionViewCell.identifier
            case .cell:
                let cellItem = cellItems[indexPath.row]
                if cellItem is CellItemCompany {
                    return CompanyCollectionViewCell.identifier
                } else if cellItem is HorizontalThemeCollectionViewCell {
                    return HorizontalThemeCollectionViewCell.identifier
                } else {
                    return ""
                }
            }
        }()
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifer, for: indexPath) as? CellImageDownloadCancelling else {
            return
        }
        
        cell.cancelDownloadImage()
    }
}


// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
}
