//
//  InviteesVC+UITableView.swift
//  Budfie
//
//  Created by appinventiv on 15/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

//MARK:- InviteesVC UITableView Delegate and DataSource Extension
//===============================================================
extension InviteesVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.state == .greeting {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.obFriendListModel.count
        }
        return self.contacts.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewHeader") as? TableViewHeader else { fatalError("TableViewHeader not found") }
        
        header.backView.backgroundColor = AppColors.themeLightBlueColor
        header.headerName.textColor = AppColors.whiteColor
        
        if section == 0 {
            header.headerName.text = "Budfie Friends"
        } else {
            header.headerName.text = "Other Friends"
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendNameCellId") as? FriendNameCell else { fatalError("FriendNameCell not found") }
        
        if indexPath.section == 0 {
            
            var isSelectedFriend = false
            if self.selectedId.contains(self.obFriendListModel[indexPath.row].id) {
                isSelectedFriend = true
            }
            cell.populate(isSelectedFriend: isSelectedFriend,
                          proPic: self.obFriendListModel[indexPath.row].image,
                          friendName: self.obFriendListModel[indexPath.row].name)
        } else {
            let name = self.contacts[indexPath.row].name
            var isSelectedFriend = false
            if self.isSelectedPhoneFriend.contains(self.contacts[indexPath.row].phone) {
                isSelectedFriend = true
            }
            cell.populate(isSelectedFriend: isSelectedFriend,
                          proPic: self.contacts[indexPath.row].image,
                          friendName: name)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if !self.obFriendListModel.isEmpty {
                let frndId = self.obFriendListModel[indexPath.row].id
                if self.selectedId.contains(frndId) {
                    guard let index = self.selectedId.index(of: frndId) else { return }
                    self.selectedId.remove(at: index)
                } else {
                    self.selectedId.append(frndId)
                }
            }
        } else if indexPath.section == 1 {
            if self.isSelectedPhoneFriend.contains(self.contacts[indexPath.row].phone) {
                guard let index = self.isSelectedPhoneFriend.index(of: self.contacts[indexPath.row].phone) else { return }
                self.isSelectedPhoneFriend.remove(at: index)
            } else {
                self.isSelectedPhoneFriend.append(self.contacts[indexPath.row].phone)
            }
        }
        self.friendListTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if screenWidth < 322 {
            return 50
        }
        return 75
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.obFriendListModel.count == 0 && section == 0 {
            return 0.0
        } else if self.contacts.count == 0 && section == 1 {
            return 0.0
        } else {
            if screenWidth < 322 {
                return 40
            }
            return 50
        }
    }
    
}


class FriendNameCell: UITableViewCell {
    
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.picImageView.roundCorners()
        self.selectionImageView.roundCorners()
    }
    
    func initialSetUp() {
        self.friendNameLabel.font = AppFonts.Comfortaa_Regular_0.withSize(13.9)
        self.friendNameLabel.textColor = AppColors.blackColor
        self.selectionImageView.image = AppImages.popupUncheck
        self.bottomView.backgroundColor = AppColors.friendListBottom
    }
    
    func populate(isSelectedFriend: Bool, proPic: String, friendName: String) {
        
        if let imgUrl = URL(string: proPic ) {
            
            self.picImageView.contentMode = .scaleAspectFit
            self.picImageView.image = AppImages.myprofilePlaceholder
            
            self.picImageView.sd_addActivityIndicator()
            self.picImageView.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            self.picImageView.sd_setImage(with: imgUrl, completed: { (image, error, type, nurl) in
                
                if error == nil{
                    
                    self.picImageView.contentMode = .scaleAspectFill
                    self.picImageView.image = image
                }else{
                    
                    self.picImageView.contentMode = .scaleAspectFit
                    self.picImageView.image = AppImages.myprofilePlaceholder
                }
            })
            
            
        }else{
            
            self.picImageView.contentMode = .scaleAspectFit
            self.picImageView.image = AppImages.myprofilePlaceholder
            
        }
        self.friendNameLabel.text = friendName
        if isSelectedFriend {
            self.selectionImageView.image = AppImages.popupCheck
        } else {
            self.selectionImageView.image = AppImages.popupUncheck
        }
    }
    
}
