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
    
    func loadFeedAdverts(completed: @escaping (([Advert]?)->())) {

        let sourceOne = Source.avito(ConfigStorage.getFilterConfig().selectedRegion?.avito, nil, nil, nil)
        guard let url = URL(string: sourceOne.feedPath) else {
            completed([])
            return
        }
        NetworkService.shared.getHtmlData(url: url) { (html, error) in
            if let html = html {
                let adverts = self.htmlParser.parseAdverts(html: html, source: sourceOne)
                completed(adverts)
            }
        }
    }
    
    func searchAdverts(config: SearchFilterConfig, completed: @escaping (([Advert])->())) {
        let sourceOne = Source.avito(config.selectedRegion?.avito, config.selectedModel?.searchName, config.priceFrom, config.priceFor)
        
        guard let url = URL(string: sourceOne.searchPath) else {
            completed([])
            return
        }
        //print(url)
        
        NetworkService.shared.getHtmlData(url: url) { (html, error) in
            if let html = html {
                let adverts = self.htmlParser.parseAdverts(html: html, source: sourceOne)
                completed(adverts ?? [])
            }
        }
    }
    
    func loadAdvertDetails(advert: Advert, completed: @escaping ((AdvertDetails?)->())) {
        
        guard let link = advert.link, let url = URL(string: link) else { completed(nil); return }
        
        NetworkService.shared.getHtmlData(url: url) { (html, error) in
            if let html = html {
                let details = self.htmlParser.parseAdvertDetails(html: html, source: .avito(nil, nil, nil, nil))
                completed(details)
            }
        }
    }
    
}
