//
//  RateHotelCell.swift
//  Budfie
//
//  Created by Aakash Srivastav on 10/04/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

protocol RateStarProtocol: class {
    func starSelected(index: String)
}

class RateHotelCell: UITableViewCell {

    var isFillStar = false
    weak var delegate: RateStarProtocol?

    //MARK: @IBOutlet
    //===============
    @IBOutlet var rateBackView: UIView!
    @IBOutlet weak var firstStarBtn: UIButton!
    @IBOutlet weak var secondStarBtn: UIButton!
    @IBOutlet weak var thirdStarBtn: UIButton!
    @IBOutlet weak var forthStarBtn: UIButton!
    @IBOutlet weak var fifthStarBtn: UIButton!
    @IBOutlet weak var sixStarBtn: UIButton!
    @IBOutlet weak var sevenStarBtn: UIButton!
    @IBOutlet weak var hotelArrow: UILabel!
    @IBOutlet weak var homeArrow: UILabel!

    //MARK: cell life cycle
    //=====================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    @IBAction func firstStarTapped() {
        if !self.isFillStar {
            self.clearStar()
            self.delegate?.starSelected(index: "1")
        }
        self.fillStar(self.firstStarBtn)
        self.isFillStar = false
    }

    @IBAction func secondStarTapped() {
        if !self.isFillStar {
            self.clearStar()
            self.delegate?.starSelected(index: "2")
        }
        self.isFillStar = true
        self.fillStar(self.secondStarBtn)
        self.firstStarTapped()
    }

    @IBAction func thirdStarTapped() {
        if !self.isFillStar {
            self.clearStar()
            self.delegate?.starSelected(index: "3")
        }
        self.isFillStar = true
        self.fillStar(self.thirdStarBtn)
        self.secondStarTapped()
    }

    @IBAction func forthStarTapped() {
        if !self.isFillStar {
            self.clearStar()
            self.delegate?.starSelected(index: "4")
        }
        self.isFillStar = true
        self.fillStar(self.forthStarBtn)
        self.thirdStarTapped()
    }

    @IBAction func fifthStarTapped() {
        if !self.isFillStar {
            self.clearStar()
            self.delegate?.starSelected(index: "5")
        }
        self.isFillStar = true
        self.fillStar(self.fifthStarBtn)
        self.forthStarTapped()
    }

    @IBAction func sixStarTapped() {
        if !self.isFillStar {
            self.clearStar()
            self.delegate?.starSelected(index: "6")
        }
        self.isFillStar = true
        self.fillStar(self.sixStarBtn)
        self.fifthStarTapped()
    }

    @IBAction func sevenStarTapped() {
        if !self.isFillStar {
            self.clearStar()
            self.delegate?.starSelected(index: "7")
        }
        self.isFillStar = true
        self.fillStar(self.sevenStarBtn)
        self.sixStarTapped()
    }

    //MARK: initial setup
    //===================
    func initialSetUp() {

        rateBackView.layer.cornerRadius = 6
        rateBackView.layer.borderWidth = 1
        rateBackView.layer.borderColor = AppColors.rateBorder.cgColor
        sixStarBtn.isHidden = true
        sevenStarBtn.isHidden = true
    }

    //MARK: fillStar cell method
    //==========================
    func fillStar(_ sender: UIButton) {
        sender.setImage(#imageLiteral(resourceName: "icHoldayPlannerStarFill"), for: .normal)
    }

    func clearStar() {

        self.firstStarBtn.setImage(#imageLiteral(resourceName: "icHoldayPlannerStarUnselect"), for: .normal)
        self.secondStarBtn.setImage(#imageLiteral(resourceName: "icHoldayPlannerStarUnselect"), for: .normal)
        self.thirdStarBtn.setImage(#imageLiteral(resourceName: "icHoldayPlannerStarUnselect"), for: .normal)
        self.forthStarBtn.setImage(#imageLiteral(resourceName: "icHoldayPlannerStarUnselect"), for: .normal)
        self.fifthStarBtn.setImage(#imageLiteral(resourceName: "icHoldayPlannerStarUnselect"), for: .normal)
        self.sixStarBtn.setImage(#imageLiteral(resourceName: "icHoldayPlannerStarUnselect"), for: .normal)
        self.sevenStarBtn.setImage(#imageLiteral(resourceName: "icHoldayPlannerStarUnselect"), for: .normal)
    }

}
