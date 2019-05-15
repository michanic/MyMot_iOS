//
//  UIImageView.swift
//  MyMot
//
//  Created by Michail Solyanic on 09/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImage(path: String?, placeholder: UIImage?, completed: (()->())?) {
        if let path = path, let url = URL(string: path.contains("https:") ? path : (URL.root + path)) {
            sd_setImage(with: url, placeholderImage: placeholder, options: .highPriority) { (_, _, _, _) in
                completed?()
            }
        } else {
            image = placeholder
            completed?()
        }
    }
    
}
