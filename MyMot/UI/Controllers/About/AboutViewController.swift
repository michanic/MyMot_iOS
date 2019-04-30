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
        
        if let aboutString = ConfigStorage.shared.aboutText, let attributedString = try? NSAttributedString(htmlString: aboutString, font: UIFont.systemFont(ofSize: 14), useDocumentFontSize: false) {
            aboutText.attributedText = attributedString
        }
    }
    

}
