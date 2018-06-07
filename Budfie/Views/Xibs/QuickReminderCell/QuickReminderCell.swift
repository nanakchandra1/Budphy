//
//  QuickReminderCell.swift
//  Budfie
//
//  Created by yogesh singh negi on 07/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import SkyFloatingLabelTextField

//MARK:- QuickReminderCell class
//=========================
class QuickReminderCell: BaseCell {
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var eventNameTextField   : SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldEndImageView: UIImageView!
    @IBOutlet weak var textFieldBottomView  : UIView!
    
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
    
}


//MARK:- Extension for private methods
//====================================
extension QuickReminderCell {
    
    private func initialSetUp() {
        
        self.eventNameTextField.textColor           = AppColors.blackColor
        self.eventNameTextField.font                = AppFonts.Comfortaa_Regular_0.withSize(15)
        self.textFieldBottomView.backgroundColor    = AppColors.floatingPlaceHolder
        self.eventNameTextField.inputView           = nil
        self.eventNameTextField.keyboardType        = .default
        self.eventNameTextField.selectedTitleColor  = AppColors.floatingPlaceHolder
        self.eventNameTextField.lineColor           = UIColor.clear
        self.eventNameTextField.tintColor           = UIColor.clear
        self.eventNameTextField.placeholderFont     = AppFonts.Comfortaa_Regular_0.withSize(15)
    }
    
    func settingCell(placeholderName: String, isDownArrow: Bool, isCalendar: Bool, isClock: Bool) {
        
        self.eventNameTextField.placeholder     = placeholderName
        if isDownArrow {
            self.textFieldEndImageView.image    = AppImages.icAddeventDropdown
        } else if isCalendar {
            self.textFieldEndImageView.image    = AppImages.icAddeventCalendar
        } else if isClock {
            self.textFieldEndImageView.image    = AppImages.icAddeventClock
        } else {
            self.textFieldEndImageView.isHidden = true
        }
    }
    
}
