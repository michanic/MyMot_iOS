//
//  CoreDataManager+Models.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import CoreData

extension CoreDataManager {
    
    func getModelById(_ id: Int) -> Model? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Model")
        request.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if let model = result.first as? Model {
                return model
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func getModels() -> [Model] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Model")
        let sortDescriptor = NSSortDescriptor(key: "sort", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if let models = result as? [Model] {
                return models
            } else {
                return []
            }
        } catch {
            return []
        }
    }
    
    func getManufacturerModels(_ manufacturer: Manufacturer) -> [Model] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Model")
        let sortDescriptor = NSSortDescriptor(key: "sort", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = NSPredicate(format: "manufacturer.id = %@", "\(manufacturer.id)")
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if let models = result as? [Model] {
                return models
            } else {
                return []
            }
        } catch {
            return []
        }
    }
    
}
