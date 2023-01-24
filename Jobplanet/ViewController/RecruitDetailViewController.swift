//
//  RecruitDetailViewController.swift
//  Jobplanet
//
//  Created by Jinhyang Kim on 2023/01/24.
//

import UIKit

class RecruitDetailViewController: UIViewController {
    
    var recruitItem: RecruitItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        guard let recruitItem = recruitItem else {
            return
        }
        
        title = recruitItem.title
        navigationController?.navigationBar.topItem?.title = ""
    }
}
