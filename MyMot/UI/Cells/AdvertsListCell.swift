//
//  AdvertsListCell.swift
//  MyMot
//
//  Created by Michail Solyanic on 02/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

protocol AdvertCellEventProtocol: CellEventProtocol {
    func favouritePressed()
}

class AdvertsListCell: UITableViewCell, CellContentProtocol {
    
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UIButton!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
   
    private var eventListener: AdvertCellEventProtocol?
    
    func fillWithContent(content: Any?, eventListener: CellEventProtocol?) {
        if let advert = content as? Advert {
            preview.setImage(path: advert.previewImage, placeholder: UIImage.placeholder)
            title.text = advert.title
            price.setTitle(advert.price.toStringPrice(), for: .normal)
            city.text = advert.city
            favouriteButton.alpha = advert.favourite ? 1.0 : 0.2
        }
        if let listener = eventListener as? AdvertCellEventProtocol {
            self.eventListener = listener
        }
    }
    
    @IBAction func favouritePressed(_ sender: Any) {
        eventListener?.favouritePressed()
    }
    
    
}
