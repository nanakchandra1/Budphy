//
//  TableCellForCollectionView.swift
//  Budfie
//
//  Created by yogesh singh negi on 05/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

//MARK:- ItemRowAddInerestDelegate Delegate
//=========================================
protocol ItemRowAddInerestDelegate : class {
    func addPopUp(isPopUp: Bool,
                  obSubCategoryModel: SubCategoryModel?,
                  selectedId: [String])
}

//MARK:- TableCellForCollectionView class
//=======================================
class TableCellForCollectionView: BaseCell {
    
    //MARK:- Properties
    //=================
    let sportImageArray     = [AppImages.interestCricket,
                               AppImages.interestFootball,
                               AppImages.interestRacket,
                               AppImages.interestBadminton]
    
    let moviesImageArray    = [AppImages.interestBollywood,
                               AppImages.interestHollywood,
                               AppImages.interestTollywood]
    
    let activitiesImageArray = [AppImages.interestPlay,
                                AppImages.interestKids,
                                AppImages.interestFood,
                                AppImages.interestAdventure]
    
    weak var delegate       : ItemRowAddInerestDelegate?
    var obInterestListModel : InterestListModel?
    static var selectedId   = [String]()
    var viewStatus :CurrentStatus   = .createUserProfile
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var addInterestsCollectionView: UICollectionView!
    
    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialSetup()
        self.registerNibs()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


//MARK: Extension for Registering Nibs and Setting Up SubViews
//============================================================
extension TableCellForCollectionView {
    
    private func initialSetup(){
        
        self.addInterestsCollectionView.delegate = self
        self.addInterestsCollectionView.dataSource = self
    }
    
    private func registerNibs() {
        
        let cell = UINib(nibName: "AddInterestCell", bundle: nil)
        self.addInterestsCollectionView.register(cell, forCellWithReuseIdentifier: "AddInterestCellId")
    }
    
}


//MARK: Extension for UICollectionView Delegate and DataSource
//============================================================
extension TableCellForCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.obInterestListModel?.subCategory.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddInterestCellId", for: indexPath) as? AddInterestCell else { fatalError("AddInterestCell not found") }
        
        cell.nameLabel.font = AppFonts.Comfortaa_Regular_0.withSize(11, iphone6: 12, iphone6p: 12)
        
        var isSelectedCell = false
        
        if let id = self.obInterestListModel?.subCategory[indexPath.row].id {
            if TableCellForCollectionView.selectedId.contains(id) {
                isSelectedCell = true
            }
        }
        switch (self.obInterestListModel?.category)! {
            
        case StringConstants.Sports.localized:
            cell.populateWithColor(isSelectedCell: isSelectedCell,
                                   name: self.obInterestListModel?.subCategory[indexPath.row].name ?? "",
                                   imageName: self.sportImageArray[indexPath.row])
            
        case StringConstants.Movies.localized:
            cell.populateWithColor(isSelectedCell: isSelectedCell,
                                   name: self.obInterestListModel?.subCategory[indexPath.row].name ?? "",
                                   imageName: self.moviesImageArray[indexPath.row])
            
        default:
            cell.populateWithColor(isSelectedCell: isSelectedCell,
                                   name: self.obInterestListModel?.subCategory[indexPath.row].name ?? "",
                                   imageName: self.activitiesImageArray[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let subCategory = obInterestListModel?.subCategory[indexPath.row],
            let unwrappedDelegate = delegate else {
                return
        }

        if TableCellForCollectionView.selectedId.contains(subCategory.id) && ["1", "2"].contains(subCategory.id) {

            unwrappedDelegate.addPopUp(isPopUp: true,
                                    obSubCategoryModel: subCategory,
                                    selectedId: TableCellForCollectionView.selectedId)

        } else if TableCellForCollectionView.selectedId.contains(subCategory.id) {

            let index = TableCellForCollectionView.selectedId.index(of: subCategory.id)
            TableCellForCollectionView.selectedId.remove(at: index!)
            unwrappedDelegate.addPopUp(isPopUp: false,
                                    obSubCategoryModel: subCategory,
                                    selectedId: TableCellForCollectionView.selectedId)

        } else {
            if [StringConstants.Cricket.localized, StringConstants.Football.localized].contains(subCategory.name) {

                unwrappedDelegate.addPopUp(isPopUp: true,
                                        obSubCategoryModel: subCategory,
                                        selectedId: TableCellForCollectionView.selectedId)
            } else {

                TableCellForCollectionView.selectedId.append(subCategory.id)
                unwrappedDelegate.addPopUp(isPopUp: false,
                                        obSubCategoryModel: subCategory,
                                        selectedId: TableCellForCollectionView.selectedId)
            }
        }
        self.addInterestsCollectionView.reloadData()
    }
    
}


//MARK: Extension for UICollectionView Layout
//===========================================
extension TableCellForCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if screenWidth < 322 {
            return CGSize(width: heightForItem + 5, height: heightForItem * 1.5)
        }
        return CGSize(width: heightForItem + 5, height: heightForItem * 1.6)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0,
                            left: spacingBetweenItems,
                            bottom: spacingBetweenItems,
                            right: spacingBetweenItems)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0//spacingBetweenItems - 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0//spacingTopDownItems
    }
    
}
