//
//  Manufacturer.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Manufacturer {
    
    static func createOrUpdate(manufacturersJson: [JSON]) {
        for manufacturerJson in manufacturersJson {
            guard let dict = manufacturerJson.dictionary, let id = dict["id"]?.int, let name = dict["name"]?.string else { break }
            
            var manufacturer: Manufacturer?
            if let coreManufacturer = CoreDataManager.instance.getManufacturerById(id) {
                manufacturer = coreManufacturer
            } else {
                manufacturer = Manufacturer.init(context: CoreDataManager.instance.persistentContainer.viewContext)
                manufacturer?.id = Int32(id)
            }
            
            manufacturer?.name = name
            manufacturer?.code = dict["code"]?.string
            manufacturer?.sort = Int32(dict["sort"]?.int ?? 0)
            manufacturer?.image = dict["image"]?.string
            
            if let modelsJson = dict["models"]?.array, let manufacturer = manufacturer {
                
                print(manufacturer.name! + " - " + String(modelsJson.count))
                
                Model.createOrUpdate(modelsJson: modelsJson, manufacturer: manufacturer)
            }
        }
    }
 
    func getModelsOfCategory(_ category: Category) -> [Model] {
        return CoreDataManager.instance.getManufacturerModels(self, ofCategory: category)
    }
}

extension Manufacturer {
    var avitoSearchName: String {
        return name?.replacingOccurrences(of: " ", with: "%20").lowercased() ?? ""
    }
    
    var autoruSearchName: String {
        return name?.replacingOccurrences(of: " ", with: "_").uppercased() ?? ""
    }
}


extension Cell {
    convenience init(manufacturersSliderTitle: String, content: [Manufacturer]) {
        self.init(cellType: .catalogSlider)
        self.content = (manufacturersSliderTitle, content)
    }
}
