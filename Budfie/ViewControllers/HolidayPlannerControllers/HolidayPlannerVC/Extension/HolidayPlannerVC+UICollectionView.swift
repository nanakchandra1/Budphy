//
//  HolidayPlannerVC+UICollectionView.swift
//  Budfie
//
//  Created by appinventiv on 19/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

//MARK:- Extension for DataSource and Delegate
//============================================
extension HolidayPlannerVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowMonthsCell", for: indexPath) as? ShowMonthsCell else {
            fatalError("ShowMonthsCell not found")
        }
        
        cell.populate(row: indexPath.item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let calendar = Calendar.current
        var components = DateComponents()
        components.year = Int(selectedYear)
        components.month = (indexPath.item + 1)

        guard let date = calendar.date(from: components) else {
            return
        }

        let holidayCalendarScene = HolidayCalendarVC.instantiate(fromAppStoryboard: .HolidayPlanner)
        holidayCalendarScene.moveToDate = date
        holidayCalendarScene.delegate = self
        holidayCalendarScene.selectableYears = selectableYears
        holidayCalendarScene.monthHolidays = monthHolidays
        holidayCalendarScene.vcType = vcType
        navigationController?.pushViewController(holidayCalendarScene, animated: true)
    }
    
}

extension HolidayPlannerVC: UpdateYearDelegate {

    func didChangeYear(_ yearString: String, monthHolidays: [[[Holiday]]]) {
        self.selectedYear = yearString
        self.monthHolidays = monthHolidays
    }
}

//MARK:- Extension for DelegateFlowLayout
//=======================================
extension HolidayPlannerVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let heightWidth = (screenWidth - 21) / 3
        
        return CGSize(width: heightWidth, height: heightWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
}

//MARK:- ShowMonthsCell Class
//===========================
class ShowMonthsCell : UICollectionViewCell {
    
    //MARK:- @IBOutlet
    //================
    @IBOutlet weak var monthsLabel: UILabel!
    @IBOutlet weak var monthsImageView: UIImageView!
    
    //MARK:- Cell Life Cycle
    //======================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = AppColors.whiteColor
        self.monthsLabel.font = AppFonts.Comfortaa_Bold_0.withSize(15)
        self.monthsLabel.textColor = AppColors.blackColor
    }
    
    func populate(row: Int) {
        if let month = Month(rawValue: (row + 1)) {
            self.monthsLabel.text = month.name
            self.monthsImageView.image = month.image
        }
    }
    
}
