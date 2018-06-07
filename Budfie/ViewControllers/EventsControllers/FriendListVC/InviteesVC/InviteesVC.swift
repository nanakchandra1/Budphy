//
//  InviteesVC.swift
//  Budfie
//
//  Created by yogesh singh negi on 11/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import EmptyDataSet_Swift
import RealmSwift

enum PageState {
    case editEvent
    case addEvent
    case greeting
    case viewEvent
}

class InviteesVC: BaseVc {
    
    //MARK:- Properties
    //=================
    //    var isSelectedBudfieFriend  = [String]()
    var isSelectedPhoneFriend   = [String]()
    var selectedId              = [String]()
    var contacts                = [PhoneContact]()
    var obFriendListModel       = [PhoneContact]()
    var allFriends              = [PhoneContact]() {
        didSet {
            contacts = allFriends
            settingEmptyDataSet(isLoading: false)
            friendListTableView.reloadData()
        }
    }//ContactsController.shared.fetchNonBudfieContacts()
    var AllobFriendListModel    = [PhoneContact]() {
        didSet {
            obFriendListModel = AllobFriendListModel
            settingEmptyDataSet(isLoading: false)
            friendListTableView.reloadData()
        }
    }//ContactsController.shared.fetchBudfieContacts()

    weak var delegate           : EventDelegate?
    var eventId                 : String!
    var state : PageState       = .addEvent
    var eventDate               : Date?
    var friendID                = [JSONDictionary]()
    var isDraft                 = false
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView: CurvedNavigationView!
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var friendListTableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    
    //MARK:- view life cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.hitFriendList(sreachString: "", page: "1")
        self.initialSetup()
        self.registerNib()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
        if selectedId.isEmpty && isSelectedPhoneFriend.isEmpty {
            CommonClass.showToast(msg: "Please select at least one friend")
            return
        }
        
        if state == .addEvent {
            self.hitInviteFriend()
            
        } else if state == .greeting {
            self.hitShareGreeting()
            
        } else {
            
            var userInfo = JSONDictionary()
            userInfo["friendIds"] = self.makeFriendList() //self.makeFriendIds()
            userInfo["otherIds"] = self.makeOtherContacts()
            
            NotificationCenter.default.post(name: Notification.Name.GetFriendId, object: nil, userInfo: userInfo)
            
            guard let nav = self.navigationController else { return }
            
            if nav.popToClass(type: EditEventVC.self) {

            } else if nav.popToClass(type: HolidayPlannerEventVC.self) {

            } else {
                nav.popToRootViewController(animated: true)
            }
        }
    }
    
    @objc func searchBarEditingChanged(_ sender: UITextField) {
        
        let txt = sender.text ?? ""
        if txt.isEmpty {
            self.contacts = self.allFriends
        } else {
            self.contacts =
                self.allFriends.filter({ ($0.name).localizedCaseInsensitiveContains(txt) })
        }
        if txt.isEmpty {
            self.obFriendListModel = self.AllobFriendListModel
        } else {
            self.obFriendListModel =
                self.AllobFriendListModel.filter({ ($0.name).localizedCaseInsensitiveContains(txt) })
        }
        self.friendListTableView.reloadData()
    }
    
}


//MARK:- InviteesVC Private Extension
//===================================
extension InviteesVC {
    
