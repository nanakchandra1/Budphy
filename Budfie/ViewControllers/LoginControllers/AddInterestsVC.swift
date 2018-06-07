//
//  AddInterestsVC.swift
//  Budfie
//
//  Created by yogesh singh negi on 05/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

//MARK:- CurrentStatus Enum
//=========================
enum CurrentStatus {
    case createUserProfile
    case updateProfile
}

//MARK:- AddInterestsVC Class
//===========================
class AddInterestsVC: BaseVc {
    
    //MARK:- Properties
    //=================
    var obInterestListModel         : [InterestListModel]?
    static var selectedId           = [String]()
    var selectedCricketLeagueId     = [String]()
    var viewStatus :CurrentStatus   = .createUserProfile
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView       : UIView!
    @IBOutlet weak var navigationTitle      : UILabel!
    @IBOutlet weak var backBtnName          : UIButton!
    @IBOutlet weak var addInterestsTableView: UITableView!
    @IBOutlet weak var submitButton         : UIButton!
    
    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
        self.registerNibs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addInterestsTableView.reloadData()
    }
    
    //MARK:- @IBActions
    //=================
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        
        //Check for empty interests
        if (AddInterestsVC.selectedId).isEmpty {
            CommonClass.showToast(msg: "Please Selected atleast one Insterest!!!")
            return
        }
        
        let obAddFavoriteInterestsVC = AddFavoriteInterestsVC.instantiate(fromAppStoryboard: .Login)
        obAddFavoriteInterestsVC.obInterestListModel = self.obInterestListModel
        AddFavoriteInterestsVC.selectedId = AddInterestsVC.selectedId
        obAddFavoriteInterestsVC.selectedCricketLeagueId = self.selectedCricketLeagueId
        obAddFavoriteInterestsVC.delegate = self
        obAddFavoriteInterestsVC.viewStatus = self.viewStatus
        self.navigationController?.pushViewController(obAddFavoriteInterestsVC, animated: true)
    }
    
}


//MARK: Extension: for Registering Nibs and Setting Up SubViews
//=============================================================
extension AddInterestsVC {
    
    private func initialSetup(){
        
        // set header view..
        self.navigationView.backgroundColor = AppColors.themeBlueColor
        self.navigationView.curvView()// For curve shape view..
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.text = StringConstants.Add_Interests.localized
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        self.backBtnName.setImage(AppImages.phonenumberBackicon, for: .normal)
        
        self.submitButton.titleLabel?.textColor = AppColors.themeBlueColor
        self.submitButton.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(14.7)
        self.submitButton.roundCommonButton(title: StringConstants.NEXT.localized)
        
        self.addInterestsTableView.backgroundColor = AppColors.whiteColor
        self.addInterestsTableView.delegate = self
        self.addInterestsTableView.dataSource = self
        //        self.selectedCricketLeagueId = ""
        //        AddInterestsVC.selectedId = [""]
        if let interest = self.obInterestListModel, interest.isEmpty {
            self.hitInterestList()
        }
    }
    
    private func registerNibs() {
        
        let cell = UINib(nibName: "TableCellForCollectionView", bundle: nil)
        self.addInterestsTableView.register(cell, forCellReuseIdentifier: "TableCellForCollectionViewId")
        
        let header = UINib(nibName: "TableViewHeader", bundle: nil)
        self.addInterestsTableView.register(header, forHeaderFooterViewReuseIdentifier: "TableViewHeaderId")
    }
    
    //MARK:- hitInterestList method
    //=============================
    func hitInterestList() {
        
        var params = JSONDictionary()
        
        params["method"] = StringConstants.K_Interest_List.localized
        params["access_token"] = AppUserDefaults.value(forKey: .Accesstoken)
        
        // Getting Interest List
        WebServices.getInterestList(parameters: params, loader: false, success: { (obInterestListModel) in
            
            self.obInterestListModel = obInterestListModel
            self.addInterestsTableView.reloadData()
        }, failure: { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        })
    }
    
}


//MARK: Extension: for ItemRowAddInerestDelegate
//==============================================
extension AddInterestsVC: ItemRowAddInerestDelegate {
    
    func addPopUp(isPopUp: Bool, obSubCategoryModel: SubCategoryModel?, selectedId: [String]) {
        if isPopUp {
            let controller = AddInterestPopUpVC.instantiate(fromAppStoryboard: .Login)
            controller.childCategory = obSubCategoryModel?.childCategory
            controller.delegate = self
            self.addChildViewController(controller)
            self.view.addSubview(controller.view)
            controller.didMove(toParentViewController: self)
        }
        print_debug(obSubCategoryModel?.name)
        AddInterestsVC.selectedId = selectedId
        print_debug(AddInterestsVC.selectedId)
    }
    
}


//MARK: Extension: for SelectedIdValueChangeDelegate
//==================================================
extension AddInterestsVC: SelectedIdValueChangeDelegate {
    
    func valueChanged(selectedId: [String]) {
        AddInterestsVC.selectedId = selectedId
        print_debug(AddInterestsVC.selectedId)
    }
    
}


//MARK: Extension: for SelectedLeagueDelegate
//===========================================
extension AddInterestsVC: SelectedLeagueDelegate {
    
    func fetchSelectedLeagues(selectedLeagues: [String]) {
        guard let interest = self.obInterestListModel else { return }
        let id = interest[0].subCategory[0].id
        AddInterestsVC.selectedId.append(id)
        self.selectedCricketLeagueId = selectedLeagues
        self.addInterestsTableView.reloadData()
    }
    
}
