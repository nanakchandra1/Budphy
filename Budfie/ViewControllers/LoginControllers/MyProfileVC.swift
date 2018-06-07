//
//  MyProfileVC.swift
//  Budfie
//
//  Created by yogesh singh negi on 02/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import GoogleMaps
import GooglePlaces
import GooglePlacePicker

//MARK:- Gender Enum
//==================
enum GenderMF: String {
    case Male   = "1"
    case Female = "2"
    case Custom = "3"
}

//MARK:- MyProfileVC Class
//========================
class MyProfileVC: BaseVc {
    
    //MARK:- Properties
    //=================
    var facbookOn           :Bool = false
    var googleOn            :Bool = false
    var obUserDetails       : UserDetails?
    var interestListModel   : [InterestListModel]?
    var selectedInterestModel: [SubCategoryModel]?
    var selectedCricketLeagueId = [String]()
    var selectedFootballLeagueId = [String]()
    //var gender              : GenderMF = .Male
    var phoneNumber         : String?
    var dob                 : String?
    fileprivate var hasImageUploaded = true {
        didSet {
            if hasImageUploaded {
                CommonClass.showToast(msg: "Profile pic has been uploaded")
            }
        }
    }
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var statusBar                : UIView!
    @IBOutlet weak var navigationView           : CurvedNavigationView!
    @IBOutlet weak var navigationTitle          : UILabel!
    @IBOutlet weak var profileImageBtn          : UIButton!
    @IBOutlet weak var profileImage             : UIImageView!
    @IBOutlet weak var shadowView               : UIView!
    @IBOutlet weak var profileNameTextField     : UITextField!
    @IBOutlet weak var profileContactNumberLabel: UILabel!
    @IBOutlet weak var bottomSaperatorView      : UIView!
    @IBOutlet weak var profileDobTextField      : UITextField!
    @IBOutlet weak var fetchYourEventsLabel     : UILabel!
    @IBOutlet weak var facebookLabel            : UILabel!
    @IBOutlet weak var googleLabel              : UILabel!
    @IBOutlet weak var submitButton             : UIButton!
    @IBOutlet weak var facebookButton           : UIButton!
    @IBOutlet weak var googleButton             : UIButton!
    @IBOutlet weak var maleFemaleBackgroundImage: UIImageView!
    @IBOutlet weak var locationTextField        : UITextField!
    @IBOutlet weak var locationImageView        : UIImageView!

    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Interest List
        self.obUserDetails = AppDelegate.shared.currentuser
        self.initialSetup()
        self.hitInterestList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.profileImage.roundCorners()
    }
    
    //MARK:- @IBActions
    //=================
    @IBAction func cameraButton(_ sender: UIButton) {
        
        //let obProfilePicVC = ProfilePicVC.instantiate(fromAppStoryboard: .Login)
        //obProfilePicVC.delegate = self
        //self.navigationController?.pushViewController(obProfilePicVC, animated: true)

        AppImagePicker.showImagePicker(delegateVC: self, whatToCapture: .image)
    }
    
    @IBAction func faceBookButtonTap(_ sender: UIButton) {
        #if DEBUG
        self.facbookOn = !self.facbookOn
        self.faceBookGoogleMethod(isFaceBookSelected: true)
        #else
        CommonClass.showToast(msg: "Under Development")
        #endif
    }
    
    @IBAction func googleButtonTap(_ sender: UIButton) {
        self.googleOn = !self.googleOn
        self.faceBookGoogleMethod(isFaceBookSelected: false)
    }

    @IBAction func submitButtonTap(_ sender: UIButton) {
        
        if !self.checkForEmpty() && hasImageUploaded {
            return
        }
        self.hitProfileUpdate()
    }
    /*
    @objc func getDOBDate(_ notification: Notification) {
        
        self.navigationController?.popToViewController(self, animated: true)

        if let userInfo = notification.userInfo, let dob = userInfo["birthDate"] as? Date {
            
            let dobForView = dob.toString(dateFormat: DateFormat.dOBAppFormat.rawValue)
            let dateInStr = dob.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
            
            self.profileDobTextField.text = dobForView
            self.dob = dateInStr
        }
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.DidChooseDate,
                                                  object: nil)
    }
 */
    
}

