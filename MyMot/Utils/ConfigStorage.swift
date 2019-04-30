//
//  ConfigStorage.swift
//  MyMot
//
//  Created by Michail Solyanic on 25/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class ConfigStorage {

    static let shared : ConfigStorage = ConfigStorage()
    var exteptedWords: Set<String> = []
    var aboutText: String?
    
    static func saveFilterConfig(_ config: SearchFilterConfig) {
        
        let regionId = config.selectedRegion?.id ?? 0
        UserDefaults.standard.set(regionId, forKey: Keys.searchLocationId.rawValue)
        
        let manufacturerId = config.selectedManufacturer?.id ?? 0
        UserDefaults.standard.set(manufacturerId, forKey: Keys.searchManufacturerId.rawValue)
        
        let modelId = config.selectedModel?.id ?? 0
        UserDefaults.standard.set(modelId, forKey: Keys.searchModelId.rawValue)
        
        let priceFrom = config.priceFrom ?? 0
        UserDefaults.standard.set(priceFrom, forKey: Keys.searchPriceFrom.rawValue)
        
        let priceFor = config.priceFor ?? 0
        UserDefaults.standard.set(priceFor, forKey: Keys.searchPriceFor.rawValue)
        
        UserDefaults.standard.synchronize()
    }
    
    static func getFilterConfig() -> SearchFilterConfig {
        var config = SearchFilterConfig()
        if let region = CoreDataManager.instance.getLocationById(UserDefaults.standard.integer(forKey: Keys.searchLocationId.rawValue)) {
            config.selectedRegion = region
        }
        if let manufacturer = CoreDataManager.instance.getManufacturerById(UserDefaults.standard.integer(forKey: Keys.searchManufacturerId.rawValue)) {
            config.selectedManufacturer = manufacturer
        }
        if let model = CoreDataManager.instance.getModelById(UserDefaults.standard.integer(forKey: Keys.searchModelId.rawValue)) {
            config.selectedModel = model
        }
        let priceFrom = UserDefaults.standard.integer(forKey: Keys.searchPriceFrom.rawValue)
        if priceFrom > 0 {
            config.priceFrom = priceFrom
        }
        let priceFor = UserDefaults.standard.integer(forKey: Keys.searchPriceFor.rawValue)
        if priceFor > 0 {
            config.priceFor = priceFor
        }
        return config
    }
    
}

fileprivate enum Keys: String {
    case searchLocationId = "search_location_id"
    case searchManufacturerId = "search_manufacturer_id"
    case searchModelId = "search_model_id"
    case searchPriceFrom = "search_price_from"
    case searchPriceFor = "search_price_for"
}
