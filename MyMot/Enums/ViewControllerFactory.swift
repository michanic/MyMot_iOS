//
//  CoordinatorFactory.swift
//  MyMot
//
//  Created by Michail Solyanic on 03/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

enum ViewControllerFactory {
    
    case loading(String, String)
    case tabBarController
    
    case imagesViewer(Images, Int, ((Int) -> ())?)
    
    case catalogByClass(Category)
    case catalogByManufacturer(Manufacturer)
    case catalogModelDetails(Model)
    
    case searchRoot
    case searchFilter(SearchFilterConfig?, ((SearchFilterConfig) -> ())?)
    case searchFilterRegions(Location?, ((Location?) -> ())?)
    case searchFilterModels(Model?, Manufacturer?, ((Model?, Manufacturer?) -> ())?)
    case searchResults(SearchFilterConfig)
    case searchAdvertPage(Advert)
    
    case favouritesRoot
    
    var create: UIViewController {
        switch self {
        case .loading(let title, let subtitle):
            return LoadingViewController(title: title, subtitle: subtitle)
        case .tabBarController:
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarController")
            
        case .imagesViewer(let images, let currentIndex, let callback):
            return UINavigationController(rootViewController: ImagesViewerController(images: images, currentIndex: currentIndex, indexChangedCallback: callback))
            
        case .catalogByClass(let category):
            return CatalogByClassViewController(category: category)
        case .catalogByManufacturer(let manufacturer):
            return CatalogByManufacturerViewController(manufacturer: manufacturer)
        case .catalogModelDetails(let model):
            return CatalogModelViewController(model: model)
        
        case .searchFilter(let config, let callback):
            return UINavigationController(rootViewController: FilterViewController(filterConfig: config, searchPressedCallback: callback))
        case .searchFilterRegions(let selectedRegion, let callback):
            return FilterRegionsViewController(selectedRegion: selectedRegion, selectedCallback: callback)
        case .searchFilterModels(let selectedModel, let selectedManufacturer, let callback):
            return FilterModelsViewController(selectedModel: selectedModel, selectedManufacturer: selectedManufacturer, selectedCallback: callback)
        case .searchResults(let filterConfig):
            return SearchResultsViewController(filterConfig: filterConfig)
        case .searchAdvertPage(let advert):
            return AdvertViewController(advert: advert)
            
        default:
            return UIViewController()
        }
    }
}
