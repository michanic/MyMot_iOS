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

    func parseAdverts(html: String, source: Source) -> ([Advert]?, Bool) {
        var loadMore = false
        do {
            let doc: Document = try SwiftSoup.parse(html)
            var adverts: [Advert] = []
                        
            switch source {
            case .avito:
                
                if try! doc.select(".pagination-page.js-pagination-next").hasText() {
                    loadMore = true
                }
                
                for row in try! doc.select(source.itemSelector) {
                    if let advert = Advert.createOrUpdateFromAvito(row) {
                        adverts.append(advert)
                    }
                }
                
            case .auto_ru:
                
                if try! doc.select(".pager__next.button__control .button__text").hasText() {
                    if try! doc.select(".pager__next.button__control").hasClass("button_disabled") {
                        loadMore = false
                    } else {
                        loadMore = true
                    }
                }
                
                for row in try! doc.select(source.itemSelector) {
                    if let advert = Advert.createOrUpdateFromAutoru(row) {
                        adverts.append(advert)
                    }
                }
                
                break
            }
            return (adverts.count > 0 ? adverts : nil, loadMore)
            
        } catch let error {
            print(error.localizedDescription)
            return (nil, loadMore)
        }
    }
    
    func parseAdvertDetails(html: String, source: Source) -> AdvertDetails? {
        switch source {
        case .avito:
            return AdvertDetails(parseFromAvito: html)
        default:
            return AdvertDetails(parseFromAutoru: html)
        }
    }
    
    func parsePhoneFromAvito(html: String) -> String {
        do {
            let doc: Document = try SwiftSoup.parse(html)
            if let phone = try? doc.select("[data-marker='item-contact-bar/call']").attr("href") {
                return(phone.replacingOccurrences(of: "tel:", with: ""))
            }
            return ("")
        } catch let error {
            print(error.localizedDescription)
            return ("")
        }
    }
    
    func parsePhonesFromAutoRu(html: String) -> [String] {
        do {
            
            let doc: Document = try SwiftSoup.parse(html)
            var phones:[String] = []
            for row in try! doc.select(".card-phones__item") {
                if let phone = try? row.text() {
                    phones.append(phone)
                }
            }
            return phones
        } catch let error {
            print(error.localizedDescription)
            return []
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
                advert?.link = Source.avito(nil, nil, nil, nil, nil).domain + link
            }
            
            var priceText = try row.select("span.price").text()
            priceText = priceText.replacingOccurrences(of: " ", with: "")
            priceText = priceText.replacingOccurrences(of: "₽", with: "")
            if let price = Int32(priceText) {
                advert?.price = price
            }
            
            let image = try row.select("img.large-picture-img[src]").array().map { try $0.attr("src").description }.first
            if let image = image {
                if image.contains("http") {
                    advert?.previewImage = image
                } else {
                    advert?.previewImage = "https:" + image
                }
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
            if try doc.select(".item-description-text").isEmpty() {
                text = try doc.select(".item-description-html").html()
            } else {
                text = try doc.select(".item-description-text").html()
            }
            date = try doc.select(".title-info-actions-item .title-info-metadata-item-redesign").text()
            warning = try doc.select(".item-view-warning-content .has-bold").text()
            
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
    
    init?(parseFromAutoru html: String) {
        images = []
        text = ""
                
        do {
            let doc: Document = try SwiftSoup.parse(html)
            text = try doc.select(".seller-details__text").html()
            date = try doc.select(".card__stat .card__stat-item:eq(1)").text()
            warning = try doc.select(".card__sold-message-header").text()
            
            var parameters: Parameters = []
            for label in try! doc.select(".card__info .card__info-label") {
                if let value = try? label.nextElementSibling()?.text(), let labelText = try? label.text() {
                    parameters.append((labelText, value))
                }
            }
            if parameters.count > 0 {
                self.parameters = parameters
            }
            
            for imageRow in try! doc.select(".gallery__thumb-item") {
                if let image = try? imageRow.attr("data-img") {
                    images.append("https:" + image)
                }
            }
            guard let dataBem = try? doc.select(".stat-publicapi").attr("data-bem"), let sale_hash = JSON(parseJSON: dataBem).dictionary?["card"]?.dictionary?["sale_hash"]?.string else { return nil }
            saleHash = sale_hash
            
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
