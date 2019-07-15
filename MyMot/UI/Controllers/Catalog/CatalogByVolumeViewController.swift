//
//  CatalogByVolumeViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 15/07/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class CatalogByVolumeViewController: UniversalViewController {

    let volume: Volume
    
    init(volume: Volume) {
        self.volume = volume
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarTitle = volume.name ?? ""
    }
    
    override func prepareData() {
        for manufacturer in CoreDataManager.instance.getManufacturers() {
            
            let models = manufacturer.getModelsOfVolume(volume)
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
