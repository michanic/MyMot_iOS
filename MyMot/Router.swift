//
//  Coordinator.swift
//  MyMot
//
//  Created by Michail Solyanic on 03/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class Router {
    
    static let shared : Router = Router()
    var window: UIWindow
    
    init() {
        if let w = UIApplication.shared.delegate?.window, let window = w {
            self.window = window
        } else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
        }
        self.window.makeKeyAndVisible()
    }
    
    func startApp() {
        window.rootViewController = ViewControllerFactory.loading("Загрузка", "Синхронизация каталога").create
        
        let apiInteractor = ApiInteractor()
        apiInteractor.loadCatalog { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.showMain()
            }
        }
    }
    
    func pushController(_ viewController: UIViewController) {
        if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController,
            let currentNavigationController = tabBarController.viewControllers?[tabBarController.selectedIndex] as? UINavigationController {
            currentNavigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func presentController(_ viewController: UniversalViewController) {
        
        
        
    }
    
    private func showMain() {
        changeRootController(ViewControllerFactory.tabBarController.create)
    }
    
    private func changeRootController(_ newController: UIViewController) {
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.window.rootViewController = newController
            }, completion: nil)
    }
    
    
}
