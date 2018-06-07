//
//  EventOwnerCell.swift
//  Budfie
//
//  Created by Aishwarya Rastogi on 12/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation
import OnlyPictures

//MARK:- MoreFriendsCell class
//============================
class EventOwnerCell: UITableViewCell {
    
    //MARK:- Properties
    //=================
    weak var delegate: ShowFriendProfile?
    var friendList = [FriendListModel]() {
        didSet {
            moreFriendsView.reloadData()
        }
    }
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var moreFriendsView: OnlyHorizontalPictures!
    @IBOutlet weak var inviteFriendLabel: UILabel!
//    @IBOutlet weak var addMoreBtn: UIButton!
    @IBOutlet weak var moreFriendsViewHeight: NSLayoutConstraint!
    
    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialSetUp()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func initialSetUp() {
        self.setUpCircularView()
        self.clipsToBounds = true
        
        delayWithSeconds(0.2) {
            if self.friendList.count == 0 {
                self.moreFriendsViewHeight.constant = 0.0
            } else {
                self.moreFriendsViewHeight.constant = 45
                self.moreFriendsView.delegate   = self
                self.moreFriendsView.dataSource = self
            }
        }
        self.inviteFriendLabel.text = "Invited By"
        self.inviteFriendLabel.font = AppFonts.Comfortaa_Bold_0.withSize(15.3)
        self.inviteFriendLabel.textColor = AppColors.blackColor
    }
    
    fileprivate func setUpCircularView() {
        self.moreFriendsView.alignment  = .left
        self.moreFriendsView.gap        = 43
        self.moreFriendsView.backgroundColorForCount = AppColors.backColorForCount
        self.moreFriendsView.textColorForCount = AppColors.colorForCount
    }
    
}


//MARK:- Extension for OnlyPictures Delegate  and DataSource
//==========================================================
extension EventOwnerCell: OnlyPicturesDelegate, OnlyPicturesDataSource {
    
    func pictureView(_ imageView: UIImageView, didSelectAt index: Int) {
        if self.friendList.count > index {
            self.delegate?.getFriendId(friendId: self.friendList[index].friendId)
            //CommonClass.showToast(msg: "\(self.friendList[index].firstName) \(self.friendList[index].lastName)")
        }
    }
    
    func numberOfPictures() -> Int {
        return self.friendList.count
    }
    
    func visiblePictures() -> Int {
        return 4
    }
    
    func pictureViews(index: Int) -> UIImage {
        
        let image = UIImageView()
        image.setImage(withSDWeb: self.friendList[index].image,
                       placeholderImage: AppImages.myprofilePlaceholder)
        return image.image ?? AppImages.icMorePlaceholder
    }
    
}
