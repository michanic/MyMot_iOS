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
    
    func loadAdvertDetails(advert: Advert, completed: @escaping ((AdvertDetails?)->())) {
        
        guard let link = advert.link, let url = URL(string: link) else { completed(nil); return }
        
        NetworkService.shared.getHtmlData(url: url) { (html, error) in
            if let html = html {
                let details = self.htmlParser.parseAdvertDetails(html: html, source: .avito(""))
                completed(details)
            }
        }
    }
    
}
