//
//  CellAccessoryType.swift
//  MyMot
//
//  Created by Michail Solyanic on 17/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

enum CellAccessoryType {
    case right
    case top
    case bottom
    case hidden
    case checked
    case loading
    
    var angle: CGFloat {
        switch self {
        case .right, .hidden, .checked, .loading:
            return 0
        case .top:
            return -CGFloat.pi / 2
        case .bottom:
            return CGFloat.pi / 2
        }
    }
}
