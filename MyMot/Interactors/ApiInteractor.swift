//
//  ApiInteractor.swift
//  MyMot
//
//  Created by Michail Solyanic on 03/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class ApiInteractor {

    func loadConfig(completed: @escaping (()->())) {
        loadExteptedWords {
            self.loadAboutText {
                completed()
            }
        }
    }
    
    private func loadExteptedWords(completed: @escaping (()->())) {
        NetworkService.shared.getJsonData(endpoint: .configWords) { (json, error) in
            if let array = json?.array {
                for word in array {
                    if let wordString = word.string {
                        ConfigStorage.shared.exteptedWords.insert(wordString)
                    }
                }
            }
            //print(ConfigStorage.shared.exteptedWords.count)
            completed()
        }
    }
    
    private func loadAboutText(completed: @escaping (()->())) {
        NetworkService.shared.getJsonData(endpoint: .configAbout) { (json, error) in
            if let aboutText = json?.dictionary?["text"]?.string {
                ConfigStorage.shared.aboutText = aboutText
            }
            completed()
        }
    }
    
    func loadAgreementText(completed: @escaping ((String)->())) {
        NetworkService.shared.getJsonData(endpoint: .infoAgreement) { (json, error) in
            if let privacyText = json?.dictionary?["text"]?.string {
                completed(privacyText)
            } else {
                completed("")
            }
        }
    }
    
    
    func loadCatalog(completed: @escaping (()->())) {
        loadRegions {
            self.loadVolumes {
                self.loadClasses {
                    self.loadModels {
                        completed()
                    }
                }
            }
        }
    }
    
    private func loadRegions(completed: @escaping (()->())) {
        if CoreDataManager.instance.locationsIsLoaded() {
            completed()
        } else {
            NetworkService.shared.getJsonData(endpoint: .catalogRegions) { (json, error) in
                if let array = json?.array {
                    Location.createOrUpdateRegions(regionsJson: array)
                    CoreDataManager.instance.saveContext()
                }
                completed()
            }
        }
    }
    
    func loadRegionCities(_ region: Location, completed: @escaping (([Location])->())) {
        let cities = region.getCities()
        if cities.count > 0 {
            completed(cities)
        } else {
            NetworkService.shared.getJsonData(endpoint: .catalogRegionCities(Int(region.id))) { (json, error) in
                if let citiesJson = json?.array {
                    Location.createOrUpdateRegionCities(region: region, citiesJson: citiesJson)
                    CoreDataManager.instance.saveContext()
                }
                completed(region.getCities())
            }
        }
    }
    
    private func loadClasses(completed: @escaping (()->())) {
        NetworkService.shared.getJsonData(endpoint: .catalogClasses) { (json, error) in
            if let array = json?.array {
                Category.createOrUpdate(categoriesJson: array)
                CoreDataManager.instance.saveContext()
            }
            completed()
        }
    }
    
    private func loadVolumes(completed: @escaping (()->())) {
        NetworkService.shared.getJsonData(endpoint: .catalogVolumes) { (json, error) in
            if let array = json?.array {
                Volume.createOrUpdate(volumesJson: array)
                CoreDataManager.instance.saveContext()
            }
            completed()
        }
    }
    
    private func loadModels(completed: @escaping (()->())) {
        NetworkService.shared.getJsonData(endpoint: .catalogModels) { (json, error) in
            if let array = json?.array {
                Manufacturer.createOrUpdate(manufacturersJson: array)
                CoreDataManager.instance.saveContext()
            }
            completed()
        }
    }
    
    
    func loadModelDetails(modelId: Int, completed: @escaping ((ModelDetails)->())) {
        NetworkService.shared.getJsonData(endpoint: .catalogModelDetails(modelId)) { (json, error) in
            if let json = json, let details = ModelDetails(json: json) {
                completed(details)
            }
        }
    }
    
    deinit {
        //print("ApiInteractor deinit")
    }
    
}
