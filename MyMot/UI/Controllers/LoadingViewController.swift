//
//  LoadingViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 02/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    var bigTitle: String
    var subtitle: String
    
    @IBOutlet weak var bigTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    init(title: String, subtitle: String) {
        self.bigTitle = title
        self.subtitle = subtitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bigTitleLabel.text = bigTitle
        subtitleLabel.text = subtitle
    }

}
