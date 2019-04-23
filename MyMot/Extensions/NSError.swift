//
//  NSError.swift
//  IosTestSolyanic
//
//  Created by Michail Solyanic on 13/03/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Foundation

extension NSError {
    
    class var notValidLink: NSError {
        return NSError(domain: Bundle.main.bundleIdentifier!, code: 1001, userInfo: [NSLocalizedDescriptionKey: "Не валидная ссылка"])
    }
    
}
