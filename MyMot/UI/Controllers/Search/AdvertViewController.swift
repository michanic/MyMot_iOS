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
    
    @IBOutlet weak var webView: WKWebView!
    
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
        
        webView.navigationDelegate = self
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17"
        webView.isHidden = true
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
        
        /*if let link = advert.link, let url = URL(string: link) {
            webView.load(URLRequest(url: url))
        }*/
        
        let siteInteractor = SitesInteractor()
        siteInteractor.loadAdvertPhone(advert: advert) { (phone) in
            phone.makeCall()
            print(phone)
        }
    }
    
}


extension AdvertViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //let script = "$('.phone-call__show-phone-button').click();"
        
        //let script = "var element = document.getElementsByClassName(\"phone-call__show-phone\")[0];" + "element.click();"
        
        //let script = "var clickEvent = new MouseEvent('click', {'view': window,'bubbles': true,'cancelable': false}); var element = document.getElementsByClassName('phone-call__show-phone-button'); element.dispatchEvent(clickEvent);"
        
        let script = "var clickEvent = new MouseEvent('click', {'view': window,'bubbles': true,'cancelable': false}); document.getElementsByClassName('phone-call__show-phone-button')[0].dispatchEvent(clickEvent);"

        webView.evaluateJavaScript(script) { (result, error) in
            
            if let result = result {
                print(result)
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            
            print(url)
        }
        
        decisionHandler(.allow)
    }
    
    /*func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }*/
    
}
