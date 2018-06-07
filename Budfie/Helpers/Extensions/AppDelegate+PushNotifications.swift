//
//  AppDelegate+PushNotifications.swift
//  Onboarding
//
//  Created by Appinventiv on 13/11/17.
//  Copyright © 2017 Gurdeep Singh. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import SwiftyJSON
//import Firebase

//MARK:
//MARK: Remote push notification methods/delegates
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        let userInfo = response.notification.request.content.userInfo
        print_debug(userInfo)

        application(UIApplication.shared, didReceiveRemoteNotification: userInfo)
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        let userInfoJSON = JSON(userInfo)
        print_debug(userInfo)

        NSLog("aps: \(userInfoJSON["aps"])")
        NSLog("data: \(userInfoJSON["aps"]["data"])")
        NSLog("type_id: \(userInfoJSON["aps"]["type_id"])")

        NSLog("UIApplication.topViewController: \(UIApplication.topViewController)")

        if let chatScene = UIApplication.topViewController() as? ChatVC,
            let roomId = userInfoJSON["aps"]["data"]["type_id"].string,
            chatScene.chatRoomInfo.roomId == roomId {

            NSLog("chatScene.chatRoomInfo.roomId: \(chatScene.chatRoomInfo.roomId)")
            NSLog("roomId: \(roomId)")

        } else {
            completionHandler(.alert)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if isLaunchedFromRemotePush {
            isLaunchedFromRemotePush = false
        } else {
            let userInfo = JSON(userInfo)
            actToReceived(json: userInfo["aps"]["data"])
        }
    }

    func actToReceived(json: JSON) {
        print_debug(json)

        let navCont: UINavigationController
        let homeScene: UIViewController
        let isBuddyChosen = !AppUserDefaults.value(forKey: .selectedBuddy).stringValue.isEmpty

        guard let type = PushType(rawValue: json["type"].intValue), isBuddyChosen else {
            return
        }

        if let nCont = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController,
            let hScene = nCont.viewControllers.first as? NewHomeScreenVC {

            navCont = nCont
            homeScene = hScene

        } else {

            homeScene = NewHomeScreenVC.instantiate(fromAppStoryboard: .Login)
            navCont = AvoidingMultiPushNavigationController(rootViewController: homeScene)
            navCont.isNavigationBarHidden = true
        }

        //let visibleCont = navCont.visibleViewController

        switch type {
        case .eventInvitation:
            let invitationScene = InvitationVC.instantiate(fromAppStoryboard: .Events)
            let viewController = [homeScene, invitationScene]
            navCont.setViewControllers(viewController, animated: true)

        case .acceptEventInvitation:
            let typeValue = json["type"].intValue
            let id = json["type_id"].stringValue

            if let type = AppDelegate.URLSchemeType(rawValue: typeValue),
                !id.isEmpty,
                let eventDetailScene = getController(for: type, id: id) {

                let viewController = [homeScene, eventDetailScene]
                navCont.setViewControllers(viewController, animated: true)
            }

        case .receivedGreeting:
            let sentGreetingsVCScene = SentGreetingsVC.instantiate(fromAppStoryboard: .Greeting)
            sentGreetingsVCScene.vcState = .receive
            sentGreetingsVCScene.flowType = .home
            let viewControllers = [homeScene, sentGreetingsVCScene]
            navCont.setViewControllers(viewControllers, animated: true)

            /*
             let id = json["type_id"].stringValue
             if !id.isEmpty {

             let greetingDict: JSONDictionary = ["greeting_id": id, "share_id": ""]
             let json = JSON(greetingDict)
             let greeting = GreetingListModel(initWithListModel: json)

             let greetingPreviewScene = GreetingPreviewVC.instantiate(fromAppStoryboard: .Greeting)
             greetingPreviewScene.vcState = .receive
             greetingPreviewScene.modelGreetingList = greeting
             let viewController = [homeScene, greetingPreviewScene]
             navCont.setViewControllers(viewController, animated: true)
             }
             */

        case .userBirthday, .friendBirthday, .eventNotification, .eventReminder:
            let tabBarScene = TabBarVC.instantiate(fromAppStoryboard: .Events)
            tabBarScene.tabBarState = .Event
            let viewController = [homeScene, tabBarScene]
            navCont.setViewControllers(viewController, animated: true)

        case .chat:
            let id = json["type_id"].stringValue
            if !id.isEmpty {
                AppUserDefaults.save(value: id, forKey: .toMoveTochatRoomId)
                let tabBarScene = TabBarVC.instantiate(fromAppStoryboard: .Events)
                tabBarScene.tabBarState = .Chat
                let viewController = [homeScene, tabBarScene]
                navCont.setViewControllers(viewController, animated: true)
            }
        }

        window?.rootViewController = navCont
        window?.makeKeyAndVisible()
        UIApplication.shared.statusBarStyle = .default

        /*
         let eventListingTypes: [PushType] = [.userBirthday, .friendBirthday]
         let eventDetailTypes: [PushType] = [.eventInvitation, .acceptEventInvitation]
         let greetingDetailTypes: [PushType] = [.receivedGreeting]

         if eventListingTypes.contains(type),
         let tabbarScene = visibleCont as? TabBarVC {

         tabbarScene.eventBtnAction(tabbarScene.eventButton)

         for childCont in tabbarScene.childViewControllers {
         if let eventScene = childCont as? EventVC {
         eventScene.personalBtnTapped()
         eventScene.childVC.prevSelectedDate = ""
         break
         }
         }

         } else if let tabbarScene = visibleCont as? TabBarVC {

         } else {

         }
         */
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        /*
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
        Auth.auth().setAPNSToken(deviceToken, type: .prod)

        var deviceTokenString:String?
        if #available(iOS 10.0, *) {
            let dToken = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
            deviceTokenString = "\(dToken)"
        }
        else {
            let characterSet: CharacterSet = CharacterSet(charactersIn: "<>")
            let dToken = deviceToken.description.trimmingCharacters(in: characterSet).replacingOccurrences(of: " ", with: "")
            deviceTokenString = "\(dToken)"
        }
        */

        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        //deviceTokenString = "\(token)"
        DeviceDetail.deviceToken = token
        
        NSLog("%@", "Device token = \(token)")
        //self.window?.rootViewController?.showAlert(msg: token)

        WebServices.refreshToken(token: token, success: {

        }, failure: { error in
            print_debug(error.localizedDescription)
        })
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }

    func registerUserNotifications() {

        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (grant, error)  in
                if error == nil, grant {
                    DispatchQueue.main.async {
                        self.registerUNNotificationCategory()
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else if let unwrappedError = error {
                    print_debug("error: \(unwrappedError.localizedDescription)")
                }
            })
        } else {
            registerUIUserNotificationCategory()
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    @available(iOS 10.0, *)
    private func registerUNNotificationCategory() {
        UNUserNotificationCenter.current().setNotificationCategories([])
    }

    private func registerUIUserNotificationCategory() {

        let types: UIUserNotificationType = [.alert, .sound, .badge]
        let notificationSettings = UIUserNotificationSettings(types: types, categories: nil)

        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
    }
    
    func pushAction(forInfo userInfo: [AnyHashable: Any], state: UIApplicationState) {

        /*
        guard let aps = userInfo["aps"] as? JSONDictionary else {
            return
        }
        if let type = aps["type"] ,let pushType : PushType = PushType(rawValue: "\(type)"){
            
        }
        */
    }
}
