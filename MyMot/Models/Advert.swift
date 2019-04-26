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
    
}

extension Cell {
    convenience init(searchFeedAdvert advert: Advert) {
        self.init(cellType: .searchFeed)
        self.content = advert
        self.cellTapped = { indexPath in
            Router.shared.pushController(ViewControllerFactory.searchAdvertPage(advert).create)
        }
    }
}
