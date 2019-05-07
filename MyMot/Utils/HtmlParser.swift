//
//  HtmlParser.swift
//  MyMot
//
//  Created by Michail Solyanic on 23/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit
import SwiftSoup
import SwiftyJSON

class HtmlParser {

    func parseAdverts(html: String, source: Source) -> [Advert]? {
        do {
            let doc: Document = try SwiftSoup.parse(html)
            var adverts: [Advert] = []
            
            for row in try! doc.select(source.itemSelector) {
                switch source {
                case .avito:
                    if let advert = Advert.createOrUpdateFromAvito(row) {
                        adverts.append(advert)
                    }
                case .auto_ru:
                    if let advert = Advert.createOrUpdateFromAutoru(row) {
                        adverts.append(advert)
                    }
                    break
                }
            }
            return adverts.count > 0 ? adverts : nil
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func parseAdvertDetails(html: String, source: Source) -> AdvertDetails? {
        switch source {
        case .avito:
            return AdvertDetails(parseFromAvito: html)
        default:
            return nil
        }
    }
    
}


extension Advert {
    
    static func createOrUpdateFromAvito(_ row: Element) -> Advert? {
        
        guard let id = try? row.attr("data-item-id"), let title = try? row.select("a.item-description-title-link span").text() else { return nil }
        guard title.checkForExteption() else { return nil }
        
        var advert: Advert?
        if let coreAdvert = CoreDataManager.instance.getAdvertById(id) {
            advert = coreAdvert
        } else {
            advert = Advert.init(context: CoreDataManager.instance.persistentContainer.viewContext)
            advert?.id = id
        }
        
        do {
            advert?.title = title
            advert?.city = try row.select(".item_table-description .data p:eq(1)").text()
            advert?.date = try row.select(".js-item-date").text()
            advert?.link = try row.select(".item-description-title-link").attr("href")
            if let link = advert?.link {
                advert?.link = Source.avito(nil, nil, nil, nil).domain + link
            }
            
            var priceText = try row.select("span.price").text()
            priceText = priceText.replacingOccurrences(of: " ", with: "")
            priceText = priceText.replacingOccurrences(of: "₽", with: "")
            if let price = Int32(priceText) {
                advert?.price = price
            }
            
            let image = try row.select("img.large-picture-img[src]").array().map { try $0.attr("src").description }.first
            if let image = image {
                advert?.previewImage = "https:" + image
            }
            
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
        
        return advert
        
    }
    
    static func createOrUpdateFromAutoru(_ row: Element) -> Advert? {
        guard let dataBem = try? row.attr("data-bem"), let id = JSON(parseJSON: dataBem).dictionary?["listing-item"]?.dictionary?["id"]?.string else { return nil }
        guard let title = try? row.select(".listing-item__link").text() else { return nil }
        guard title.checkForExteption() else { return nil }
        
        var advert: Advert?
        if let coreAdvert = CoreDataManager.instance.getAdvertById(id) {
            advert = coreAdvert
        } else {
            advert = Advert.init(context: CoreDataManager.instance.persistentContainer.viewContext)
            advert?.id = id
        }
        
        do {
            advert?.title = title
            advert?.city = try row.select(".listing-item__place").text()
            advert?.date = try row.select(".listing-item__date").text()
            advert?.link = try row.select(".listing-item__link").attr("href")
            
            var priceText = try row.select(".listing-item__price").text()
            
            priceText = priceText.replacingOccurrences(of: " ", with: "")
            priceText = priceText.replacingOccurrences(of: " ", with: "")
            priceText = priceText.replacingOccurrences(of: "₽", with: "")

            if let price = Int32(priceText) {
                advert?.price = price
            }
            
            let image = try row.select(".image.tile__image").attr("data-original")
            advert?.previewImage = "https:" + image
            
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
        
        return advert
    }
    
}

extension AdvertDetails {
    
    init?(parseFromAvito html: String) {
        images = []
        text = ""
        
        do {
            let doc: Document = try SwiftSoup.parse(html)
            text = try doc.select(".item-description-text p").text()
            for imageRow in try! doc.select(".js-gallery-img-frame") {
                if let image = try? imageRow.attr("data-url") {
                    images.append("https:" + image)
                }
            }
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
