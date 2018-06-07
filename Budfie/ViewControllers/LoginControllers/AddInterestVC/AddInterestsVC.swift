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
    case movies
    case concert
    case sports
    case personal
}

//MARK:- AddInterestsVC Class
//===========================
class AddInterestsVC: BaseVc {
    
    //MARK:- Properties
    //=================
    var obInterestListModel         : [InterestListModel]?
    var selectedInterestModel       : [SubCategoryModel]?
    static var selectedId           = [String]()
    var selectedCricketLeagueId     = [String]()
    var selectedFootballLeagueId    = [String]()
    var viewStatus :CurrentStatus   = .createUserProfile

    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var statusBar            : UIView!
    @IBOutlet weak var navigationView       : CurvedNavigationView!
    @IBOutlet weak var navigationTitle      : UILabel!
    @IBOutlet weak var backBtnName          : UIButton!
    @IBOutlet weak var addInterestsTableView: UITableView!
    @IBOutlet weak var submitButton         : UIButton!
    
    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.obInterestListModel == nil {
            self.hitInterestList()
        }
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
       if self.viewStatus == .movies || self.viewStatus == .sports || self.viewStatus == .concert {
            //AppDelegate.shared.sharedTabbar?.showTabbar()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        
        //Check for empty interests
        if !self.checkForEmptyInterest() {
            CommonClass.showToast(msg: "Please select atleast one interest from Movies or Sports!!!")
            return
        }
        if viewStatus == .updateProfile {
            
            //      self.editProgileDelegate?.valueChangedOfEditProfile(selectedId: AddFavoriteInterestsVC.selectedId)
            let unique = Array(Set(AddInterestsVC.selectedId))
            AddInterestsVC.selectedId = unique
            NotificationCenter.default.post(name: Notification.Name.ValueChangedOfEditProfile,
                                            object: nil,
                                            userInfo: ["selectedId" :  unique as Any,
                                                       "cricketId"  : self.selectedCricketLeagueId as Any,
                                                       "footballId" : self.selectedFootballLeagueId as Any])
            
            guard let obEditProfile = self.navigationController else { return }
            
            if !obEditProfile.popToClass(type: EditProfileVC.self) {
                
                obEditProfile.popToRootViewController(animated: true)
            }
        } else {
            self.hitAddInterest()
        }
        /*
        let obAddFavoriteInterestsVC = AddFavoriteInterestsVC.instantiate(fromAppStoryboard: .Login)
        obAddFavoriteInterestsVC.obInterestListModel = self.obInterestListModel
        obAddFavoriteInterestsVC.selectedInterestModel = self.selectedInterestModel
        AddFavoriteInterestsVC.selectedId = AddInterestsVC.selectedId
        obAddFavoriteInterestsVC.selectedCricketLeagueId = self.selectedCricketLeagueId
        obAddFavoriteInterestsVC.delegate = self
        obAddFavoriteInterestsVC.viewStatus = self.viewStatus
        self.navigationController?.pushViewController(obAddFavoriteInterestsVC, animated: true)
 */
    }
    
}


//MARK: Extension: for Registering Nibs and Setting Up SubViews
//=============================================================
extension AddInterestsVC {
    
    private func initialSetup(){
        
        // set header view..
        self.navigationView.backgroundColor = UIColor.clear
        self.statusBar.backgroundColor = AppColors.themeBlueColor
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.text = StringConstants.Add_Interests.localized
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        self.backBtnName.setImage(AppImages.phonenumberBackicon, for: .normal)
        
        self.submitButton.titleLabel?.textColor = AppColors.themeBlueColor
        self.submitButton.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(14.7)
        
//        self.addInterestsTableView.backgroundColor = AppColors.whiteColor
        
        self.addInterestsTableView.delegate = self
        self.addInterestsTableView.dataSource = self
        self.addInterestsTableView.contentInset.top = 50
        
        //        self.selectedCricketLeagueId = ""
        //        AddInterestsVC.selectedId = [""]
        if self.viewStatus == .updateProfile {
            self.submitButton.roundCommonButtonPositive(title: StringConstants.Save.localized)
        } else {
            self.submitButton.roundCommonButtonPositive(title: StringConstants.FINISH.localized)
        }
    }
    
    private func registerNibs() {
        
        let cell = UINib(nibName: "TableCellForCollectionView", bundle: nil)
        self.addInterestsTableView.register(cell, forCellReuseIdentifier: "TableCellForCollectionViewId")
        
        let header = UINib(nibName: "TableViewHeader", bundle: nil)
        self.addInterestsTableView.register(header, forHeaderFooterViewReuseIdentifier: "TableViewHeaderId")
    }
    
    func checkForEmptyInterest() -> Bool {
        for temp in AddInterestsVC.selectedId {
            if let num = Int(temp), num < 10 {
                return true
            }
        }
        if AddInterestsVC.selectedId.count == 0 {
            return false
        }
        return false
    }
    
