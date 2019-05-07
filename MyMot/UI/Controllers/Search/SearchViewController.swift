//
//  SearchViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 02/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class SearchViewController: UniversalViewController, UniversalViewControllerRefreshing {
    
    var refreshCompletionHandler: (() -> Void)?

    let searchController = UISearchController(searchResultsController: nil)
    lazy var filterButton = UIBarButtonItem(image: UIImage(named: "nav_filter"), style: .plain, target: self, action: #selector(showFilter))
    
    var searchDataSource = SearchModelDataSource()
    lazy var searchTableView: TableView = TableView(dataSourceDelegate: searchDataSource, frame: customCollectionView!.bounds)
    
    override func viewDidLoad() {
        dataSource = [Section()]
        self.refreshDelegate = self
        super.viewDidLoad()
        
        self.navigationItem.titleView = searchController.searchBar
        
        searchController.searchBar.barStyle = .blackOpaque
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Введите модель или объем"
        searchController.searchBar.setSearchButtonText("Отмена")
        searchController.searchBar.setPlaceholderColor(UIColor.white)
        searchController.searchBar.setImage(UIImage(named: "search_clear"), for: .clear, state: .normal)
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor.white

        self.navigationItem.rightBarButtonItem = filterButton
        
        self.view.addSubview(searchTableView)
        searchTableView.isHidden = true
        hideKeyboardByTouchView = searchTableView
        
        hideKeyboardPressed = {
            self.searchController.searchBar.resignFirstResponder()
        }
        searchDataSource.modelSelected = { model in
            var searchConfig = ConfigStorage.getFilterConfig()
            searchConfig.selectedModel = model
            ConfigStorage.saveFilterConfig(searchConfig)
            Router.shared.pushController(ViewControllerFactory.searchResults(searchConfig).create)
        }
    }
    
    func refreshPulled() {
        prepareData()
    }
    
    override func prepareData() {
        
        if refreshCompletionHandler == nil {
            showLoading()
        }
        
        let sitesInteractor = SitesInteractor()
        sitesInteractor.loadFeedAdverts(page: 1) { (adverts, loadMore) in
            
            let section = Section()
            section.cells.append(Cell(collectionTitle: "Все подряд"))
        
            let newAdverts = adverts.count % 2 != 0 ? adverts.dropLast() : adverts
            
            for advert in newAdverts {
                let advertCell = Cell(searchFeedAdvert: advert)
                section.cells.append(advertCell)
            }
            
            self.dataSource = [section]
            self.refreshCompletionHandler?()
            self.updateData()
            self.hideLoading()
        }
        
    }
    
    func showSearchResults(searchText: String) {
        if searchText.count == 0 {
            searchTableView.isHidden = true
            customCollectionView?.isScrollEnabled = true
        } else {
            searchDataSource.updateWithText(searchText: searchText)
            searchTableView.isHidden = false
            searchTableView.frame = customCollectionView!.frame
            customCollectionView?.isScrollEnabled = false
            searchTableView.reloadData()
        }
    }
    
    @objc func showFilter() {
        view.endEditing(true)
        searchController.searchBar.resignFirstResponder()
        let searchCallback: ((SearchFilterConfig) -> ())  = { config in
            Router.shared.pushController(ViewControllerFactory.searchResults(config).create)
        }
        Router.shared.presentController(ViewControllerFactory.searchFilter(nil, searchCallback).create)
    }
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        showSearchResults(searchText: "")
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showSearchResults(searchText: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationItem.rightBarButtonItem = nil
    }
    
}
