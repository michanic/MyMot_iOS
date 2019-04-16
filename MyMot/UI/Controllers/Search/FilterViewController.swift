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
        let regionCell = Cell(simpleTitle: "Край")
        sectionRegion.cells = [regionCell]
        
        let sectionModel = Section()
        sectionModel.headerProperties.title = "Модель"
        let modelCell = Cell(simpleTitle: "Любая")
        sectionModel.cells = [modelCell]
        
        let sectionPrice = Section()
        sectionPrice.headerProperties.title = "Цена"
        let priceFromCell = Cell(propertyTitle: "От", propertyValue: "0", keyboardType: .numberPad)
        let priceForCell = Cell(propertyTitle: "До", propertyValue: "0", keyboardType: .numberPad)
        sectionPrice.cells = [priceFromCell, priceForCell]
        
        dataSource = [sectionRegion, sectionModel, sectionPrice]
        
    }
    
    @IBAction func searchAction(_ sender: Any) {
        close()
    }
    

}
