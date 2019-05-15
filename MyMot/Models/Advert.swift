//
//  Advert.swift
//  MyMot
//
//  Created by Michail Solyanic on 23/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import SwiftSoup

struct AdvertDetails {
    
    var images: Images
    var text: String?
    var parameters: Parameters? = nil
    var saleHash: String? = nil
}

extension Advert {
    func getSource() -> Source? {
        guard let link = link else { return nil }
        
        if link.contains("avito") {
            return Source.avito(nil, nil, nil, nil, nil)
        } else if link.contains("auto.ru") {
            return Source.auto_ru(nil, nil, nil, nil, nil)
        }
        return nil
    }
}

extension Cell {
    convenience init(searchFeedAdvert advert: Advert) {
        self.init(cellType: .searchFeed)
        self.content = advert
        self.cellTapped = { indexPath in
            Router.shared.pushController(ViewControllerFactory.searchAdvertPage(advert).create)
        }
    }
    
    convenience init(advertsList advert: Advert) {
        self.init(cellType: .advertsList)
        self.content = advert
        self.cellTapped = { indexPath in
            Router.shared.pushController(ViewControllerFactory.searchAdvertPage(advert).create)
        }
    }
}
