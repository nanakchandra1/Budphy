//
//  roundBtn.swift
//  Budfie
//
//  Created by yogesh singh negi on 07/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

//MARK:- RoundBtnCell class
//=========================
class RoundBtnCell: BaseCell {
    
    //MARK:- @IBOutlet
    //================
    @IBOutlet weak var roundBtn: UIButton!
    
    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.roundBtn.titleLabel?.textColor = AppColors.themeBlueColor
        self.roundBtn.titleLabel?.font      = AppFonts.Comfortaa_Regular_0.withSize(15)
        self.roundBtn.backgroundColor       = AppColors.whiteColor
        self.roundBtn.roundCommonButtonPositive(title: StringConstants.CREATE.localized)
        self.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
