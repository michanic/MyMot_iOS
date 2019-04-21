//
//  FavouritesViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 02/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class FavouritesViewController: UniversalViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func prepareData() {
        refreshData()
    }
    
    func refreshData() {
        dataSource = [Section()]
        if segmentControl.selectedSegmentIndex == 0 {
            
        } else {
            for model in CoreDataManager.instance.getFavouriteModels() {
                let modelCell = Cell(modelsList: model)
                dataSource[0].cells.append(modelCell)
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        refreshData()
    }
    
}
