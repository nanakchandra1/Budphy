//
//  GreetingPreviewVC+UITableView.swift
//  Budfie
//
//  Created by Aishwarya Rastogi on 11/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

extension GreetingPreviewVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelGreetingDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let shareFriendCell = tableView.dequeueReusableCell(withIdentifier: "ShowSharedFriendsCell", for: indexPath) as? ShowSharedFriendsCell else { fatalError("ShowSharedFriendsCell not found") }
        
        shareFriendCell.populate(greetingDetails: self.modelGreetingDetail[indexPath.row])
        return shareFriendCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        audioPlayer.stop()
        
        let profileVCScene = ProfileVC.instantiate(fromAppStoryboard: .EditProfile)
        profileVCScene.state = .otherProfile
        profileVCScene.friendId = self.modelGreetingDetail[indexPath.row].receiver_id
        self.navigationController?.pushViewController(profileVCScene, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}

class ShowSharedFriendsCell: UITableViewCell {
    
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.picImageView.roundCorners()
    }
    
    func initialSetUp() {
        self.friendNameLabel.font = AppFonts.Comfortaa_Regular_0.withSize(16)
        self.friendNameLabel.textColor = AppColors.blackColor
    }
    
    func populate(greetingDetails: GreetingDetailsModel) {
        
        if let imgUrl = URL(string: greetingDetails.image ) {
            
            self.picImageView.contentMode = .scaleAspectFit
            if greetingDetails.avtar == "0" {
                self.picImageView.image = AppImages.icUbMnaph
            } else if greetingDetails.avtar == "1" {
                self.picImageView.image = AppImages.icUbFemailph
            } else {
                self.picImageView.image = AppImages.myprofilePlaceholder
            }
            
            self.picImageView.sd_addActivityIndicator()
            self.picImageView.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            self.picImageView.sd_setImage(with: imgUrl, completed: { (image, error, type, nurl) in
                
                if error == nil {
                    
                    self.picImageView.contentMode = .scaleAspectFill
                    self.picImageView.image = image
                } else {
                    
                    self.picImageView.contentMode = .scaleAspectFit
                    if greetingDetails.avtar == "0" {
                        self.picImageView.image = AppImages.icUbMnaph
                    } else if greetingDetails.avtar == "1" {
                        self.picImageView.image = AppImages.icUbFemailph
                    } else {
                        self.picImageView.image = AppImages.myprofilePlaceholder
                    }
                }
            })
            
            
        } else {
            
            self.picImageView.contentMode = .scaleAspectFit
            if greetingDetails.avtar == "0" {
                self.picImageView.image = AppImages.icUbMnaph
            } else if greetingDetails.avtar == "1" {
                self.picImageView.image = AppImages.icUbFemailph
            } else {
                self.picImageView.image = AppImages.myprofilePlaceholder
            }
            
        }
        self.friendNameLabel.text = greetingDetails.first_name
    }
    
}
