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
    
    lazy var favouritesSwitchSubscriber = NotificationSubscriber(types: [.favouriteAdvertSwitched, .favouriteModelSwitched], received: { (object) in
        self.refreshData()
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.editingDelegate = self
        NotificationCenter.subscribe(favouritesSwitchSubscriber)
    }

    override func prepareData() {
        refreshData()
    }
    
    func refreshData() {
        dataSource = [Section()]
        if segmentControl.selectedSegmentIndex == 0 {
            for advert in CoreDataManager.instance.getFavouriteAdverts() {
                let advertCell = Cell(advertsList: advert)
                advertCell.editingDelete = true
                dataSource[0].cells.append(advertCell)
            }
        } else {
            for model in CoreDataManager.instance.getFavouriteModels() {
                let modelCell = Cell(modelsList: model, accessoryState: .right)
                modelCell.editingDelete = true
                dataSource[0].cells.append(modelCell)
            }
        }
        tableView.reloadData()
        tableView.isHidden = dataSource[0].cells.count == 0
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        refreshData()
    }
    
}

extension FavouritesViewController: TableViewEditing {
    func deleteCellPressed(indexPath: IndexPath) {
        print(indexPath.row)
        if segmentControl.selectedSegmentIndex == 0 {
            
        } else {
            
        }
    }
}
