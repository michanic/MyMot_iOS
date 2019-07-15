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
    //var currentSource: Source = .avito(nil, nil, nil, nil, nil)
    
    func loadFeedAdverts(source: Source, loaded: @escaping (([Advert], Bool)->())) {

        var loadedAdverts:[Advert] = []
        var loadMore = false
        guard let urlAvito = URL(string: source.searchPath) else { loaded(loadedAdverts, loadMore); return }
        loadSourceAdverts(source: source, url: urlAvito) { (adverts, more) in
            loadedAdverts.append(contentsOf: adverts)
            /*if source.domain.contains("avito") {
                loadMore = true
            } else {
                loadMore = more
            }*/
            loadMore = more
            loaded(loadedAdverts, loadMore)
        }
    }
    
    
    func searchAdverts(page: Int, config: SearchFilterConfig, loaded: @escaping (([Advert], Bool)->())) {
        
        var loadedAdverts:[Advert] = []
        var loadMore = false
        
        /*var query: String? = nil
        if let manufacturer = config.selectedManufacturer {
            query = manufacturer.autoruSearchName
        } else if let model = config.selectedModel {
            query = model.autoruSearchName
        }
        
        let sourceAutoRu = Source.auto_ru(config.selectedRegion?.autoru, query, config.priceFrom, config.priceFor, page)
        guard let urlAutoRu = URL(string: sourceAutoRu.searchPath) else { loaded(loadedAdverts, loadMore); return }
        
        self.loadSourceAdverts(source: sourceAutoRu, url: urlAutoRu, completed: { (adverts, more) in
            
            loadedAdverts.append(contentsOf: adverts)
            if loadMore == false {
                loadMore = more
            }
            loaded(loadedAdverts, loadMore)
        })*/
        
        var query: String? = nil
        if let manufacturer = config.selectedManufacturer {
            query = manufacturer.avitoSearchName
        } else if let model = config.selectedModel {
            query = model.avitoSearchName
        }
        
        let sourceAvito = Source.avito(config.selectedRegion?.avito, query, config.priceFrom, config.priceFor, page)
        guard let urlAvito = URL(string: sourceAvito.searchPath) else { loaded(loadedAdverts, loadMore); return }

        loadSourceAdverts(source: sourceAvito, url: urlAvito) { (adverts, more) in
            loadedAdverts.append(contentsOf: adverts)
            loadMore = more
            
            var query: String? = nil
            if let manufacturer = config.selectedManufacturer {
                query = manufacturer.autoruSearchName
            } else if let model = config.selectedModel {
                query = model.autoruSearchName
            }
            
            let sourceAutoRu = Source.auto_ru(config.selectedRegion?.autoru, query, config.priceFrom, config.priceFor, page)
            guard let urlAutoRu = URL(string: sourceAutoRu.searchPath) else { loaded(loadedAdverts, loadMore); return }
            
            self.loadSourceAdverts(source: sourceAutoRu, url: urlAutoRu, completed: { (adverts, more) in
                
                loadedAdverts.append(contentsOf: adverts)
                if loadMore == false {
                    loadMore = more
                }
                loaded(loadedAdverts, loadMore)
            })
        }
    }
    
    private func loadSourceAdverts(source: Source, url: URL, completed: @escaping (([Advert], Bool)->())) {
        
        //print("loadSourceAdverts " + url.absoluteString)
        
        NetworkService.shared.getHtmlData(url: url) { (html, error) in
            if let html = html {
                let result = self.htmlParser.parseAdverts(html: html, source: source)
                completed(result.0 ?? [], result.1)
            }
        }
    }
    
    
    func loadAdvertDetails(advert: Advert, completed: @escaping ((AdvertDetails?)->())) {
        
        guard let link = advert.link, let url = URL(string: link), let source = advert.getSource() else { completed(nil); return }
        print(link)
        
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
    
    
    func checkRegionLinksAdverts(_ location: Location, loaded: @escaping (()->())) {
        guard let regionStringAvito = location.avito else { loaded(); return }
        print("check " + (location.name ?? ""))
        let path = "https://www.avito.ru/\(regionStringAvito)/avtomobili"
        guard let urlAvito = URL(string: path) else { loaded(); return }
        let sourceAvito: Source = .avito(nil, nil, nil, nil, nil)
        
        
        loadSourceAdverts(source: sourceAvito, url: urlAvito) { (adverts, more) in
            
            if adverts.count == 0 {
                print("EMPTY Avito: " + regionStringAvito + " - " + String(adverts.count))
            }
            
            guard let regionStringAutoRu = location.autoru else { loaded(); return }
            let path = "https://auto.ru/\(regionStringAutoRu)/motorcycle/all/"
            guard let urlAutoRu = URL(string: path) else { loaded(); return }
            let sourceAutoRu: Source = .auto_ru(nil, nil, nil, nil, nil)
            
            self.loadSourceAdverts(source: sourceAutoRu, url: urlAutoRu, completed: { (adverts, more) in

                if adverts.count == 0 {
                    print("EMPTY AutoRu: " + regionStringAutoRu + " - " + String(adverts.count))
                }
                loaded()
            })
        }
    }
    
}
