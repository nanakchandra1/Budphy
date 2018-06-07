//
//  AddInterestPopUpVC.swift
//  Budfie
//
//  Created by yogesh singh negi on 06/12/17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

extension UIViewController {
    func hidePopUp() {
        self.dismiss(animated: false, completion: nil)
    }
}

//MARK:- Get Selected Cricket Leagues Delegate
//============================================
protocol SelectedLeagueDelegate : class {
    func fetchSelectedCricketLeagues(selectedLeagues: [String])
    func fetchSelectedFootballLeagues(selectedLeagues: [String])
}

//MARK:- AddInterestPopUpVC class
//===============================
class AddInterestPopUpVC: BaseVc {
    
    //MARK:- Properties
    //=================
    var subCategory: SubCategoryModel!
    //var childCategory  : [ChildCategoryModel]?
    var selectedIds    = Set<String>()
    weak var delegate  : SelectedLeagueDelegate?
    var selectedCricketLeagueId  = [String]()
    var selectedFootballLeagueId = [String]()

    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var popUpTableView: UITableView!
    
    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpInitailViews()
        self.registerNibs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.statusBarView.backgroundColor = AppColors.popUpBackground
        self.backView.transform = CGAffineTransform(translationX: 0,
                                                    y: -screenHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5) {
            self.backGroundView.backgroundColor = AppColors.popUpBackground
            self.statusBarView.backgroundColor = AppColors.whiteColor
            self.backView.transform = .identity
        }

        if subCategory.childCategory.count > 3 {
            if let scrollIndicatorImageView = popUpTableView.subviews.last as? UIImageView {
                scrollIndicatorImageView.backgroundColor = AppColors.themeLightBlueColor
            }
            popUpTableView.flashScrollIndicators()
        }
    }
    
    //MARK:- @IBActions
    //=================
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        
        self.UpDownAnimation()
    }
    
    @IBAction func okBtnTapped(_ sender: UIButton) {
        
//        if self.selectedRow.count == 0 {
//            CommonClass.showToast(msg: "Please select atleast one Cricket League")
//            return
//        }
        self.UpDownAnimation()

        if subCategory.id == "1" {
            self.delegate?.fetchSelectedCricketLeagues(selectedLeagues: Array(selectedIds))
        } else {
            self.delegate?.fetchSelectedFootballLeagues(selectedLeagues: Array(selectedIds))
        }
    }
    
    @objc func selectedRowBtnTapped(_ sender: UIButton) {
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.popUpTableView) else {
            fatalError("Cannot Find IndexPath")
        }
        let row = indexPath.row
        let id = subCategory.childCategory[row].id
        
        if self.selectedIds.contains(id) {
            self.selectedIds.remove(id)
        } else {
            self.selectedIds.insert(id)
        }
        self.popUpTableView.reloadData()
    }
}


//MARK: Extension of AddInterestPopUpVC for Regisering Nibs and Setting Up SubViews
//=================================================================================
extension AddInterestPopUpVC {
    
    //MARK:- Set Up SubViews method
    //=============================
    fileprivate func setUpInitailViews() {

        if subCategory.id == "2" {
            headingLabel.text = "Choose Soccer Leagues:"
        } else {
            headingLabel.text = StringConstants.Choose_Cricket_Leagues.localized
            subCategory.childCategory.sort(by: { (firstCategory, secondCategory) -> Bool in
                return firstCategory.id > secondCategory.id
            })
        }

        self.popUpTableView.delegate = self
        self.popUpTableView.dataSource = self
        self.popUpTableView.backgroundColor = UIColor.clear
        
        self.view.backgroundColor = UIColor.clear
        self.backView.backgroundColor = UIColor.clear
        self.backGroundView.backgroundColor = UIColor.clear
        self.popUpView.backgroundColor = AppColors.whiteColor
        
        self.headingLabel.textColor = AppColors.blackColor
        headingLabel.text = "Choose Leagues:"
        self.headingLabel.font = AppFonts.Comfortaa_Bold_0.withSize(16)

        self.submitBtn.titleLabel?.textColor = AppColors.themeBlueColor
        self.submitBtn.titleLabel?.font = AppFonts.MyriadPro_Regular.withSize(14.7)
        self.submitBtn.roundCommonButtonPositive(title: StringConstants.OK.localized)
        
        self.makeCricketSelectedIds()
    }
    
    func makeCricketSelectedIds() {
        self.selectedIds.removeAll()
        if subCategory.id == "1" {
            selectedIds = Set(self.selectedCricketLeagueId)
        } else {
            selectedIds = Set(self.selectedFootballLeagueId)
        }
    }
    
    //MARK:- Nib Register method
    //==========================
    fileprivate func registerNibs() {
    }
    
    func show(parentVC: UIViewController) {
        self.didMove(toParentViewController: parentVC)
    }
    
    // Animation performed
    func UpDownAnimation() {
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.statusBarView.backgroundColor = AppColors.popUpBackground
                        self.backGroundView.backgroundColor = UIColor.clear
                        self.backView.transform = CGAffineTransform(translationX: 0,
                                                                    y: -screenHeight)
        },
                       completion: { (doneWith) in
                        self.hidePopUp()
        })
    }
    
}

