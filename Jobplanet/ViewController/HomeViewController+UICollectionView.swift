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
            
            // Company
            if cellItem is CellItemCompany {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyCollectionViewCell.identifier, for: indexPath) as? CompanyCollectionViewCell,
                      let cellItem = cellItem as? CellItemCompany else {
                    return UICollectionViewCell()
                }
                
                cell.setupCell(with: cellItem)
                return cell
            
            // Horizontal_Theme
            } else if cellItem is CellItemHorizontalTheme {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalThemeCollectionViewCell.identifier, for: indexPath) as? HorizontalThemeCollectionViewCell,
                      let cellItem = cellItem as? CellItemHorizontalTheme else {
                    return UICollectionViewCell()
                }
                
                cell.setupCell(with: cellItem)
                cell.delegate = { [weak self] recruitItem in
                    self?.pushRecruitDetailViewController(with: recruitItem)
                }
                
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
}


// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch listButtonSelectedValue {
        case .recruit:
            pushRecruitDetailViewController(with: recruitItems[indexPath.row])
        case .cell:
            guard let item = cellItems[indexPath.row] as? CellItemCompany else {
                return
            }
            pushCompanyDetailViewController(with: item)
        }
    }
}
