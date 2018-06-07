//
//  SettingsVC.swift
//  Budfie
//
//  Created by appinventiv on 10/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit
import SafariServices

class SettingsVC: BaseVc {

    // MARK: Enums
    enum VCType {
        case generalSettings
        case notificationSettings
    }

    enum NotificationType: Int {
        case all = 1
        case sports
        case concerts
        case movies
        case birthday
        case fortuneCookie
        case invitation

        var name: String {
            switch self {
            case .all:
                return "All"
            case .sports:
                return "Sports"
            case .concerts:
                return "Events"
            case .movies:
                return "Movie"
            case .birthday:
                return "Birthday"
            case .fortuneCookie:
                return "Fortune Cookie"
            case .invitation:
                return "Invitation"
            }
        }

        var image: UIImage {
            switch self {
            case .all:
                return AppImages.icSettingsNotifications
            case .concerts:
                return #imageLiteral(resourceName: "icNotificationPartInvite")
            case .sports:
                return #imageLiteral(resourceName: "icNotificationPartMatch")
            case .movies:
                return #imageLiteral(resourceName: "icNotificationPartMovie")
            case .birthday:
                return #imageLiteral(resourceName: "icNotificationPartBday")
            case .fortuneCookie:
                return #imageLiteral(resourceName: "icNotificationPartFortune")
            case .invitation:
                return #imageLiteral(resourceName: "icNotificationPartInvitation")
            }
        }

        var statusValue: String? {
            guard let user = AppDelegate.shared.currentuser else {
                return nil
            }

            let status: String

            switch self {
            case .all:
                status = user.allNotificationStatus
            case .sports:
                status = user.sportsNotificationStatus
            case .concerts:
                status = user.concertsNotificationStatus
            case .movies:
                status = user.moviesNotificationStatus
            case .birthday:
                status = user.birthdayNotificationStatus
            case .fortuneCookie:
                status = user.fortuneCookieNotificationStatus
            case .invitation:
                status = user.invitationNotificationStatus
            }

            return status
        }

        var toggledValue: String? {
            guard let status = statusValue else {
                return nil
            }
            return ((status == "1") ? "2" : "1")
        }

        func toggleValue() {

            guard let user = AppDelegate.shared.currentuser,
                let tValue = toggledValue else {
                    return
            }

            switch self {
            case .all:
                user.allNotificationStatus = tValue
                user.sportsNotificationStatus = tValue
                user.concertsNotificationStatus = tValue
                user.moviesNotificationStatus = tValue
                user.birthdayNotificationStatus = tValue
                user.fortuneCookieNotificationStatus = tValue
                user.invitationNotificationStatus = tValue
            case .sports:
                user.sportsNotificationStatus = tValue
            case .concerts:
                user.concertsNotificationStatus = tValue
            case .movies:
                user.moviesNotificationStatus = tValue
            case .birthday:
                user.birthdayNotificationStatus = tValue
            case .fortuneCookie:
                user.fortuneCookieNotificationStatus = tValue
            case .invitation:
                user.invitationNotificationStatus = tValue
            }
        }
    }

    //MARK:- Properties
    //=================
    let settingArray = ["Notifications",
                        "Profile Visibility",
                        StringConstants.K_Change_Number.localized,
                        StringConstants.K_Blocked_Users.localized,
                        StringConstants.K_Rating_App.localized,
                        StringConstants.Invite_Friends.localized,
                        StringConstants.K_Privacy_Policy.localized,
                        StringConstants.K_Terms_Conditions.localized,
                        StringConstants.K_Help_Support.localized,
                        StringConstants.Logout.localized]
    let settingImages = [AppImages.icSettingsNotifications,
                         AppImages.icSettingsProfileVisibility,
                         AppImages.icSettingsCp,
                         AppImages.icSettingsBu,
                         AppImages.icSettingsRa,
                         AppImages.icSettingsIf,
                         AppImages.icSettingsPp,
                         AppImages.icSettingsTc,
                         AppImages.icSettingsHS,
                         AppImages.icSettingsLogout]

    let notifications: [NotificationType] = [.all, .concerts, .sports, .movies, .birthday, .fortuneCookie, .invitation]

