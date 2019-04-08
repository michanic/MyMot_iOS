//
//  ApiInteractor.swift
//  MyMot
//
//  Created by Michail Solyanic on 03/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class ApiInteractor {

    func loadCatalog(completed: @escaping (()->())) {
        loadRegions {
            self.loadClasses {
                self.loadModels {
                    completed()
                }
            }
        }
    }
    
    private func loadRegions(completed: @escaping (()->())) {
        NetworkService.shared.getJsonData(endpoint: .catalogRegions) { (json, error) in
            if let array = json?.array {
                Location.createOrUpdate(regionsJson: array)
                CoreDataManager.instance.saveContext()
            }
            completed()
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
    
    private func loadModels(completed: @escaping (()->())) {
        NetworkService.shared.getJsonData(endpoint: .catalogModels) { (json, error) in
            if let array = json?.array {
                Manufacturer.createOrUpdate(manufacturersJson: array)
                CoreDataManager.instance.saveContext()
            }
            completed()
        }
    }
    
    deinit {
        //print("ApiInteractor deinit")
    }
    
}
