//
//  LogInVC.swift
//  Budfie
//
//  Created by yogesh singh negi on 04/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

//MARK:- LogInVC Class
//====================
class LogInVC: BaseVc {
    
    //MARK:- Properties
    //=================
    //    var isFaceBookSelected: Bool = false
    //    var isGoogleSelected: Bool = false
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var logInLabel       : UILabel!
    @IBOutlet weak var budfieBtnName    : UIButton!
    @IBOutlet weak var facebookBtnName  : UIButton!
    @IBOutlet weak var googleBtnName    : UIButton!
    
    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpInitailViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .default
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    //MARK:- @IBActions
    //=================
    
    //MARK:- Login with Budfie
    //========================
    @IBAction func budfieBtnTapped(_ sender: UIButton) {
        
        let obPhoneNumberVC = PhoneNumberVC.instantiate(fromAppStoryboard: .Login)
        self.navigationController?.pushViewController(obPhoneNumberVC, animated: true)
    }
    
    //MARK:- Login with Facebook
    //==========================
    @IBAction func faceBookBtnTapped(_ sender: UIButton) {
        CommonClass.showToast(msg: "Under Development")

        /*
         FacebookController.shared.getFacebookUserInfo(fromViewController: self, success: { (modelFacebook: FacebookModel) in

         print_debug(modelFacebook.name)
         print_debug(modelFacebook.email)
         print_debug("Your profile Image Url is... \(String(describing: modelFacebook.picture!))")

         var params = JSONDictionary()
         params["social_type"]   = LoginType.Facebook.rawValue
         params["social_id"]     = modelFacebook.id
         params["device_token"]  = deviceToken
         params["device_type"]   = DeviceType.iPhone.rawValue
         params["method"]        = StringConstants.K_Check_Id.localized

         //Hit Check Service For FaceBook
         self.hitCommonCheck(params: params, model: modelFacebook as AnyObject)
         }) { (error) in
         CommonClass.showToast(msg: error?.localizedDescription ?? "")
         }
         */
    }
    
    //MARK:- Login with Google
    //========================
    @IBAction func googleBtnTapped(_ sender: UIButton) {

        GoogleLoginController.shared.login(success: { (modelGoogle: GoogleUser) in
            
            print_debug(modelGoogle.name)
            print_debug(modelGoogle.email)
            print_debug(modelGoogle.image?.absoluteString)
            
            var params = JSONDictionary()
            params["social_type"]   = LoginType.Google.rawValue
            params["social_id"]     = modelGoogle.id
            params["device_token"]  = deviceToken
            params["device_type"]   = DeviceType.iPhone.rawValue
            params["method"]        = StringConstants.K_Check_Id.localized
            
            //Hit Check Service For Google
            self.hitCommonCheck(params: params, model: modelGoogle as AnyObject)
        })
        { (err : Error) in
            CommonClass.showToast(msg: err.localizedDescription)
        }
    }
    
}


//MARK: Extension: for Setting Up SubViews
//========================================
extension LogInVC {
    
    //MARK:- Set Up SubViews method
    //=============================
    fileprivate func setUpInitailViews() {
        
//        self.budfieImage.image      = AppImages.logo
        
        self.logInLabel.text        = StringConstants.LogIn_With.localized
        self.logInLabel.textColor   = AppColors.themeBlueColor
        self.logInLabel.font        = AppFonts.MyriadPro_Regular.withSize(16)
        
        self.budfieBtnName.setImage(AppImages.selectionBudfieicon, for: .normal)
        self.facebookBtnName.setImage(AppImages.selectionFb, for: .normal)
        self.googleBtnName.setImage(AppImages.selectionGoogle, for: .normal)
        
        self.budfieBtnName.backgroundColor = AppColors.themeBlueColor
        self.facebookBtnName.backgroundColor = AppColors.loginFb
        self.googleBtnName.backgroundColor = AppColors.loginGoogle
        
        self.budfieBtnName.roundCornerWith(radius: 3.5)
        self.facebookBtnName.roundCornerWith(radius: 3.5)
        self.googleBtnName.roundCornerWith(radius: 3.5)
    }
    
    //MARK:- Hit Social Check Service
    //===============================
    private func hitCommonCheck(params: JSONDictionary, model: AnyObject) {
        
        //CheckServiceHit
        WebServices.socialCheck(parameters: params, success: { (isSuccess, phoneNumber) in

            if isSuccess {

                if let number = phoneNumber {

                    let otpSceen = OneTimePasswordVC.instantiate(fromAppStoryboard: .Login)
                    //otpSceen.obUserDetails = obUserDetails
                    otpSceen.phoneNumber = number
                    //otpSceen.userData = data
                    self.navigationController?.pushViewController(otpSceen, animated: true)

                } else {
                    AppDelegate.shared.setupFirebase()

                    if AppDelegate.shared.currentuser.has_interest == true {
                        AppUserDefaults.save(value: true, forKey: AppUserDefaults.Key.isIntesrest)
                        // MARK: Landing screen
                        let newHomeScreenScene = NewHomeScreenVC.instantiate(fromAppStoryboard: .Login)
                        self.navigationController?.pushViewController(newHomeScreenScene,
                                                                      animated: true)
                        AppUserDefaults.save(value: "0", forKey: AppUserDefaults.Key.isThankYou)
                    }
                }

            } else {
                
                let obPhoneNumberVC = PhoneNumberVC.instantiate(fromAppStoryboard: .Login)
                if model is FacebookModel {
                    guard let modelFacebook = model as? FacebookModel else { return }
                    obPhoneNumberVC.modelFacebook = modelFacebook
                } else if model is GoogleUser {
                    guard let modelGoogle = model as? GoogleUser else { return }
                    obPhoneNumberVC.modelGoogle = modelGoogle
                }
                self.navigationController?.pushViewController(obPhoneNumberVC, animated: true)
            }
        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
}

