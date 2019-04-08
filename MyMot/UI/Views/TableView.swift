//
//  TableView.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class TableView: UITableView {

    let universalDelegate: TableViewUniversalDelegate
    var registeredCellTypes: Set<CellType> = []
    
    init(universalDelegate: TableViewUniversalDelegate, frame: CGRect, style: UITableView.Style) {
        self.universalDelegate = universalDelegate
        super.init(frame: frame, style: style)
        dataSource = self
        delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TableView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return universalDelegate.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universalDelegate.dataSource[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = universalDelegate.dataSource[indexPath.section].cells[indexPath.row]
        let reuseIdentifier = String(describing: cellModel.type.cellClass)
        if !registeredCellTypes.contains(cellModel.type) {
            let nib = UINib(nibName: String(describing: cellModel.type.cellClass), bundle: nil)
            register(nib, forCellReuseIdentifier: reuseIdentifier)
            registeredCellTypes.insert(cellModel.type)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
}

extension TableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return universalDelegate.dataSource[indexPath.section].cells[indexPath.row].type.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return universalDelegate.dataSource[section].headerProperties.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return universalDelegate.dataSource[section].headerProperties.view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
