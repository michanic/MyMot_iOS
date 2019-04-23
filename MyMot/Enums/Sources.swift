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
    
    var sitePath: String {
        switch self {
        case .avito(let region):
            return "https://www.avito.ru/\(region)/mototsikly_i_mototehnika/mototsikly"
        case .auto_ru(let region):
            return "https://auto.ru/\(region)/motorcycle/"
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