    var state: State = .exploreMore
    var vcType: VCType = .generalSettings
    var links : OpenLinks = .privacyPolicy
    
//    enum PageState {
//        case profile
//        case exploreMore
//    }
    enum OpenLinks : String {
        case privacyPolicy  = "http://staging.budfie.com/admin/content/privacy_policy"
        case termsCondition = "http://staging.budfie.com/admin/content/terms"
        case helpSupport    = "http://staging.budfie.com/admin/content/help"
    }
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView   : CurvedNavigationView!
    @IBOutlet weak var topNavBar        : UIView!
    @IBOutlet weak var backBtn          : UIButton!
    @IBOutlet weak var navigationTitle  : UILabel!
//    @IBOutlet weak var logoutBtn        : UIButton!
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialSetup()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        if self.state == .exploreMore {
            //AppDelegate.shared.sharedTabbar?.showTabbar()
        }
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- Private Extension
//========================
extension SettingsVC {
    
    private func initialSetup() {

        switch vcType {
        case .generalSettings:
            self.navigationTitle.text = StringConstants.K_Settings.localized
        case .notificationSettings:
            navigationTitle.text = "Notifications"
        }

        self.settingsTableView.delegate = self
        self.settingsTableView.dataSource = self
        self.settingsTableView.backgroundColor = UIColor.clear
        
        self.navigationView.backgroundColor = UIColor.clear
        self.topNavBar.backgroundColor = AppColors.themeBlueColor
        
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        
        self.backBtn.setImage(AppImages.phonenumberBackicon, for: .normal)
        self.settingsTableView.isScrollEnabled = screenWidth > 375 ? false : true
    }
    
    private func registerNib() {
        
    }

    func hitProfileVisibility(onOff: String) {

        var params = JSONDictionary()

        params["method"]        = "on_off_visibility"
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["action"]        = onOff

        WebServices.profileVisibilityOnOff(parameters: params, loader: false, success: { (result) in

        }, failure: { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        })
    }
    
    func hitLogout() {
        
        var params = JSONDictionary()
        
        params["method"]        = StringConstants.K_Logout.localized
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        
        WebServices.logout(parameters: params, success: { (result) in
            if result {
                
                CommonClass.showToast(msg: "Logged Out Successfully!!!")
                //ContactsController.shared.deleteContacts()
                AppUserDefaults.removeAllValues()
                FacebookController.shared.facebookLogout()
                GoogleLoginController.shared.logout()
                AppNetworking.cancelAllRequests()
                let obLogInVC = LogInVC.instantiate(fromAppStoryboard: .Login)
                self.navigationController?.setViewControllers([obLogInVC], animated: true)
            }
        }, failure: { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        })
        
    }

    /*
     func notificationCellSelected() {

     guard Connectivity.isConnectedToInternet else {
     CommonClass.showToast(msg: StringConstants.INTERNET_NOT_CONNECTED.localized)
     return
     }

     if AppDelegate.shared.currentuser.notification_status == "1" {
     self.hitNotification(onOff: "2")
     AppDelegate.shared.currentuser.notification_status = "2"
     } else {
     self.hitNotification(onOff: "1")
     AppDelegate.shared.currentuser.notification_status = "1"
     }
     self.settingsTableView.reloadData()
     }
     */

    func profileVisibilityCellSelected() {

        guard Connectivity.isConnectedToInternet else {
            CommonClass.showToast(msg: StringConstants.INTERNET_NOT_CONNECTED.localized)
            return
        }

        if AppDelegate.shared.currentuser.profileVisibility == "1" {
            self.hitProfileVisibility(onOff: "2")
            AppDelegate.shared.currentuser.profileVisibility = "2"
        } else {
            self.hitProfileVisibility(onOff: "1")
            AppDelegate.shared.currentuser.profileVisibility = "1"
        }
        self.settingsTableView.reloadData()
    }
    
    func logoutBtnTapped() {
        
        let controller = InviteFriendsPopUpVC.instantiate(fromAppStoryboard: .Events)
        controller.pageState = .logout
        controller.delegate = self
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: false, completion: nil)
    }
    
    func openLinks() {
        
        if #available(iOS 9.0, *) {
            let safariVC = SFSafariViewController(url: URL(string: self.links.rawValue)!)
            self.present(safariVC, animated: true, completion: nil)
            
        } else {
            UIApplication.shared.openURL(URL(string: self.links.rawValue)!)
        }
    }
}

//MARK:- GetResponseDelegate Delegate Extension
//=============================================
extension SettingsVC: GetResponseDelegate {
    
    func nowOrSkipBtnTapped(isOkBtn: Bool) {
        if isOkBtn {
            self.hitLogout()
        } else {
            return
        }
    }
}
