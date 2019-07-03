//
//  UISearchBar.swift
//  MyMot
//
//  Created by Michail Solyanic on 30/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    func setSearchButtonText(_ text: String) {
        self.setValue(text, forKey: "_cancelButtonText")
    }
    
    func setupSearchField(){
        setImage(UIImage(named: "search_clear"), for: .clear, state: .normal)
        
        searchBarStyle = .minimal
        barTintColor = .white
        tintColor = .white
        
        showsBookmarkButton = true
        setImage(UIImage(named: "nav_filter"), for: .bookmark, state: .normal)
        
        setPlaceholderColor(.white)
        
        if let textfield = self.value(forKey: "searchField") as? UITextField {
            textfield.textColor = .white
            textfield.backgroundColor = .appPassiveBlue
        }
    }
    
    func setPlaceholderColor(_ color: UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = color
        
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = color
        
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = color
        
    }
    
}
