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
    
    func loadFeedAdverts(page: Int, loaded: @escaping (([Advert], Bool)->())) {

        var loadedAdverts:[Advert] = []
        var loadMore = false
        
        let config = ConfigStorage.getFilterConfig()
        
        let sourceAvito = Source.avito(config.selectedRegion?.avito, nil, config.priceFrom, config.priceFor, page)
        guard let urlAvito = URL(string: sourceAvito.searchPath) else { loaded(loadedAdverts, loadMore); return }
        
        loadSourceAdverts(page: page, source: sourceAvito, url: urlAvito) { (adverts, more) in
            loadedAdverts.append(contentsOf: adverts)
            loadMore = more
            
            let sourceAutoRu = Source.auto_ru(config.selectedRegion?.autoru, nil, config.priceFrom, config.priceFor, page)
            guard let urlAutoRu = URL(string: sourceAutoRu.searchPath) else { loaded(loadedAdverts, loadMore); return }
            
            self.loadSourceAdverts(page: page, source: sourceAutoRu, url: urlAutoRu, completed: { (adverts, more) in
                loadedAdverts.append(contentsOf: adverts)
                if loadMore == false {
                    loadMore = more
                }
                
                loaded(loadedAdverts, loadMore)
            })
        }
    }
    
    
    func searchAdverts(page: Int, config: SearchFilterConfig, loaded: @escaping (([Advert], Bool)->())) {
        
        var loadedAdverts:[Advert] = []
        var loadMore = false
        
        let sourceAvito = Source.avito(config.selectedRegion?.avito, config.selectedModel?.avitoSearchName, config.priceFrom, config.priceFor, page)
        guard let urlAvito = URL(string: sourceAvito.searchPath) else { loaded(loadedAdverts, loadMore); return }

        loadSourceAdverts(page: page, source: sourceAvito, url: urlAvito) { (adverts, more) in
            loadedAdverts.append(contentsOf: adverts)
            loadMore = more
            
            let sourceAutoRu = Source.auto_ru(config.selectedRegion?.autoru, config.selectedModel?.autoruSearchName, config.priceFrom, config.priceFor, page)
            guard let urlAutoRu = URL(string: sourceAutoRu.searchPath) else { loaded(loadedAdverts, loadMore); return }
            
            self.loadSourceAdverts(page: page, source: sourceAutoRu, url: urlAutoRu, completed: { (adverts, more) in
                loadedAdverts.append(contentsOf: adverts)
                if loadMore == false {
                    loadMore = more
                }
                loaded(loadedAdverts, loadMore)
            })
        }
    }
    
    private func loadSourceAdverts(page: Int, source: Source, url: URL, completed: @escaping (([Advert], Bool)->())) {
        
        print(url)
        
        NetworkService.shared.getHtmlData(url: url) { (html, error) in
            if let html = html {
                let result = self.htmlParser.parseAdverts(html: html, source: source)
                completed(result.0 ?? [], result.1)
            }
        }
    }
    
    
    func loadAdvertDetails(advert: Advert, completed: @escaping ((AdvertDetails?)->())) {
        
        guard let link = advert.link, let url = URL(string: link), let source = advert.getSource() else { completed(nil); return }
        
        NetworkService.shared.getHtmlData(url: url) { (html, error) in
            if let html = html {
                let details = self.htmlParser.parseAdvertDetails(html: html, source: source)
                completed(details)
            } else {
                completed(nil)
            }
        }
    }
    
    func loadAvitoAdvertPhone(advert: Advert, completed: @escaping ((String)->())) {
        guard var link = advert.link else { completed(""); return }
        
        link = link.replacingOccurrences(of: "www.avito", with: "m.avito")
        guard let url = URL(string: link) else { completed(""); return }
        NetworkService.shared.getHtmlData(url: url) { (html, error) in
            if let html = html {
                let phone = self.htmlParser.parsePhoneFromAvito(html: html)
                completed(phone)
            } else {
                completed("")
            }
        }
    }

    func loadAutoRuAdvertPhones(saleId: String, saleHash: String, token: String, completed: @escaping (([String])->())) {
        
        let path = "https://auto.ru/-/ajax/phones/?category=moto&sale_id=\(saleId)&sale_hash=\(saleHash)&isFromPhoneModal=true&__blocks=card-phones%2Ccall-number"
        guard let url = URL(string: path) else { completed([]); return }
        
        let headers = [
            "x-csrf-token" : token,
            "Cookie": "_csrf_token=\(token)"
        ]
        
        NetworkService.shared.getJsonData(url: url, method: .get, headers: headers) { (json, error) in
            if let html = json?.dictionary?["blocks"]?.dictionary?["card-phones"]?.string?.replacingOccurrences(of: ("\""), with: ("'")) {
                print(html)
                let phones = self.htmlParser.parsePhonesFromAutoRu(html: html)
                completed(phones)
            } else {
                completed([])
            }
            
        }
        
    }
    
}
