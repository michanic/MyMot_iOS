//
//  FilterViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 16/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

struct SearchFilterConfig {
    
    var selectedRegion: Location?
    var selectedManufacturer: Manufacturer?
    var selectedModel: Model?
    var priceFrom: Int?
    var priceFor: Int?
    
}

class FilterViewController: UniversalViewController {

    @IBOutlet weak var searchButon: UIButton!
    
    var filterConfig: SearchFilterConfig
    var searchPressedCallback: ((SearchFilterConfig) -> ())?
    
    init(filterConfig: SearchFilterConfig?, searchPressedCallback: ((SearchFilterConfig) -> ())?) {
        if let filterConfig = filterConfig {
            self.filterConfig = filterConfig
        } else {
             self.filterConfig = ConfigStorage.getFilterConfig()
        }
        self.searchPressedCallback = searchPressedCallback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarTitle = "Фильтр"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.frame = self.view.bounds
        view.bringSubviewToFront(searchButon)
    }

    override func prepareData() {
        
        let sectionRegion = Section()
        sectionRegion.headerProperties.title = "Регион поиска"
        sectionRegion.cells = [selectedRegionCell()]
        
        let sectionModel = Section()
        sectionModel.headerProperties.title = "Модель"
        sectionModel.cells = [selectedModelCell()]
        
        let sectionPrice = Section()
        sectionPrice.headerProperties.title = "Цена"
        
        var priceFromString: String?
        if let priceFrom = filterConfig.priceFrom {
            priceFromString = String(priceFrom)
        }
        let priceFromCell = Cell(setPriceTitle: "От", value: priceFromString)
        priceFromCell.intChangedEvent = { newValue in
            self.filterConfig.priceFrom = newValue
            ConfigStorage.saveFilterConfig(self.filterConfig)
        }
        
        var priceForString: String?
        if let priceFor = filterConfig.priceFor {
            priceForString = String(priceFor)
        }
        let priceForCell = Cell(setPriceTitle: "До", value: priceForString)
        priceForCell.intChangedEvent = { newValue in
            self.filterConfig.priceFor = newValue
            ConfigStorage.saveFilterConfig(self.filterConfig)
        }
        sectionPrice.cells = [priceFromCell, priceForCell]
        
        dataSource = [sectionRegion, sectionModel, sectionPrice]
        
    }
    
    func selectedRegionCell() -> Cell {
        let selectedRegionTitle = filterConfig.selectedRegion?.name ?? "По всей России"
        let regionCell = Cell(simpleTitle: selectedRegionTitle)
        let regionSelectedCallback: ((Location?) -> ())? = { locaion in
            self.filterConfig.selectedRegion = locaion
            ConfigStorage.saveFilterConfig(self.filterConfig)
            self.dataSource[0].cells = [self.selectedRegionCell()]
            self.updateRows(indexPaths: [IndexPath(row: 0, section: 0)])
        }
        regionCell.cellTapped = { indexPath in
            Router.shared.pushController(ViewControllerFactory.searchFilterRegions(self.filterConfig.selectedRegion, regionSelectedCallback).create)
        }
        return regionCell
    }
    
    func selectedModelCell() -> Cell {
        var selectedTitle = "Любая"
        if let selectedModelName = filterConfig.selectedModel?.name {
            selectedTitle = selectedModelName
        } else if let selectedManufacturerName = filterConfig.selectedManufacturer?.name {
            selectedTitle = "Все мотоциклы " + selectedManufacturerName
        }
        
        let modelCell = Cell(simpleTitle: selectedTitle)
        let selectedCallback: ((Model?, Manufacturer?) -> ())? = { (model, manufacturer) in
            self.filterConfig.selectedModel = model
            self.filterConfig.selectedManufacturer = manufacturer
            ConfigStorage.saveFilterConfig(self.filterConfig)
            self.dataSource[1].cells = [self.selectedModelCell()]
            self.updateRows(indexPaths: [IndexPath(row: 0, section: 1)])
        }
        modelCell.cellTapped = { indexPath in
            Router.shared.pushController(ViewControllerFactory.searchFilterModels(self.filterConfig.selectedModel, self.filterConfig.selectedManufacturer, selectedCallback).create)
        }
        return modelCell
    }
    
    @IBAction func searchAction(_ sender: Any) {
        close()
        searchPressedCallback?(filterConfig)
    }
    

}
