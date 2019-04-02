//
//  Endpoints.swift
//  MyMot
//
//  Created by Michail Solyanic on 02/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Alamofire
import Foundation

enum Endpoint {

    case catalogRegions
    case catalogClasses
    case catalogModels
    
    var method: HTTPMethod {
        switch self {
        case .catalogRegions, .catalogClasses, .catalogModels:
            return .get
        }
    }
    
    var url: URL {
        switch self {
        case .catalogRegions:
            return URL(fromEndpoint: "catalog.php?type=regions")!
        case .catalogClasses:
            return URL(fromEndpoint: "catalog.php?type=classes")!
        case .catalogModels:
            return URL(fromEndpoint: "catalog.php?type=models")!
        }
    }
    
}
