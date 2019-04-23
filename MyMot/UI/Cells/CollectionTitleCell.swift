//
//  CollectionTitleCell.swift
//  MyMot
//
//  Created by Michail Solyanic on 23/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class CollectionTitleCell: UICollectionViewCell, CellContentProtocol {

    @IBOutlet weak var title: UILabel!
    
    func fillWithContent(content: Any?, eventListener: CellEventProtocol?) {
        if let titleText = content as? String {
            title.text = titleText
        }
    }

}

extension Cell {
    convenience init(collectionTitle: String) {
        self.init(cellType: .collectionTitle)
        self.content = collectionTitle
    }
}
