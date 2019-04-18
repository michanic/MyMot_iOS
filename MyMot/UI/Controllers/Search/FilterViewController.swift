//
//  FilterViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 16/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class FilterViewController: UniversalViewController {

    @IBOutlet weak var searchButon: UIButton!
    var selectedRegion: Location?
    var selectedManufacturer: Manufacturer?
    var selectedModel: Model?
    
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
        let priceFromCell = Cell(propertyTitle: "От", propertyValue: "0", keyboardType: .numberPad)
        let priceForCell = Cell(propertyTitle: "До", propertyValue: "0", keyboardType: .numberPad)
        sectionPrice.cells = [priceFromCell, priceForCell]
        
        dataSource = [sectionRegion, sectionModel, sectionPrice]
        
    }
    
    func selectedRegionCell() -> Cell {
        let selectedRegionTitle = selectedRegion?.name ?? "По всей России"
        let regionCell = Cell(simpleTitle: selectedRegionTitle)
        let regionSelectedCallback: ((Location?) -> ())? = { locaion in
            self.selectedRegion = locaion
            self.dataSource[0].cells = [self.selectedRegionCell()]
            self.updateRows(indexPaths: [IndexPath(row: 0, section: 0)])
        }
        regionCell.cellTapped = { indexPath in
            Router.shared.pushController(ViewControllerFactory.searchFilterRegions(self.selectedRegion, regionSelectedCallback).create)
        }
        return regionCell
    }
    
    func selectedModelCell() -> Cell {
        var selectedTitle = "Любая"
        if let selectedModelName = selectedModel?.name {
            selectedTitle = selectedModelName
        } else if let selectedManufacturerName = selectedManufacturer?.name {
            selectedTitle = selectedManufacturerName
        }
        
        let modelCell = Cell(simpleTitle: selectedTitle)
        let selectedCallback: ((Model?, Manufacturer?) -> ())? = { (model, manufacturer) in
            self.selectedModel = model
            self.selectedManufacturer = manufacturer
            self.dataSource[1].cells = [self.selectedModelCell()]
            self.updateRows(indexPaths: [IndexPath(row: 0, section: 1)])
        }
        modelCell.cellTapped = { indexPath in
            Router.shared.pushController(ViewControllerFactory.searchFilterModels(self.selectedModel, self.selectedManufacturer, selectedCallback).create)
        }
        return modelCell
    }
    
    @IBAction func searchAction(_ sender: Any) {
        close()
    }
    

}
