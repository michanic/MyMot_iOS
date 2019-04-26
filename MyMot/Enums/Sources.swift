//
//  Source.swift
//  MotoParser
//
//  Created by Michail Solyanic on 22/03/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Foundation

enum Source {
    
    case avito(String)
    case auto_ru(String)
    
    static let all = [avito, auto_ru]
    
    var domain: String {
        switch self {
        case .avito:
            return "https://www.avito.ru/"
        case .auto_ru:
            return "https://auto.ru/"
        }
    }
    
    var sitePath: String {
        switch self {
        case .avito(let region):
            return self.domain + "\(region)/mototsikly_i_mototehnika/mototsikly"
        case .auto_ru(let region):
            return self.domain + "\(region)/motorcycle/"
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
    
}
