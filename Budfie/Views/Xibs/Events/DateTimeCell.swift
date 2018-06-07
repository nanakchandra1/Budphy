//
//  DateTimeCell.swift
//  Budfie
//
//  Created by yogesh singh negi on 07/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

//MARK:- DateTimeCell class
//=========================
class DateTimeCell: BaseCell {
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var dateBackView     : UIView!
    @IBOutlet weak var dateTextField    : SkyFloatingLabelTextField!
    @IBOutlet weak var dateImageView    : UIImageView!
    @IBOutlet weak var dateBottomView   : UIView!
    @IBOutlet weak var timeBackView     : UIView!
    @IBOutlet weak var timeTextField    : SkyFloatingLabelTextField!
    @IBOutlet weak var timeImageView    : UIImageView!
    @IBOutlet weak var timeBottomView   : UIView!
    
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
extension DateTimeCell {
    
    private func initialSetUp() {
        
        self.dateTextField.textColor            = AppColors.blackColor
        self.dateTextField.placeholder          = StringConstants.Date.localized
        self.dateTextField.font                 = AppFonts.Comfortaa_Regular_0.withSize(15)
        
        self.dateImageView.image                = AppImages.icAddeventCalendar
        self.dateBottomView.backgroundColor     = AppColors.addEventBaseLine
        
        self.timeTextField.textColor            = AppColors.blackColor
        self.timeTextField.placeholder          = StringConstants.Time.localized
        self.timeTextField.font                 = AppFonts.Comfortaa_Regular_0.withSize(15)
        
        self.timeImageView.image                = AppImages.icAddeventClock
        self.timeBottomView.backgroundColor     = AppColors.addEventBaseLine
        
        self.dateTextField.inputView            = nil
        self.timeTextField.inputView            = nil
        self.dateTextField.keyboardType         = .default
        self.timeTextField.keyboardType         = .default
        
        self.dateTextField.titleColor   = AppColors.floatingPlaceHolder
        self.timeTextField.titleColor   = AppColors.floatingPlaceHolder
        
        self.dateTextField.selectedTitleColor   = AppColors.floatingPlaceHolder
        self.timeTextField.selectedTitleColor   = AppColors.floatingPlaceHolder
        
        self.dateTextField.lineColor            = UIColor.clear
        self.timeTextField.lineColor            = UIColor.clear
        
        self.dateTextField.tintColor            = UIColor.clear
        self.timeTextField.tintColor            = UIColor.clear
        
        self.dateTextField.placeholderFont      = AppFonts.Comfortaa_Regular_0.withSize(15)
        self.timeTextField.placeholderFont      = AppFonts.Comfortaa_Regular_0.withSize(15)

    }
    
    func setViewEventState() {
        self.dateBottomView.isHidden = true
        self.timeBottomView.isHidden = true
    }
    
    func setHolidayPlannerView() {
        setHolidayPlannerEventView()
        self.dateTextField.isUserInteractionEnabled = false
        self.timeTextField.isUserInteractionEnabled = false
    }

    func setHolidayPlannerEventView() {
        self.dateTextField.placeholder = "From"
        self.timeTextField.placeholder = "To"
        self.dateImageView.image = AppImages.icAddeventCalendar
        self.timeImageView.image = AppImages.icAddeventCalendar
        self.dateTextField.textColor = AppColors.blackColor
        self.timeTextField.textColor = AppColors.blackColor
    }
}
