//
//  JokesThoughtsVC+UITableView.swift
//  Budfie
//
//  Created by appinventiv on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation
import CHTCollectionViewWaterfallLayout

//MARK:- Extension for UICollectionView Delegate and DataSource
//=============================================================
extension JokesThoughtsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.jokesThoughtsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JokesThoughtsCell", for: indexPath) as? JokesThoughtsCell else {
            fatalError("JokesThoughtsCell not found")
        }
        
        if vcState == .jokes {
            cell.backImage.image = jokesImages[indexPath.row % 4]
        } else {
            cell.backImage.image = thoughtsImages[indexPath.row % 4]
        }
        cell.dataLabel.text = self.jokesThoughtsList[indexPath.row]
        
        return cell
    }
    
}


//MARK:- Extension for DelegateFlowLayout
//=======================================
extension JokesThoughtsVC: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let width = screenWidth / 2
        let height = self.jokesThoughtsList[indexPath.row].heightOfText((width - 60), font: AppFonts.AvenirNext_Regular.withSize(15))
        return CGSize(width: width, height: (height + 120))
        
    }
    //UICollectionViewDelegateFlowLayout {
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = screenWidth / 2
        let height = self.jokesThoughtsList[indexPath.row].heightOfText((width - 60), font: AppFonts.AvenirNext_Regular.withSize(13.9))
        return CGSize(width: width, height: (height + 130))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    */
    
}


class JokesThoughtsCell : UICollectionViewCell {
    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var dataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.backImage.image = #imageLiteral(resourceName: "icFunnyJokesCard1")
        self.dataLabel.textColor = AppColors.blackColor
//        print_debug(dataLabel.font)
        self.contentView.backgroundColor = UIColor.clear
    }
    
}
