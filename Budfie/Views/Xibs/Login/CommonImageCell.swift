//
//  CommonImageCell.swift
//  Budfie
//
//  Created by yogesh singh negi on 05/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

//MARK:- CommonImageCell class
//============================
class CommonImageCell: UICollectionViewCell {
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var imageBackView            : UIView!
    @IBOutlet weak var commonImageView          : UIImageView!
    @IBOutlet weak var nameLabel                : UILabel!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialSetUp()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.commonImageView.roundCornerWith(radius: self.commonImageView.frame.size.height / 2)
        self.imageViewHeightConstraint.constant = self.contentView.frame.width
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.superview?.superview?.endEditing(true)
    }
    
}


//MARK:- Extension for private methods
//====================================
extension CommonImageCell {
    
    private func initialSetUp() {
        
        self.imageBackView.backgroundColor      = AppColors.imageBackView
        self.imageBackView.roundCornerWith(radius: 5)
        self.imageBackView.layer.masksToBounds  = false
        self.imageBackView.clipsToBounds        = true
        self.commonImageView.border(width:2, borderColor: AppColors.blackColor)
//        self.commonImageView.backgroundColor    = AppColors.whiteColor
        self.nameLabel.textColor                = AppColors.blackColor
        self.nameLabel.font                     = AppFonts.Comfortaa_Regular_0.withSize(15.4)
    }
    
    func populate(name: String) {
        
        if name == StringConstants.Male.localized {
            self.commonImageView.image = AppImages.profileMale
        } else if name == StringConstants.Female.localized {
            self.commonImageView.image = AppImages.profileFemale
        } else if name == StringConstants.Camera.localized {
            self.commonImageView.image = AppImages.profileCamera
        } else {
            self.commonImageView.image = AppImages.profileGallery
        }
        self.nameLabel.text = name
    }
    
    func setBorder(){
        self.imageBackView.border(width: 2, borderColor: AppColors.themeBlueColor)
    }
    
    func removeBorder(){
        self.imageBackView.border(width: 0, borderColor: .clear)
    }
    
}
