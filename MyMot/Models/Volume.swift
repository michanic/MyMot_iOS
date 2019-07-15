//
//  Volume.swift
//  MyMot
//
//  Created by Michail Solyanic on 15/07/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Volume {
    
    static let volumes = CoreDataManager.instance.getVolumes()
    
    static func createOrUpdate(volumesJson: [JSON]) {
        for volumeJson in volumesJson {
            guard let dict = volumeJson.dictionary, let id = dict["id"]?.int, let name = dict["name"]?.string else { break }
            
            var volume: Volume?
            if let coreVolume = CoreDataManager.instance.getVolumeById(id) {
                volume = coreVolume
            } else {
                volume = Volume.init(context: CoreDataManager.instance.persistentContainer.viewContext)
                volume?.id = Int32(id)
            }
            
            volume?.code = dict["code"]?.string
            volume?.sort = Int32(dict["sort"]?.int ?? 0)
            volume?.name = name
            volume?.image = dict["image"]?.string
            volume?.min = Int16(dict["min"]?.int ?? 0)
            volume?.max = Int16(dict["max"]?.int ?? 0)
        }
    }
    
    static func defineVolume(value: Float) -> Volume? {
        var definedVolume: Volume? = nil
        for volume in volumes {
            if Float(volume.min) <= value && value <= Float(volume.max) {
                definedVolume = volume
            }
        }
        return definedVolume
    }
    
}

extension Cell {
    convenience init(volumesSliderTitle: String, content: [Volume]) {
        self.init(cellType: .catalogSlider)
        self.content = (volumesSliderTitle, content)
    }
}
