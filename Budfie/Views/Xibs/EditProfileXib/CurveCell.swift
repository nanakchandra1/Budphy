//
//  CurveCell.swift
//  Budfie
//
//  Created by Aishwarya Rastogi on 20/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

class CurveCell: UITableViewCell {
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var curveView: UIView!
    
    @IBOutlet weak var cameraBtn: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.cameraBtn.layer.cornerRadius = self.cameraBtn.frame.width/2
        //self.curveView.curvHeaderView()
          
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
