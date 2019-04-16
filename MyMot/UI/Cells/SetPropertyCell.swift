//
//  SetPropertyCell.swift
//  MyMot
//
//  Created by Michail Solyanic on 16/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class SetPropertyCell: UITableViewCell, CellContentProtocol {
    
    @IBOutlet weak var propertyCaption: UILabel!
    @IBOutlet weak var propertyField: UITextField!
    
    func fillWithContent(content: Any?, eventListener: CellEventProtocol?) {
        if let content = content as? (String, String?, UIKeyboardType) {
            propertyCaption.text = content.0
            propertyField.text = content.1
            propertyField.keyboardType = content.2
            propertyField.clearButtonMode = .never
            propertyField.textAlignment = .right
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
    }
}


extension Cell {
    convenience init(propertyTitle: String, propertyValue: String?, keyboardType: UIKeyboardType) {
        self.init(cellType: .setProperty)
        self.content = (propertyTitle, propertyValue, keyboardType)
    }
}
