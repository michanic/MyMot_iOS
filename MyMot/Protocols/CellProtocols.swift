//
//  CellProtocols.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit
import SDWebImage

protocol CellEventProtocol: class {
    func tapEvent()
}

protocol CellContentProtocol: class {
    func fillWithContent(content: Any?, eventListener: CellEventProtocol?)
}

protocol CellAccessoryStateProtocol: class {
    func setAccessoryState(_ state: CellAccessoryType)
}

protocol CellUpdateProtocol: class {
    func updateData()
    func updateSections(sections: IndexSet)
    func updateRows(indexPaths: [IndexPath])
}
