//
//  DestinationDescriptionCell.swift
//  Budfie
//
//  Created by Aakash Srivastav on 10/04/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class DestinationDescriptionCell: UICollectionViewCell {

    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var destinationImage: UIImageView!
    @IBOutlet weak var destinationLocationLabel: UILabel!

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
        backView.layer.cornerRadius = 6
        backView.layer.borderWidth = 0.5
        backView.layer.borderColor = UIColor.lightGray.cgColor
    }

    //MARK: Populate cell method
    //==========================
    func populateView() {

    }
}
