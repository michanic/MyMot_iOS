//
//  HtmlParser.swift
//  MyMot
//
//  Created by Michail Solyanic on 23/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit
import SwiftSoup

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
                    
                    break
                }
            }
            return adverts.count > 0 ? adverts : nil
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
