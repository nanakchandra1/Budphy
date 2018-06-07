//
//  BlockedUserListVC+UITableView.swift
//  Budfie
//
//  Created by appinventiv on 30/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

//MARK:- Extension for UITableView Delegate and DataSource
//========================================================
extension BlockedUserListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.obBlockedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BlockedUserCell", for: indexPath) as? BlockedUserCell else { fatalError("BlockedUserCell not found") }
        
        cell.populateView(model: self.obBlockedList[indexPath.row])
        cell.unblockBtn.addTarget(self, action: #selector(unBlockUserBtnTapped), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
}


//MARK:- BlockedUserCell Prototype Class
//==================================
class BlockedUserCell: UITableViewCell {
    
    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var unblockBtn: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    //MARK: cell life cycle
    //=====================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.userImage.roundCorners()
        self.unblockBtn.roundCommonButtonPositive(title: "Unblock")
        self.unblockBtn.roundCornerWith(radius: 15)
        self.backView.roundCornerWith(radius: 5)
        self.backView.dropShadow(width: 3.7, shadow: AppColors.shadowViewColor)
    }
    
    //MARK: initial setup
    //===================
    func initialSetUp() {
        self.userNameLabel.font = AppFonts.Comfortaa_Regular_0.withSize(16)
        self.userNameLabel.textColor = AppColors.blackColor
        self.contentView.backgroundColor = UIColor.clear
    }
    
    //MARK: Populate cell method
    //==========================
    func populateView(model: FriendListModel) {
        self.userImage.setImage(withSDWeb: model.image, placeholderImage: AppImages.myprofilePlaceholder)
        self.userNameLabel.text = model.firstName
    }
    
}
