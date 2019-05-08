//
//  SearchResultsViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 30/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class SearchResultsViewController: UniversalViewController, UniversalViewControllerLoadMore {

    var filterConfig: SearchFilterConfig

    var loadMoreCompletionHandler: (() -> Void)?
    var currentPage: Int = 1
    var loadMoreAvailable: Bool = false
    
    init(filterConfig: SearchFilterConfig) {
        self.filterConfig = filterConfig
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        dataSource = [Section()]
        self.loadMoreDelegate = self
        super.viewDidLoad()
        
        updateTitle()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_filter"), style: .plain, target: self, action: #selector(showFilter))
        
        showLoading()
    }

    override func prepareData() {
        showLoading()
        currentPage = 1
        loadMore()
    }
    
    func loadMore() {
        
        let sitesInteractor = SitesInteractor()
        sitesInteractor.searchAdverts(page: currentPage, config: filterConfig) { (adverts, loadMore) in
            
            if self.currentPage == 1 {
                self.dataSource = [Section()]
            }
            
            if adverts.count > 0 {
                for advert in adverts {
                    let advertCell = Cell(advertsList: advert)
                    self.dataSource[0].cells.append(advertCell)
                }
            } else if self.currentPage == 1 {
                let noResultsCell = Cell(simpleTitle: "Ничего не найдено", accessoryState: .hidden)
                self.dataSource[0].cells = [noResultsCell]
            }
            
            self.loadMoreAvailable = loadMore
            self.currentPage += 1
            self.loadMoreCompletionHandler?()
            
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
