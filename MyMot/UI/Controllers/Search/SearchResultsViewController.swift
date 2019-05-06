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
        updateTitle()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_filter"), style: .plain, target: self, action: #selector(showFilter))
    }

    override func prepareData() {
        dataSource = [Section()]
        showLoading()
        
        let sitesInteractor = SitesInteractor()
        sitesInteractor.searchAdverts(config: filterConfig) { (adverts) in
            
            if adverts.count > 0 {
                for advert in adverts {
                    let advertCell = Cell(advertsList: advert)
                    self.dataSource[0].cells.append(advertCell)
                }
            } else {
                let noResultsCell = Cell(simpleTitle: "Ничего не найдено", accessoryState: .hidden)
                self.dataSource[0].cells = [noResultsCell]
            }
            
            self.updateData()
            self.hideLoading()
        }
    }
    
    func updateTitle() {
        if let model = filterConfig.selectedModel, let name = model.name {
            navBarTitle = name
        } else if let manufacturer = filterConfig.selectedManufacturer, let name = manufacturer.name {
            navBarTitle = name
        } else {
            navBarTitle = "Результаты поиска"
        }
    }
    
    @objc func showFilter() {
        let searchCallback: ((SearchFilterConfig) -> ())  = { config in
            self.filterConfig = config
            self.prepareData()
        }
        Router.shared.presentController(ViewControllerFactory.searchFilter(nil, searchCallback).create)
    }
}
