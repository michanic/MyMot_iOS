//
//  TableView.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class TableView: UITableView {

    let DS: DataSource
    var registeredCellTypes: Set<CellType> = []
    
    init(dataSourceDelegate: DataSource, frame: CGRect, style: UITableView.Style) {
        self.DS = dataSourceDelegate
        super.init(frame: frame, style: style)
        dataSource = self
        delegate = self
        tableFooterView = UIView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TableView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return DS.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DS.dataSource[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = DS.dataSource[indexPath.section].cells[indexPath.row]
        let reuseIdentifier = String(describing: cellModel.type.cellClass)
        if !registeredCellTypes.contains(cellModel.type) {
            let nib = UINib(nibName: String(describing: cellModel.type.cellClass), bundle: nil)
            register(nib, forCellReuseIdentifier: reuseIdentifier)
            registeredCellTypes.insert(cellModel.type)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let contentProtocolCell = cell as? CellContentProtocol
        contentProtocolCell?.fillWithContent(content: cellModel.content, eventListener: cellModel.eventListener)
        return cell
    }
    
}

extension TableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DS.dataSource[indexPath.section].cells[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return DS.dataSource[section].headerProperties.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return DS.dataSource[section].headerProperties.view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellModel = DS.dataSource[indexPath.section].cells[indexPath.row]
        cellModel.eventListener?.tapEvent()
    }
    
}
