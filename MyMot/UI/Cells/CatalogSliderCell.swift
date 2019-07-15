//
//  CatalogSliderCell.swift
//  MyMot
//
//  Created by Michail Solyanic on 10/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class CatalogSliderCell: UITableViewCell, CellContentProtocol {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var slides: [Any] = []
    
    func fillWithContent(content: Any?, eventListener: CellEventProtocol?) {
        
        let slideCellName = String(describing: CellType.catalogSlide.cellClass)
        collectionView.register(UINib(nibName: slideCellName, bundle: Bundle.main), forCellWithReuseIdentifier: slideCellName)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if let content = content as? (String, [Any]) {
            titleLabel.text = content.0.uppercased()
            slides = content.1
            collectionView.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
    }
    
}

extension CatalogSliderCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let slide = slides[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CellType.catalogSlide.cellClass), for: indexPath) as! CatalogSlideCell
        cell.fillWithContent(content: slide, eventListener: nil)
        return cell
    }
    
}

extension CatalogSliderCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let category = slides[indexPath.row] as? Category {
            Router.shared.pushController(ViewControllerFactory.catalogByClass(category).create)
        } else if let manufacturer = slides[indexPath.row] as? Manufacturer {
            Router.shared.pushController(ViewControllerFactory.catalogByManufacturer(manufacturer).create)
        } else if let volume = slides[indexPath.row] as? Volume {
            Router.shared.pushController(ViewControllerFactory.catalogByVolume(volume).create)
        }
    }
    
}

extension CatalogSliderCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 160)
    }
    
}
