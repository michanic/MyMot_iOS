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
            }
            
            manufacturer?.id = Int32(id)
            manufacturer?.name = name
            manufacturer?.code = dict["code"]?.string
            manufacturer?.sort = Int32(dict["sort"]?.int ?? 0)
            manufacturer?.image = dict["image"]?.string
            
            if let modelsJson = dict["models"]?.array, let manufacturer = manufacturer {
                Model.createOrUpdate(modelsJson: modelsJson, manufacturer: manufacturer)
            }
        }
    }
    
}
