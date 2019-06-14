//
//  Screen.swift
//  MyMot
//
//  Created by Michail Solyanic on 13/06/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class Screen {
    
    static var width = UIScreen.main.bounds.width
    static var height = UIScreen.main.bounds.height
    
    static var safeWidth: CGFloat {
        var safeWidth = width
        if #available(iOS 11.0, *), let window = UIApplication.shared.keyWindow {
            if isLandscape {
                if window.safeAreaInsets.left > window.safeAreaInsets.top {
                    safeWidth -= window.safeAreaInsets.left * 2
                } else {
                    safeWidth -= window.safeAreaInsets.top * 2
                }
            }
        }
        return safeWidth
    }
    
    static var isLandscape: Bool {
        return width > height
    }
    
    static var minSide: CGFloat {
        return width > height ? height : width
    }
    
    
}
