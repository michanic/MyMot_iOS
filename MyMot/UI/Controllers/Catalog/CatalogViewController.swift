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
            let section = Section()
            section.headerProperties.title = manufacturer.name
            
            let modelCell = Cell(cellType: .modelsList)
            section.cells.append(modelCell)
            
            dataSource.append(section)
        }
    }
    
}
