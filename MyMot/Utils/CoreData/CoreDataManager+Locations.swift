//
//  CoreDataManager+Locations.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import CoreData

extension CoreDataManager {
    
    func locationsIsLoaded() -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if result is [Location], result.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func getLocationById(_ id: Int) -> Location? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        request.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if let location = result.first as? Location {
                return location
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func getRegions() -> [Location] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        request.predicate = NSPredicate(format: "region == nil")
        let sortDescriptor = NSSortDescriptor(key: "sort", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if let locations = result as? [Location] {
                return locations
            } else {
                return []
            }
        } catch {
            return []
        }
    }
    
    func getRegionCities(regionId: Int) -> [Location] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        request.predicate = NSPredicate(format: "region.id = %@", "\(regionId)")
        let sortDescriptor = NSSortDescriptor(key: "sort", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if let locations = result as? [Location] {
                return locations
            } else {
                return []
            }
        } catch {
            return []
        }
    }
    
}
