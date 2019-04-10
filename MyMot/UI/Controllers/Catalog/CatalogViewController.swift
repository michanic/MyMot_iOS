//
//  CatalogViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 02/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class CatalogViewController: UniversalViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func prepareData() {
        let section = Section()
        
        let categoriesCell = Cell(categoriesSliderTitle: "По классам", categories: CoreDataManager.instance.getCategories())
        
        let manufacturersCell = Cell(manufacturersSliderTitle: "По производителю", content: CoreDataManager.instance.getManufacturers())
        
        section.cells = [categoriesCell, manufacturersCell]
        dataSource = [section]
        
    }
}
