//
//  FilterRegionsViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 17/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class FilterRegionsViewController: UniversalViewController {

    let apiInteractor = ApiInteractor()
    var regionsMap: [Int:(Bool, Int, [Cell])] = [:]
    var regions = CoreDataManager.instance.getRegions()
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
        for region in regions {
            let section = Section()
            
            let cellsContent = createCityCells(region: region, sectionIndex: sectionIndex)
            regionsMap[Int(region.id)] = (cellsContent.1, sectionIndex, cellsContent.0)
            section.cells.append(createRegionCell(region))
            if cellsContent.1 {
                section.cells.append(contentsOf: cellsContent.0)
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
            self.regionPressed(region, indexPath: indexPath)
        }
        return regionCell
    }
    
    private func createCityCells(region: Location, sectionIndex: Int) -> ([Cell], Bool) {
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
            cityCells.append(createCityCell(city: city, checked: cityChecked))
            row += 1
        }
        return (cityCells, regionExpanded)
    }
    
    private func createCityCell(city: Location, checked: Bool) -> Cell {
        let cityCell = Cell(simpleTitle: city.name, accessoryState: checked ? .checked : .hidden, level: 2)
        cityCell.cellTapped = { indexPath in
            self.goBack()
            self.selectedCallback?(city)
        }
        return cityCell
    }
    
    private func regionPressed(_ region: Location, indexPath: IndexPath?) {
        
        guard let regionCells: (Bool, Int, [Cell]) = regionsMap[Int(region.id)] else { return }
        if regionCells.0 { // expanded
            dataSource[regionCells.1].cells.removeLast(regionCells.2.count)
            regionsMap[Int(region.id)] = (!regionCells.0, regionCells.1, regionCells.2)
            dataSource[regionCells.1].cells[0] = createRegionCell(region)
            updateSections(sections: [regionCells.1])
        } else {
            guard let indexPath = indexPath else { return }
            if region.getCities().count == 0 {
                updateCellState(indexPath: indexPath, state: .loading)
            }
            self.apiInteractor.loadRegionCities(region) { (cities) in
                
                let cellsContent = self.createCityCells(region: region, sectionIndex: indexPath.section)
                
                self.dataSource[regionCells.1].cells.append(contentsOf: cellsContent.0)
                self.regionsMap[Int(region.id)] = (!regionCells.0, regionCells.1, cellsContent.0)
                self.dataSource[regionCells.1].cells[0] = self.createRegionCell(region)
                self.updateSections(sections: [regionCells.1])
                
            }
        }
        
    }
    
    private func updateCellState(indexPath: IndexPath, state: CellAccessoryType) {
        if let cell = tableView.cellForRow(at: indexPath) as? SimpleCell {
            cell.setAccessoryState(state)
            let cellModel = dataSource[indexPath.section].cells[indexPath.row]
            if let content = cellModel.content as? (String?, CellAccessoryType, Int) {
                cellModel.content = (content.0, state, content.2)
            }
        }
    }
    
}
