//
//  SearchModelDataSource.swift
//  MyMot
//
//  Created by Michail Solyanic on 06/05/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class SearchModelDataSource: DataSource {

    var dataSource: [Section] = [Section()]
    var models: [Model] = []
    var modelSelected: ((Model) -> ())?
    
    func updateWithText(searchText: String) {
        models = CoreDataManager.instance.searchModelsByName(searchText)
        prepareData()
    }
    
    func prepareData() {
        if models.count > 0 {
            dataSource[0].cells = []
            for model in models {
                let modelCell = Cell(modelsList: model, accessoryState: .right)
                modelCell.cellTapped = { indexPath in
                    self.modelSelected?(model)
                }
                dataSource[0].cells.append(modelCell)
            }
        } else {
            let noResultsCell = Cell(simpleTitle: "Ничего не найдено", accessoryState: .hidden, level: 1)
            dataSource[0].cells = [noResultsCell]
        }
    }
    
}
