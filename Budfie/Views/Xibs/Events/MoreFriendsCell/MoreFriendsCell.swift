//
//  MoreFriendsCell.swift
//  Budfie
//
//  Created by yogesh singh negi on 11/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit
import OnlyPictures
import SDWebImage
import InitialsImageView

protocol ShowFriendProfile : class {
    func getFriendId(friendId : String)
}

//MARK:- MoreFriendsCell class
//============================
class MoreFriendsCell: UITableViewCell {
    
    //MARK:- Properties
    //=================
    weak var delegate: ShowFriendProfile?
    var friendList = [FriendListModel]() {
        didSet {
            moreFriendsView.reloadData()
        }
    }

    var unusedChatColors: [String] = []

    var randomColor: UIColor {
        if unusedChatColors.isEmpty {
            unusedChatColors = FirebaseHelper.chatColors
        }
        let randomIndex = Int(arc4random_uniform(UInt32(unusedChatColors.count)))
        let color = unusedChatColors[randomIndex]
        unusedChatColors.remove(at: randomIndex)
        return UIColor(hexString: color)
    }

    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var moreFriendsView: OnlyHorizontalPictures!
    @IBOutlet weak var inviteFriendLabel: UILabel!
    @IBOutlet weak var addMoreBtn: UIButton!
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
        self.inviteFriendLabel.text = "Invited Friend"
        self.inviteFriendLabel.font = AppFonts.Comfortaa_Bold_0.withSize(15.3)
        self.inviteFriendLabel.textColor = AppColors.blackColor
        
        self.addMoreBtn.setTitle("Add More", for: .normal)
        self.addMoreBtn.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(13)
        self.addMoreBtn.titleLabel?.textColor = AppColors.themeBlueColor
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
extension MoreFriendsCell: OnlyPicturesDelegate, OnlyPicturesDataSource {
    
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
    
    func pictureViews(_ imageView: UIImageView, index: Int) {
        let friend = friendList[index]
        let imageUrl = friend.image
        if imageUrl.isEmpty {
            let attributes: [NSAttributedStringKey: AnyObject] = [.font : AppFonts.Comfortaa_Bold_0.withSize(15),
                              .foregroundColor: UIColor.white]
            imageView.bounds.size = CGSize(width: 45, height: 45)
            imageView.setImageForName(string: friend.fullName, backgroundColor: randomColor, circular: true, textAttributes: attributes, gradient: false)
        } else {
            imageView.setImage(withSDWeb: imageUrl,
                               placeholderImage: AppImages.myprofilePlaceholder)
        }
    }
}
