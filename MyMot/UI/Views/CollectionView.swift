//
//  CollectionView.swift
//  MyMot
//
//  Created by Michail Solyanic on 23/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class CollectionView: UICollectionView {

    var DS: DataSource?
    var registeredCellTypes: Set<CellType> = []

    init(dataSourceDelegate: DataSource, frame: CGRect) {
        self.DS = dataSourceDelegate
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        dataSource = self
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupWithCustomView(dataSourceDelegate: DataSource) {
        self.DS = dataSourceDelegate
        dataSource = self
        delegate = self
    }
    
}

extension CollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DS?.dataSource[section].cells.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellModel = DS?.dataSource[indexPath.section].cells[indexPath.row] else { return UICollectionViewCell() }
        cellModel.indexPath = indexPath
        let reuseIdentifier = String(describing: cellModel.type.cellClass)
        if !registeredCellTypes.contains(cellModel.type) {
            let nib = UINib(nibName: reuseIdentifier, bundle: nil)
            register(nib, forCellWithReuseIdentifier: reuseIdentifier)
            registeredCellTypes.insert(cellModel.type)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let contentProtocolCell = cell as? CellContentProtocol
        contentProtocolCell?.fillWithContent(content: cellModel.content, eventListener: cellModel.eventListener)
        return cell
    }
    
}

extension CollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
}
