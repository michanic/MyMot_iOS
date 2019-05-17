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
   
    private var eventListener: CellEventProtocol?
    
    func fillWithContent(content: Any?, eventListener: CellEventProtocol?) {
        self.eventListener = eventListener
        if let advert = content as? Advert {
            preview.setImage(path: advert.previewImage, placeholder: UIImage.placeholder, completed: nil)
            title.text = advert.title
            price.setTitle(advert.price.toStringPrice(), for: .normal)
            city.text = advert.city
            updateFavouriteButton(favourite: advert.favourite)
        }
    }
    
    func updateFavouriteButton(favourite: Bool) {
        favouriteButton.alpha = favourite ? 0.6 : 0.1
        favouriteButton.tag = favourite ? 1 : 0
    }
    
    @IBAction func favouritePressed(_ sender: UIButton) {
        eventListener?.boolValueChanged(sender.tag == 0)
    }
    
    
}
