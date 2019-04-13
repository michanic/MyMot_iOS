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
    
    var loadingView: UIView?
    lazy var tableView: TableView = { return TableView(dataSourceDelegate: self, frame: self.view.bounds, style: .plain) } ()
    
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
    
    func createLoadingView() {
        let loadingView = UIView(frame: self.view.bounds)
        let indicatorView = UIActivityIndicatorView(style: .gray)
        indicatorView.frame = CGRect(x: loadingView.bounds.width / 2 - 10, y: loadingView.bounds.height / 2 - 10, width: 20, height: 20)
        indicatorView.startAnimating()
        loadingView.addSubview(indicatorView)
        loadingView.backgroundColor = UIColor.white
        view.addSubview(loadingView)
        self.loadingView = loadingView
    }
    
    func showLoading() {
        if let loadingView = loadingView {
            view.addSubview(loadingView)
        } else {
            createLoadingView()
        }
    }
    
    func hideLoading() {
        loadingView?.removeFromSuperview()
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
