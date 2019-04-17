//
//  Cell.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class Cell {

    // Properties
    var type: CellType
    var content: Any?
    var height: CGFloat
    var indexPath: IndexPath?
    
    // Events
    var eventListener: CellEventProtocol?
    var cellTapped: ((IndexPath?) -> ())?
    
    init(cellType: CellType) {
        self.type = cellType
        self.height = cellType.height
        self.eventListener = self
    }
    
}

extension Cell: CellEventProtocol {
    
    func tapEvent() {
        cellTapped?(indexPath)
    }
    
}
