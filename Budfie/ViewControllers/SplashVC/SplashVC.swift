//
//  SplashVC.swift
//  Budfie
//
//  Created by yogesh singh negi on 04/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON
import Crashlytics

//MARK:- SplashVC Class
//=====================
class SplashVC: BaseVc {
    
    //MARK:- Properties
    //=================
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var logoFront: UIImageView!
    @IBOutlet weak var logoBack : UIImageView!
    @IBOutlet weak var versionLbl: UILabel!
    @IBOutlet weak var versionContainerView: UIView!

    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Crashlytics.sharedInstance().crash()
        
        UIApplication.shared.statusBarStyle = .default
        // Do any additional setup after loading the view.
        self.animationSetUp()

        versionLbl.text = AppDelegate.shared.buildVersionNumber
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.animationBegan()
        UIApplication.shared.statusBarStyle = .default
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}


//MARK: Extension: for Setting Up SubViews
//========================================
extension SplashVC {
    
    //MARK:- Setting Up Animation
    //===========================
    func animationSetUp() {
        self.logoFront.transform = CGAffineTransform(translationX: -screenWidth, y: 0)
        self.logoBack.transform = CGAffineTransform(translationX: screenWidth, y: 0)
    }
    
    //MARK:- Performing Animation
    //===========================
    func animationBegan() {
        
        UIView.animate(withDuration: 1.5,
                       delay: 0.0,
                       options: .curveLinear,
                       animations: {
                        self.logoFront.transform = .identity
        }, completion: { (finish) in
            // Compeletion work
        })
        
        UIView.animate(withDuration: 1.5,
                       delay: 0.0,
                       options: .curveLinear,
                       animations: {
                        self.logoBack.transform = .identity
        }, completion: { (finish) in
            // Compeletion work
            delayWithSeconds(2, completion: {
                self.userPersistency()
            })
        })
    }
    
    //MARK:- Checking for user persistency
    //====================================
    func userPersistency() {
        
        // Check For User Persistency
        let isInterestFilled = AppUserDefaults.value(forKey: .isIntesrest).boolValue
        let isBuddyChosen = !AppUserDefaults.value(forKey: .selectedBuddy).stringValue.isEmpty
        
        if AppUserDefaults.value(forKey: .userData) != JSON.null {
            
            UIApplication.shared.statusBarStyle = .lightContent
            
            var user = AppUserDefaults.value(forKey: .userData)
            var json = JSON(user)
            AppDelegate.shared.currentuser = UserDetails(initForLoginData: json)

            user = AppUserDefaults.value(forKey: .supportData)
            json = JSON(user)
            AppDelegate.shared.helpSupport = UserDetails(initForLoginData: json)

            AppDelegate.shared.setupFirebase()

            if isInterestFilled {

                if isBuddyChosen {
                    let json = AppUserDefaults.value(forKey: .remoteNotification)
                    if json != JSON.null {
                        AppDelegate.shared.actToReceived(json: json["aps"]["data"])
                        AppUserDefaults.removeValue(forKey: .remoteNotification)

                    } else if let typeValue = AppUserDefaults.value(forKey: .appDidOpenWithEventType, fallBackValue: JSON.null).int,
                        let type = AppDelegate.URLSchemeType(rawValue: typeValue),
                        let id = AppUserDefaults.value(forKey: .appDidOpenWithEventId, fallBackValue: JSON.null).string {

                        AppUserDefaults.removeValue(forKey: .appDidOpenWithEventType)
                        AppUserDefaults.removeValue(forKey: .appDidOpenWithEventId)

                        AppDelegate.shared.moveToEventDetail(of: type, with: id)

                    } else {
                        CommonClass.gotoHome()
                    }
                } else {
                    CommonClass.goToChooseBuddy()
                }

            } else {
                if AppDelegate.shared.currentuser.dob.isEmpty {
                    CommonClass.goToProfile()
                } else {
                    CommonClass.gotoInterest()
                }
            }
        } else {
            UIApplication.shared.statusBarStyle = .default
            CommonClass.gotoUserDetails()
        }
    }
    
}
