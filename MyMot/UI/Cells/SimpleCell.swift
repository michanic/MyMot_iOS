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
    @IBOutlet weak var arrowImage: UIImageView!
    
    func fillWithContent(content: Any?, eventListener: CellEventProtocol?) {
        if let content = content as? String {
            simpleLabel.text = content
            setArrowPosition(.right)
        } else if let content = content as? (String?, Bool) {
            simpleLabel.text = content.0
            setArrowPosition(content.1 ? .top : .bottom)
        }
    }
    
    private func setArrowPosition(_ position: CellArrowPosition) {
        arrowImage.rotate(angle: position.angle)
    }
    
}

extension Cell {
    convenience init(simpleTitle: String) {
        self.init(cellType: .simple)
        self.content = simpleTitle
    }
    
    convenience init(simpleTitle: String?, expanded: Bool) {
        self.init(cellType: .simple)
        self.content = (simpleTitle, expanded)
    }
}
