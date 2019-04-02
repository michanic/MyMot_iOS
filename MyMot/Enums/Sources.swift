//
//  Source.swift
//  MotoParser
//
//  Created by Michail Solyanic on 22/03/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Foundation

enum Source {
    
    case avito
    case auto_ru
    
    static let all = [avito, auto_ru]
    
    /*var siteUrl: String {
        switch self {
        case .avito:
            return "https://www.avito.ru/krasnodarskiy_kray/mototsikly_i_mototehnika"
        case .auto_ru:
            return "https://auto.ru/krasnodarskiy_kray/motorcycle/honda/vfr/all/"
        }
    }*/
    
}
