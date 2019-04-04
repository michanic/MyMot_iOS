//
//  Location.swift
//  MyMot
//
//  Created by Michail Solyanic on 04/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Location {
    
    convenience init?(json: JSON) {
        self.init(context: CoreDataManager.instance.persistentContainer.viewContext)
        guard let dict = json.dictionary, let id = dict["id"]?.int, let name = dict["name"]?.string else { return }
        
        self.id = Int32(id)
        self.name = name
        self.sort = Int32(dict["sort"]?.int ?? 0)
        self.avito = dict["avito"]?.string
        self.autoru = dict["autoru"]?.string
        
    }
    
}