    //MARK:- hitInterestList method
    //=============================
    func hitInterestList(loader: Bool = false) {
        
        var params = JSONDictionary()
        
        params["method"] = StringConstants.K_Interest_List.localized
        params["access_token"] = AppDelegate.shared.currentuser.access_token
        
        // Getting Interest List
        WebServices.getInterestList(parameters: params, loader: loader, success: { (isSuccess,obInterestListModel, selectedInterestModel)  in
            
                self.obInterestListModel = obInterestListModel
                self.selectedInterestModel = selectedInterestModel
                self.makeSelectedId()
                self.addInterestsTableView.reloadData()
            
        }, failure: { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        })
//        if self.obInterestListModel == nil {
//            self.navigationController?.popViewController(animated: true)
//        }
    }
    
    func makeSelectedId() {
        
        AddInterestsVC.selectedId.removeAll()
        self.selectedCricketLeagueId.removeAll()
        self.selectedFootballLeagueId.removeAll()
        
        if let sel = self.selectedInterestModel {
            for subCat in sel {
                AddInterestsVC.selectedId.append(subCat.id)
                if subCat.id == "1" {
                    for childCat in subCat.childCategory {
                        self.selectedCricketLeagueId.append(childCat.id)
                    }
                } else {
                    for childCat in subCat.childCategory {
                        self.selectedFootballLeagueId.append(childCat.id)
                    }
                }
            }
        }
    }
    
    //MARK:- makeParams method
    //========================
    func makeParams() -> JSONDictionary {
        
        var params = JSONDictionary()
        
        params["method"]            = StringConstants.K_User_Interest.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
//        params["location"]          = self.storeFormData[StringConstants.Location.localized]
//        params["longitude"]         = self.storeFormData[StringConstants.Longitude.localized]
//        params["latitude"]          = self.storeFormData[StringConstants.Latitude.localized]
        params["interest"]          = self.makeInterest()
        return params
    }
    
    //MARK:- makeInterest method
    //==========================
    func makeInterest() -> String {
        
        var jsonInterest = [JSONDictionary]()
        
        for id in AddInterestsVC.selectedId {
            var interest = JSONDictionary()
            for temp in self.obInterestListModel! {
                for tem in temp.subCategory {
                    if id == tem.id {
                        //                        interest["interest_id"] = temp.id
                        interest["sub_category"] = id
                    }
                }
            }
            if let subCat = self.obInterestListModel?[0].subCategory, subCat[0].id == "1", subCat[0].id == id {
                for childId in self.selectedCricketLeagueId {
                    for t in subCat[0].childCategory {
                        if childId == t.id, let subId = interest["sub_category"] as? String, subId == "1" {
                            interest["child_category"] = t.id
                            jsonInterest.append(interest)
                        }
                    }
                }
            } else if let subCat = self.obInterestListModel?[0].subCategory, subCat[0].id == "2", subCat[0].id == id {
                for childId in self.selectedCricketLeagueId {
                    for t in subCat[0].childCategory {
                        if childId == t.id, let subId = interest["sub_category"] as? String, subId == "2" {
                            interest["child_category"] = t.id
                            jsonInterest.append(interest)
                        }
                    }
                }
            } else {
                jsonInterest.append(interest)
            }
        }
        return CommonClass.convertToJson(jsonDic: jsonInterest)
    }
    
