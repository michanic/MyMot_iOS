//
//  UniversalViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 10/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class UniversalViewController: UIViewController, DataSource, KeyboardEventsDelegate {
    
    var dataSource: [Section] = []
    var loadingView: UIView?
    var keyboardManager = KeyboardManager()
    var hideKeyboardByTouchView: UIView?
    var navBarTitle: String {
        get { return title ?? "" }
        set { title = "‌‌‍‍ " + newValue + "‌‌‍‍ " }
    }
    var startScrollTo: IndexPath?
    
    @IBOutlet weak var customTableView: TableView?
    @IBOutlet weak var customCollectionView: CollectionView?

    lazy var tableView: TableView = {
        if let customTableView = customTableView {
            customTableView.setupWithCustomView(dataSourceDelegate: self)
            return customTableView
        } else {
            return TableView(dataSourceDelegate: self, frame: self.view.bounds, style: .plain)
        }
    } ()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyboardManager.delegate = self
        hideKeyboardByTouchView = view
        
        prepareData()
        
        if dataSource.count > 0 && customTableView == nil && customCollectionView == nil {
            view.addSubview(tableView)
        } else if let customCollectionView = customCollectionView {
            customCollectionView.setupWithCustomView(dataSourceDelegate: self)
        }
        
        if let navigationController = navigationController {
            if navigationController.viewControllers.count == 1 && tabBarController == nil {
                addCloseButton()
            } else if navigationController.viewControllers.count > 1 {
                addBackButton()
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        if let startScrollTo = startScrollTo {
            tableView.scrollToRow(at: startScrollTo, at: .middle, animated: false)
            self.startScrollTo = nil
        }
        keyboardManager.beginMonitoring()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        keyboardManager.stopMonitoring()
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

extension UniversalViewController: CellUpdateProtocol {
    
    func updateData() {
        tableView.reloadData()
        customCollectionView?.reloadData()
    }
    
    func updateSections(sections: IndexSet) {
        tableView.beginUpdates()
        tableView.reloadSections(sections, with: .automatic)
        tableView.endUpdates()
    }
    
    func updateRows(indexPaths: [IndexPath]) {
        tableView.beginUpdates()
        tableView.reloadRows(at: indexPaths, with: .fade)
        tableView.endUpdates()
    }
    
}

func Delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}
