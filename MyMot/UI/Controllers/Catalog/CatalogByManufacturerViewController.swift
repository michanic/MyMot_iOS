//
//  CatalogByManufacturerViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 10/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class CatalogByManufacturerViewController: UniversalViewController {

    let manufacturer: Manufacturer
    
    init(manufacturer: Manufacturer) {
        self.manufacturer = manufacturer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarTitle = manufacturer.name ?? ""
    }
    
    override func prepareData() {
        for category in CoreDataManager.instance.getCategories() {
            
            let models = category.getModelsOfManufacturer(manufacturer)
            if models.count > 0 {
                
                let section = Section()
                section.headerProperties.title = category.name?.uppercased()
                
                for model in models {
                    let modelCell = Cell(modelsList: model, accessoryState: .right)
                    section.cells.append(modelCell)
                }
                dataSource.append(section)
            }
            
        }
    }
}
