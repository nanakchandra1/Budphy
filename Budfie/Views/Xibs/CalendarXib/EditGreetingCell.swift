//
//  GreetingCell.swift
//  Budfie
//
//  Created by yogesh singh negi on 11/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

protocol JumpToGreeting: class {
    func goToPreviewScreen()
}

//MARK:- EditGreetingCell class
//=============================
class EditGreetingCell: BaseCell {
    
    var eventDetailsModel   : EditEventDetailsModel!
    weak var delegate       : JumpToGreeting?
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var greetingCollectionView: UICollectionView!
    @IBOutlet weak var editBtn: UIButton!
    
    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }
    
    private func initialSetUp() {
        
        self.editBtn.setTitle(StringConstants.Edit.localized, for: .normal)
        self.editBtn.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(13)
        self.editBtn.titleLabel?.textColor = AppColors.themeBlueColor
        
        self.greetingCollectionView.delegate = self
        self.greetingCollectionView.dataSource = self
    }
    
}


//MARK:- Extension for UICollectionView Delegate and DataSource
//=============================================================
extension EditGreetingCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GreetingCollectionCellId", for: indexPath) as? GreetingCollectionCell else { fatalError("GreetingCollectionCell not found") }
        
        if self.eventDetailsModel.greeting.isEmpty {
            cell.greetingImage.isHidden = true
            cell.greetingImageHeight.constant = 10
            self.editBtn.setTitle("Add", for: .normal)
        } else {
            cell.greetingImage.isHidden = false
            cell.greetingImageHeight.constant = 55
            self.editBtn.setTitle("Edit", for: .normal)
        }
        cell.greetingImage.setImage(withSDWeb: self.eventDetailsModel.greeting, placeholderImage: AppImages.myprofilePlaceholder)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.delegate?.goToPreviewScreen()
    }
    
}


//MARK:- Extension for UICollectionView Delegate FlowLayout
//=========================================================
extension EditGreetingCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let heightWidth = (collectionView.frame.width - 51) / 4
        return CGSize(width: heightWidth, height: heightWidth + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}


//MARK:- GreetingCollectionCell class
//===================================
class GreetingCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var greetingImage: UIImageView!
    @IBOutlet weak var greetingImageHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.greetingImage.backgroundColor = AppColors.addEventBaseLine
        
        self.greetingLabel.text = "Greeting"
        self.greetingLabel.font = AppFonts.Comfortaa_Bold_0.withSize(15.3)
        self.greetingLabel.textColor = AppColors.blackColor
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.contentView.roundCornerWith(radius: 5)
        self.greetingImage.roundCornerWith(radius: 5)
    }
    
}
