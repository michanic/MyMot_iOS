//
//  TabBarController.swift
//  MyMot
//
//  Created by Michail Solyanic on 14/06/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        Screen.width = size.width
        Screen.height = size.height
        NotificationCenter.post(type: .screenOrientationChanged, object: size.width)
    }
    
}
