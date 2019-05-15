//
//  CategoryAboutCell.swift
//  MyMot
//
//  Created by Michail Solyanic on 13/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class CategoryAboutCell: UITableViewCell, CellContentProtocol {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var aboutLabel: UILabel!
    
    func fillWithContent(content: Any?, eventListener: CellEventProtocol?) {
        if let content = content as? (String?, String?) {
            categoryImage.setImage(path: content.0, placeholder: nil, completed: nil)
            aboutLabel.text = content.1
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
    }
    
}
