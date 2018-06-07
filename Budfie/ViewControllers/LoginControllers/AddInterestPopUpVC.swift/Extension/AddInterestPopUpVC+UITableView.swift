//
//  AddInterestPopUpVC+UITableView.swift
//  Budfie
//
//  Created by yogesh singh negi on 09/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

// MARK:- Extension for tableview Delegate And DataSource
//=======================================================
extension AddInterestPopUpVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategory.childCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let addInterestPopUpCell = tableView.dequeueReusableCell(withIdentifier: "AddInterestPopUpCellId") as? AddInterestPopUpCell else { fatalError("AddInterestPopUpCell not found") }

        let childCategory = subCategory.childCategory[indexPath.row]
        addInterestPopUpCell.populate(radioText: childCategory.name, isSelected: selectedIds.contains(childCategory.id))

        addInterestPopUpCell.radioImageBtn.isUserInteractionEnabled = false
        addInterestPopUpCell.radioImageBtn.addTarget(self,
                                                     action: #selector(selectedRowBtnTapped(_:)),
                                                     for: .touchUpInside)
        return addInterestPopUpCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let id = subCategory.childCategory[row].id

        if self.selectedIds.contains(id) {
            self.selectedIds.remove(id)
        } else {
            self.selectedIds.insert(id)
        }
        self.popUpTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}


// MARK:- AddInterestPopUpCell Prototype Cell Class
//=================================================
class AddInterestPopUpCell: UITableViewCell {
    
    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var radioImageBtn: UIButton!
    @IBOutlet weak var radioTextLabel: UILabel!
    
    //MARK: cell life cycle
    //=====================
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.radioTextLabel.font = AppFonts.Comfortaa_Regular_0.withSize(16)
        self.radioTextLabel.textColor = AppColors.blackColor
        
        self.radioImageBtn.setImage(AppImages.popupUncheck, for: .normal)
        
        self.contentView.backgroundColor = UIColor.clear
    }
    
    //MARK: Populate cell method
    //==========================
    func populate(radioText: String, isSelected: Bool) {
        
        self.radioTextLabel.text = radioText
        if isSelected {
            self.radioImageBtn.setImage(AppImages.popupCheck, for: .normal)
        } else {
            self.radioImageBtn.setImage(AppImages.popupUncheck, for: .normal)
        }
    }
    
}
