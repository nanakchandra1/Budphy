//
//  OneTimePasswordVC.swift
//  Budfie
//
//  Created by yogesh singh negi on 02/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

//MARK:- OneTimePasswordVC Class
//==============================
class OneTimePasswordVC: BaseVc {
    
    //MARK:- Properties
    //=================
    var isSubmitButtonEnable: Bool = false
    var otp                 : String = ""
    var obUserDetails       : UserDetails?
    var timer               : Timer?
    var phoneNumber         : String?
    var counter             : Int = 60
    var userData            : JSONDictionary?
    var vcState             : PhoneNumberState = .newLogin

    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView       : CurvedNavigationView!
    @IBOutlet weak var navigationTitle      : UILabel!
    @IBOutlet weak var backBtnName          : UIButton!
    @IBOutlet weak var topNavBar: UIView!
    @IBOutlet weak var otpImage             : UIImageView!
    @IBOutlet weak var otpDescriptionLabel  : UILabel!
    @IBOutlet weak var firstTextField       : UITextField!
    @IBOutlet weak var secondTextField      : UITextField!
    @IBOutlet weak var thirdTextField       : UITextField!
    @IBOutlet weak var fourthTextField      : UITextField!
    @IBOutlet weak var submitButton         : UIButton!
    @IBOutlet weak var resendButton         : UIButton!
    @IBOutlet weak var timerLabel           : UILabel!
    
    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.timer == nil {
            self.enableTimerHit()
        }
        AppDelegate.shared.registerUserNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer?.invalidate()
    }
    
    //MARK:- @IBActions
    //=================
    
    //MARK:- Back Button
    //==================
    @IBAction func backButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Submit Button
    //====================
    @IBAction func submitButton(_ sender: UIButton) {
        
        if !isSubmitButtonEnable {
            CommonClass.showToast(msg: "OTP is Missing: Please Provide OTP")
            return
        }
        
        guard let firstDigit    = self.firstTextField.text else {return}
        guard let secondDigit   = self.secondTextField.text else {return}
        guard let thirdDigit    = self.thirdTextField.text else {return}
        guard let fourthDigit   = self.fourthTextField.text else {return}
        
        if !firstDigit.isEmpty && !secondDigit.isEmpty && !thirdDigit.isEmpty && !fourthDigit.isEmpty {
            
            if vcState == .newLogin {
                self.sendResendOtpHit(sender)
            } else {
                self.sendResendOtpForChangeNumber(sender)
            }

        } else {
            CommonClass.showToast(msg: "OTP is Missing: Please Provide OTP")
        }
        
    }
    
    //MARK:- Resend OTP Button
    //========================
    @IBAction func resendCodeButton(_ sender: UIButton) {
        
        if vcState == .newLogin {
            self.sendResendOtpHit(sender)
        } else {
            self.sendResendOtpForChangeNumber(sender)
        }
    }
    
    //MARK:- Setting Counter
    //======================
    @objc func calculate() {
        
        if counter > 0 {
            counter = counter - 1
            if counter < 10 {
                self.timerLabel.text = "00:0\(counter)"
            } else {
                self.timerLabel.text = "00:\(counter)"
            }
        } else {
            self.disableTimerHit()
        }
    }
    
}


//MARK: Extension: for Registering Nibs and Setting Up SubViews
//=============================================================
extension OneTimePasswordVC {
    
