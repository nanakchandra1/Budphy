//
//  AdultsKidsCell.swift
//  Budfie
//
//  Created by Aakash Srivastav on 10/04/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class AdultsKidsCell: UITableViewCell {

    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var adultBtn: UIButton!
    @IBOutlet weak var kidsBtn: UIButton!
    @IBOutlet weak var adultKidsLabel: UILabel!

    //MARK: cell life cycle
    //=====================
    override func awakeFromNib() {
        super.awakeFromNib()

        self.initialSetUp()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

    //MARK: initial setup
    //===================
    func initialSetUp() {

        self.adultKidsLabel.font = AppFonts.Comfortaa_Regular_0.withSize(16)
        self.adultKidsLabel.textColor = AppColors.budgetColor
    }

    //MARK: Populate cell method
    //==========================
    func populateView() {

    }
}
