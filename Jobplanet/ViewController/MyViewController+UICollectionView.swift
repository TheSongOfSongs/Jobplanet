//
//  MyViewController+UICollectionView.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/25.
//

import UIKit

extension MyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recruits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecruitCollectionViewCell.identifier, for: indexPath) as? RecruitCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = recruits[indexPath.row]
        cell.setupCell(with: recruits[indexPath.row])
        cell.bookMarkDelegate = { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.performBatchUpdates ({
                self.viewModel.deleteBookMark(recruitItem: item)
                self.collectionView.deleteItems(at: [indexPath])
                self.recruits.remove(at: indexPath.row)
            }) { _ in
                self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            }
            
        }
        return cell
    }
}


extension MyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: RecruitDetailViewController.identifier) as? RecruitDetailViewController else {
            return
        }
        
        detailVC.recruitItem = recruits[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInset.left * 2.0 + minSpacing * (itemsPerRow - 1.0)
        let width = (view.frame.width - paddingSpace) / itemsPerRow
        return CGSize(width: width, height: width * 226 / 160)
    }
}
