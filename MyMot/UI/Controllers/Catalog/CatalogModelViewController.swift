//
//  CatalogModelViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 10/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class CatalogModelViewController: UniversalViewController {

    let model: Model
    
    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarTitle = (model.name ?? "")
        
        updateFavouriteButton()
        
        let apiInteractor = ApiInteractor()
        apiInteractor.loadModelDetails(modelId: Int(model.id)) { (details) in
            
        }
    }

    @objc func toFavourite() {
        model.favourite =  !model.favourite
        CoreDataManager.instance.saveContext()
        updateFavouriteButton()
    }
    
    func updateFavouriteButton() {
        if model.favourite {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_favourite_active")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(toFavourite))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_favourite_passive")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(toFavourite))
        }
    }

}
