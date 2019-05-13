//
//  AdvertViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 25/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit
import WebKit

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
        NotificationCenter.post(type: .favouriteAdvertSwitched, object: advert)
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
        priceLabel.text = advert.price.toStringPrice()
        
        if let advertDetails = advertDetails {
            imagesSlider.fillWithImages(advertDetails.images, contentMode: .scaleAspectFill)
            aboutLabel.text = advertDetails.text
        }
    }
    
    @IBAction func callPressed(_ sender: Any) {

        let siteInteractor = SitesInteractor()
        
        if let source = advert.getSource() {
            switch source {
            case .avito:
                siteInteractor.loadAvitoAdvertPhone(advert: advert) { (phone) in
                    phone.makeCall()
                }
            case .auto_ru:
                guard let advertId = advert.id, let saleHash = advertDetails?.saleHash, let token = ConfigStorage.getCsrfToken() else { return }
                siteInteractor.loadAutoRuAdvertPhones(saleId: advertId, saleHash: saleHash, token: token) { (phones) in
                    if phones.count == 1 {
                        phones[0].makeCall()
                    } else if phones.count > 1 {
                        let actionSheet = UIAlertController(title: "Позвонить", message: nil, preferredStyle: .actionSheet)
                        for phone in phones {
                            let callAction = UIAlertAction(title: phone, style: .default, handler: { (alert: UIAlertAction!) -> Void in
                                phone.makeCall()
                            })
                            actionSheet.addAction(callAction)
                        }
                        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in })
                        actionSheet.addAction(cancelAction)
                        self.present(actionSheet, animated: true, completion: nil)
                        // TODO
                    } else {
                        // TODO
                    }
                }
            }
        }
        
    }
    
}
