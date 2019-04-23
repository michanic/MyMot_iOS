//
//  CoreDataManager+Adverts.swift
//  MyMot
//
//  Created by Michail Solyanic on 23/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit
import CoreData

extension CoreDataManager {
    
    func getAdvertById(_ id: String) -> Advert? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Advert")
        request.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if let advert = result.first as? Advert {
                return advert
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
}
