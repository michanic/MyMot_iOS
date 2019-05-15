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
    
    func fillWithContent(content: Any?, eventListener: CellEventProtocol?) {
        if let category = content as? Category {
            image.setImage(path: category.image, placeholder: UIImage.placeholder, completed: nil)
            title.text = category.name
        } else if let manufacturer = content as? Manufacturer {
            image.setImage(path: manufacturer.image, placeholder: UIImage.placeholder, completed: nil)
            title.text = manufacturer.name
        }
    }

}
