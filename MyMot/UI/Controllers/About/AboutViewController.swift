//
//  AboutViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 30/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class AboutViewController: UniversalViewController {

    @IBOutlet weak var aboutText: UITextView!
    @IBOutlet weak var separatorHeight: NSLayoutConstraint!
    @IBOutlet weak var separator2Height: NSLayoutConstraint!
    
    let sitesInteractor = SitesInteractor()
    let regions = CoreDataManager.instance.getRegions()
    //var currentRegion = 83
    //var currentcCity = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        separatorHeight.constant = 0.5
        separator2Height.constant = 0.5
        aboutText.textContainerInset = UIEdgeInsets(top: -2, left: -5, bottom: 0, right: 0)
        
        aboutText.text = nil
        DispatchQueue.global(qos: .background).async {
            if let aboutString = ConfigStorage.shared.aboutText, let attributedString = try? NSAttributedString(htmlString: aboutString, font: UIFont.systemFont(ofSize: 14), useDocumentFontSize: false) {
                DispatchQueue.main.async {
                    self.aboutText.attributedText = attributedString
                }
            }
        }
        
        //checkNextCity()
    }
    
    /*func checkNextCity() {
        let cities = self.regions[self.currentRegion].getCities()
        let city = cities[self.currentcCity]
        
        sitesInteractor.checkRegionLinksAdverts(city) {
            self.currentcCity += 1
            if self.currentcCity < cities.count {
                self.checkNextCity()
            } else {
                self.currentcCity = 0
                self.currentRegion += 1
                if self.currentRegion < (self.currentRegion + 1) {
                    self.checkNextCity()
                } else {
                    print("FINISH")
                }
            }
        }
    }*/
    
    @IBAction func privacyPressed(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        Router.shared.pushController(ViewControllerFactory.textViewer(title).create)
    }
    

}
