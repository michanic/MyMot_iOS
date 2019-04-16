//
//  SimpleCell.swift
//  MyMot
//
//  Created by Michail Solyanic on 02/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class SimpleCell: UITableViewCell, CellContentProtocol {
    
    @IBOutlet weak var simpleLabel: UILabel!
    
    func fillWithContent(content: Any?, eventListener: CellEventProtocol?) {
        if let content = content as? String {
            simpleLabel.text = content
        }
    }

}

extension Cell {
    convenience init(simpleTitle: String) {
        self.init(cellType: .simple)
        self.content = simpleTitle
    }
}
