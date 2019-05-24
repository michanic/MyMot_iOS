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
    var advertsMap: [String:Int] = [:]
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
    
    lazy var favouritesSwitchSubscriber = NotificationSubscriber(types: [.favouriteAdvertSwitched], received: { (object) in
        if let advert = object as? Advert {
            self.updateFavoutiteCell(advert: advert)
        }
    })
    
    override func viewDidLoad() {
        dataSource = [Section()]
        self.loadMoreDelegate = self
        super.viewDidLoad()
        NotificationCenter.subscribe(favouritesSwitchSubscriber)
        updateTitle()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_filter"), style: .plain, target: self, action: #selector(showFilter))
        showLoading()
    }

    override func prepareData() {
        showLoading()
        advertsMap = [:]
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
                    guard let advertId = advert.id else { return }
                    let advertCell = Cell(advertsList: advert)
                    advertCell.boolChangedEvent = { newValue in
                        if let newValue = newValue {
                            advert.favourite = newValue
                            CoreDataManager.instance.saveContext()
                            NotificationCenter.post(type: .favouriteAdvertSwitched, object: advert)
                        }
                    }
                    self.advertsMap[advertId] = self.dataSource[0].cells.count
                    self.dataSource[0].cells.append(advertCell)
                }
            } else if self.currentPage == 1 {
                let noResultsCell = Cell(simpleTitle: "Ничего не найдено", accessoryState: .hidden, level: 1)
                self.dataSource[0].cells = [noResultsCell]
            }
            
            self.loadMoreAvailable = loadMore
            self.loadMoreSetEnabled(loadMore)
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
    
    func updateFavoutiteCell(advert: Advert) {
        if let advertId = advert.id, let row = advertsMap[advertId], let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? AdvertsListCell {
            cell.updateFavouriteButton(favourite: advert.favourite)
        }
    }
    
    @objc func showFilter() {
        let searchCallback: ((SearchFilterConfig) -> ())  = { config in
            self.filterConfig = config
            self.updateTitle()
            self.prepareData()
        }
        let closedCallback: ((SearchFilterConfig?) -> ())  = { config in
            if let config = config {
                self.filterConfig = config
                self.updateTitle()
                self.prepareData()
            }
        }
        Router.shared.presentController(ViewControllerFactory.searchFilter(nil, searchCallback, closedCallback).create)
    }
}
