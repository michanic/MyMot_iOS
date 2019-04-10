//
//  Model.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Model {
    
    static func createOrUpdate(modelsJson: [JSON], manufacturer: Manufacturer) {
        let categoriesMap = CoreDataManager.instance.getCategoriesMap()
        var models: [Model] = []
        for modelJson in modelsJson {
            if let model = Model.createOrUpdateModel(json: modelJson) {
                models.append(model)
                model.manufacturer = manufacturer
                if let categoryId = modelJson.dictionary?["class"]?.int, let category = categoriesMap[categoryId] {
                    model.category = category
                }
            }
        }
        manufacturer.models = NSSet(array: models)
    }
    
    private static func createOrUpdateModel(json: JSON) -> Model? {
        guard let dict = json.dictionary, let id = dict["id"]?.int, let name = dict["name"]?.string else { return nil }
        
        var model: Model?
        if let coreModel = CoreDataManager.instance.getModelById(id) {
            model = coreModel
        } else {
            model = Model.init(context: CoreDataManager.instance.persistentContainer.viewContext)
        }
        
        model?.id = Int32(id)
        model?.name = name
        model?.code = dict["code"]?.string
        model?.sort = Int32(dict["sort"]?.int ?? 0)
        model?.preview_picture = dict["preview_picture"]?.string
        model?.preview_text = dict["preview_text"]?.string
        model?.parameters = dict["parameters"]?.string
        model?.first_year = Int16(dict["first_year"]?.int ?? 0)
        model?.last_year = Int16(dict["last_year"]?.int ?? 0)
        
        return model
    }
    
    var years: String {
        return String(first_year) + " - " + (last_year == 0 ? "настоящее время" : String(last_year))
    }
}

extension Cell {
    convenience init(modelsList: Model) {
        self.init(cellType: .modelsList)
        self.content = modelsList
    }
}
