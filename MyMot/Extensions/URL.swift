//
//  URL.swift
//  MyMot
//
//  Created by Michail Solyanic on 02/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Foundation

extension URL {
    
    static var root: String {
        guard let info = Bundle.main.infoDictionary,
            let urlString = info["Domain"] as? String,
            let url = URL(string: urlString) else {
                fatalError("Cannot get base url from info.plist")
        }
        return url.absoluteString
    }
    
    static var api: String {
        guard let info = Bundle.main.infoDictionary,
            let urlString = info["Domain"] as? String,
            let url = URL(string: urlString + "api/") else {
                fatalError("Cannot get base url from info.plist")
        }
        return url.absoluteString
    }

    init?(fromEndpoint: String) {
        self.init(string: URL.api + fromEndpoint)
    }
}
