//
//  BlockedUserListVC.swift
//  Budfie
//
//  Created by appinventiv on 30/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class BlockedUserListVC: BaseVc {
    
    var obBlockedList = [FriendListModel]()
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView   : CurvedNavigationView!
    @IBOutlet weak var topNavBar        : UIView!
    @IBOutlet weak var backBtn          : UIButton!
    @IBOutlet weak var navigationTitle  : UILabel!
    @IBOutlet weak var showBlockedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hitBlockedUserList()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func unBlockUserBtnTapped(_ sender: UIButton) {
        
        guard let indexPath = self.showBlockedTableView.indexPath(forItem: sender) else { return }
        self.hitBlockUnBlock(friendId: self.obBlockedList[indexPath.row].friendId)
        self.obBlockedList.remove(at: indexPath.row)
        self.showBlockedTableView.deleteRows(at: [indexPath], with: .middle)
    }
    
}


//MARK:- Private Extension
//========================
extension BlockedUserListVC {
    
    private func initialSetup() {
        
        self.showBlockedTableView.delegate = self
        self.showBlockedTableView.dataSource = self
        self.showBlockedTableView.backgroundColor = UIColor.clear
        
        //Empty Data Set
        self.showBlockedTableView.emptyDataSetSource = self
        self.showBlockedTableView.emptyDataSetDelegate = self
        self.settingEmptyDataSet()
        
        self.navigationView.backgroundColor = UIColor.clear
        self.topNavBar.backgroundColor = AppColors.themeBlueColor
        
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.text = StringConstants.K_Blocked_Users.localized
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        
        self.backBtn.setImage(AppImages.phonenumberBackicon, for: .normal)
    }
    
    func settingEmptyDataSet(isLoading: Bool = true) {
        
        var placeholder = ""
        if isLoading {
            placeholder = StringConstants.K_Loading_Your_Favourites.localized//"Loading..."
        } else {
            placeholder = "No Blocked User Found"
        }
        
        let myAttribute = [ NSAttributedStringKey.font: AppFonts.Comfortaa_Bold_0.withSize(20),
                            NSAttributedStringKey.foregroundColor: AppColors.noDataFound]
        let myAttrString = NSAttributedString(string: placeholder, attributes: myAttribute)
        
        self.showBlockedTableView.emptyDataSetView { view in
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
    
    //MARK:- hitBlockedUserList method
    //================================
    func hitBlockedUserList(page: Int = 1) {
        
        var params = JSONDictionary()
        
        params["method"] = StringConstants.K_Block_List.localized
        params["access_token"] = AppDelegate.shared.currentuser.access_token
        params["page"] = page
        
        // Getting user Profile
        WebServices.getBlockedUserList(parameters: params, loader: false, success: { (obBlockedList) in
            self.settingEmptyDataSet(isLoading: false)
            self.obBlockedList = obBlockedList
            self.showBlockedTableView.reloadData()
        }) { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        }
    }
    
    //MARK:- hitBlockUnBlock method
    //=============================
    func hitBlockUnBlock(friendId: String) {
        
        var params = JSONDictionary()
        
        params["method"]        = StringConstants.K_Block_Unblock.localized
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["friend_id"]     = friendId
        params["type"]          = "2"
        
        // Getting user Profile
        WebServices.blockUnBlock(parameters: params, loader: false, success: { (success) in
            self.settingEmptyDataSet(isLoading: false)
            if success {
                self.checkIfChatRoomExists(for: friendId)
            }
        }) { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        }
    }

    private func checkIfChatRoomExists(for friendId: String) {

        guard !friendId.isEmpty else {
            return
        }
        let userId = AppDelegate.shared.currentuser.user_id

        DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(userId).child(friendId).observeSingleEvent(of: .value) { [weak self] (snapshot) in

            guard let strongSelf = self else {
                return
            }

            if let roomId = snapshot.value as? String {
                strongSelf.removeBlockStatus(for: roomId)

            } else {

                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(friendId).child(userId).observeSingleEvent(of: .value) {  [weak self] (snapshot) in

                    guard let strongSelf = self else {
                        return
                    }

                    if let roomId = snapshot.value as? String {
                        strongSelf.removeBlockStatus(for: roomId)
                    }
                }
            }
        }
    }

    private func removeBlockStatus(for roomId: String) {
        DatabaseReference.child(DatabaseNode.Root.userBlockStatus.rawValue).child(roomId).removeValue()
    }
    
}


//MARK:- Extension for EmptyDataSetSource, EmptyDataSetDelegate
//=============================================================
extension BlockedUserListVC : EmptyDataSetSource, EmptyDataSetDelegate {
    
}
