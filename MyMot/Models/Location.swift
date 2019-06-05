//
//  Location.swift
//  MyMot
//
//  Created by Michail Solyanic on 04/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Location {
    
    static func createOrUpdateRegions(regionsJson: [JSON]) {
        for regionJson in regionsJson {
            _ = createOrUpdateLocation(json: regionJson, parentId: nil)
        }
    }
    
    static func createOrUpdateRegionCities(region: Location, citiesJson: [JSON]) {
        var cities: [Location] = []
        for cityJson in citiesJson {
            if let city = createOrUpdateLocation(json: cityJson, parentId: Int(region.id)) {
                cities.append(city)
            }
        }
        region.cities = NSSet(array: cities)
    }
    
    
    private static func createOrUpdateLocation(json: JSON, parentId: Int?) -> Location? {
        guard let dict = json.dictionary, let id = dict["id"]?.int, let name = dict["name"]?.string else { return nil }
    
        var location: Location?
        if let coreLocation = CoreDataManager.instance.getLocationById(id) {
            location = coreLocation
        } else {
            location = Location.init(context: CoreDataManager.instance.persistentContainer.viewContext)
            location?.id = Int32(id)
        }
        
        location?.name = name
        location?.sort = Int32(dict["sort"]?.int ?? 0)
        location?.avito = dict["avito"]?.string
        location?.autoru = dict["autoru"]?.string
        
        if let parentId = parentId, let region = CoreDataManager.instance.getLocationById(parentId) {
            location?.region = region
        }
        return location
    }
    
    func getCities() -> [Location] {
        return CoreDataManager.instance.getRegionCities(regionId: Int(id))
    }
}
