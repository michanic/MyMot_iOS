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
    case collectionTitle
    case setPrice
    case advertsList
    case modelsList
    case categoryAbout
    case catalogSlider
    case catalogSlide
    case youtubeVideo
    case searchFeed
    
    var cellClass: Any {
        switch self {
        case .simple:
            return SimpleCell.self
        case .collectionTitle:
            return CollectionTitleCell.self
        case .setPrice:
            return SetPriceCell.self
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
        case .youtubeVideo:
            return YoutubeVideoCell.self
        case .searchFeed:
            return SearchFeedCell.self
        }
    }
    
    var height: CGFloat {
        switch self {
        case .simple, .setPrice:
            return 48
        case .collectionTitle:
            return 55
        case .modelsList:
            return 70
        case .catalogSlider:
            return 236
        case .searchFeed:
            return self.width * 0.75 + 95
        default:
            return UITableView.automaticDimension
        }
    }
    
    var width: CGFloat {
        switch self {
        case .searchFeed:
            let cols: CGFloat = Screen.isLandscape ? 3 : 2
            let spaces: CGFloat = Screen.isLandscape ? 46 : 36
            return (Screen.safeWidth - spaces) / cols
        case .collectionTitle:
            return Screen.width - 26
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
}
