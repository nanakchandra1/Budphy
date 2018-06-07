//
//  MyProfileVC.swift
//  Budfie
//
//  Created by Appinventiv Technologies on 02/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit

enum GenderMF: String {
    case Male = "1"
    case Female = "2"
}

//MARK:- ViewController Class
//===========================
class MyProfileVC: BaseVc {
    
    
    //MARK:- Properties
    //=================
    var facbookOn = true
    var googleOn = true
    var obUserDetails: UserDetails?
    var interestListModel: [InterestListModel]?
    var gender: GenderMF?
    var dob: String?
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var profileContactNumberLabel: UILabel!
    @IBOutlet weak var bottomSaperatorView: UIView!
    @IBOutlet weak var profileDobTextField: UITextField!
    @IBOutlet weak var fetchYourEventsLabel: UILabel!
    @IBOutlet weak var facebookLabel: UILabel!
    @IBOutlet weak var googleLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var maleFemaleBackgroundImage: UIImageView!
    
    
    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
        // Get Interest List
        self.hitInterestList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- @IBActions
    //=================
    @IBAction func cameraButton(_ sender: UIButton) {
        
        let obProfilePicVC = ProfilePicVC.instantiate(fromAppStoryboard: .Login)
        obProfilePicVC.delegate = self
        self.navigationController?.pushViewController(obProfilePicVC, animated: true)
    }
    
    @IBAction func faceBookButtonTap() {
        
        self.faceBookGoogleMethod(isFaceBookSelected: true)
    }
    
    @IBAction func googleButtonTap() {
        
        self.faceBookGoogleMethod(isFaceBookSelected: false)
    }
    
    
    @IBAction func submitButtonTap(_ sender: UIButton) {
        
        self.hitProfileUpdate()
    }
}





