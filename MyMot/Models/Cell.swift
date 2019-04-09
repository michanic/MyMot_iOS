//
//  Cell.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Foundation

class Cell {

    var type: CellType
    var content: Any?
    var eventListener: CellEventProtocol?
    
    init(cellType: CellType) {
        self.type = cellType
    }
    
}
