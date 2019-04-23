//
//  SitesInteractor.swift
//  MyMot
//
//  Created by Michail Solyanic on 23/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class SitesInteractor {

    let htmlParser: HtmlParser = HtmlParser()
    
    func loadFeedAdverts(ofSource source: Source, completed: @escaping (([Advert]?)->())) {

        NetworkService.shared.getHtmlData(source: source) { (html, error) in
            if let html = html {
                let adverts = self.htmlParser.parseAdverts(html: html, source: source)
                completed(adverts)
            }
        }
        
    }
    
}
