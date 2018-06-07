//
//  TableViewHeader.swift
//  Budfie
//
//  Created by yogesh singh negi on 05/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

//MARK:- TableViewHeader class
//============================
class TableViewHeader: UITableViewHeaderFooterView {
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var backView     : UIView!
    @IBOutlet weak var headerName   : UILabel!
    
    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.backView.backgroundColor   = AppColors.whiteColor
        self.headerName.textColor       = AppColors.themeBlueColor
        self.headerName.font            = AppFonts.Comfortaa_Bold_0.withSize(15)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.superview?.superview?.endEditing(true)
    }
    
}
