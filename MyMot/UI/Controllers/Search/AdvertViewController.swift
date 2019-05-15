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
    
    @IBOutlet weak var parametersView: UIStackView!
    @IBOutlet weak var parametersViewTop: NSLayoutConstraint!
    @IBOutlet weak var parametersViewHeight: NSLayoutConstraint!
    @IBOutlet weak var aboutTextView: UITextView!
    
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
        aboutTextView.textContainerInset = UIEdgeInsets(top: -2, left: -5, bottom: 0, right: 0)
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
        
        if let parameters = advertDetails?.parameters {
            parametersView.isHidden = false
            parametersViewTop.constant = 25
            drawParametersView(parameters)
        } else {
            parametersView.isHidden = true
            parametersViewTop.constant = 0
            parametersViewHeight.constant = 0
        }
        
        if let advertDetails = advertDetails {
            imagesSlider.fillWithImages(advertDetails.images, contentMode: .scaleAspectFill)
            aboutTextView.text = advertDetails.text
            
            if let aboutString = advertDetails.text, let attributedString = try? NSAttributedString(htmlString: aboutString, font: UIFont.systemFont(ofSize: 14), useDocumentFontSize: false) {
                aboutTextView.attributedText = attributedString
            }
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
    
    private func drawParametersView(_ parameters: Parameters) {
        
        let captionWidth = (UIScreen.width - 26 - 32 - 10) * 0.4
        let valueWidth = (UIScreen.width - 26 - 32 - 10) * 0.6
        var posY: CGFloat = 0
        
        for parameter in parameters {
            
            let captionHeight = parameter.0.getHeightFor(width: captionWidth, font: UIFont.systemFont(ofSize: 14))
            let valueHeight = parameter.1.getHeightFor(width: valueWidth, font: UIFont.systemFont(ofSize: 12))
            var viewHeight: CGFloat = 0
            if captionHeight > valueHeight {
                viewHeight = captionHeight + 24.0
            } else {
                viewHeight = valueHeight + 24.0
            }
            
            let backView = UIView(frame: CGRect(x: 0, y: posY, width: UIScreen.width, height: viewHeight))
            
            let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 0.5))
            separatorView.backgroundColor = UIColor.separatorGray
            backView.addSubview(separatorView)
            
            let captionLabel = UILabel(frame: CGRect(x: 26, y: 12, width: captionWidth, height: captionHeight))
            captionLabel.font = UIFont.systemFont(ofSize: 14)
            captionLabel.numberOfLines = 0
            captionLabel.textColor = UIColor.textDarkGray
            captionLabel.text = parameter.0
            backView.addSubview(captionLabel)
            
            let valueLabel = UILabel(frame: CGRect(x: UIScreen.width - valueWidth - 32, y: 12, width: valueWidth, height: valueHeight))
            valueLabel.font = UIFont.systemFont(ofSize: 12)
            valueLabel.numberOfLines = 0
            valueLabel.textColor = UIColor.textLightGray
            valueLabel.text = parameter.1
            backView.addSubview(valueLabel)
            
            parametersView.addSubview(backView)
            posY += backView.frame.height
            
        }
        parametersViewHeight.constant = posY
    }
    
}
