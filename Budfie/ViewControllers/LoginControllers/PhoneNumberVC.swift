//
//  PhoneNumberVC.swift
//
//  Created by yogesh singh negi on 07/11/17.
//  Copyright © 2017 yogesh singh negi. All rights reserved.
//


enum PhoneNumberState {
    case newLogin
    case changeNumber
}

//MARK:- PhoneNumberVC Class
//==========================
class PhoneNumberVC: BaseVc {
    
    //MARK:- Properties
    //=================
    var phoneNumber     = String()
    var confirmNumber   = String()
    var modelFacebook   : FacebookModel?
    var modelGoogle     : GoogleUser?
    var vcState         : PhoneNumberState = .newLogin
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView       : CurvedNavigationView!
    @IBOutlet weak var navigationTitle      : UILabel!
    @IBOutlet weak var backBtnName          : UIButton!
    @IBOutlet weak var topNavBar            : UIView!
    @IBOutlet weak var phoneImage           : UIImageView!
    @IBOutlet weak var countryTextField     : UITextField!
//    @IBOutlet weak var countryArrowImage    : UIImageView!
    @IBOutlet weak var countryBottomView    : UIView!
    @IBOutlet weak var phoneNumberTextField : UITextField!
    @IBOutlet weak var phoneBottomView      : UIView!
    @IBOutlet weak var submitBtnName        : UIButton!
    @IBOutlet weak var confirmCodeBottom    : UIView!
    @IBOutlet weak var confirmCode          : UITextField!
    @IBOutlet weak var confirmNumberTextField: UITextField!
    @IBOutlet weak var confirmNumberBottom: UIView!
    
    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpInitialViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
    }
    
    //MARK:- @IBActions
    //=================
    
    //MARK:- Submit Button
    //====================
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        
        if vcState == .newLogin {
            submitForNewLogin()
        } else {
            submitForChangeNumber()
        }
    }
    
    //MARK:- Back Button
    //==================
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Fetch Country Code Button
    //================================
    @objc func fetchCountryCodeButton(_ sender: UITextField) {
        
        self.view.endEditing(true)
        let countryCode = CountryCodeVC.instantiate(fromAppStoryboard: .Login)
        countryCode.delegate = self
        self.navigationController?.pushViewController(countryCode, animated: true)
    }
    
    //MARK:- Storing Phone Details
    //============================
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        
        if sender === self.phoneNumberTextField {
            self.phoneNumber = sender.text ?? ""
        } else if sender == self.confirmNumberTextField {
            confirmNumber = sender.text ?? ""
        }
    }
    
}


//MARK: Extension: for Registering Nibs and Setting Up SubViews
//=============================================================
extension PhoneNumberVC {
    
    //MARK:- Set Up SubViews method
    //=============================
    fileprivate func setUpInitialViews() {
        
        self.navigationView.backgroundColor = UIColor.clear
        self.topNavBar.backgroundColor = AppColors.themeBlueColor
        
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        
        self.backBtnName.setImage(AppImages.phonenumberBackicon, for: .normal)
        
        self.phoneImage.image = AppImages.phonenumberOtp
//        self.countryArrowImage.isHidden = true
//        self.countryArrowImage.image = AppImages.phonenumberRight
        
//        self.phoneImage.dropBottomShadow(shadow: AppColors.shadowViewColor)
        
        self.countryTextField.font = AppFonts.Comfortaa_Regular_0.withSize(13.6)
        self.countryTextField.text = StringConstants.India_Code.localized
        self.countryTextField.textColor = AppColors.blackColor
        
        self.phoneNumberTextField.font = AppFonts.Comfortaa_Regular_0.withSize(13.6)
        self.phoneNumberTextField.textColor = AppColors.blackColor
        self.phoneNumberTextField.delegate = self
        
        self.confirmCode.font = AppFonts.Comfortaa_Regular_0.withSize(13.6)
        self.confirmCode.text = StringConstants.India_Code.localized
        self.confirmCode.textColor = AppColors.blackColor
        
        self.confirmNumberTextField.font = AppFonts.Comfortaa_Regular_0.withSize(13.6)
        self.confirmNumberTextField.textColor = AppColors.blackColor
        self.confirmNumberTextField.delegate = self

        
        self.countryBottomView.backgroundColor = AppColors.textFieldBaseLine
        self.phoneBottomView.backgroundColor = AppColors.textFieldBaseLine
        
        self.confirmCodeBottom.backgroundColor = AppColors.textFieldBaseLine
        self.confirmNumberBottom.backgroundColor = AppColors.textFieldBaseLine
        
        self.submitBtnName.titleLabel?.textColor = AppColors.themeBlueColor
        self.submitBtnName.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(14.7)
        self.submitBtnName.roundCommonButtonPositive(title: "GENERATE OTP")
        
        self.countryTextField.isUserInteractionEnabled = false
        self.phoneNumberTextField.keyboardType = .numberPad
        self.phoneNumberTextField.addTarget(self,
                                            action: #selector(textFieldEditingChanged(_ :)),
                                            for: .editingChanged)
        
        self.confirmCode.isUserInteractionEnabled = false
        self.confirmNumberTextField.keyboardType = .numberPad
        self.confirmNumberTextField.addTarget(self,
                                            action: #selector(textFieldEditingChanged(_ :)),
                                            for: .editingChanged)
        
        if vcState == .newLogin {
            settingForNewLogin()
        } else {
            settingForChangePhone()
        }
        
    }
    
    func settingForNewLogin() {
        
        self.phoneNumberTextField.placeholder = StringConstants.Your_Phone_Number.localized
        self.navigationTitle.text = StringConstants.Phone_Number.localized

        confirmCode.isHidden = true
        confirmCodeBottom.isHidden = true
        confirmNumberBottom.isHidden = true
        confirmNumberTextField.isHidden = true
    }
    