    private func initialSetup() {
        
        self.friendListTableView.delegate = self
        self.friendListTableView.dataSource = self
        
        //Empty Data Set
        self.friendListTableView.emptyDataSetSource = self
        self.friendListTableView.emptyDataSetDelegate = self
        self.settingEmptyDataSet()
        
        self.navigationView.backgroundColor = UIColor.clear
        self.statusBar.backgroundColor = AppColors.themeBlueColor
        
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.text = "Contacts"
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        
        self.backBtn.setImage(AppImages.phonenumberBackicon, for: .normal)
        self.searchImageView.image = AppImages.icInviteSearch
        
        self.searchBarView.roundCornerWith(radius: 17.5)
        self.searchBarView.backgroundColor = AppColors.friendListBottom
        
        self.searchBar.font = AppFonts.Comfortaa_Light_0.withSize(12.5)
        self.searchBar.placeholder = StringConstants.Search.localized
        self.searchBar.textColor = AppColors.blackColor
        self.searchBar.backgroundColor = UIColor.clear
        //        self.searchBar.delegate = self
        
        self.submitButton.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(15)
        self.submitButton.titleLabel?.textColor = AppColors.themeBlueColor
        
        if self.state == .greeting {
            self.submitButton.roundCommonButtonPositive(title: "Share")
        } else {
            self.submitButton.roundCommonButtonPositive(title: StringConstants.Invite.localized)
        }
        
        self.AllobFriendListModel = ContactsController.shared.fetchBudfieContacts()
        self.allFriends = ContactsController.shared.fetchNonBudfieContacts()

        self.searchBar.addTarget(self,
                                 action: #selector(searchBarEditingChanged(_:)),
                                 for: UIControlEvents.editingChanged)
    }
    
    func registerNib() {
        
        let header = UINib(nibName: "TableViewHeader", bundle: nil)
        self.friendListTableView.register(header, forHeaderFooterViewReuseIdentifier: "TableViewHeader")
    }
    
    func settingEmptyDataSet(isLoading: Bool = true) {
        
        var placeholder = ""
        if isLoading {
            placeholder = StringConstants.K_Loading_Your_Favourites.localized//"Loading..."
        } else {
            placeholder = "No Friends Found"
        }
        
        let myAttribute = [ NSAttributedStringKey.font: AppFonts.Comfortaa_Bold_0.withSize(20),
                            NSAttributedStringKey.foregroundColor: AppColors.noDataFound]
        let myAttrString = NSAttributedString(string: placeholder, attributes: myAttribute)
        
        self.friendListTableView.emptyDataSetView { view in
            view.titleLabelString(myAttrString)
                //                .detailLabelString(NSAttributedString.init(string: "No Data"))
                //                .image(AppImages.icNodata)
                //                .imageAnimation(imageAnimation)
                //                .buttonTitle(buttonTitle, for: .normal)
                //                .buttonTitle(buttonTitle, for: .highlighted)
                //                .buttonBackgroundImage(buttonBackgroundImage, for: .normal)
                //                .buttonBackgroundImage(buttonBackgroundImage, for: .highlighted)
                //                .dataSetBackgroundColor(backgroundColor)
                //                .verticalOffset(verticalOffset)
                //                .verticalSpace(spaceHeight)
                //                .shouldDisplay(true, view: tableView)
                //                .shouldFadeIn(true)
                //                .isTouchAllowed(true)
                //                .isScrollAllowed(true)
                .isImageViewAnimateAllowed(true)
                .didTapDataButton {
                    // Do something
                }
                .didTapContentView {
                    // Do something
            }
        }
    }
    
    //MARK:- makeFriendIds method
    //===========================
    func makeFriendIds() -> [JSONDictionary] {
        var friendDic = [JSONDictionary]()
        for temp in self.selectedId {
            var friend = JSONDictionary()
            friend["friend_id"] = temp
            friendDic.append(friend)
        }
        return friendDic
    }
    
    func makeFriendList() -> [FriendListModel] {
        
        var friendListModel = [FriendListModel]()
        
        for friend in self.AllobFriendListModel {
            for selectedFriendId in self.selectedId {
                if friend.id == selectedFriendId {
                    var dic = JSONDictionary()
                    dic["first_name"] = friend.name
                    dic["last_name"] = ""
                    dic["friend_id"] = friend.id
                    dic["image"] = friend.image
                    dic["avtar"] = ""
                    friendListModel.append(FriendListModel(initForFriendList: JSON(dic)))
                }
            }
        }
        return friendListModel
        
        /*
         son["first_name"].stringValue
         self.lastName   = json["last_name"].stringValue
         self.friendId   = json["friend_id"].stringValue
         self.image      = json["image"].stringValue
         self.avtar      = json["avtar"].stringValue
         */
        
    }
    
