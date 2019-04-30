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

    func setPlaceholderColor(_ color: UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = color
        
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = color
        
        if let clearButton = textFieldInsideSearchBar?.value(forKey: "clearButton") as? UIButton {
            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for : .normal)
            clearButton.tintColor = color
        }
        
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = color
    }
    
}
