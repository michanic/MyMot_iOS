//
//  TableView.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

protocol TableViewEditing: class {
    func deleteCellPressed(indexPath: IndexPath)
}

class TableView: UITableView {

    var DS: DataSource?
    var registeredCellTypes: Set<CellType> = []
    weak var editingDelegate: TableViewEditing?
    
    init(dataSourceDelegate: DataSource, frame: CGRect) {
        self.DS = dataSourceDelegate
        super.init(frame: frame, style: .plain)
        dataSource = self
        delegate = self
        tableFooterView = UIView()
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

extension TableView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return DS?.dataSource.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DS?.dataSource[section].cells.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = DS?.dataSource[indexPath.section].cells[indexPath.row] else { return UITableViewCell() }
        cellModel.indexPath = indexPath
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
        return DS?.dataSource[indexPath.section].cells[indexPath.row].height ?? CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return DS?.dataSource[section].headerProperties.height ?? CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return DS?.dataSource[section].headerProperties.view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cellModel = DS?.dataSource[indexPath.section].cells[indexPath.row] else { return }
        cellModel.eventListener?.tapEvent()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return DS?.dataSource[indexPath.section].cells[indexPath.row].editingDelete ?? false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            editingDelegate?.deleteCellPressed(indexPath: indexPath)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
}
