//
//  UIView.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

extension UIView {
    
    static func titleForHeaderInSection(_ title: String?) -> UIView {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 25.0))
        backView.backgroundColor = UIColor.tableSectionBack
        if let title = title, title.count > 0 {
            let titleLabel = UILabel(frame: CGRect(x: 23, y: 5, width: UIScreen.width - 40, height: 16.0))
            titleLabel.text = title
            titleLabel.font = UIFont.suzuki(size: 12)
            titleLabel.textColor = UIColor.tableSectionTitle
            backView.addSubview(titleLabel)
        }
        return backView
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
}
