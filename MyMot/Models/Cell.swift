//
//  Cell.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class Cell {

    var type: CellType
    var content: Any?
    var eventListener: CellEventProtocol?
    var height: CGFloat
    
    init(cellType: CellType) {
        self.type = cellType
        self.height = cellType.height
    }
    
}