    //MARK:- hitFriendList method
    //===========================
    func hitFriendList(sreachString: String, page: String) {
        
        var params = JSONDictionary()
        
        params["method"]            = StringConstants.K_Friend_List.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["page"]              = page
        params["search_key"]        = sreachString
        
        // Get Friend List
        //================
        WebServices.getFriendList(parameters: params, loader: false, success: { (obFriendListModel) in
            
            //            self.obFriendListModel = obFriendListModel
            self.friendListTableView.reloadData()
            
        }) { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        }
    }
    
    //MARK:- makeParams method
    //========================
    func makeParams() -> JSONDictionary {
        
        var params = JSONDictionary()
        
        params["method"]       = StringConstants.K_Invite_Friends.localized
        params["access_token"] = AppDelegate.shared.currentuser.access_token
        params["event_id"]     = self.eventId
        
        let frndID             = self.makeFriendIds()
        let otherID            = self.makeOtherContacts()
        /*
         for frnUniqueID in self.friendID {
         var count = 0
         for f in frndID {
         if let str = f["friend_id"] as? String,
         let str2 = frnUniqueID["friend_id"] as? String,
         str == str2 {
         count = 1
         }
         }
         if count == 0 {
         frndID.append(frnUniqueID)
         }
         }
         */

        if frndID.isEmpty {
            params["friends"]   = ""
        } else {
            params["friends"]   = CommonClass.convertToJson(jsonDic: frndID)
        }

        if otherID.isEmpty {
            params["contacts"]  = ""
        } else {
            params["contacts"]  = CommonClass.convertToJson(jsonDic: otherID)
        }
        
        return params
    }
    
    //MARK:- hitInviteFriend method
    //=============================
    func hitInviteFriend() {
        
        var params = JSONDictionary()
        params = self.makeParams()
        
        // Invite Friend
        //==============
        WebServices.inviteFriends(parameters: params, success: { (success) in
            
            if success {
                
                let controller = InviteFriendsPopUpVC.instantiate(fromAppStoryboard: .Events)
                controller.delegate = self
                controller.pageState = .greetingEvent
                controller.modalPresentationStyle = .overCurrentContext
                self.present(controller, animated: false, completion: nil)
            }
            
        }) { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        }
    }
    
    //MARK:- hitShareGreeting method
    //==============================
    func hitShareGreeting() {
        
        var params = JSONDictionary()
        params = self.makeParamsForGreetings()
        
        // Share Greetings
        //================
        WebServices.shareGreeting(parameters: params, success: { [weak self] (result) in

            guard let strongSelf = self else {
                return
            }

            if result {
                if strongSelf.state == .addEvent {
                    
                } else if strongSelf.isDraft {
                    strongSelf.removeGreetingfromDraft(greetingId: strongSelf.eventId)
                }
                //AppDelegate.shared.sharedTabbar?.showTabbar()
                let scene = TypeOfGreetingVC.instantiate(fromAppStoryboard: .Greeting)
                strongSelf.navigationController?.pushViewController(scene, animated: true)
            }
        }, failure: { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        })
    }

    func removeGreetingfromDraft(greetingId: String) {
        
        guard let realm = try? Realm() else {
            return
        }

        let greetings = realm.objects(Greeting.self).filter({ greeting in
            if let id = greeting.id {
                return (greeting.isDraft && !id.isEmpty && greetingId == id)
            }
            return false
        })

        guard let greeting = greetings.first else {
            return
        }

        try? realm.write {
            greeting.isDraft = false
        }
    }
    
