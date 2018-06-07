//
//  SettingsVC+UITableView.swift
//  Budfie
//
//  Created by appinventiv on 10/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation

//MARK:- Extension for UITableView Delegate and DataSource
//========================================================
extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch vcType {
        case .generalSettings:
            return self.settingArray.count
        case .notificationSettings:
            if let statusValue = NotificationType.all.statusValue,
                statusValue == "2" {
                return 1
            }
            return self.notifications.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell else { fatalError("SettingCell not found") }

        let settingText: String
        let settingImage: UIImage

        switch vcType {

        case .generalSettings:
            settingText = self.settingArray[indexPath.row]
            settingImage = self.settingImages[indexPath.row]

        case .notificationSettings:
            
            let notification = notifications[indexPath.row]
            settingText = notification.name
            settingImage = notification.image
        }

        cell.settingLabel.text = settingText
        cell.settingIconImage.image = settingImage

        if vcType == .notificationSettings {
            cell.toggleOnOff.isHidden = false

            if notifications[indexPath.row].statusValue == "1" {
                cell.toggleOnOff.image = AppImages.icToggleOn
            } else {
                cell.toggleOnOff.image = AppImages.icToggleOff
            }

        } else if [0, 1].contains(indexPath.row) {
            cell.toggleOnOff.isHidden = false

            if indexPath.row == 0 {
                cell.toggleOnOff.image = AppImages.phonenumberRight

                /*
                 if AppDelegate.shared.currentuser.notification_status == "2" {
                 cell.toggleOnOff.image = AppImages.icToggleOff
                 } else {
                 cell.toggleOnOff.image = AppImages.icToggleOn
                 }
                 */

            } else {
                if AppDelegate.shared.currentuser.profileVisibility == "2" {
                    cell.toggleOnOff.image = AppImages.icToggleOff
                } else {
                    cell.toggleOnOff.image = AppImages.icToggleOn
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch vcType {
        case .generalSettings:

            switch indexPath.row {

            case 0:
                let notificationSettingsScene = SettingsVC.instantiate(fromAppStoryboard: .Settings)
                notificationSettingsScene.vcType = .notificationSettings
                self.navigationController?.pushViewController(notificationSettingsScene, animated: true)

            case 1:
                profileVisibilityCellSelected()

            case 2:
                //            print_debug(self.settingArray[indexPath.row])
                //            CommonClass.showToast(msg: "Under Development")
                let scene = PhoneNumberVC.instantiate(fromAppStoryboard: .Login)
                scene.vcState = .changeNumber
                self.navigationController?.pushViewController(scene, animated: true)

            case 3:
                let scene = BlockedUserListVC.instantiate(fromAppStoryboard: .Settings)
                self.navigationController?.pushViewController(scene, animated: true)

            case 4:
                if let url = URL(string: "itms-apps://itunes.apple.com/app/id1024941703"),
                    UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }

            case 5:
                // Invite Friends
                // http://staging.budfie.com/share/event?id=&type=1
                CommonClass.externalShare(textURL: "https://itunes.apple.com/app/id1024941703", viewController: self)
                //            print_debug(self.settingArray[indexPath.row])
                //            CommonClass.showToast(msg: StringConstants.K_Under_Development.localized)

            case 6:
                //            print_debug(self.settingArray[indexPath.row])
                //            CommonClass.showToast(msg: "Under Development")
                self.links = .privacyPolicy
                self.openLinks()

            case 7:
                //            print_debug(self.settingArray[indexPath.row])
                //            CommonClass.showToast(msg: "Under Development")
                self.links = .termsCondition
                self.openLinks()

            case 8:
                //            print_debug(self.settingArray[indexPath.row])
                //            CommonClass.showToast(msg: "Under Development")
                self.links = .helpSupport
                self.openLinks()

            case 9:
                self.logoutBtnTapped()

            default:
                print_debug(self.settingArray[indexPath.row])
                CommonClass.showToast(msg: StringConstants.K_Under_Development.localized)
            }

        case .notificationSettings:
            toggleNotification(notifications[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if screenWidth < 322 {
            return 65
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

    private func toggleNotification(_ notification: NotificationType) {

        guard Connectivity.isConnectedToInternet,
            let toggledValue = notification.toggledValue else {
                CommonClass.showToast(msg: StringConstants.INTERNET_NOT_CONNECTED.localized)
                return
        }

        var params = JSONDictionary()

        params["method"]        = StringConstants.K_On_Off_Notification.localized
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["type"]          = notification.rawValue
        params["action"]        = toggledValue

        WebServices.notificationOnOff(parameters: params, loader: false, success: { [weak self] (result) in

            guard let strongSelf = self else {
                return
            }
            notification.toggleValue()
            strongSelf.settingsTableView.reloadSections([0], with: .fade)

        }, failure: { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        })
    }
}


//MARK:- SettingCell Prototype Class
//==================================
class SettingCell: UITableViewCell {
    
    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var settingIconImage: UIImageView!
    @IBOutlet weak var toggleOnOff: UIImageView!
    @IBOutlet weak var settingLabel: UILabel!
    
    //MARK: cell life cycle
    //=====================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.toggleOnOff.isHidden = true
    }
    
    //MARK: initial setup
    //===================
    func initialSetUp() {
        self.settingLabel.font = AppFonts.Comfortaa_Regular_0.withSize(16)
        self.settingLabel.textColor = AppColors.blackColor
        self.toggleOnOff.isHidden = true
        self.contentView.backgroundColor = UIColor.clear
    }
    
    //MARK: Populate cell method
    //==========================
    func populateView() {
        
    }
}
