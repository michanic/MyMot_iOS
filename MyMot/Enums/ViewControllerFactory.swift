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
    
    case catalogByClass(Category)
    case catalogByManufacturer(Manufacturer)
    
    case searchRoot
    case favouritesRoot
    
    var create: UIViewController {
        switch self {
        case .loading(let title, let subtitle):
            return LoadingViewController(title: title, subtitle: subtitle)
        case .tabBarController:
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarController")
            
        case .catalogByClass(let category):
            return CatalogByClassViewController(category: category)
        case .catalogByManufacturer(let manufacturer):
            return CatalogByManufacturerViewController(manufacturer: manufacturer)
            
        default:
            return UIViewController()
        }
    }
}
