//
//  AddEventCell.swift
//  Budfie
//
//  Created by yogesh singh negi on 07/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

//MARK:- AddEventCell class
//=========================
class AddEventCell: BaseCell {
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var eventNameTextField   : SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldEndImageView: UIImageView!
    @IBOutlet weak var textFieldBottomView  : UIView!
    @IBOutlet weak var budgetImage: UIImageView!
    @IBOutlet weak var budgetWidth: NSLayoutConstraint!
    @IBOutlet weak var horizontalSpace: NSLayoutConstraint!
    @IBOutlet weak var locationBtn: UIButton!
    
    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()

        self.initialSetUp()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        locationBtn.removeTarget(nil, action: nil, for: .allEvents)
    }
}


//MARK:- Extension for private methods
//====================================
extension AddEventCell {
    
    private func initialSetUp() {
        
        self.eventNameTextField.textColor           = AppColors.blackColor
        self.eventNameTextField.font                = AppFonts.Comfortaa_Regular_0.withSize(15)
        self.textFieldBottomView.backgroundColor    = AppColors.addEventBaseLine
        self.eventNameTextField.inputView           = nil
        self.eventNameTextField.keyboardType        = .default
        self.eventNameTextField.selectedTitleColor  = AppColors.floatingPlaceHolder
        self.eventNameTextField.lineColor           = UIColor.clear
        self.eventNameTextField.tintColor           = UIColor.clear
        self.eventNameTextField.placeholderFont     = AppFonts.Comfortaa_Regular_0.withSize(15)
        
//        let myAttribute = [NSAttributedStringKey.font: AppFonts.Comfortaa_Regular_0.withSize(15),
//                           NSAttributedStringKey.foregroundColor: AppColors.floatingPlaceHolder]
//        self.eventNameTextField.attributedPlaceholder = myAttribute

        self.budgetImage.isHidden                   = true
        self.budgetWidth.constant                   = 0
        self.horizontalSpace.constant               = 0
    }
    
    func setViewEventState() {
        self.textFieldBottomView.isHidden = true
    }
    
    func populate(placeholderName: String, isDownArrow: Bool, isLocation: Bool) {
        
        self.eventNameTextField.placeholder     = placeholderName
        if isDownArrow {
            self.textFieldEndImageView.image    = AppImages.icAddeventDropdown
        } else if isLocation {
            self.textFieldEndImageView.image    = AppImages.icAddeventLocation
            self.eventNameTextField.inputView = nil
            self.eventNameTextField.keyboardType = .default
        } else {
            self.textFieldEndImageView.isHidden = true
        }
    }
    
}
