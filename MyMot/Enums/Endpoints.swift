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

    case configWords
    case configAbout
    case infoAgreement
    
    case catalogRegions
    case catalogClasses
    case catalogModels
    case catalogModelDetails(Int)
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var url: URL {
        switch self {
        case .configWords:
            return URL(fromEndpoint: "config.php?type=word_exceptions")!
        case .configAbout:
            return URL(fromEndpoint: "config.php?type=about")!
        case .infoAgreement:
            return URL(fromEndpoint: "config.php?type=agreement")!
            
        case .catalogRegions:
            return URL(fromEndpoint: "catalog.php?type=regions")!
        case .catalogClasses:
            return URL(fromEndpoint: "catalog.php?type=classes")!
        case .catalogModels:
            return URL(fromEndpoint: "catalog.php?type=models")!
        case .catalogModelDetails(let modelId):
            return URL(fromEndpoint: "catalog.php?type=model_details&id=\(modelId)")!
        }
    }
    
}
