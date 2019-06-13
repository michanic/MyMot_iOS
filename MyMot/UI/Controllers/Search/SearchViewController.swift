//
//  SearchViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 02/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class SearchViewController: UniversalViewController, UniversalViewControllerLoadMore, UniversalViewControllerRefreshing {
    
    var loadMoreCompletionHandler: (() -> Void)?
    var currentPage: Int = 1
    var loadMoreAvailable: Bool = false
    var refreshCompletionHandler: (() -> Void)?
    
    var currentSource: Source?
    var avitoLoadMoreAvailable: Bool = true
    let sitesInteractor = SitesInteractor()
    
    let searchController = UISearchController(searchResultsController: nil)
    lazy var filterButton = UIBarButtonItem(image: UIImage(named: "nav_filter"), style: .plain, target: self, action: #selector(showFilter))
    
    var searchDataSource = SearchModelDataSource()
    lazy var searchTableView: TableView = TableView(dataSourceDelegate: searchDataSource, frame: customCollectionView!.bounds)
    
    override func viewDidLoad() {
        dataSource = [Section()]
        self.loadMoreDelegate = self
        //self.refreshDelegate = self
        super.viewDidLoad()
        
        self.navigationItem.titleView = searchController.searchBar
        
        searchController.searchBar.barStyle = .blackOpaque
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Модель или объем"
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
    
    override func prepareData() {
        if refreshCompletionHandler == nil {
            showLoading()
        }
        currentSource = nil
        avitoLoadMoreAvailable = true
        currentPage = 1
        loadMore()
    }
    
    func refreshPulled() {
        prepareData()
    }
    
    func loadMore() {
        
        let config = ConfigStorage.getFilterConfig()
        
        if let currentSource = currentSource {
            if currentSource.domain.contains("avito"), avitoLoadMoreAvailable {
                self.currentSource = Source.auto_ru(config.selectedRegion?.autoru, nil, config.priceFrom, config.priceFor, currentPage)
            } else {
                if avitoLoadMoreAvailable {
                    currentPage += 1
                    self.currentSource = Source.avito(config.selectedRegion?.avito, nil, config.priceFrom, config.priceFor, currentPage)
                } else {
                    self.currentSource = Source.auto_ru(config.selectedRegion?.autoru, nil, config.priceFrom, config.priceFor, currentPage)
                    currentPage += 1
                }
            }
        } else {
            currentSource = Source.avito(config.selectedRegion?.avito, nil, config.priceFrom, config.priceFor, currentPage)
        }
        
        sitesInteractor.loadFeedAdverts(source: currentSource!) { (adverts, loadMore) in
            
            var sectionTitle = "Все мотоциклы"
            if let selectedRegionName = config.selectedRegion?.name {
                sectionTitle = selectedRegionName
            }
            if let priceFrom = config.priceFrom {
                if let priceFor = config.priceFor {
                    sectionTitle += ",\n" + priceFrom.splitThousands() + " - " + priceFor.splitThousands() + " руб."
                } else {
                    sectionTitle += ",\nЦена от " + priceFrom.splitThousands() + " руб."
                }
            } else if let priceFor = config.priceFor {
                sectionTitle += ",\nЦена до " + priceFor.splitThousands() + " руб."
            }
            if adverts.count == 0 {
                sectionTitle = "Ничего не найдено"
            }
            
            if self.currentPage == 1 && self.currentSource!.domain.contains("avito") {
                let section = Section()
                section.cells.append(Cell(collectionTitle: sectionTitle))
                self.dataSource = [section]
            } else {
                self.dataSource[0].cells[0] = Cell(collectionTitle: sectionTitle)
            }
            
            let newAdverts = adverts.count % 2 != 0 ? adverts.dropLast() : adverts
            for advert in newAdverts {
                let advertCell = Cell(searchFeedAdvert: advert)
                self.dataSource[0].cells.append(advertCell)
            }
            
            /*if self.currentPage == 1 {
                self.refreshCompletionHandler?()
            }*/
            
            if self.currentSource!.domain.contains("avito") {
                self.avitoLoadMoreAvailable = loadMore
                self.loadMoreAvailable = true
            } else {
                self.loadMoreAvailable = loadMore
            }
    
            
            self.loadMoreCompletionHandler?()
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
        let searchClosedCallback: ((SearchFilterConfig?) -> ())  = { config in
            if config != nil {
                self.prepareData()
            }
        }
        //let navController = NavigationController(rootViewController: ViewControllerFactory.searchFilter(nil, nil, searchClosedCallback).create)
        //Router.shared.presentController(navController)
        Router.shared.pushController(ViewControllerFactory.searchFilter(nil, nil, searchClosedCallback).create)
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
