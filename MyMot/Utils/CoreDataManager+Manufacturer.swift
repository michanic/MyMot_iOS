//
//  CoreDataManager+Manufacturer.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import CoreData

extension CoreDataManager {

    func getManufacturerById(_ id: Int) -> Manufacturer? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Manufacturer")
        request.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if let manufacturer = result.first as? Manufacturer {
                return manufacturer
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func getManufacturers() -> [Manufacturer] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Manufacturer")
        let sortDescriptor = NSSortDescriptor(key: "sort", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if let manufacturers = result as? [Manufacturer] {
                return manufacturers
            } else {
                return []
            }
        } catch {
            return []
        }
    }
    
}
