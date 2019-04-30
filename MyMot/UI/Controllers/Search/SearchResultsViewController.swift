//
//  SearchResultsViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 30/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class SearchResultsViewController: UniversalViewController {

    var filterConfig: SearchFilterConfig
    
    init(filterConfig: SearchFilterConfig) {
        self.filterConfig = filterConfig
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarTitle = "Результаты поиска"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_filter"), style: .plain, target: self, action: #selector(showFilter))
    }

    override func prepareData() {
        dataSource = [Section()]
    }
    
    @objc func showFilter() {
        let searchCallback: ((SearchFilterConfig) -> ())  = { config in
            self.filterConfig = config
            // reload data
        }
        Router.shared.presentController(ViewControllerFactory.searchFilter(nil, searchCallback).create)
    }
}
