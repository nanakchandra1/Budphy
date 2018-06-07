//
//  HolidayPlannerVC.swift
//  Budfie
//
//  Created by appinventiv on 19/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

enum CalendarFlowType {
    case birthDate
    case eventDate
    case holidayPlan
    case exploreMore
}

//MARK: HolidayPlannerVC class
//============================
class HolidayPlannerVC: BaseVc {
    
    //MARK: Public Properties
    //=======================
    var vcType: CalendarFlowType = .holidayPlan
    var monthHolidays = [[[Holiday]]]()
    var selectableYears: [String] = []
    var selectedYear = "" {
        didSet {
            navYearBtn.setTitle(selectedYear, for: .normal)
        }
    }

    //MARK: Private Properties
    //========================

    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var navBar: CurvedNavigationView!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var navBackBtn: UIButton!
    @IBOutlet weak var navYearBtn: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var monthsCollectionView: UICollectionView!
    
    //MARK: view life cycle
    //=====================
    override func viewDidLoad() {
        super.viewDidLoad()

//        vcType = .eventDate
        self.initialSetUp()
    }
    
    //MARK: IBAction
    //==============
    @IBAction func backBtnTapped(_ sender: UIButton) {
        if vcType == .exploreMore {
            //AppDelegate.shared.sharedTabbar?.showTabbar()
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func changeYearBtnTapped(_ sender: UIButton) {

        FTPopOverMenu.showForSender(sender: sender,
                                    with: selectableYears,
                                    done: { selectedIndex in

                                        let selectedYear = self.selectableYears[selectedIndex]

                                        guard self.selectedYear != selectedYear else {
                                            return
                                        }

                                        self.selectedYear = selectedYear
                                        switch self.vcType {

                                        case .holidayPlan, .exploreMore:
                                            self.getHolidays(for: selectedYear)
                                        case .birthDate, .eventDate:
                                            break
                                        }

        }, cancel: {
            
        })
    }

    //MARK: WEBSERVICES
    //=================
    private func getHolidays(for year: String) {

        WebServices.getHolidays(for: year, success: { holidays in

            self.monthHolidays = holidays

        }, failure: { error in

            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
}

//MARK:- Extension for Private methods
//====================================
extension HolidayPlannerVC {
    
    fileprivate func initialSetUp() {

        let currentDate = Date()
        let calendar = Calendar.current

        switch vcType {
        case .holidayPlan, .exploreMore:

            if vcType == .exploreMore {
                //AppDelegate.shared.sharedTabbar?.hideTabbar()
            }

            let currentYear = calendar.component(.year, from: currentDate)
            if let nextYearDate = calendar.date(byAdding: .year, value: 1, to:  currentDate) {

                let nextYear = calendar.component(.year, from: nextYearDate)
                selectableYears = [currentYear.toString, nextYear.toString]
                selectedYear = selectableYears[0]
                getHolidays(for: selectedYear)
            }

        case .birthDate:
            let initialYear = 1970
            let currentYear = calendar.component(.year, from: currentDate)

            for yearValue in (initialYear...currentYear) {
                selectableYears.append(yearValue.toString)
            }

            selectedYear = currentYear.toString

        case .eventDate:
            let currentYear = calendar.component(.year, from: currentDate)
            let finalYear = (currentYear + 10)

            for yearValue in (currentYear...finalYear) {
                selectableYears.append(yearValue.toString)
            }
            selectedYear = currentYear.toString
        }
        
        if vcType == .holidayPlan {
            self.navBackBtn.setImage(AppImages.eventsHomeLogo, for: .normal)
        } else {
            self.navBackBtn.setImage(AppImages.phonenumberBackicon, for: .normal)
        }

        self.monthsCollectionView.delegate = self
        self.monthsCollectionView.dataSource = self
        
        self.statusBar.backgroundColor = AppColors.themeBlueColor
        self.navBar.backgroundColor = UIColor.clear
        self.navTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        self.navTitle.textColor = AppColors.whiteColor
        self.navTitle.text = StringConstants.K_Holiday_Planner.localized
        self.navYearBtn.titleLabel?.font = AppFonts.AvenirNext_DemiBold.withSize(15)
        self.navYearBtn.setTitleColor(AppColors.whiteColor, for: .normal)
        
        self.headerLabel.font = AppFonts.Comfortaa_Regular_0.withSize(18)
        self.headerLabel.textColor = AppColors.blackColor
        self.headerLabel.text = "\(StringConstants.K_Lets_Plan_holiday.localized)"
    }
    
}

