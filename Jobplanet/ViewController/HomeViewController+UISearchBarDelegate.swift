//
//  HomeViewController+UISearchBarDelegate.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/23.
//

import UIKit

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        requestItems()
    }
    }
}
