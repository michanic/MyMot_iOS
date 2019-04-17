//
//  FilterModelsViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 17/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class FilterModelsViewController: UniversalViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navBarTitle = "Модель"
    }

    override func prepareData() {
        dataSource = [Section()]
    }
    
}
