//
//  ModelsListCell.swift
//  MyMot
//
//  Created by Michail Solyanic on 02/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class ModelsListCell: UITableViewCell, CellContentProtocol, CellAccessoryStateProtocol {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var years: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    func fillWithContent(content: Any?, eventListener: CellEventProtocol?) {
        if let content = content as? (Model, CellAccessoryType) {
            photo.setImage(path: content.0.preview_picture, placeholder: UIImage.placeholder, completed: nil)
            name.text = content.0.name
            years.text = content.0.years
            volume.text = content.0.volume_text
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
