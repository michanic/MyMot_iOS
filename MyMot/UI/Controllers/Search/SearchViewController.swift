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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск по модели"
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor.textLightGray
        searchController.searchBar.showsCancelButton = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_filter"), style: .plain, target: self, action: #selector(showFilter))
    }
    
    override func prepareData() {
        dataSource = [Section()]
        
        let sitesInteractor = SitesInteractor()
        sitesInteractor.loadFeedAdverts(ofSource: .avito("rossiya")) { (adverts) in
            if let adverts = adverts {
                for advert in adverts {
                    print(advert.title)
                }
            }
        }
        
    }
    
    @objc func showFilter() {
        view.endEditing(true)
        searchController.searchBar.resignFirstResponder()
        Router.shared.presentController(ViewControllerFactory.searchFilter.create)
    }
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
        searchController.searchBar.resignFirstResponder()
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        Delay(0) {
            self.searchController.searchBar.showsCancelButton = false
        }
    }
    
}
