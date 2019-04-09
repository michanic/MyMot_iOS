//
//  ModelsListCell.swift
//  MyMot
//
//  Created by Michail Solyanic on 02/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class ModelsListCell: UITableViewCell, CellContentProtocol {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var years: UILabel!
    
    func fillWithContent(content: Any?, eventListener: CellEventProtocol?) {
        
        if let model = content as? Model {
            
            photo.setImage(path: model.preview_picture, placeholder: UIImage(named: "launch_logo"))
            name.text = model.name
            years.text = model.preview_text
            
        }
    }
    
}
