//
//  CommonImageCell.swift
//  Budfie
//
//  Created by yogesh singh negi on 05/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

//MARK:- AddInterestCell class
//============================
class AddInterestCell: UICollectionViewCell {
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var imageBackView    : UIView!
    @IBOutlet weak var commonImageView  : UIImageView!
    @IBOutlet weak var nameLabel        : UILabel!
    
    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialSetUp()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.superview?.superview?.endEditing(true)
    }
    
}


//MARK:- Extension for private methods
//====================================
extension AddInterestCell {
    
    private func initialSetUp() {
        
        self.imageBackView.backgroundColor = AppColors.imageBackView
        self.imageBackView.roundCornerWith(radius: 5)
        self.nameLabel.font = AppFonts.Comfortaa_Regular_0.withSize(10)
    }
    
    func populateWithColor(isSelectedCell: Bool,
                           name: String,
                           imageName: UIImage) {
        
        self.nameLabel.text = name
        self.commonImageView.image = imageName
        if isSelectedCell {
            self.nameLabel.textColor = AppColors.themeBlueColor
            self.imageBackView.border(width: 2,
                                      borderColor: AppColors.themeBlueColor)
        } else {
            self.nameLabel.textColor = AppColors.blackColor
            self.imageBackView.border(width: 0,
                                      borderColor: UIColor.clear)
        }
    }
    
    func populate(name: String, imageName: UIImage) {
        self.nameLabel.text = name
        self.commonImageView.image = imageName
    }
    
}
