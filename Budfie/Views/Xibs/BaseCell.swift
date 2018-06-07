//
//  BaseCell.swift
//  Budfie
//
//  Created by yogesh singh negi on 08/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

//MARK:- BaseCell class
//=====================
class BaseCell: UITableViewCell {
    
    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK:- End Editing If touched outside the textfield
    //===================================================
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.superview?.superview?.endEditing(true)
    }
    
}
