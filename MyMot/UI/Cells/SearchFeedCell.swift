//
//  SearchFeedCell.swift
//  MyMot
//
//  Created by Michail Solyanic on 23/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class SearchFeedCell: UICollectionViewCell, CellContentProtocol {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!

    func fillWithContent(content: Any?, eventListener: CellEventProtocol?) {
        if let advert = content as? Advert {
            image.setImage(path: advert.previewImage, placeholder: nil, completed: nil)
            title.text = advert.title
            price.text = advert.price.toStringPrice()
            details.text = (advert.city ?? "") + "\n" + (advert.date ?? "")
        }
    }
        
}
