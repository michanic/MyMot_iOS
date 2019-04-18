//
//  SimpleCell.swift
//  MyMot
//
//  Created by Michail Solyanic on 02/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class SimpleCell: UITableViewCell, CellContentProtocol, CellAccessoryStateProtocol {
    
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    func fillWithContent(content: Any?, eventListener: CellEventProtocol?) {
        if let content = content as? String? {
            simpleLabel.text = content
            setAccessoryState(.right)
        } else if let content = content as? (String?, CellAccessoryType) {
            simpleLabel.text = content.0
            setAccessoryState(content.1)
        }
        
    }
    
    func setAccessoryState(_ state: CellAccessoryType) {
        arrowImage.rotate(angle: state.angle)
        switch state {
        case .hidden:
            arrowImage.image = nil
        case .checked:
            arrowImage.image = UIImage(named: "cell_checked")
        default:
            arrowImage.image = UIImage(named: "cell_arrow_right")
        }
    }
    
}

extension Cell {
    convenience init(simpleTitle: String?) {
        self.init(cellType: .simple)
        self.content = simpleTitle
    }
    
    convenience init(simpleTitle: String?, accessoryState: CellAccessoryType) {
        self.init(cellType: .simple)
        self.content = (simpleTitle, accessoryState)
    }
}
