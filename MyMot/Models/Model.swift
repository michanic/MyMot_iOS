//
//  Model.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias Parameters = [(String, String)]

struct ModelDetails {
    
    var parameters: Parameters
    var images: Images
    var bigImages: Images
    var videos: Videos
    var text: String?
    
    init?(json: JSON) {
        
        self.text = json.dictionary?["preview_text"]?.string
        
        self.images = []
        self.bigImages = []
        self.videos = []
        
        if let images = json.dictionary?["images"]?.array, let bigImages = json.dictionary?["big_images"]?.array  {
            for row in images {
                if let imagePath = row.string {
                    self.images.append(imagePath)
                }
            }
            for row in bigImages {
                if let imagePath = row.string {
                    self.bigImages.append(imagePath)
                }
            }
        }
        
        if let videos = json.dictionary?["video_reviews"]?.array {
            for row in videos {
                if let videoId = row.string {
                    self.videos.append(YoutubeVideo(videoId: videoId))
                }
            }
        }
        
        self.parameters = []
        if let parametersArray = json.dictionary?["parameters"]?.array {
            for parameterDict in parametersArray {
                if let dict = parameterDict.first, let value = dict.1.string {
                    self.parameters.append((dict.0, value))
                }
            }
        }
    }
    
}

extension Model {
    
    static func createOrUpdate(modelsJson: [JSON], manufacturer: Manufacturer) {
        let categoriesMap = CoreDataManager.instance.getCategoriesMap()
        
        let volumesMap = CoreDataManager.instance.getCategoriesMap()
        
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
            model?.id = Int32(id)
        }
        
        model?.name = name
        model?.code = dict["code"]?.string
        model?.sort = Int32(dict["sort"]?.int ?? 0)
        model?.preview_picture = dict["preview_picture"]?.string
        model?.first_year = Int16(dict["first_year"]?.int ?? 0)
        model?.last_year = Int16(dict["last_year"]?.int ?? 0)
        
        if let volumeText = dict["volume"]?.string {
            model?.volume_text = volumeText + " куб.см."
            if let volumeVal = volumeText.replacingOccurrences(of: "от ", with: "").floatValue {
                model?.volume_value = volumeVal
                model?.volume_type = Volume.defineVolume(value: volumeVal)
            }
        }
        
        return model
    }
    
    var years: String {
        return String(first_year) + " - " + (last_year == 0 ? "настоящее время" : String(last_year))
    }
    
    var avitoSearchName: String {
        return (manufacturer?.name?.lowercased() ?? "") + "+" + (name?.replacingOccurrences(of: " ", with: "+").lowercased() ?? "")
    }
    
    var autoruSearchName: String {
        return (manufacturer?.name?.uppercased() ?? "") + "%23" + (code?.uppercased() ?? "")
    }
}

extension Cell {
    convenience init(modelsList model: Model, accessoryState: CellAccessoryType) {
        self.init(cellType: .modelsList)
        self.content = (model, accessoryState)
        self.cellTapped = { indexPath in
            Router.shared.pushController(ViewControllerFactory.catalogModelDetails(model).create)
        }
    }
}
