//
//  Source.swift
//  MotoParser
//
//  Created by Michail Solyanic on 22/03/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Foundation

enum Source {
    
    case avito(String?, String?, Int?, Int?, Int?)
    case auto_ru(String?, String?, Int?, Int?, Int?)
    
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
            var page = ""
            if let pageInt = params.4 {
                page = "?p=" + String(pageInt)
            }
            return self.domain + "\(regionString)/mototsikly_i_mototehnika/mototsikly" + page
        case .auto_ru(let params):
            let regionString = params.0 ?? "rossiya"
            var page = ""
            if let pageInt = params.4 {
                page = "?page_num_offers=" + String(pageInt)
            }
            return self.domain + "\(regionString)/motorcycle/all/" + page
        }
    }
    
    var searchPath: String {
        switch self {
        case .avito(let region, let model, let pMin, let pMax, let page):
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
            if let page = page {
                request += "&p=" + String(page)
            }
            if request.count > 0 {
                request = "?" + request.dropFirst()
            }
            return path + request
            
        case .auto_ru(let region, let model, let pMin, let pMax, let page):
            let regionString = region ?? "rossiya"
            let path = self.domain + "\(regionString)/motorcycle/all/"
            
            var request = ""
            if let pMin = pMin {
                request += "&price_from=" + String(pMin)
            }
            if let pMax = pMax {
                request += "&price_to=" + String(pMax)
            }
            if let model = model {
                request += "&mark-model-nameplate=" + String(model)
            }
            if let page = page {
                request += "&page_num_offers=" + String(page)
            }
            if request.count > 0 {
                request = "?" + request.dropFirst()
            }
            
            return path + request
        }
    }
    
}
