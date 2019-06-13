//
//  YoutubeVideoCell.swift
//  MyMot
//
//  Created by Michail Solyanic on 11/06/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class YoutubeVideoCell: UICollectionViewCell, CellContentProtocol {

    @IBOutlet weak var previewImage: UIImageView!
    
    func fillWithContent(content: Any?, eventListener: CellEventProtocol?) {
        if let video = content as? YoutubeVideo {
            previewImage.setImage(path: video.previewPath, placeholder: UIImage.placeholder, completed: nil)
        }
    }
    
}
