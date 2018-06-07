//
//  WeekEndTopDecorationTableCell.swift
//  Budfie
//
//  Created by Aakash Srivastav on 22/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class WeekEndTopDecorationTableCell: UITableViewCell {

    static let cellHeight = 20

    @IBOutlet weak var circularView: UIView!
    @IBOutlet weak var connectorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        circularView.roundCorners()
        connectorView.roundCorner([.topLeft, .topRight], radius: connectorView.width/2)
    }
}
