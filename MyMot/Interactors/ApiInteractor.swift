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
            
            guard let array = json?.array else { return }
            for location in array {
                let managedObject = Location(json: location)
                print(managedObject?.avito)
            }
            
            CoreDataManager.instance.saveContext()
        }
        
    }
    
    private func loadClasses(completed: @escaping (()->())) {
        NetworkService.shared.getJsonData(endpoint: .catalogClasses) { (json, error) in
            //print(json as Any)
            completed()
        }
    }
    
    private func loadModels(completed: @escaping (()->())) {
        NetworkService.shared.getJsonData(endpoint: .catalogModels) { (json, error) in
            //print(json as Any)
            completed()
        }
    }
    
    deinit {
        print("ApiInteractor deinit")
    }
    
}
