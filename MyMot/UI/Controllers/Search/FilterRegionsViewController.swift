//
//  FilterRegionsViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 17/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class FilterRegionsViewController: UniversalViewController {

    var regionsMap: [Int:(Bool, Int, [Cell])] = [:]
    var selectedRegion: Location?
    var selectedCallback: ((Location?) -> ())?
    
    init(selectedRegion: Location?, selectedCallback: ((Location?) -> ())?) {
        self.selectedRegion = selectedRegion
        self.selectedCallback = selectedCallback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarTitle = "Регион"
    }

    override func prepareData() {
        dataSource = []
        
        let sectionAll = Section()
        let allCountryCell = Cell(simpleTitle: "По всей России", accessoryState: selectedRegion == nil ? .checked : .hidden, level: 1)
        allCountryCell.cellTapped = { indexPath in
            self.goBack()
            self.selectedCallback?(nil)
        }
        sectionAll.cells.append(allCountryCell)
        dataSource.append(sectionAll)
        
        var sectionIndex = 1
        for region in CoreDataManager.instance.getRegions() {
            let section = Section()
            var regionExpanded = false
            
            var cityCells: [Cell] = []
            if let selectedRegion = selectedRegion, selectedRegion.id == region.id {
                regionExpanded = true
                startScrollTo = IndexPath(row: 1, section: sectionIndex)
            }
            let allRegionCell = Cell(simpleTitle: "Все города", accessoryState: regionExpanded ? .checked : .hidden, level: 2)
            allRegionCell.cellTapped = { indexPath in
                self.goBack()
                self.selectedCallback?(region)
            }
            cityCells.append(allRegionCell)
            
            var row = 2
            for city in region.getCities() {
                var cityChecked = false
                if let selectedRegion = selectedRegion, selectedRegion.id == city.id {
                    cityChecked = true
                    regionExpanded = true
                    startScrollTo = IndexPath(row: row, section: sectionIndex)
                }
                let cityCell = Cell(simpleTitle: city.name, accessoryState: cityChecked ? .checked : .hidden, level: 2)
                cityCell.cellTapped = { indexPath in
                    self.goBack()
                    self.selectedCallback?(city)
                }
                cityCells.append(cityCell)
                row += 1
            }
            
            regionsMap[Int(region.id)] = (regionExpanded, sectionIndex, cityCells)
            
            section.cells.append(createRegionCell(region))
            if regionExpanded {
                section.cells.append(contentsOf: cityCells)
            }
            
            dataSource.append(section)
            sectionIndex += 1
        }
    }
    
    private func createRegionCell(_ region: Location) -> Cell {
        var accessoryState: CellAccessoryType = .bottom
        if let regionCells: (Bool, Int, [Cell]) = regionsMap[Int(region.id)], regionCells.0 {
            accessoryState = .top
        }
        
        let regionCell = Cell(simpleTitle: region.name, accessoryState: accessoryState, level: 1)
        regionCell.cellTapped = { indexPath in
            self.regionPressed(region)
        }
        return regionCell
    }
    
    private func regionPressed(_ region: Location) {
        
        guard let regionCells: (Bool, Int, [Cell]) = regionsMap[Int(region.id)] else { return }
        
        if regionCells.0 { // expanded
            dataSource[regionCells.1].cells.removeLast(regionCells.2.count)
        } else {
            dataSource[regionCells.1].cells.append(contentsOf: regionCells.2)
        }
        regionsMap[Int(region.id)] = (!regionCells.0, regionCells.1, regionCells.2)
        
        dataSource[regionCells.1].cells[0] = createRegionCell(region)
        updateSections(sections: [regionCells.1])
    }
}