//MARK: Extension: for Setting Up SubViews
//========================================
extension MyProfileVC {
    
    //MARK:- initialSetup method
    //==========================
    private func initialSetup(){
        
        self.navigationView.backgroundColor = UIColor.clear
        self.statusBar.backgroundColor      = AppColors.themeBlueColor
        self.navigationTitle.text           = StringConstants.My_Profile.localized
        self.navigationTitle.textColor      = AppColors.whiteColor
        self.navigationTitle.font           = AppFonts.AvenirNext_Medium.withSize(20)
        
        self.profileImageBtn.setImage(AppImages.profileCameraWhite, for: .normal)
        //self.profileImage.isHidden             = true
        //self.maleFemaleBackgroundImage.image = (gender == .Male) ? AppImages.ic_myprofile_male : AppImages.ic_myprofile_female

        self.shadowView.roundCornerWith(radius: 5)
        self.shadowView.dropShadow(width: 5, shadow: AppColors.shadowViewColor)
        
        self.profileNameTextField.placeholder   = StringConstants.Enter_Name.localized
        self.profileNameTextField.textColor     = AppColors.blackColor
        self.profileNameTextField.font          = AppFonts.Comfortaa_Bold_0.withSize(18.1)
        
        self.profileDobTextField.placeholder    = StringConstants.Enter_DOB.localized
        self.profileDobTextField.textColor      = AppColors.textFieldBaseLine
        self.profileDobTextField.font           = AppFonts.Comfortaa_Regular_0.withSize(12.5)
//        self.profileDobTextField.delegate       = self
        self.settingDatePicker()
        
        self.profileContactNumberLabel.textColor    = AppColors.textFieldBaseLine
        self.profileContactNumberLabel.font         = AppFonts.Comfortaa_Regular_0.withSize(12.5)
        
        self.locationTextField.placeholder      = "Location*"
        self.locationTextField.textColor        = AppColors.blackColor
        self.locationTextField.font             = AppFonts.Comfortaa_Bold_0.withSize(15.1)
        self.locationTextField.delegate         = self
        
        self.fetchYourEventsLabel.text              = StringConstants.Fetch_Your_Events_Via.localized
        self.fetchYourEventsLabel.textColor         = AppColors.themeBlueColor
        self.fetchYourEventsLabel.font              = AppFonts.Comfortaa_Bold_0.withSize(13)
        
        self.facebookLabel.text                     = StringConstants.Facebook.localized
        self.facebookLabel.textColor                = AppColors.blackColor
        self.facebookLabel.font                     = AppFonts.Comfortaa_Light_0.withSize(12.5)
        
        self.googleLabel.text                       = StringConstants.Google.localized
        self.googleLabel.textColor                  = AppColors.blackColor
        self.googleLabel.font                       = AppFonts.Comfortaa_Light_0.withSize(12.5)
        
        self.submitButton.titleLabel?.font          = AppFonts.MyriadPro_Regular.withSize(14.7)
        self.submitButton.titleLabel?.textColor     = AppColors.themeBlueColor
        self.submitButton.roundCommonButtonPositive(title: StringConstants.NEXT.localized)
        
        self.bottomSaperatorView.backgroundColor    = AppColors.textFieldBaseLine
        self.facebookButton.setImage(AppImages.icToggleOff, for: .normal)
        self.googleButton.setImage(AppImages.icToggleOff, for: .normal)

        let locationTapGesture = UITapGestureRecognizer(target: self, action: #selector(locationTapped))
        locationImageView.addGestureRecognizer(locationTapGesture)

        self.makeName()
        self.facebookGoogleBtn()
        self.makePhone()
        self.setProfilePic()
    }

    @objc private func locationTapped(_ gesture: UITapGestureRecognizer) {
        didSendLocation()
    }

    //MARK:- setProfilePic method
    //===========================
    func setProfilePic() {

        if let imgUrl = URL(string: AppDelegate.shared.currentuser.image ) {
            self.maleFemaleBackgroundImage.sd_addActivityIndicator()
            self.maleFemaleBackgroundImage.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            self.maleFemaleBackgroundImage.sd_setImage(with: imgUrl, completed: { [weak self] (image, error, type, nurl) in

                guard let strongSelf = self, error == nil else {
                    return
                }

                strongSelf.maleFemaleBackgroundImage.image = image
                strongSelf.profileImage.isHidden = true

                let tapGesture = UITapGestureRecognizer(target: strongSelf, action: #selector(strongSelf.profileImageTapped))
                strongSelf.maleFemaleBackgroundImage.isUserInteractionEnabled = true
                strongSelf.maleFemaleBackgroundImage.addGestureRecognizer(tapGesture)
            })
        }
        self.profileImage.setImage(withSDWeb: AppDelegate.shared.currentuser.image, placeholderImage: AppImages.myprofilePlaceholder)
    }

    @objc private func profileImageTapped(_ gesture: UITapGestureRecognizer) {
        guard let imageView = gesture.view as? UIImageView, let image = imageView.image else {
            CommonClass.showToast(msg: "Loading image...")
            return
        }
        let chatImagePreviewScene = ChatImagePreviewVC.instantiate(fromAppStoryboard: .Chat)
        chatImagePreviewScene.image = image
        chatImagePreviewScene.vcType = .profileImage
        chatImagePreviewScene.modalPresentationStyle = .overCurrentContext
        present(chatImagePreviewScene, animated: true, completion: nil)
    }
    
    func checkForEmpty() -> Bool {
        // Check Name for Empty
        if let name = self.profileNameTextField.text, name.isEmpty {
            CommonClass.showToast(msg: "Please enter your name")
            return false
        }
        if let name = self.locationTextField.text, name.isEmpty {
            CommonClass.showToast(msg: "Please enter your location")
            return false
        }
        // Check DOB for Empty
//        if let dob = self.profileDobTextField.text, dob.isEmpty {
//            CommonClass.showToast(msg: "Please enter DOB")
//            return false
//        }
        return true
    }
    
    //MARK:- makeName method
    //======================
    func makeName() {
        
        var fullName = String()
        if let fName = self.obUserDetails?.first_name,
            !fName.isEmpty {
            fullName = fName
        }
        if let lName = self.obUserDetails?.last_name,
            !lName.isEmpty {
            fullName = fullName + " " + lName
        }
        if !fullName.isEmpty {
            self.profileNameTextField.text = fullName
        } else {
            self.profileNameTextField.text = ""
        }
        if let dobDate = self.obUserDetails?.dob, !dobDate.isEmpty {
            let date = dobDate.toDate(dateFormat: DateFormat.dOBServerFormat.rawValue)
            self.profileDobTextField.text = date?.toString(dateFormat: DateFormat.dOBAppFormat.rawValue) ?? ""
        } else {
            self.profileDobTextField.text = ""
        }
        if let location = self.obUserDetails?.location, !location.isEmpty {
            self.locationTextField.text = location
        }
    }
    
    //MARK:- facebookGoogleBtn method
    //===============================
    func facebookGoogleBtn() {
        
        if let socialType = self.obUserDetails?.social_type, socialType == "2" {
            self.faceBookButtonTap(facebookButton)
        } else if let socialType = self.obUserDetails?.social_type, socialType == "3" {
            self.googleButtonTap(googleButton)
        }
    }
    
    //MARK:- makePhone method
    //=======================
    func makePhone() {
        
        if let phone = self.obUserDetails?.phone_no, !phone.isEmpty {
            self.profileContactNumberLabel.text = "+91-" + phone
        } else {
            self.profileContactNumberLabel.text = "+91-\(self.phoneNumber ?? "")"
        }
    }
    
    //MARK:- settingDatePicker method
    //===============================
    func settingDatePicker() {
        
        // DatePicker
        let calendar            = Calendar.autoupdatingCurrent
        var minDateComponent    = calendar.dateComponents([.day,.month,.year], from: Date())
        minDateComponent.day    = 01
        minDateComponent.month  = 1
        minDateComponent.year   = 1960
        let minDate             = calendar.date(from: minDateComponent)
        let maxDate             = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        
        DatePicker.openDatePickerIn(self.profileDobTextField,
                                    outPutFormate: DateFormat.dOBAppFormat.rawValue,
                                    mode: .date,
                                    minimumDate: minDate!,
                                    maximumDate: maxDate!,
                                    selectedDate: Date(),
                                    doneBlock: { (dateStr,date) in
                                        
                                        // Converting String Date to Date Format
                                        self.profileDobTextField.text = dateStr
                                        
                                        let dateInStr = date.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
                                        self.dob = dateInStr
        })
    }
    
    //MARK:- faceBookGoogleMethod method
    //==================================
    func faceBookGoogleMethod(isFaceBookSelected: Bool) {
        
        let controller = EventsPopUpVC.instantiate(fromAppStoryboard: .Events)
        
        if isFaceBookSelected {
            
            if self.facbookOn {
                self.facebookButton.setImage(AppImages.icToggleOn, for: .normal)
                
                controller.socialType = SocialType.FaceBook
                controller.headerText = "\(StringConstants.Would_You_Like_To_Fetch.localized)\n\(StringConstants.Facebook_Events_Now.localized)"
            } else {
                self.facebookButton.setImage(AppImages.icToggleOff, for: .normal)
                AppUserDefaults.save(value: "0", forKey: AppUserDefaults.Key.facebookEvent)
                return
            }
        } else {
            
            if self.googleOn {
                self.googleButton.setImage(AppImages.icToggleOn, for: .normal)
                
                controller.socialType = SocialType.Google
                controller.headerText = "\(StringConstants.Would_You_Like_To_Fetch.localized)\n\(StringConstants.Google_Events_Now.localized)"
            } else {
                self.googleButton.setImage(AppImages.icToggleOff, for: .normal)
//                AppUserDefaults.save(value: "0", forKey: AppUserDefaults.Key.googleEvent)
                EventsCoreDataController.deleteEvents()
                return
            }
        }
        controller.delegate = self
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: false, completion: nil)
    }
    
    //MARK:- hitInterestList method
    //=============================
    func hitInterestList() {
        
        var params = JSONDictionary()
        
        params["method"] = StringConstants.K_Interest_List.localized
        params["access_token"] = AppDelegate.shared.currentuser.access_token//AppDelegate.shared.currentuser.access_token
        
        // Getting Interest List
        WebServices.getInterestList(parameters: params, loader: false, success: { (isSuccess,obInterestListModel, selectedInterestModel) in
            self.interestListModel = obInterestListModel
            self.selectedInterestModel = selectedInterestModel
            self.makeSelectedId()
        }, failure: { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        })
    }
    
    //MARK:- makeParams method
    //========================
    func makeParams() -> JSONDictionary {
        
        var params = JSONDictionary()
        
        params["method"]        = StringConstants.K_Update_Profile.localized
        params["access_token"]  = AppDelegate.shared.currentuser.access_token//AppDelegate.shared.currentuser.access_token
        params["first_name"]    = ""
        params["last_name"]     = ""
        params["image"]         = self.obUserDetails?.image
        
        params["location"]      = self.obUserDetails?.location
        params["latitude"]      = self.obUserDetails?.lat
        params["longitude"]     = self.obUserDetails?.long
        
        params["dob"]           = ""
        params["gender"]        = ""
        
        if let name = self.profileNameTextField.text, !name.isEmpty {
            //            let (fName,lName) = name.parseName()
            //            params["first_name"] = fName
            //            params["last_name"] = lName
            params["first_name"] = name
            self.obUserDetails?.first_name = name
            //            self.obUserDetails?.last_name = lName
        }
        if let dob = self.dob, !dob.isEmpty {
            params["dob"] = dob
            self.obUserDetails?.dob = dob
        }
        //params["gender"] = self.gender.rawValue
        //params["avtar"] = self.gender.rawValue
        return params
    }
    
    //MARK:- hitProfileUpdate method
    //==============================
    func hitProfileUpdate() {
        
        var params = JSONDictionary()
        params = self.makeParams()
        
        // Getting Interest List
        WebServices.updateProfile(parameters: params, success: { (isSuccess) in
            
            if AppUserDefaults.value(forKey: AppUserDefaults.Key.googleEvent) == "0" {
                EventsCoreDataController.deleteEvents()
            }
            
            if isSuccess {
                
                //                CommonClass.showToast(msg: "Your Profile Has Been Updated Successfully")
                let dic = UserDetails.convertModelintoDictionary(user: self.obUserDetails!)
                AppUserDefaults.save(value: dic, forKey: .userData)
                AppDelegate.shared.currentuser = self.obUserDetails
                let obAddInterestsVC = AddInterestsVC.instantiate(fromAppStoryboard: .Login)
                obAddInterestsVC.obInterestListModel = self.interestListModel
                obAddInterestsVC.selectedInterestModel = self.selectedInterestModel
                obAddInterestsVC.selectedCricketLeagueId = self.selectedCricketLeagueId
                obAddInterestsVC.selectedFootballLeagueId = self.selectedFootballLeagueId
                obAddInterestsVC.viewStatus = .createUserProfile
                //                                obAddInterestsVC.obUserDetails = self.obUserDetails
                AddInterestsVC.selectedId.removeAll()
                FirebaseHelper.createUsersNode()
                self.navigationController?.pushViewController(obAddInterestsVC, animated: true)
                
            } else if AppUserDefaults.value(forKey: .isIntesrest).boolValue {
                
                //                CommonClass.showToast(msg: "Failed!!!")
                let dic = UserDetails.convertModelintoDictionary(user: self.obUserDetails!)
                AppUserDefaults.save(value: dic, forKey: .userData)
                let newHomeScreenScene = NewHomeScreenVC.instantiate(fromAppStoryboard: .Login)
                self.navigationController?.pushViewController(newHomeScreenScene, animated: true)
                AppUserDefaults.save(value: "0", forKey: AppUserDefaults.Key.isThankYou)
            }
        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
    func makeSelectedId() {
        
        AddInterestsVC.selectedId.removeAll()
        self.selectedCricketLeagueId.removeAll()
        self.selectedFootballLeagueId.removeAll()

        guard let selectedIds = selectedInterestModel else {
            return
        }

        for subCat in selectedIds {
            AddInterestsVC.selectedId.append(subCat.id)
            for childCat in subCat.childCategory {
                self.selectedCricketLeagueId.append(childCat.id)
            }

            if subCat.id == "1" {
                for childCategory in subCat.childCategory {
                    self.selectedFootballLeagueId.append(childCategory.id)
                }
            }
            if subCat.id == "2" {
                for childCategory in subCat.childCategory {
                    self.selectedFootballLeagueId.append(childCategory.id)
                }
            }
        }
    }
    
    fileprivate func pickLocation() {
        
        var placePicker: GMSPlacePickerViewController?
        
        LocationManager.sharedInstance.autoUpdate = true
        
        LocationManager.sharedInstance.startUpdatingLocationWithCompletionHandler {[weak self] (latitude, longitude, status, verboseMessage, error) -> () in
            
            guard let strongSelf = self else{return}
            
            let center = CLLocationCoordinate2DMake(latitude, longitude)
            
            let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
            
            let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
            
            let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
            
            let config = GMSPlacePickerConfig(viewport: viewport)
            
            placePicker = GMSPlacePickerViewController(config: config)
            
            placePicker?.delegate = self
            
            strongSelf.present(placePicker!, animated: true, completion: nil)
            
            LocationManager.sharedInstance.stopUpdatingLocation()
        }
    }
    
    func didSendLocation() {
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .authorizedWhenInUse {
            self.pickLocation()
        }
        else if status == .denied || status == .restricted {
            if let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(settingsUrl)
            }
        } else if status == .notDetermined {
            self.pickLocation()
        }
    }
    
}


//MARK:- Google Autocomplete Delegate Extension
//=============================================
extension MyProfileVC : GMSPlacePickerViewControllerDelegate {
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        
        self.obUserDetails?.long = "\(place.coordinate.longitude)"
        self.obUserDetails?.lat = "\(place.coordinate.latitude)"
        self.obUserDetails?.location = place.name

        CommonClass.getCity(from: place) { [weak self] city in
            guard let strongSelf = self else {
                return
            }
            strongSelf.setCity(city)
        }
        
        viewController.dismiss(animated: true, completion: nil)
    }

    private func setCity(_ city: String) {
        self.obUserDetails?.location = city
        self.locationTextField.text = city
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}


//MARK: Extension: for Setting Up SubViews
//========================================
extension MyProfileVC: EventsPopUpVCDelegate {
    
    func getResponse(isOkBtnTapped: Bool, socialType: SocialType) {
        if isOkBtnTapped {
            // Hit Service according to socialType
            print_debug(socialType)
            if socialType == SocialType.FaceBook {
//                AppUserDefaults.save(value: "1",
//                                     forKey: AppUserDefaults.Key.facebookEvent)
                FacebookController.shared.getFacebookEvents(true, fromViewController: self, completion: { (events, error) in

                    if error != nil {
                        AppUserDefaults.save(value: "0", forKey: AppUserDefaults.Key.facebookEvent)
                        self.facebookButton.setImage(AppImages.icToggleOff, for: .normal)
                    }
                })
            } else {
//                AppUserDefaults.save(value: "1",
//                                     forKey: AppUserDefaults.Key.googleEvent)
                GoogleLoginController.shared.loginWithEventFetch(completion: { (events, error) in

                    if error != nil {
                        AppUserDefaults.save(value: "0", forKey: AppUserDefaults.Key.googleEvent)
                        self.googleButton.setImage(AppImages.icToggleOff, for: .normal)
                    }
                })
            }
        } else {
            if socialType == SocialType.FaceBook {
                self.facbookOn = false
                AppUserDefaults.save(value: "0", forKey: AppUserDefaults.Key.facebookEvent)
                self.facebookButton.setImage(AppImages.icToggleOff, for: .normal)
            } else {
                self.googleOn = false
                AppUserDefaults.save(value: "0", forKey: AppUserDefaults.Key.googleEvent)
                self.googleButton.setImage(AppImages.icToggleOff, for: .normal)
                EventsCoreDataController.deleteEvents()
            }
        }
    }
    
}

/*MARK: Extension: for SetProfilePicDelegate
 //==========================================
 extension MyProfileVC: SetProfilePicDelegate {

 func changeProfilePic(picName: UIImage, gender: GenderMF) {

 if gender == .Custom {
 self.maleFemaleBackgroundImage.image = picName




 } else {
 self.maleFemaleBackgroundImage.image = picName
 }
 self.profileImage.isHidden = true
 //self.gender = gender
 }

 }
 */

// MARK: UIImagePickerController Delegate Methods
extension MyProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {

            self.maleFemaleBackgroundImage.image = pickedImage
            self.profileImage.isHidden = true

            let url = "\(Int(Date().timeIntervalSince1970)).png"
            let imageURL = "\(S3_BASE_URL)\(BUCKET_NAME)/\(BUCKET_DIRECTORY)/\(url)"

            self.obUserDetails?.image = imageURL
            hasImageUploaded = false

            pickedImage.uploadImageToS3(imageurl: url,success: { [weak self] (success, url) in

                guard let strongSelf = self else {
                    return
                }

                print_debug(url)
                strongSelf.hasImageUploaded = true
                strongSelf.obUserDetails?.image = url

                }, progress: { (status) in
                    print_debug(status)

            }, failure: { [weak self] (error) in

                guard let strongSelf = self else {
                    return
                }

                strongSelf.hasImageUploaded = true
                CommonClass.showToast(msg: error.localizedDescription)
            })

        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

/*
//MARK: Extension: for UITextFieldDelegate
//========================================
extension MyProfileVC: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.getDOBDate),
                                               name: Notification.Name.DidChooseDate,
                                               object: nil)
        let scene = HolidayPlannerVC.instantiate(fromAppStoryboard: .HolidayPlanner)
        scene.vcType = .birthDate
        self.navigationController?.pushViewController(scene, animated: true)
        
        return false
    }

}
 */

//MARK: Extension: for UITextFieldDelegate
//========================================
extension MyProfileVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.didSendLocation()
        return false
    }
}



