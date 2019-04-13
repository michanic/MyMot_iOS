//
//  CoreDataManager+Categories.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import CoreData

extension CoreDataManager {

    func getCategoryById(_ id: Int) -> Category? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        request.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if let category = result.first as? Category {
                return category
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func getCategories() -> [Category] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        request.predicate = NSPredicate(format: "models.@count > 0")
        let sortDescriptor = NSSortDescriptor(key: "sort", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if let categories = result as? [Category] {
                return categories
            } else {
                return []
            }
        } catch {
            return []
        }
    }
    
    func getCategoriesMap() -> [Int : Category] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        let sortDescriptor = NSSortDescriptor(key: "sort", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            var categoriesMap: [Int : Category] = [:]
            if let categories = result as? [Category] {
                for category in categories {
                    categoriesMap[Int(category.id)] = category
                }
                return categoriesMap
            } else {
                return categoriesMap
            }
        } catch {
            return [:]
        }
    }
    
}
