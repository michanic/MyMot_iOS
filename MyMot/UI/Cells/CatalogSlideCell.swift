//
//  CatalogSlideCell.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class CatalogSlideCell: UICollectionViewCell, CellContentProtocol {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var about: UILabel!
    
    func fillWithContent(content: Any?, eventListener: CellEventProtocol?) {
        
    }

}
