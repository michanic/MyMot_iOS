//
//  CellTypes.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

enum CellType {
    
    case simple
    case advertsList
    case modelsList
    case categoryAbout
    case catalogSlider
    case catalogSlide
    
    var cellClass: Any {
        switch self {
        case .simple:
            return SimpleCell.self
        case .advertsList:
            return AdvertsListCell.self
        case .modelsList:
            return ModelsListCell.self
        case .categoryAbout:
            return CategoryAboutCell.self
        case .catalogSlider:
            return CatalogSliderCell.self
        case .catalogSlide:
            return CatalogSlideCell.self
        }
    }
    
    var height: CGFloat {
        switch self {
        case .modelsList:
            return 60
        case .catalogSlider:
            return 240
        default:
            return UITableView.automaticDimension
        }
    }
}
