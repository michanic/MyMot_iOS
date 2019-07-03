//
//  NSLayoutConstraint.swift
//  MyMot
//
//  Created by Michail Solyanic on 03/07/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    static func pinBorders(of view: UIView , toView: UIView, top: CGFloat, left: CGFloat, right: CGFloat, bottom: CGFloat) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: toView, attribute: .top, multiplier: 1, constant: top)
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: toView, attribute: .bottom, multiplier: 1, constant: bottom)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: toView, attribute: .leading, multiplier: 1, constant: left)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: toView, attribute: .trailing, multiplier: 1, constant: right)
        toView.addConstraints([topConstraint ,bottomConstraint , leadingConstraint , trailingConstraint])
    }
    
    static func pinCenter(of view: UIView , toView: UIView) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: toView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: toView, attribute: .centerY, multiplier: 1, constant: 0)
        toView.addConstraints([centerX ,centerY])
    }
}
