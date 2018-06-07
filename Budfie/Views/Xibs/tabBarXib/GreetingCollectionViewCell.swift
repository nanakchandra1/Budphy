//
//  GreetingCollectionViewCell.swift
//  beziarPath
//
//  Created by Aishwarya Rastogi on 08/12/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

//MARK:- GreetingCollectionViewCell class
//=======================================
class GreetingCollectionViewCell: UICollectionViewCell {
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var imageView    : UIImageView!
    @IBOutlet weak var customView   : Polygon!
    
    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        customView.setup(width: customView.frame.width,
                         height: customView.frame.height,
                         upDown: false)
    }
    
}
