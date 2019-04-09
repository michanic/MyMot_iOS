//
//  CatalogViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 02/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class CatalogViewController: UIViewController, TableViewUniversalDelegate {

    var dataSource: [Section] = []
    
    lazy var tableView: TableView = {
        return TableView(universalDelegate: self, frame: self.view.bounds, style: .plain)
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCells()
        view.addSubview(tableView)
    }
    
    func createCells() {
        dataSource = []
        for manufacturer in CoreDataManager.instance.getManufacturers() {
            let models = manufacturer.getSotredModels()
            if models.count > 0 {
                
                let section = Section()
                section.headerProperties.title = manufacturer.name?.uppercased()
                
                for model in models {
                    let modelCell = Cell(modelsList: model)
                    section.cells.append(modelCell)
                }
                
                dataSource.append(section)
            }
        }
    }
    
}
