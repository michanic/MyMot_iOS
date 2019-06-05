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
    @IBOutlet weak var paddingLeft: NSLayoutConstraint!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    func fillWithContent(content: Any?, eventListener: CellEventProtocol?) {
        if let content = content as? String? {
            simpleLabel.text = content
            setAccessoryState(.right)
        } else if let content = content as? (String?, CellAccessoryType, Int) {
            simpleLabel.text = content.0
            setAccessoryState(content.1)
            paddingLeft.constant = (content.2 == 2) ? 40 : 26
        }
    }
    
    func setAccessoryState(_ state: CellAccessoryType) {
        arrowImage.rotate(angle: state.angle)
        switch state {
        case .hidden, .loading:
            arrowImage.image = nil
        case .checked:
            arrowImage.image = UIImage(named: "cell_checked")
        default:
            arrowImage.image = UIImage(named: "cell_arrow_right")
        }
        if state == .loading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
}

extension Cell {
    convenience init(simpleTitle: String?) {
        self.init(cellType: .simple)
        self.content = simpleTitle
    }
    
    convenience init(simpleTitle: String?, accessoryState: CellAccessoryType, level: Int) {
        self.init(cellType: .simple)
        self.content = (simpleTitle, accessoryState, level)
    }
}
