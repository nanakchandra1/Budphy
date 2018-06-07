//
//  TableTopCurveHeaderFooterView.swift
//  Budfie
//
//  Created by Aakash Srivastav on 24/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class TableTopCurveHeaderFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var shareBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        shareBtn.round()
    }
    
}
