//
//  ProfilePicVC+UICollectionView.swift
//  Budfie
//
//  Created by yogesh singh negi on 09/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

//MARK: Extension: for UICollection Delegate and DataSource
//=========================================================
extension ProfilePicVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonImageCellId", for: indexPath) as? CommonImageCell else { fatalError("CommonImageCell not found") }
        
        self.selectedIndex == indexPath.item ? cell.setBorder() : cell.removeBorder()
        cell.populate(name: displayItems[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedIndex = self.selectedIndex == indexPath.item ? -1 : indexPath.item
        if indexPath.item == 2 {
            AppImagePicker.showImagePicker(delegateVC: self, whatToCapture: .image, source: .camera)
        } else if indexPath.row == 3 {
            AppImagePicker.showImagePicker(delegateVC: self, whatToCapture: .image, source: .gallery)
        }
        self.customizeProfileCollectionView.reloadData()
    }
    
}


//MARK: Extension: for UICollection Layout
//========================================
extension ProfilePicVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.customizeProfileCollectionView.frame.width - LRTBSpacing.LeftRight.rawValue * 3) / 2
        let height = (self.customizeProfileCollectionView.frame.height - LRTBSpacing.TopBottom.rawValue * 3) / 2
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: LRTBSpacing.TopBottom.rawValue,
                            left: LRTBSpacing.LeftRight.rawValue,
                            bottom: LRTBSpacing.TopBottom.rawValue,
                            right: LRTBSpacing.LeftRight.rawValue)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
