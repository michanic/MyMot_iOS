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
        let modelCell = Cell(simpleTitle: "Любая")
        modelCell.cellTapped = { indexPath in
            Router.shared.pushController(ViewControllerFactory.searchFilterModels.create)
        }
        sectionModel.cells = [modelCell]
        
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
    
    @IBAction func searchAction(_ sender: Any) {
        close()
    }
    

}