//MARK: Extension: for Setting Up SubViews
//========================================
extension MyProfileVC {
    
    
    //MARK:- initialSetup method
    //==========================
    private func initialSetup(){
        
        self.navigationView.backgroundColor = AppColors.themeBlueColor
        self.navigationView.curvView()
        self.navigationTitle.text = StringConstants.My_Profile.localized
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(16)
        
        self.profileImageBtn.setImage(AppImages.profileCameraWhite, for: .normal)
        self.profileImage.image = AppImages.myprofilePlaceholder
        
        self.shadowView.roundCornerWith(radius: 5)
        self.shadowView.dropShadow(width: 5, shadow: AppColors.shadowViewColor)
        
        self.profileNameTextField.placeholder = StringConstants.Enter_Name.localized
        self.profileNameTextField.text = "\(self.obUserDetails?.first_name ?? "") \(self.obUserDetails?.last_name ?? "")"
        self.profileNameTextField.textColor = AppColors.blackColor
        self.profileNameTextField.font = AppFonts.Comfortaa_Bold_0.withSize(18.1)
        
        self.profileDobTextField.placeholder = StringConstants.Enter_DOB.localized
        self.profileDobTextField.textColor = AppColors.textFieldBaseLine
        self.profileDobTextField.font = AppFonts.Comfortaa_Regular_0.withSize(12.5)
        self.settingDatePicker()
        
        self.profileContactNumberLabel.text = "\(self.obUserDetails?.country_code ?? "")-\(self.obUserDetails?.phone_no ?? "")"
        self.profileContactNumberLabel.textColor = AppColors.textFieldBaseLine
        self.profileContactNumberLabel.font = AppFonts.Comfortaa_Regular_0.withSize(12.5)
        
        self.fetchYourEventsLabel.text = StringConstants.Fetch_Your_Events_Via.localized
        self.fetchYourEventsLabel.textColor = AppColors.themeBlueColor
        self.fetchYourEventsLabel.font = AppFonts.Comfortaa_Bold_0.withSize(12.5)
        
        self.facebookLabel.text = StringConstants.Facebook.localized
        self.facebookLabel.textColor = AppColors.blackColor
        self.facebookLabel.font = AppFonts.Comfortaa_Light_0.withSize(11.3)
        
        self.googleLabel.text = StringConstants.Google.localized
        self.googleLabel.textColor = AppColors.blackColor
        self.googleLabel.font = AppFonts.Comfortaa_Light_0.withSize(11.3)
        
        self.submitButton.titleLabel?.font = AppFonts.MyriadPro_Regular.withSize(14.7)
        self.submitButton.titleLabel?.textColor = AppColors.themeBlueColor
        self.submitButton.roundCommonButton(title: StringConstants.NEXT.localized)
        
        self.bottomSaperatorView.backgroundColor = AppColors.textFieldBaseLine
        self.facebookButton.setImage(AppImages.icToggleOff, for: .normal)
        self.googleButton.setImage(AppImages.icToggleOff, for: .normal)
        
        if let socialType = self.obUserDetails?.social_type, socialType == "2" {
            self.faceBookButtonTap()
        } else if let socialType = self.obUserDetails?.social_type, socialType == "3" {
            self.googleButtonTap()
        }
    }
    
    
    //MARK:- settingDatePicker method
    //===============================
    func settingDatePicker() {
        
        // DatePicker
        let calendar = Calendar.autoupdatingCurrent
        var minDateComponent = calendar.dateComponents([.day,.month,.year], from: Date())
        minDateComponent.day = 01
        minDateComponent.month = 1
        minDateComponent.year = 1900
        let minDate = calendar.date(from: minDateComponent)
        let maxDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        
        DatePicker.openDatePickerIn(self.profileDobTextField,
                                    outPutFormate: DateFormat.dOBAppFormat.rawValue,
                                    mode: .date,
                                    minimumDate: minDate!,
                                    maximumDate: maxDate!,
                                    selectedDate: Date(),
                                    doneBlock: { (dateStr) in
                                        
                                        // Converting String Date to Date Format
                                        self.profileDobTextField.text = dateStr
                                        self.dob = dateStr
        })
    }
    
    
    //MARK:- faceBookGoogleMethod method
    //==================================
    func faceBookGoogleMethod(isFaceBookSelected: Bool) {
        
        let controller = EventsPopUpVC.instantiate(fromAppStoryboard: .Events)
        
        if isFaceBookSelected {
            self.facbookOn = !self.facbookOn
            
            if !self.facbookOn {
                self.facebookButton.setImage(AppImages.icToggleOn, for: .normal)
                
                controller.socialType = SocialType.FaceBook
                controller.headerText = "\(StringConstants.Would_You_Like_To_Fetch.localized)\n\(StringConstants.Facebook_Events_Now.localized)"
            } else {
                self.facebookButton.setImage(AppImages.icToggleOff, for: .normal)
                return
            }
        } else {
            self.googleOn = !self.googleOn
            
            if !self.googleOn {
                self.googleButton.setImage(AppImages.icToggleOn, for: .normal)
                
                controller.socialType = SocialType.Google
                controller.headerText = "\(StringConstants.Would_You_Like_To_Fetch.localized)\n\(StringConstants.Google_Events_Now.localized)"
            } else {
                self.googleButton.setImage(AppImages.icToggleOff, for: .normal)
                return
            }
        }
        controller.delegate = self
        self.addChildViewController(controller)
        self.view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
    
    
    //MARK:- hitInterestList method
    //=============================
    func hitInterestList() {
        
        var params = JSONDictionary()
        
        params["method"] = StringConstants.K_Interest_List.localized
        params["access_token"] = self.obUserDetails?.access_token
        
        // Getting Interest List
        WebServices.getInterestList(parameters: params, loader: false, success: { (obInterestListModel) in
            
            self.interestListModel = obInterestListModel
        }, failure: { (err) in
            self.showAlert(msg: err as! String)
        })
    }
    
    
    //MARK:- hitProfileUpdate method
    //==============================
    func hitProfileUpdate() {
        
        var params = JSONDictionary()
        
        params["method"] = StringConstants.K_Update_Profile.localized
        params["access_token"] = self.obUserDetails?.access_token
        params["first_name"] = ""
        params["last_name"] = ""
        params["image"] = ""
        params["dob"] = ""
        params["gender"] = ""
        
        if let name = self.profileNameTextField.text, !name.isEmpty {
            let strSplitArray = name.split(separator: " ")
            params["first_name"] = strSplitArray.first ?? ""
            params["last_name"] = strSplitArray.last ?? ""
        }
        if let dob = self.dob, !dob.isEmpty {
            params["dob"] = dob
        }
        if let gen = self.gender {
            params["gender"] = gen.rawValue
        }
        //Temp URL
        params["image"] = "http://budfiedev.applaurels.com/dist/index.html#/Update_profile/index_post6"
        
        // Getting Interest List
        WebServices.updateProfile(parameters: params, success: { (isSuccess) in
            if isSuccess {
                self.showAlert(title: "Profile Updated!!!",
                               msg: "Your Profile Has Been Updated Successfully",
                               {
                                AppUserDefaults.save(value: self.obUserDetails?.access_token ?? "", forKey: .Accesstoken)
                                
                                let obAddInterestsVC = AddInterestsVC.instantiate(fromAppStoryboard: .Login)
                                obAddInterestsVC.obInterestListModel = self.interestListModel
//                                obAddInterestsVC.obUserDetails = self.obUserDetails
                                self.navigationController?.pushViewController(obAddInterestsVC, animated: true)
                })
            } else {
                self.showAlert(msg: "Failed!!!")
            }
        }, failure: { (error) in
            self.showAlert(msg: error as! String)
        })
        
    }
}




//MARK: Extension: for Setting Up SubViews
//========================================
extension MyProfileVC: EventsPopUpVCDelegate {
    
    func getResponse(isOkBtnTapped: Bool, socialType: SocialType) {
        if isOkBtnTapped {
            // Hit Service according to socialType
            print_debug(socialType)
        } else {
            if socialType == SocialType.FaceBook {
                self.facebookButton.setImage(AppImages.icToggleOff, for: .normal)
            } else {
                self.googleButton.setImage(AppImages.icToggleOff, for: .normal)
            }
        }
    }
    
}



extension MyProfileVC: SetProfilePicDelegate {
    
    func changeProfilePic(picName: UIImage, gender: GenderMF) {
        self.maleFemaleBackgroundImage.image = picName
        self.profileImage.isHidden = true
        self.gender = gender
    }
    
}



