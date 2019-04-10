//
//  UniversalViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 10/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class UniversalViewController: UIViewController, DataSource {

    var dataSource: [Section] = []
    var navBarTitle: String {
        get {
            return title ?? ""
        }
        set {
            title = "‌‌‍‍ " + newValue + "‌‌‍‍ "
        }
    }
    
    lazy var tableView: TableView = {
        return TableView(dataSourceDelegate: self, frame: self.view.bounds, style: .plain)
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareData()
        if dataSource.count > 0 {
            view.addSubview(tableView)
        }
        
        if let navigationController = navigationController {
            if navigationController.viewControllers.count == 1 && tabBarController == nil {
                addCloseButton()
            } else if navigationController.viewControllers.count > 1 {
                addBackButton()
            }
        }
    }
    
    func prepareData() {
        dataSource = []
    }
    
    private func addCloseButton() {
        let backButton = UIBarButtonItem(image: UIImage(named: "nav_cancel"), style: .plain, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func addBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(named: "nav_back"), style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
}
