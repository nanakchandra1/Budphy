//
//  SelectStayCell.swift
//  Budfie
//
//  Created by Aakash Srivastav on 10/04/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class SelectStayCell: UITableViewCell {

    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var radioHotelOnOff: UIImageView!
    @IBOutlet weak var radioHomeOnOff: UIImageView!
    @IBOutlet weak var hotelBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var stayLabel: UILabel!
    @IBOutlet weak var stayHomeImage: UIImageView!
    @IBOutlet weak var stayHomeLabel: UILabel!


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
        self.radioHotelOnOff.image = AppImages.icChooseMusicRadioOff
        self.radioHomeOnOff.image = AppImages.icChooseMusicRadioOff
        self.stayLabel.font = AppFonts.Comfortaa_Regular_0.withSize(16)
        self.stayLabel.textColor = AppColors.budgetColor
    }

    //MARK: Populate cell method
    //==========================
    func populateView() {

    }
}
