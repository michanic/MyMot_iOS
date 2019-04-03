//
//  ApiInteractor.swift
//  MyMot
//
//  Created by Michail Solyanic on 03/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class ApiInteractor {

    func loadCatalog(completed: (()->())) {
        loadRegions {
            loadClasses {
                loadModels {
                    completed()
                }
            }
        }
    }
    
    private func loadRegions(completed: (()->())) {
        print("loadRegions")
        completed()
    }
    
    private func loadClasses(completed: (()->())) {
        print("loadClasses")
        completed()
    }
    
    private func loadModels(completed: (()->())) {
        print("loadModels")
        completed()
    }
    
    deinit {
        print("ApiInteractor deinit")
    }
}