    func settingForChangePhone() {
        
        self.phoneNumberTextField.placeholder = StringConstants.Enter_Current_Number.localized
        self.phoneNumberTextField.text = AppDelegate.shared.currentuser.phone_no
        self.phoneNumberTextField.isUserInteractionEnabled = false
        self.phoneNumberTextField.textColor = AppColors.popUpBackground
        self.countryTextField.textColor = AppColors.popUpBackground
        self.confirmNumberTextField.placeholder = StringConstants.Enter_New_Number.localized
        self.navigationTitle.text = StringConstants.Change_Number.localized
        
        confirmCode.isHidden = false
        confirmCodeBottom.isHidden = false
        confirmNumberBottom.isHidden = false
        confirmNumberTextField.isHidden = false
    }
    
    func submitForNewLogin() {
        
        if !self.phoneNumber.isEmpty {
            
            if !Validation.validatePhoneNo(self.phoneNumber) {
                CommonClass.showToast(msg: StringConstants.Enter_Valid_Phone.localized)
            } else {
                self.loginWithOTP()
            }
        } else {
            CommonClass.showToast(msg: StringConstants.Enter_Mobile.localized)
        }
        
    }
    
    func submitForChangeNumber() {
        
        /*
        if !self.phoneNumber.isEmpty {
            if !Validation.validatePhoneNo(self.phoneNumber) {
                CommonClass.showToast(msg: "Please enter valid current number")
            } else {
         */
                if !self.confirmNumber.isEmpty {
                    if !Validation.validatePhoneNo(self.confirmNumber) {
                        CommonClass.showToast(msg: "Please enter valid new number")
                    } else {
                        if self.confirmNumber == AppDelegate.shared.currentuser.phone_no {
                            CommonClass.showToast(msg: "Current number and new number cannot be same")
                        } else {
                            self.hitChangeNumber()
                        }
                    }
                } else {
                    CommonClass.showToast(msg: "Enter your new number")
                }
        /*
            }
        } else {
            CommonClass.showToast(msg: "Enter your current number")
        }
         */
    }
    
    //MARK:- Hit Change Number Service
    //================================
    func hitChangeNumber() {
        
        var params  = JSONDictionary()
        params["access_token"]  = AppDelegate.shared.currentuser.access_token//AppUserDefaults.value(forKey: AppUserDefaults.Key.Accesstoken)
        params["method"]        = StringConstants.K_Change_Number_Method.localized
        params["country_code"]  = StringConstants.India_Code.localized
        params["phone_no"]      = self.confirmNumber
        
        WebServices.changeNumber(parameters: params, success: { (isSuccess)  in
            
            if isSuccess {
                let otpSceen = OneTimePasswordVC.instantiate(fromAppStoryboard: .Login)
                otpSceen.vcState = self.vcState
                otpSceen.phoneNumber = self.confirmNumber
                self.navigationController?.pushViewController(otpSceen, animated: true)
            }
        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
    //MARK:- Make Params
    //==================
    func makeParams() -> JSONDictionary {
        
        var params = JSONDictionary()
        
        params["device_token"]  = deviceToken
        params["device_type"]   = DeviceType.iPhone.rawValue
        params["method"]        = StringConstants.K_Login.localized
        params["country_code"]  = StringConstants.India_Code.localized
        params["phone_no"]      = self.phoneNumber
        
        if let modelFacebook = self.modelFacebook {
            
            params["social_type"]   = LoginType.Facebook.rawValue
            params["social_id"]     = modelFacebook.id
            params["email"]         = modelFacebook.email
            params["image"]         = modelFacebook.picture
            params["first_name"]    = "\(modelFacebook.first_name) \(modelFacebook.last_name)"
            params["last_name"]     = ""
            
        } else if let modelGoogle = self.modelGoogle {
            
            params["social_type"]   = LoginType.Google.rawValue
            params["social_id"]     = modelGoogle.id
            params["email"]         = modelGoogle.email
            params["image"]         = modelGoogle.image
            params["first_name"]    = modelGoogle.name
            params["last_name"]     = ""
//            let strSplitArray = modelGoogle.name.split(separator: " ")
//            params["first_name"]    = strSplitArray.first ?? ""
//            params["last_name"]     = strSplitArray.last ?? ""
            
        } else {
            params["social_type"]   = LoginType.Budfie.rawValue
        }
        return params
    }
    
    //MARK:- Hit Login Service
    //========================
    func loginWithOTP() {
        
        var params  = JSONDictionary()
        params      = self.makeParams()
        
        WebServices.logInAPI(parameters: params, success: { (isSuccess, obUserDetails,data)  in
            
            if isSuccess {
                
                AppDelegate.shared.currentuser = obUserDetails
                let otpSceen = OneTimePasswordVC.instantiate(fromAppStoryboard: .Login)
                otpSceen.obUserDetails = obUserDetails
                otpSceen.phoneNumber = self.phoneNumber
                otpSceen.userData = data
                self.navigationController?.pushViewController(otpSceen, animated: true)
            }
        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
}


//MARK: Extension: for SetContryCodeDelegate
//==========================================
extension PhoneNumberVC: SetContryCodeDelegate{
    
    func setCountryCode(country_info: JSONDictionary) {
        
        if let countryName = country_info[StringConstants.Country_English_Name.localized],
            let countryCodeData = country_info[StringConstants.CountryCode.localized] {
            
            self.countryTextField.text = "\(countryName)(+\(countryCodeData))"
        }
    }
    
}


//MARK: Extension: for UITextFieldDelegate
//========================================
extension PhoneNumberVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        if string == " " {
            return false
        }
        let newLength = text.count + string.count - range.length
        return newLength <= 10
    }
    
}









