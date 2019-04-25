//
//  Advert.swift
//  MyMot
//
//  Created by Michail Solyanic on 23/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import SwiftSoup

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
    
}


extension Cell {
    convenience init(searchFeedAdvert advert: Advert) {
        self.init(cellType: .searchFeed)
        self.content = advert
        self.cellTapped = { indexPath in
            //Router.shared.pushController(ViewControllerFactory.catalogModelDetails(model).create)
        }
    }
}
