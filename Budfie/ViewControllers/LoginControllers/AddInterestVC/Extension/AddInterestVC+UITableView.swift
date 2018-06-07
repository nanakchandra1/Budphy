//
//  AddInterestVC+UITableView.swift
//  Budfie
//
//  Created by aishwarya rastogi on 09/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation


//MARK: Extension: for UITableView Delegate and DataSource
//========================================================
extension AddInterestsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellForCollectionViewId", for: indexPath) as? TableCellForCollectionView else { fatalError("TableCellForCollectionView not found") }
        
        cell.obInterestListModel = self.obInterestListModel?[indexPath.section]
        TableCellForCollectionView.selectedId = AddInterestsVC.selectedId
        cell.delegate = self
        cell.addInterestsCollectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if screenWidth < 322 {
//            if indexPath.section == 0 {
//                return (heightForItem * 2.92)
//            }
            return (heightForItem * 1.4)
        } else {
//            if indexPath.section == 0 {
//                return (heightForItem * 3.15)
//            }
            return (heightForItem * 1.48)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewHeaderId") as? TableViewHeader else { fatalError("TableViewHeader not found") }
        
        header.headerName.text = "\(self.obInterestListModel?[section].category ?? "") :"
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
}
