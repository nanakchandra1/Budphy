//
//  EditCell.swift
//  Budfie
//
//  Created by Aishwarya Rastogi on 22/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

//MARK:- EditCell class
//============================
class EditCell: UICollectionViewCell {
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var imageBackView    : UIView!
    @IBOutlet weak var commonImageView  : UIImageView!
    @IBOutlet weak var nameLabel        : UILabel!
    @IBOutlet weak var removeBtn        : UIButton!
    @IBOutlet weak var addImage         : UIImageView!
    
    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialSetUp()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.commonImageView.image = nil
        self.nameLabel.text = nil
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        self.removeBtn.roundCorners()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.superview?.superview?.endEditing(true)
    }
    
}


//MARK:- Extension for private methods
//====================================
extension EditCell {
    
    private func initialSetUp() {
        
        //        self.commonImageView.image = nil
        //        self.nameLabel.text = nil
        self.imageBackView.backgroundColor = AppColors.imageBackView
        self.imageBackView.roundCornerWith(radius: 5)
        self.nameLabel.font = AppFonts.Comfortaa_Regular_0.withSize(11)
        self.removeBtn.isHidden = false
        self.removeBtn.setImage(AppImages.icCancel, for: .normal)
        self.addImage.isHidden = true
    }
    
    func populateData(id: String) {
        
        self.nameLabel.text = getName(subCategoryId: id)
        self.commonImageView.image = getImage(subCategoryId: id)
        self.removeBtn.isHidden = false
        self.addImage.isHidden = true
        self.commonImageView.isHidden = false
    }
    
    func populateFirstCell() {
        
        self.removeBtn.isHidden = true
        self.addImage.isHidden = false
        self.commonImageView.isHidden = true
        self.nameLabel.text = StringConstants.Add.localized
    }
    
}