    //MARK:- Initial setup
    //====================
    private func initialSetup(){
        
        // set header view..
        self.navigationView.backgroundColor = UIColor.clear
        self.topNavBar.backgroundColor = AppColors.themeBlueColor
        self.navigationTitle.textColor      = AppColors.whiteColor
        self.navigationTitle.text           = StringConstants.One_Time_Password.localized
        self.navigationTitle.font           = AppFonts.AvenirNext_Medium.withSize(20)
        self.backBtnName.setImage(AppImages.phonenumberBackicon, for: .normal)
        self.otpImage.image                 = AppImages.phonenumberOtp
//        self.otpImage.dropBottomShadow(shadow: AppColors.textFieldBaseLine)
        
        self.otpDescriptionLabel.text       = StringConstants.OTP_Title_Label.localized
        self.otpDescriptionLabel.textColor  = AppColors.blackColor
        self.otpDescriptionLabel.font       = AppFonts.Comfortaa_Light_0.withSize(12.5)
        
        self.textFieldSetup()
        self.disableTimerHit()
        
        self.submitButton.titleLabel?.textColor = AppColors.themeBlueColor
        self.submitButton.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(14.7)
        self.submitButton.roundCommonButtonPositive(title: "CONTINUE")
        
        self.resendButton.titleLabel?.textColor = AppColors.themeBlueColor
        self.resendButton.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(14.7)
        self.resendButton.setTitle(StringConstants.Resend_Code.localized, for: .normal)
    }
    
