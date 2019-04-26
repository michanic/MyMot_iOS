//
//  AdvertViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 25/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class AdvertViewController: UniversalViewController {

    @IBOutlet weak var imagesSlider: ImagesSliderView!
    @IBOutlet weak var imagesSliderHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    
    let advert: Advert
    var advertDetails: AdvertDetails?
    
    init(advert: Advert) {
        self.advert = advert
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarTitle = (advert.title ?? "")
        updateFavouriteButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoading()
        let siteInteractor = SitesInteractor()
        siteInteractor.loadAdvertDetails(advert: advert) { (details) in
            self.advertDetails = details
            self.fillProperties()
            self.hideLoading()
        }
    }

    @objc func toFavourite() {
        advert.favourite =  !advert.favourite
        CoreDataManager.instance.saveContext()
        updateFavouriteButton()
    }
    
    private func updateFavouriteButton() {
        if advert.favourite {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_favourite_active")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(toFavourite))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_favourite_passive")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(toFavourite))
        }
    }
    
    private func fillProperties() {
        imagesSliderHeight.constant = UIScreen.width * 0.75 + 37
        view.layoutIfNeeded()
        
        titleLabel.text = advert.title
        cityLabel.text = advert.city
        dateLabel.text = advert.date
        priceLabel.text = String(advert.price) + " р."
        
        if let advertDetails = advertDetails {
            imagesSlider.fillWithImages(advertDetails.images, contentMode: .scaleAspectFill)
            aboutLabel.text = advertDetails.text
        }
    }
}
