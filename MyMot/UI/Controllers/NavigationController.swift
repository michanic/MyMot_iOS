//
//  NavigationController.swift
//  MyMot
//
//  Created by Michail Solyanic on 11/06/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.appBlue
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white , NSAttributedString.Key.font: UIFont.progress(size: 20)]
        
        /*navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.layoutIfNeeded()*/
        
        view.backgroundColor = .white
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


}
