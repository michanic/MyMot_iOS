//
//  CoreDataManager+Volumes.swift
//  MyMot
//
//  Created by Michail Solyanic on 15/07/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import CoreData

extension CoreDataManager {
    
    func getVolumeById(_ id: Int) -> Volume? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Volume")
        request.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if let volume = result.first as? Volume {
                return volume
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func getVolumes() -> [Volume] {
        print("getVolumes")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Volume")
        //request.predicate = NSPredicate(format: "models.@count > 0")
        let sortDescriptor = NSSortDescriptor(key: "sort", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if let volumes = result as? [Volume] {
                return volumes
            } else {
                return []
            }
        } catch {
            return []
        }
    }
    
}
