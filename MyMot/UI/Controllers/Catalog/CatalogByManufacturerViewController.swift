//
//  CatalogByManufacturerViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 10/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class CatalogByManufacturerViewController: UniversalViewController {

    let manufacturer: Manufacturer
    
    init(manufacturer: Manufacturer) {
        self.manufacturer = manufacturer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarTitle = manufacturer.name ?? ""
    }
    
    override func prepareData() {
        
    }
}
