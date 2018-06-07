//
//  TextFieldCell.swift
//  Budfie
//
//  Created by Aishwarya Rastogi on 20/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {

    @IBOutlet weak var customTextField: UITextField!
    @IBOutlet weak var textFieldBaseView: UIView!
    @IBOutlet weak var calendarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialSetUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func initialSetUp() {
        self.customTextField.font = AppFonts.Comfortaa_Regular_0.withSize(13, iphone6: 15, iphone6p: 15.3)
        self.customTextField.textColor = AppColors.floatingPlaceHolder
        self.calendarImage.isHidden = true
        self.calendarImage.image = AppImages.icAddeventCalendar
        self.textFieldBaseView.backgroundColor = AppColors.addEventBaseLine
    }
    
}
