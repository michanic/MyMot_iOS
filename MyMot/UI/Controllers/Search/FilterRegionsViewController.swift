//
//  FilterRegionsViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 17/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class FilterRegionsViewController: UniversalViewController {

    var regionsMap: [Int:(Bool, [Cell])] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarTitle = "Регион"
    }

    override func prepareData() {
        dataSource = []
        var sectionIndex = 0
        for region in CoreDataManager.instance.getRegions() {
            let section = Section()
            
            let regionCell = Cell(simpleTitle: region.name, expanded: false)
            regionCell.cellTapped = { indexPath in
                self.regionPressed(index: sectionIndex)
            }
            section.cells.append(regionCell)
            
            var cityCells: [Cell] = []
            let allRegionCell = Cell(simpleTitle: "Все города")
            cityCells.append(allRegionCell)
            for city in region.getCities() {
                let cityCell = Cell(simpleTitle: city.name ?? "")
                cityCells.append(cityCell)
            }
            regionsMap[sectionIndex] = (false, cityCells)
            
            section.cells.append(contentsOf: cityCells)
            
            dataSource.append(section)
            sectionIndex += 1
        }
    }
    
    func regionPressed(index: Int) {
        print(index)
    }
}
