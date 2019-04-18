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
        let allModelsCell = Cell(simpleTitle: "Любая", accessoryState: selectedModel == nil ? .checked : .hidden)
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
            }
            let allCategoriesCell = Cell(simpleTitle: "Все", accessoryState: state)
            allCategoriesCell.cellTapped = { indexPath in
                self.goBack()
                self.selectedCallback?(nil, manufacturer)
            }
            section.cells.append(allCategoriesCell)
            dataSource.append(section)
            sectionIndex += 1
            
            //var rowIndex = 1
            for category in categories {
                let categoryModels = manufacturer.getModelsOfCategory(category)
                if categoryModels.count > 0 {
                    catalogMap[sectionIndex] = (false, categoryModels)
                    let sectionCategory = Section()
                    sectionCategory.cells.append(createCategoryCell(category, sectionIndex: sectionIndex))
                    //rowIndex += 1
                    dataSource.append(sectionCategory)
                    sectionIndex += 1
                }
            }
            
        }
        
    }
    
    private func createCategoryCell(_ category: Category, sectionIndex: Int) -> Cell {
        var accessoryState: CellAccessoryType = .bottom
        if let mapRow: (Bool, [Model]) = catalogMap[sectionIndex], mapRow.0 {
            accessoryState = .top
        }
        
        let categoryCell = Cell(simpleTitle: category.name, accessoryState: accessoryState)
        categoryCell.cellTapped = { indexPath in
            if let indexPath = indexPath {
                self.categoryPressed(indexPath: indexPath)
            }
        }
        return categoryCell
    }
    
    private func createModelCell(_ model: Model) -> Cell {
        var state: CellAccessoryType = .hidden
        if let selectedModel = selectedModel, selectedModel.id == model.id {
            state = .checked
        }
        let modelCell = Cell(modelsList: model, accessoryState: state)
        modelCell.cellTapped = { indexPath in
            self.goBack()
            self.selectedCallback?(model, nil)
        }
        return modelCell
    }
    
    private func categoryPressed(indexPath: IndexPath) {
        
        guard let mapRow: (Bool, [Model]) = catalogMap[indexPath.section] else { return }
        if mapRow.0 { // expanded
            dataSource[indexPath.section].cells.removeLast(mapRow.1.count)
        } else {
            var cells: [Cell] = []
            for model in mapRow.1 {
                cells.append(createModelCell(model))
            }
            dataSource[indexPath.section].cells.insert(contentsOf: cells, at: indexPath.row + 1)
        }
        catalogMap[indexPath.section] = (!mapRow.0, mapRow.1)
        //dataSource[indexPath.section].cells[indexPath.row] = createCategoryCell(categories[indexPath.row - 1], sectionIndex: indexPath.section)
        
        updateSections(sections: [indexPath.section])
    }
    
}
