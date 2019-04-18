//
//  CatalogByClassViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 10/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class CatalogByClassViewController: UniversalViewController {

    let category: Category
    
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarTitle = category.name ?? ""
    }

    override func prepareData() {
        let section = Section()
        let categoryCell = Cell(categoryAbout: category)
        section.cells.append(categoryCell)
        dataSource.append(section)
        
        for manufacturer in CoreDataManager.instance.getManufacturers() {
            let models = manufacturer.getModelsOfCategory(category)
            if models.count > 0 {
                
                let section = Section()
                section.headerProperties.title = manufacturer.name?.uppercased()
                
                for model in models {
                    let modelCell = Cell(modelsList: model, accessoryState: .right)
                    section.cells.append(modelCell)
                }
                dataSource.append(section)
            }
        }
    }
    
}