    //MARK:- hitAddInterest method
    //============================
    func hitAddInterest() {
        
        var params = JSONDictionary()
        params = self.makeParams()
        
        // Getting Interest List
        WebServices.addInterest(parameters: params, success: { (isSuccess) in
            if isSuccess {
                if self.viewStatus == .createUserProfile {
                    
                    AppUserDefaults.save(value: true, forKey: AppUserDefaults.Key.isIntesrest)
                    
                    let controller = ThankYouVC.instantiate(fromAppStoryboard: .Login)
                    controller.state = .interest
                    controller.delegate = self
                    self.addChildViewController(controller)
                    self.view.addSubview(controller.view)
                    controller.didMove(toParentViewController: self)
                    //                    controller.modalPresentationStyle = .overCurrentContext
                    //                    self.present(controller, animated: false, completion: nil)
                    
                } else {

                    guard let navCont = self.navigationController else {
                        return
                    }

                    let viewControllers = navCont.viewControllers
                    var eventScene: EventVC?

                    for controller in viewControllers {
                        if let tabbarScene = controller as? TabBarVC {
                            let childViewControllers = tabbarScene.childViewControllers
                            for childController in childViewControllers {
                                if let eventCont = childController as? EventVC {
                                    eventScene = eventCont
                                    break
                                }
                            }
                            break
                        }
                    }

                    guard let unwrappedEventScene = eventScene else {
                        return
                    }

                    unwrappedEventScene.hitGetEventDates(date: unwrappedEventScene.selectedDateString, reloadSimple: false, loader: false, shouldGetData: false)

                    switch self.viewStatus {

                    case .personal:
                        unwrappedEventScene.childVC.prevSelectedDate = ""
                        unwrappedEventScene.childVC.getPersonelEvents(page: 1, reloadSimple: true, loader: false)

                    case .sports:
                        unwrappedEventScene.childVC1.prevSelectedDate = ""
                        unwrappedEventScene.childVC1.hitGetSports(page: 1, reloadSimple: true, loader: false)

                    case .movies:
                        unwrappedEventScene.childVC2.prevSelectedDate = ""
                        unwrappedEventScene.childVC2.hitGetMovies(page: 1, reloadSimple: true, loader: false)

                    case .concert:
                        unwrappedEventScene.childVC3.prevSelectedDate = ""
                        unwrappedEventScene.childVC3.hitGetConcert(page: 1, reloadSimple: true, loader: false)

                    default:
                         break
                    }

                    //AppDelegate.shared.sharedTabbar?.showTabbar()
                    if !navCont.popToClass(type: TabBarVC.self) {
                        navCont.popToRootViewController(animated: true)
                    }
                }

            } else {
                CommonClass.showToast(msg: "Failed!!!")
            }

        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
}


//MARK:- AddInterestsVC Delegate Extension
//========================================
extension AddInterestsVC: PushToHomeScreenDelegate {
    
    func pushHomeScreen() {
        let buddyValue = AppUserDefaults.value(forKey: .selectedBuddy).stringValue
        if buddyValue.isEmpty {
            let chooseBuddyScene = ChooseBuddyVC.instantiate(fromAppStoryboard: .Login)
            navigationController?.pushViewController(chooseBuddyScene, animated: true)
        } else {
            moveToHomeScreen()
        }
    }

    fileprivate func moveToHomeScreen() {
        let newHomeScreenScene = NewHomeScreenVC.instantiate(fromAppStoryboard: .Login)
        navigationController?.pushViewController(newHomeScreenScene, animated: true)
    }
}


//MARK: Extension: for ItemRowAddInerestDelegate
//==============================================
extension AddInterestsVC: ItemRowAddInerestDelegate {
    
    func addPopUp(isPopUp: Bool, obSubCategoryModel: SubCategoryModel?, selectedId: [String]) {
        if isPopUp, let subCategory = obSubCategoryModel {
            let controller = AddInterestPopUpVC.instantiate(fromAppStoryboard: .Login)
            controller.subCategory = subCategory
            controller.delegate = self
            controller.selectedCricketLeagueId  = self.selectedCricketLeagueId
            controller.selectedFootballLeagueId = self.selectedFootballLeagueId
            controller.modalPresentationStyle = .overCurrentContext
            self.present(controller, animated: false, completion: nil)
        }
        print_debug(obSubCategoryModel?.name)
        AddInterestsVC.selectedId = selectedId
        print_debug(AddInterestsVC.selectedId)
    }
    
}

/*
//MARK: Extension: for SelectedIdValueChangeDelegate
//==================================================
extension AddInterestsVC: SelectedIdValueChangeDelegate {
    
    func valueChanged(selectedId: [String]) {
        AddInterestsVC.selectedId = selectedId
        print_debug(AddInterestsVC.selectedId)
    }
    
}
*/

//MARK: Extension: for SelectedLeagueDelegate
//===========================================
extension AddInterestsVC: SelectedLeagueDelegate {
    
    func fetchSelectedCricketLeagues(selectedLeagues: [String]) {
        var selectedId = Set(AddInterestsVC.selectedId)
        if selectedLeagues.count == 0 {
            selectedId.remove("1")
            self.selectedCricketLeagueId.removeAll()
        } else {
            guard let interest = self.obInterestListModel else { return }
            let id = interest[0].subCategory[0].id
            selectedId.insert(id)
            self.selectedCricketLeagueId = selectedLeagues
        }
        AddInterestsVC.selectedId = Array(selectedId)
        self.addInterestsTableView.reloadData()
    }

    func fetchSelectedFootballLeagues(selectedLeagues: [String]) {
        var selectedId = Set(AddInterestsVC.selectedId)
        if selectedLeagues.count == 0 {
            selectedId.remove("2")
            self.selectedFootballLeagueId.removeAll()
        } else {
            guard let interest = self.obInterestListModel else { return }
            let id = interest[0].subCategory[1].id
            selectedId.insert(id)
            self.selectedFootballLeagueId = selectedLeagues
        }
        AddInterestsVC.selectedId = Array(selectedId)
        self.addInterestsTableView.reloadData()
    }
}

