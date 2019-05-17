//
//  TextViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 17/05/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class TextViewController: UniversalViewController {

    @IBOutlet weak var textView: UITextView!
    var pageTitle: String
    
    init(pageTitle: String) {
        self.pageTitle = pageTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarTitle = pageTitle
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoading(transparent: true)
        let apiInteractor = ApiInteractor()
        apiInteractor.loadAgreementText { (text) in
            if let attributedString = try? NSAttributedString(htmlString: text, font: UIFont.systemFont(ofSize: 14), useDocumentFontSize: false) {
                self.textView.attributedText = attributedString
            }
            self.hideLoading()
        }
    }
    
}
