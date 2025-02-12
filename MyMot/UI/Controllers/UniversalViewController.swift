//
//  UniversalViewController.swift
//  MyMot
//
//  Created by Michail Solyanic on 10/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit
import KRPullLoader

protocol UniversalViewControllerRefreshing: class {
    func refreshPulled()
    var refreshCompletionHandler: (()->Void)? { get set }
}

protocol UniversalViewControllerLoadMore: class {
    func loadMore()
    var loadMoreCompletionHandler: (()->Void)? { get set }
    var loadMoreAvailable: Bool { get set }
    var currentPage: Int { get set }
}

class UniversalViewController: UIViewController, DataSource, KeyboardEventsDelegate {
    
    var darkStyle: Bool = false
    var dataSource: [Section] = []
    var loadingView: UIView?
    var keyboardManager = KeyboardManager()
    var hideKeyboardByTouchView: UIView?
    var hideKeyboardPressed: (() -> ())?
    var navBarTitle: String {
        get { return title ?? "" }
        set { title = "‌‌‍‍ " + newValue + "‌‌‍‍ " }
    }
    var startScrollTo: IndexPath?
    
    weak var refreshDelegate: UniversalViewControllerRefreshing?
    let refreshView = KRPullLoadView()
    
    weak var loadMoreDelegate: UniversalViewControllerLoadMore?
    let loadMoreView = KRPullLoadView()
    
    @IBOutlet weak var customTableView: TableView?
    @IBOutlet weak var customCollectionView: CollectionView?

    lazy var tableView: TableView = {
        if let customTableView = customTableView {
            customTableView.setupWithCustomView(dataSourceDelegate: self)
            return customTableView
        } else {
            return TableView(dataSourceDelegate: self, frame: self.view.bounds)
        }
    } ()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyboardManager.delegate = self
        hideKeyboardByTouchView = view
        
        prepareData()
        
        if dataSource.count > 0 && customTableView == nil && customCollectionView == nil {
            
            view.addSubview(tableView)
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            tableView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 0).isActive = true
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            tableView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
            
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
        
        if refreshDelegate != nil {
            refreshView.delegate = self
            refreshSetEnabled(true)
        }
        if loadMoreDelegate != nil {
            loadMoreView.delegate = self
            loadMoreSetEnabled(true)
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func prepareData() {
        dataSource = []
    }
    
    func createLoadingView(transparent: Bool?) {
        let loadingView = UIView(frame: self.view.bounds)
        let indicatorView = UIActivityIndicatorView(style: .gray)
        indicatorView.frame = CGRect(x: loadingView.bounds.width / 2 - 10, y: loadingView.bounds.height / 2 - 10, width: 20, height: 20)
        indicatorView.startAnimating()
        loadingView.addSubview(indicatorView)
        if let transparent = transparent, transparent == false {
            loadingView.backgroundColor = UIColor.clear
        } else {
            loadingView.backgroundColor = UIColor.white
        }
        view.addSubview(loadingView)
        
        NSLayoutConstraint.pinBorders(of: loadingView, toView: view, top: 0, left: 0, right: 0, bottom: 0)
        NSLayoutConstraint.pinCenter(of: indicatorView, toView: loadingView)
        
        self.loadingView = loadingView
    }
    
    func showLoading(transparent: Bool? = nil) {
        createLoadingView(transparent: transparent)
    }
    
    func hideLoading() {
        loadingView?.removeFromSuperview()
        loadingView = nil
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
        Router.shared.clearPresentController()
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
    
    func updateCellSizes() {
        for section in dataSource {
            for cell in section.cells {
                cell.updateSize()
            }
        }
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
    
    func deleteRows(indexPaths: [IndexPath]) {
        tableView.beginUpdates()
        tableView.deleteRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
    }
    
}

func Delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}