    //MARK:- Start Timmer
    //===================
    private func enableTimerHit() {
        
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(calculate),
                                              userInfo: nil,
                                              repeats: true)
            self.resendButton.isHidden = true
            self.timerLabel.isHidden = false
        }
    }
    
    //MARK:- Stop Timmer
    //==================
    private func disableTimerHit() {
        
        self.resendButton.isHidden = false
        self.timerLabel.isHidden = true
        self.timer?.invalidate()
        self.timer = nil
        self.counter = 60
    }
    
    //MARK:- Setup Textfields
    //=======================
    func textFieldSetup() {
        
        // Set textFields..
        self.firstTextField.font = AppFonts.Comfortaa_Bold_0.withSize(15.8)
        self.firstTextField.textColor = AppColors.blackColor
        self.firstTextField.roundCornerWith(radius: 5)
        self.firstTextField.border(width: 0.8, borderColor: AppColors.textFieldBaseLine)
        self.firstTextField.keyboardType = .numberPad
        self.firstTextField.delegate = self
        
        self.secondTextField.font = AppFonts.Comfortaa_Bold_0.withSize(15.8)
        self.secondTextField.textColor = AppColors.blackColor
        self.secondTextField.roundCornerWith(radius: 5)
        self.secondTextField.border(width: 0.8, borderColor: AppColors.textFieldBaseLine)
        self.secondTextField.keyboardType = .numberPad
        self.secondTextField.delegate = self
        
        self.thirdTextField.font = AppFonts.Comfortaa_Bold_0.withSize(15.8)
        self.thirdTextField.textColor = AppColors.blackColor
        self.thirdTextField.roundCornerWith(radius: 5)
        self.thirdTextField.border(width: 0.8, borderColor: AppColors.textFieldBaseLine)
        self.thirdTextField.keyboardType = .numberPad
        self.thirdTextField.delegate = self
        
        self.fourthTextField.font = AppFonts.Comfortaa_Bold_0.withSize(15.8)
        self.fourthTextField.textColor = AppColors.blackColor
        self.fourthTextField.roundCornerWith(radius: 5)
        self.fourthTextField.border(width: 0.8, borderColor: AppColors.textFieldBaseLine)
        self.fourthTextField.keyboardType = .numberPad
        self.fourthTextField.delegate = self
    }
    
    //MARK:- Setup Verify Button
    //==========================
    func setupVerifyButton() {
        
        if let text1 = self.firstTextField.text,
            let text2 = self.secondTextField.text,
            let text3 = self.thirdTextField.text,
            let text4 = self.fourthTextField.text {
            
            if !text1.isEmpty && !text2.isEmpty && !text3.isEmpty && !text4.isEmpty {
                self.submitButton.isUserInteractionEnabled = true
            } else {
                self.submitButton.isUserInteractionEnabled = false
            }
        }
    }
    
    //MARK:- Change Border Color of textfields
    //========================================
    func changeBorderColor(_ textField: UITextField) {
        
        if (textField.text != nil){
            textField.layer.borderColor = AppColors.themeBlueColor.cgColor
        } else {
            textField.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    //MARK:- Removing Spaces and special characters
    //=============================================
    func textFieldShouldHighLight() {
        
        if let text1 = self.firstTextField.text,
            let text2 = self.secondTextField.text,
            let text3 = self.thirdTextField.text,
            let text4 = self.fourthTextField.text {
            
            if text1.removeSpaces != "\u{200B}", !text1.isEmpty {
                self.firstTextField.border(width: 1, borderColor: AppColors.themeBlueColor)
            } else {
                self.firstTextField.border(width: 0.8, borderColor: AppColors.textFieldBaseLine)
            }
            
            if text2.removeSpaces != "\u{200B}", !text2.isEmpty {
                self.secondTextField.border(width: 1, borderColor: AppColors.themeBlueColor)
            } else {
                self.secondTextField.border(width: 0.8, borderColor: AppColors.textFieldBaseLine)
            }
            
            if text3.removeSpaces != "\u{200B}", !text3.isEmpty {
                self.thirdTextField.border(width: 1, borderColor: AppColors.themeBlueColor)
            } else {
                self.thirdTextField.border(width: 0.8, borderColor: AppColors.textFieldBaseLine)
            }
            
            if text4.removeSpaces != "\u{200B}", !text4.isEmpty {
                self.fourthTextField.border(width: 1, borderColor: AppColors.themeBlueColor)
            } else {
                self.fourthTextField.border(width: 0.8, borderColor: AppColors.textFieldBaseLine)
            }
            
            if text1.removeSpaces != "\u{200B}" && !text1.isEmpty && text2.removeSpaces != "\u{200B}" && !text2.isEmpty && text3.removeSpaces != "\u{200B}" && !text3.isEmpty && text4.removeSpaces != "\u{200B}" && !text4.isEmpty {
                
                self.isSubmitButtonEnable = true
                
                self.otp = "\(text1)\(text2)\(text3)\(text4)"
                
                self.firstTextField.border(width: 1, borderColor: AppColors.themeBlueColor)
                self.secondTextField.border(width: 1, borderColor: AppColors.themeBlueColor)
                self.thirdTextField.border(width: 1, borderColor: AppColors.themeBlueColor)
                self.fourthTextField.border(width: 1, borderColor: AppColors.themeBlueColor)
                
            } else {
                self.isSubmitButtonEnable = false
            }
        } else {
            self.isSubmitButtonEnable = false
        }
    }
    
    //MARK:- Make Params for Send-Resend OTP Service Hit
    //==================================================
    func sendResendOtpForChangeNumber(_ sender: UIButton) {
        
        var params = JSONDictionary()
        
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        
        if sender === self.submitButton {
            params["otp"]           = self.otp
            params["method"]        = StringConstants.K_Verify_Otp.localized
            self.hitVerifyOtpChangeNumber(params: params)
        } else {
            params["phone_no"]      = self.phoneNumber
            params["country_code"]  = "+91"
            params["method"]        = StringConstants.K_Resend_Otp.localized
            self.resendOtp(params: params)
        }
        
    }
    
    func hitVerifyOtpChangeNumber(params: JSONDictionary) {
        
        WebServices.verifyOtpForChangeNumber(parameters: params, success: { [weak self] (isSuccess) in

            guard isSuccess,
                let strongSelf = self,
                strongSelf.popToController(SettingsVC.self, animated: true) else {
                    return
            }
            AppDelegate.shared.currentuser.phone_no = strongSelf.phoneNumber ?? AppDelegate.shared.currentuser.phone_no
            let userDataDict = UserDetails.convertModelintoDictionary(user: AppDelegate.shared.currentuser)
            UserDetails.updateUserData(dic: userDataDict)

        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        })
        
    }
    
    //MARK:- Make Params for Send-Resend OTP Service Hit
    //==================================================
    func sendResendOtpHit(_ sender: UIButton) {
        
        var params = JSONDictionary()
        
        params["phone_no"]      = self.phoneNumber
        params["country_code"]  = "+91"
        params["method"]        = ""
        
        if sender === self.submitButton {
            params["otp"]           = self.otp
            params["method"]        = StringConstants.K_Verify_Otp.localized
            self.sendOtp(params: params)
        } else {
            params["method"]        = StringConstants.K_Resend_Otp.localized
            self.resendOtp(params: params)
        }
    }
    
    //MARK:- Hit Resend OTP
    //=====================
    func resendOtp(params: JSONDictionary) {
        
        WebServices.reSendOtp(parameters: params, success: { (isSuccess) in
            if isSuccess {
                self.enableTimerHit()
                CommonClass.showToast(msg: "OTP Resend Successfully!!!")
            }
        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
    //MARK:- Hit Send OTP
    //===================
    func sendOtp(params: JSONDictionary) {
        
        WebServices.sendOtp(parameters: params, success: { (isSuccess, obUserDetails, data) in

            if isSuccess {
                
                AppDelegate.shared.currentuser = obUserDetails
                self.obUserDetails = obUserDetails
                self.userData = data
                AppDelegate.shared.setupFirebase()

                if let value = self.userData {
                    UserDetails.saveUserData(dic:value)
                }
//                AppUserDefaults.save(value: self.obUserDetails?.access_token ?? "",
//                                     forKey: AppUserDefaults.Key.Accesstoken)
                
                if self.obUserDetails?.has_interest == true {
                    AppUserDefaults.save(value: true, forKey: AppUserDefaults.Key.isIntesrest)
                    
                    /* MARK: Landing screen
                     let newHomeScreenScene = NewHomeScreenVC.instantiate(fromAppStoryboard: .Login)
                     self.navigationController?.pushViewController(newHomeScreenScene, animated: true)
                     */

                    let chooseBuddyScene = ChooseBuddyVC.instantiate(fromAppStoryboard: .Login)
                    self.navigationController?.pushViewController(chooseBuddyScene, animated: true)

                    AppUserDefaults.save(value: "0", forKey: AppUserDefaults.Key.isThankYou)

                } else {
                    
//                    CommonClass.showToast(msg: "Done!!! OTP has been verified successfully")
                    
                    AppUserDefaults.save(value: false, forKey: AppUserDefaults.Key.isIntesrest)
                    let myProfileSceen = MyProfileVC.instantiate(fromAppStoryboard: .Login)
                    myProfileSceen.obUserDetails = self.obUserDetails
                    myProfileSceen.phoneNumber = self.phoneNumber
                    self.navigationController?.pushViewController(myProfileSceen, animated: true)
                }
            } else {
                CommonClass.showToast(msg: "Incorrect OTP")
            }
        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
}


//MARK: Extension of OneTimePasswordVC : for UITextFieldDelegate
//==============================================================
extension OneTimePasswordVC: UITextFieldDelegate {
    
    //Moving responder to next textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let inputMode = textField.textInputMode else{
            return false
        }
        if inputMode.primaryLanguage == "emoji" || !(inputMode.primaryLanguage != nil) {
            return false
        }
        
        if string == " " {
            return false
        }
        
        if (textField == self.firstTextField)
        {
            if (range.length == 0)
            {
                textField.text = string
                self.secondTextField.becomeFirstResponder()
            }
            else
            {
                textField.text = "\u{200B}"
            }
        }
        else if (textField == self.secondTextField)
        {
            if (range.length == 0)
            {
                textField.text = string
                self.thirdTextField.becomeFirstResponder()
            }
            else
            {
                textField.text = "\u{200B}"
                self.firstTextField.becomeFirstResponder()
            }
        }
            
        else if (textField == self.thirdTextField)
        {
            if (range.length == 0)
            {
                textField.text = string
                self.fourthTextField.becomeFirstResponder()
            }
            else
            {
                textField.text = "\u{200B}"
                self.secondTextField.becomeFirstResponder()
            }
        }
        else if (textField == self.fourthTextField)
        {
            if (range.length == 0)
            {
                textField.text = string
                textField.resignFirstResponder()
            }
            else
            {
                textField.text = "\u{200B}"
                self.thirdTextField.becomeFirstResponder()
            }
        }
        self.textFieldShouldHighLight()
        return false
    }
    
}

