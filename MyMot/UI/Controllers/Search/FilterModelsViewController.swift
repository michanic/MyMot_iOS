//
//  FilterModelsViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 17/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class FilterModelsViewController: UniversalViewController {

    var catalogMap: [Int:(Bool, [Model])] = [:]
    let categories = CoreDataManager.instance.getCategories()
    var selectedModel: Model?
    var selectedManufacturer: Manufacturer?
    var selectedCallback: ((Model?, Manufacturer?) -> ())?
    
    init(selectedModel: Model?, selectedManufacturer: Manufacturer?, selectedCallback: ((Model?, Manufacturer?) -> ())?) {
        self.selectedModel = selectedModel
        self.selectedManufacturer = selectedManufacturer
        self.selectedCallback = selectedCallback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarTitle = "Модель"
    }

    override func prepareData() {
        dataSource = []
        
        let sectionAll = Section()
        let allModelsCell = Cell(simpleTitle: "Все мотоциклы", accessoryState: (selectedModel == nil && selectedManufacturer == nil) ? .checked : .hidden, level: 1)
        allModelsCell.cellTapped = { indexPath in
            self.goBack()
            self.selectedCallback?(nil, nil)
        }
        sectionAll.cells.append(allModelsCell)
        dataSource.append(sectionAll)
        
        var sectionIndex = 1
        for manufacturer in CoreDataManager.instance.getManufacturers() {
            let section = Section()
            section.headerProperties.title = manufacturer.name
            
            var state: CellAccessoryType = .hidden
            if let selectedManufacturer = selectedManufacturer, selectedManufacturer.id == manufacturer.id {
                state = .checked
                startScrollTo = IndexPath(row: 0, section: sectionIndex)
            }
            var cellName = "Все"
            if let manufacturerName =  manufacturer.name {
                cellName = "Все мотоциклы " + manufacturerName
            }
            let allCategoriesCell = Cell(simpleTitle: cellName, accessoryState: state, level: 1)
            allCategoriesCell.cellTapped = { indexPath in
                self.goBack()
                self.selectedCallback?(nil, manufacturer)
            }
            section.cells.append(allCategoriesCell)
            dataSource.append(section)
            sectionIndex += 1
            
            for category in categories {
                var expanded = false
                let categoryModels = manufacturer.getModelsOfCategory(category)
                if categoryModels.count > 0 {
                    if let selectedModel = selectedModel, selectedModel.category?.id == category.id, selectedModel.manufacturer?.id == manufacturer.id {
                        expanded = true
                        var row = 1
                        for model in categoryModels {
                            if selectedModel.id == model.id {
                                startScrollTo = IndexPath(row: row, section: sectionIndex)
                            }
                            row += 1
                        }
                    }
                    catalogMap[sectionIndex] = (expanded, categoryModels)
                    let sectionCategory = Section()
                    sectionCategory.cells.append(createCategoryCell(categoryName: category.name, sectionIndex: sectionIndex))
                    
                    if expanded {
                        sectionCategory.cells.append(contentsOf: createModelCells(categoryModels))
                        
                    }

                    dataSource.append(sectionCategory)
                    sectionIndex += 1
                }
            }
            
        }
        
    }
    
    private func createCategoryCell(categoryName: String?, sectionIndex: Int) -> Cell {
        var accessoryState: CellAccessoryType = .bottom
        if let mapRow: (Bool, [Model]) = catalogMap[sectionIndex], mapRow.0 {
            accessoryState = .top
        }
        
        let categoryCell = Cell(simpleTitle: categoryName, accessoryState: accessoryState, level: 1)
        categoryCell.cellTapped = { indexPath in
            if let indexPath = indexPath {
                self.categoryPressed(indexPath: indexPath)
            }
        }
        return categoryCell
    }
    
    private func createModelCells(_ models: [Model]) -> [Cell] {
        var cells: [Cell] = []
        for model in models {
            var state: CellAccessoryType = .hidden
            if let selectedModel = selectedModel, selectedModel.id == model.id {
                state = .checked
            }
            let modelCell = Cell(modelsList: model, accessoryState: state)
            modelCell.cellTapped = { indexPath in
                self.goBack()
                self.selectedCallback?(model, nil)
            }
            cells.append(modelCell)
        }
        return cells
    }
    
    private func categoryPressed(indexPath: IndexPath) {
        
        guard let mapRow: (Bool, [Model]) = catalogMap[indexPath.section] else { return }
        let categoryName: String? = mapRow.1.first?.category?.name
        if mapRow.0 { // expanded
            dataSource[indexPath.section].cells.removeLast(mapRow.1.count)
        } else {
            dataSource[indexPath.section].cells.insert(contentsOf: createModelCells(mapRow.1), at: indexPath.row + 1)
        }
        catalogMap[indexPath.section] = (!mapRow.0, mapRow.1)
        dataSource[indexPath.section].cells[indexPath.row] = createCategoryCell(categoryName: categoryName, sectionIndex: indexPath.section)
        updateSections(sections: [indexPath.section])
    }
    
}
