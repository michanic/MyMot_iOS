//
//  SearchViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 02/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class SearchViewController: UniversalViewController {

    let searchController = UISearchController(searchResultsController: nil)
    lazy var filterButton = UIBarButtonItem(image: UIImage(named: "nav_filter"), style: .plain, target: self, action: #selector(showFilter))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = searchController.searchBar
        
        searchController.searchBar.barStyle = .blackOpaque
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск по модели"
        searchController.searchBar.setSearchButtonText("Отмена")
        searchController.searchBar.setPlaceholderColor(UIColor.white)
        searchController.searchBar.delegate = self
        
        searchController.searchBar.tintColor = UIColor.white

        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    override func prepareData() {
        dataSource = [Section()]
        /*showLoading()
        
        let sitesInteractor = SitesInteractor()
        sitesInteractor.loadFeedAdverts(ofSource: .avito("rossiya")) { (adverts) in
            let section = Section()
            section.cells.append(Cell(collectionTitle: "Все подряд"))
            
            if let adverts = adverts {
                for advert in adverts {
                    let advertCell = Cell(searchFeedAdvert: advert)
                    section.cells.append(advertCell)
                }
            }
            
            self.dataSource = [section]
            self.updateData()
            self.hideLoading()
        }*/
        
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
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
        //searchController.searchBar.resignFirstResponder()
        //view.endEditing(true)
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        print("searchBarSearchButtonClicked")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchBarTextDidEndEditing")
        print(searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationItem.rightBarButtonItem = nil
    }
    
}