    //MARK:- makeParams method
    //========================
    func makeParamsForGreetings() -> JSONDictionary {
        
        var params = JSONDictionary()
        
        params["method"]       = StringConstants.K_Share_Greeting.localized
        params["access_token"] = AppDelegate.shared.currentuser.access_token
        params["greeting_id"]  = self.eventId
        
        let frndID             = self.makeFriendIdsGreeting()
        /*
         for frnUniqueID in self.friendID {
         var count = 0
         for f in frndID {
         if let str = f["friend_id"] as? String,
         let str2 = frnUniqueID["friend_id"] as? String,
         str == str2 {
         count = 1
         }
         }
         if count == 0 {
         frndID.append(frnUniqueID)
         }
         }
         */
        params["friend_ids"]       = CommonClass.convertToJson(jsonDic: frndID)
        
        return params
    }
    
    //MARK:- makeFriendIds method
    //===========================
    func makeFriendIdsGreeting() -> [JSONDictionary] {
        
        var friendDic = [JSONDictionary]()
        for temp in self.selectedId {
            var friend = JSONDictionary()
            for tem in self.obFriendListModel {
                if tem.id == temp {
                    friend["id"] = temp
                }
            }
            friendDic.append(friend)
        }
        return friendDic
    }
    
    private func makeOtherContacts() -> [JSONDictionary] {
        
        var otherDic = [JSONDictionary]()
        for temp in self.isSelectedPhoneFriend {
            var friend = JSONDictionary()
            friend["phone_no"] = temp
            friend["country_code"] = "+91"
            otherDic.append(friend)
        }
        return otherDic
    }
    
}

//MARK:- GetResponseDelegate Delegate Extension
//=============================================
extension InviteesVC: GetResponseDelegate {
    
    func nowOrSkipBtnTapped(isOkBtn: Bool) {
        
        CommonClass.showToast(msg: "Friends has been invited successfully")

        if isOkBtn {
            
            let ob = TypeOfGreetingVC.instantiate(fromAppStoryboard: .Greeting)
            if let date = self.eventDate?.toString(dateFormat: DateFormat.dOBServerFormat.rawValue) {
                ob.eventDate = date
                ob.eventId = eventId
                ob.flowType = .events
                //AppDelegate.shared.sharedTabbar?.hideTabbar()
            }
            self.navigationController?.pushViewController(ob, animated: true)
            
        } else {
            
            if AppUserDefaults.value(forKey: AppUserDefaults.Key.isThankYou) == "0" {
                let controller = ThankYouVC.instantiate(fromAppStoryboard: .Login)
                controller.state = .invite
                controller.delegate = self
                self.addChildViewController(controller)
                self.view.addSubview(controller.view)
                controller.didMove(toParentViewController: self)
                //                controller.modalPresentationStyle = .overCurrentContext
                //                self.present(controller, animated: false, completion: nil)
            } else {
                self.pushHomeScreen()
            }
        }
    }
    
}


//MARK:- InviteesVC Delegate Extension
//====================================
extension InviteesVC: PushToHomeScreenDelegate {
    
    func pushHomeScreen() {
        
        guard let nav = self.navigationController else { return }
        
        //AppDelegate.shared.sharedTabbar?.showTabbar()
        if nav.popToClass(type: TabBarVC.self) {
            if let eventD = self.eventDate?.toString(dateFormat: DateFormat.dOBServerFormat.rawValue) {
                NotificationCenter.default.post(name: Notification.Name.EventAdded,
                                                object: nil,
                                                userInfo: ["eventDate":eventD as String])
                //self.delegate?.eventAdded(date: eventD)
            }
        }
    }
}

//MARK:- Extension for EmptyDataSetSource, EmptyDataSetDelegate
//=============================================================
extension InviteesVC : EmptyDataSetSource, EmptyDataSetDelegate {
    
}


extension InviteesVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        delayWithSeconds(0.1) {
            let txt = textField.text ?? ""
            if txt.isEmpty {
                
                self.contacts = self.allFriends
                
            } else {
                self.contacts =
                    self.allFriends.filter({ ($0.name).localizedCaseInsensitiveContains(txt) })
            }
        }
        self.friendListTableView.reloadData()
        return true
    }
}


