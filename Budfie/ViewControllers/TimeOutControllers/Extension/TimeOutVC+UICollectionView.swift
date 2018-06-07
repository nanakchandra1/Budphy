//
//  TimeOutVC+UICollectionView.swift
//  Budfie
//
//  Created by appinventiv on 15/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

//MARK: Extension for UICollectionViewDelegate UICollectionViewDataSource
//=======================================================================
extension TimeOutVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChangeFaceCell", for: indexPath) as? ChangeFaceCell else { fatalError("ChangeFaceCell not found") }
        
        cell.backFaceImage.image = self.image[indexPath.row]
        cell.headerLabel.text = self.headerText[indexPath.row]
        cell.contentView.backgroundColor = self.backColors[indexPath.row]
//        self.view.backgroundColor = self.backColors[indexPath.row]
        
        return cell
    }
    
}


//MARK: Extension for UICollectionViewDelegateFlowLayout
//======================================================
extension TimeOutVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}


//MARK: ChangeFaceCell Prototype Cell Class
//=========================================
class ChangeFaceCell: UICollectionViewCell {
    
    @IBOutlet weak var backFaceImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        self.backFaceImage.image = AppImages.ic_congratulations
        self.headerLabel.font = AppFonts.Comfortaa_Bold_0.withSize(30)
        self.headerLabel.textColor = AppColors.whiteColor
    }
    
}

