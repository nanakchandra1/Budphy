//
//  CommonClass.swift
//  Onboarding
//
//  Created by Anuj on 9/15/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import FirebaseAnalytics
import Crashlytics
import GooglePlaces
import Toaster

class CommonClass {
    
    static func gotoHome() {
        
        logFirebaseEvent()
        
        let newHomeScreenScene = NewHomeScreenVC.instantiate(fromAppStoryboard: .Login)
        self.gotoViewController(newHomeScreenScene)
        
        
//        let sceen = PhoneNumberVC.instantiate(fromAppStoryboard: .Login)
//        self.gotoViewController(sceen)

    }
    
    static func gotoInterest() {
        
        logFirebaseEvent()
        
        let sceen = AddInterestsVC.instantiate(fromAppStoryboard: .Login)
        sceen.hitInterestList(loader: true)
        self.gotoViewController(sceen)
        
        
        //        let sceen = PhoneNumberVC.instantiate(fromAppStoryboard: .Login)
        //        self.gotoViewController(sceen)
        
    }
    
    static func goToProfile() {
        
        logFirebaseEvent()

        let sceen = MyProfileVC.instantiate(fromAppStoryboard: .Login)
        self.gotoViewController(sceen)
    }

    static func goToChooseBuddy() {
        let chooseBuddyScene = ChooseBuddyVC.instantiate(fromAppStoryboard: .Login)
        self.gotoViewController(chooseBuddyScene)
    }
    
    static func gotoUserDetails() {

        let walkThroughScene = WalkThroughVC.instantiate(fromAppStoryboard: .Login)
        self.gotoViewController(walkThroughScene)

        //let sceen = LogInVC.instantiate(fromAppStoryboard: .Login)
        //self.gotoViewController(sceen)

        //let sceen = UserDetailViewController.instantiate(fromAppStoryboard: .Main)
        //self.gotoViewController(sceen,sideMenu: true)
    }
    
    static func logFirebaseEvent() {
        
        guard let curUser = AppDelegate.shared.currentuser
            else {
                return
        }
        
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id-\(curUser.user_id)" as NSObject,
            AnalyticsParameterItemName: "\(curUser.first_name)" as NSObject,
            AnalyticsParameterContentType: "Logged user details" as NSObject
            ])
        
        let c = Crashlytics()
        c.setUserName(curUser.first_name)
        c.setUserEmail(curUser.phone_no)
        c.setUserIdentifier(curUser.user_id)

    }
    
    static func gotoViewController(_ vc : BaseVc,sideMenu : Bool = true) {
        
//        if sideMenu {
//            let leftMenuViewController = SideMenuVC.instantiate(fromAppStoryboard: .Main)
//            let mainViewController = vc
//            let nvc = UINavigationController(rootViewController: mainViewController)
//            nvc.isNavigationBarHidden = true
//
//            let leftslideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftMenuViewController)
//
//            AppDelegate.shared.window?.rootViewController = leftslideMenuController
//            AppDelegate.shared.window?.makeKeyAndVisible()
//
//        }else {
        let nvc = AvoidingMultiPushNavigationController(rootViewController: vc)
        nvc.isNavigationBarHidden = true

        AppDelegate.shared.window?.rootViewController = nvc
        AppDelegate.shared.window?.makeKeyAndVisible()
        UIApplication.shared.statusBarStyle = .default

//        }
    }

    class func configureToasterAppearance() {
//        ToastView.appearance().backgroundColor = AppColors.themeBlueColor.withAlphaComponent(0.9)
        ToastView.appearance().cornerRadius = 15
//        ToastView.appearance().textColor = .white
        ToastView.appearance().font = AppFonts.Comfortaa_Regular_0.withSize(15)
        ToastView.appearance().bottomOffsetPortrait = 45
        ToastView.appearance().textInsets = UIEdgeInsetsMake(10, 20, 10, 20)
    }
    
    class func showToast(msg: String){
        
        if let currentToast = ToastCenter.default.currentToast {
            currentToast.cancel()
        }
        
        let toast = Toast(text: msg)
        toast.show()

//        TinyToast.shared.dismissAll()
//        TinyToast.shared.show(message: msg,
//                              valign: TinyToastDisplayVAlign.bottom,
//                              duration: TinyToastDisplayDuration.normal)
    }
    
    class func hideToast() {
        if let currentToast = ToastCenter.default.currentToast {
            currentToast.cancel()
        }
    }
    
    class func convertToJson(jsonDic: [JSONDictionary]) -> String {
        if let json = try? JSONSerialization.data(withJSONObject: jsonDic, options: []) {
            if let content = String(data: json, encoding: .utf8) {
                print_debug(content)
                return content
            }
        }
        return ""
    }

    class func showBudfieShare(text: String?, image: UIImage?, on controller: UIViewController, shareDelegate: BudfieShareDelegate) {
        let budfieShareScene = BudfieShareVC.instantiate(fromAppStoryboard: .Greeting)
        budfieShareScene.view.frame = controller.view.bounds
        budfieShareScene.delegate = shareDelegate
        budfieShareScene.text = text
        budfieShareScene.image = image
        budfieShareScene.willMove(toParentViewController: controller)
        controller.view.addSubview(budfieShareScene.view)
        controller.addChildViewController(budfieShareScene)
        budfieShareScene.didMove(toParentViewController: controller)
    }

    final class func getCity(geocoding: Bool = false, from place: GMSPlace, completion: @escaping (String) -> Void) {

        if place.name.contains(s: "°") || geocoding {

            let parameters: JSONDictionary = ["latlng": "\(place.coordinate.latitude),\(place.coordinate.longitude)", "key": "AIzaSyA2-c4OGH6e1qS8kvwTvLu2xCUDALntipE"]

            WebServices.reverseGeocode(parameters: parameters, success: { place in

                if let city = place.city {
                    completion(city)
                } else if let cityDistrict = place.cityDistrict {
                    completion(cityDistrict)
                } else if let state = place.state {
                    completion(state)
                } else if let country = place.country {
                    completion(country)
                }

            }, failure: { error in
                CommonClass.showToast(msg: error.localizedDescription)
            })

        } else if let addressComponents = place.addressComponents {
            for component in addressComponents {
                if component.type == "locality" {
                    completion(component.name)
                    return
                }
            }
            for component in addressComponents {
                if component.type == "administrative_area_level_2" {
                    completion(component.name)
                    return
                }
            }
            for component in addressComponents {
                if component.type == "administrative_area_level_1" {
                    completion(component.name)
                    return
                }
            }
            for component in addressComponents {
                if component.type == "country" {
                    completion(component.name)
                    return
                }
            }
        } else {
            getCity(geocoding: true, from: place, completion: completion)
        }
    }

    final class func showPermissionAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { action in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    class func externalShare(textURL: String, viewController: UIViewController) {
        
        if let url = URL(string: textURL) {
            
            let shareController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            shareController.popoverPresentationController?.sourceView = viewController.view
            // so that iPads won't crash
            viewController.present(shareController, animated: true, completion: nil)
            
        } else {
            CommonClass.showToast(msg: "Please try later!!!")
        }
    }
    
    class func imageShare(textURL: String, shareImage: UIImage, viewController: UIViewController) {
        let shareController = UIActivityViewController(activityItems: [textURL, shareImage], applicationActivities: [])
        shareController.popoverPresentationController?.sourceView = viewController.view
        viewController.present(shareController, animated: true, completion: nil)
    }
}
