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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutText.textContainerInset = UIEdgeInsets(top: -2, left: -5, bottom: 0, right: 0)
        if let aboutString = ConfigStorage.shared.aboutText, let attributedString = try? NSAttributedString(htmlString: aboutString, font: UIFont.systemFont(ofSize: 14), useDocumentFontSize: false) {
            aboutText.attributedText = attributedString
        }
    }
    
    @IBAction func privacyPressed(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        Router.shared.pushController(ViewControllerFactory.textViewer(title).create)
    }
    

}
