//
//  Source.swift
//  MotoParser
//
//  Created by Michail Solyanic on 22/03/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Foundation

enum Source {
    
    case avito(String?, String?, Int?, Int?)
    case auto_ru(String?, String?, Int?, Int?)
    
    static let all = [avito, auto_ru]
    
    var domain: String {
        switch self {
        case .avito:
            return "https://www.avito.ru/"
        case .auto_ru:
            return "https://auto.ru/"
        }
    }
    
    var mobileDomain: String {
        switch self {
        case .avito:
            return "https://m.avito.ru/"
        case .auto_ru:
            return "https://m.auto.ru/"
        }
    }
    
    var itemSelector: String {
        switch self {
        case .avito:
            return ".js-catalog-item-enum.item-with-contact"
        case .auto_ru:
            return ".listing-item.stat_type_listing"
        }
    }
    
    var feedPath: String {
        switch self {
        case .avito(let params):
            let regionString = params.0 ?? "rossiya"
            return self.domain + "\(regionString)/mototsikly_i_mototehnika/mototsikly"
        case .auto_ru(let params):
            let regionString = params.0 ?? "rossiya"
            return self.domain + "\(regionString)/motorcycle/all/"
        }
    }
    
    var searchPath: String {
        switch self {
        case .avito(let region, let model, let pMin, let pMax):
            let regionString = region ?? "rossiya"
            let path = self.domain + "\(regionString)/mototsikly_i_mototehnika/mototsikly"
            var request = ""
            if let pMin = pMin {
                request += "&pmin=" + String(pMin)
            }
            if let pMax = pMax {
                request += "&pmax=" + String(pMax)
            }
            if let model = model {
                request += "&q=" + String(model)
            }
            if request.count > 0 {
                request = "?" + request.dropFirst()
            }
            return path + request
            
        case .auto_ru(let region, _, _, _):
            let regionString = region ?? "rossiya"
            return self.domain + "\(regionString)/motorcycle/"
        }
    }
    
}
