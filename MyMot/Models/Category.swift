//
//  Category.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Category {
    
    static func createOrUpdate(categoriesJson: [JSON]) {
        for categoryJson in categoriesJson {
            guard let dict = categoryJson.dictionary, let id = dict["id"]?.int, let name = dict["name"]?.string else { break }
            
            var category: Category?
            if let coreCategory = CoreDataManager.instance.getCategoryById(id) {
                category = coreCategory
            } else {
                category = Category.init(context: CoreDataManager.instance.persistentContainer.viewContext)
                category?.id = Int32(id)
            }
            
            category?.code = dict["code"]?.string
            category?.sort = Int32(dict["sort"]?.int ?? 0)
            category?.name = name
            category?.image = dict["image"]?.string
            category?.about = dict["description"]?.string
        }
    }
    
    func getModelsOfManufacturer(_ manufacturer: Manufacturer) -> [Model] {
        return CoreDataManager.instance.getManufacturerModels(manufacturer, ofCategory: self)
    }
    
}


extension Cell {
    
    convenience init(categoriesSliderTitle: String, categories: [Category]) {
        self.init(cellType: .catalogSlider)
        self.content = (categoriesSliderTitle, categories)
    }
    
    convenience init(categoryAbout category: Category) {
        self.init(cellType: .categoryAbout)
        self.content = (category.image, category.about)
    }
}

