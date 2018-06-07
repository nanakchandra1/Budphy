//
//  EditProfileVC.swift
//  Budfie
//
//  Created by Aishwarya Rastogi on 20/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import ParallaxHeader
import SwiftyJSON
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class EditProfileVC: BaseVc {
    
    var obProfileDataModel: ProfileDataModel?
    var interestListModel: [InterestListModel]?
    var profilePic: UIImage?
    static var selectedId = [String]()
    var selectedCricketId = [String]()
    var selectedFootballId = [String]()
    var textBaseColor = false
    var state: State = .exploreMore
    var name = String()
    var headerView: AddEventHeaderView!
    weak var delegate: DoRefreshOnPop?

    fileprivate var hasImageUploaded = true {
        didSet {
            if hasImageUploaded {
                CommonClass.showToast(msg: "Profile pic has been uploaded")
            }
        }
    }

    @IBOutlet weak var editProfileTableView: UITableView!
    @IBOutlet weak var navBackgroundView: UIView!
//    @IBOutlet weak var navCameraBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerNibs()
        self.initialSetUp()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.valueChangedOfEditProfile(_:)),
                                               name: Notification.Name.ValueChangedOfEditProfile,
                                               object: nil)

        if #available(iOS 11.0, *) {
//            editProfileTableView.contentInsetAdjustmentBehavior = .never
//            editProfileTableView.insetsContentViewsToSafeArea = false
//            editProfileTableView.insetsLayoutMarginsFromSafeArea = false
            editProfileTableView.contentInset = UIEdgeInsetsMake(-view.safeAreaInsets.top, 0, 0, 0)
        }

        if let headerView = editProfileTableView.dequeueReusableHeaderFooterView(withIdentifier: "AddEventHeaderViewId") as? AddEventHeaderView {

            let headerHeight: CGFloat = 320
            let navViewHeight: CGFloat = 44
            headerView.setForEditProfile()
            self.headerView = headerView
            setProfileImage()

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventsImageTapped))
            tapGesture.cancelsTouchesInView = false
            headerView.eventsImage.addGestureRecognizer(tapGesture)

            /*
            headerView.eventsImage.curvHeaderView(height: headerHeight)
            headerView.overlayView.curvHeaderView(height: 320)
            headerView.backBtn.addTarget(self, action: #selector(self.backBtnTapped(_:)), for: .touchUpInside)
            headerView.submitImageBtn.addTarget(self,
                                                action: #selector(cameraBtnTapped(_ :)),
                                                for: .touchUpInside)
            */

            editProfileTableView.parallaxHeader.view = headerView
            editProfileTableView.parallaxHeader.height = headerHeight
            editProfileTableView.parallaxHeader.minimumHeight = navViewHeight
            editProfileTableView.parallaxHeader.mode = .centerFill
            navBackgroundView.backgroundColor = AppColors.themeBlueColor.withAlphaComponent(0)

            editProfileTableView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in

                let progress = parallaxHeader.progress

                let alpaComponent = max(0, min(1, ((1 - (progress)) / 0.95)))
                self.navBackgroundView.backgroundColor = AppColors.themeBlueColor.withAlphaComponent(alpaComponent)
                //headerView.overlayView.setNeedsDisplay()
                //self.updateHeaderConstraint()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.editProfileTableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.ValueChangedOfEditProfile,
                                                  object: nil)
    }
    
    //MARK:- @IBActions
    //=================
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func fetchName(_ sender: UITextField) {
        
        guard let cell = sender.getTableViewCell as? TextFieldCell else {
            return
        }
        if let text = cell.customTextField.text {
            self.name = text
            self.obProfileDataModel?.first_name = text
        }
    }

    func setProfileImage() {
        
        if let profileimage = profilePic {
            headerView.eventsImage.image = profileimage
            headerView.cameraImageBtn.isHidden = true
//            navCameraBtn.isHidden = true
        } else if let img = obProfileDataModel?.image {
            headerView.eventsImage.setImage(withSDWeb: img, placeholderImage: AppImages.myprofilePlaceholder)
            headerView.cameraImageBtn.isHidden = true
//            navCameraBtn.isHidden = true
        } else {
            headerView.cameraImageBtn.isHidden = false
//            navCameraBtn.isHidden = true
        }
    }

    //MARK:- submitBtnTapped Button
    //============================
    @objc func submitBtnTapped(_ sender: UIButton) {

        guard hasImageUploaded else {
            CommonClass.showToast(msg: "Please wait, uploading your profile pic")
            return
        }

        // Check Name for Empty
        self.view.endEditing(true)
        self.setName()
        if let fName = self.obProfileDataModel?.first_name, fName.isEmpty {
            CommonClass.showToast(msg: "Please enter your name")
            return
        }
        if let fName = self.obProfileDataModel?.location, fName.isEmpty {
            CommonClass.showToast(msg: "Please enter your location")
            return
        }
        if EditProfileVC.selectedId.isEmpty {
            CommonClass.showToast(msg: "Please select atlease one interest")
            return
        }
        self.hitProfileUpdate()
    }

    @objc private func eventsImageTapped(_ sender: UITapGestureRecognizer) {

        if let cell = editProfileTableView.headerView(forSection: 0) as? TableTopCurveHeaderFooterView {

            let location = sender.location(in: cell)
            let modifiedLocation = CGPoint(x: location.x, y: -location.y)

            if cell.shareBtn.frame.contains(modifiedLocation) {
                cameraBtnTapped(cell.shareBtn)
            }
            /* else if cell.frame.contains(modifiedLocation) {
             return

             } else if let imageView = sender.view as? UIImageView,
             let urlString = data?.response.result.user_detail.user_cover_pic {
             showGalleryImageViewer(for: imageView, with: urlString)
             }*/

        }
        /* else if let imageView = sender.view as? UIImageView,
         let urlString = data?.response.result.user_detail.user_cover_pic {
         showGalleryImageViewer(for: imageView, with: urlString)
         }*/
    }
    
    //MARK:- cameraBtnTapped Button
    //=============================
    @objc func cameraBtnTapped(_ sender: UIButton) {
        AppImagePicker.showImagePicker(delegateVC: self, whatToCapture: .image)
    }
    
    /*
    @objc func getDOBDate(_ notification: Notification) {
        
        self.navigationController?.popToViewController(self, animated: true)
        
        if let userInfo = notification.userInfo, let dob = userInfo["birthDate"] as? Date {
            
            let dateInStr = dob.toString(dateFormat: DateFormat.showProfileDate.rawValue)
            
            self.obProfileDataModel?.dob = dateInStr
            self.editProfileTableView.reloadRows(at: [[0,2]], with: .none)
        }
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.DidChooseDate,
                                                  object: nil)
    }
 */
    
}


extension EditProfileVC {
    
    private func registerNibs() {
        
        let textFieldCell = UINib(nibName: "TextFieldCell", bundle: nil)
        self.editProfileTableView.register(textFieldCell, forCellReuseIdentifier: "TextFieldCell")
        
        let interestsCell = UINib(nibName: "InterestsCell", bundle: nil)
        self.editProfileTableView.register(interestsCell, forCellReuseIdentifier: "InterestsCell")
        
        let submitCell = UINib(nibName: "RoundBtnCell", bundle: nil)
        self.editProfileTableView.register(submitCell, forCellReuseIdentifier: "RoundBtnCellId")
        
        let addEventHeaderView = UINib(nibName: "AddEventHeaderView", bundle: nil)
        self.editProfileTableView.register(addEventHeaderView, forHeaderFooterViewReuseIdentifier: "AddEventHeaderViewId")

        let tableTopCurveNib = UINib(nibName: "TableTopCurveHeaderFooterView", bundle: nil)
        self.editProfileTableView.register(tableTopCurveNib, forHeaderFooterViewReuseIdentifier: "TableTopCurveHeaderFooterView")
    }
    
    func initialSetUp() {
//        navCameraBtn.isHidden = true
        self.editProfileTableView.delegate = self
        self.editProfileTableView.dataSource = self
        self.editProfileTableView.backgroundColor = AppColors.whiteColor
        self.hitInterestList()
    }
    
    //    func submitBtnOnTap() {
    //        // Check Name for Empty
    //        if let fName = self.obProfileDataModel?.first_name, fName.isEmpty {
    //            CommonClass.showToast(msg: "Please enter your name")
    //            return
    //        }
    //        self.hitProfileUpdate()
    //    }
    
    func setName() {
        if !self.name.isEmpty {
//            let (fName,lName) = self.name.parseName()
            self.obProfileDataModel?.first_name = self.name
//            self.obProfileDataModel?.last_name = lName
        }
    }
    
    //MARK:- hitInterestList method
    //=============================
    func hitInterestList() {
        
        var params = JSONDictionary()
        
        params["method"] = StringConstants.K_Interest_List.localized
        params["access_token"] = AppDelegate.shared.currentuser.access_token
        
        // Getting Interest List
        WebServices.getInterestList(parameters: params, loader: false, success: { (isSuccess,obInterestListModel, selectedInterestModel) in
            
            self.interestListModel = obInterestListModel
        }, failure: { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        })
    }
    
    //MARK:- makeInterest method
    //==========================
    func makeInterest() -> String {
        
        var jsonInterest = [JSONDictionary]()
        
        for id in EditProfileVC.selectedId {
            var interest = JSONDictionary()
            interest["sub_category"] = id
            if id == "1" {
                for crkID in self.selectedCricketId {
                    interest["child_category"] = crkID
                    jsonInterest.append(interest)
                }
            } else if id == "2" {
                for crkID in self.selectedFootballId {
                    interest["child_category"] = crkID
                    jsonInterest.append(interest)
                }
            } else {
                jsonInterest.append(interest)
            }
        }
        return CommonClass.convertToJson(jsonDic: jsonInterest)
    }
    
    //MARK:- makeParams method
    //========================
    func makeParams() -> JSONDictionary {
        
        var params = JSONDictionary()
        
        params["method"]        = StringConstants.K_Update_Profile.localized
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["first_name"]    = self.obProfileDataModel?.first_name
        params["last_name"]     = self.obProfileDataModel?.last_name
        params["image"]         = self.obProfileDataModel?.image
        params["location"]      = self.obProfileDataModel?.location
        params["latitude"]      = self.obProfileDataModel?.lat
        params["longitude"]     = self.obProfileDataModel?.long
        params["gender"]        = self.obProfileDataModel?.gender
        params["avtar"]         = self.obProfileDataModel?.avtar
        params["interest"]      = self.makeInterest()
        
        if let date = self.obProfileDataModel?.dob.toDate(dateFormat: DateFormat.showProfileDate.rawValue) {
            params["dob"] = date.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
        }
        return params
    }
    
    
    //MARK:- hitProfileUpdate method
    //==============================
    func hitProfileUpdate() {
        
        var params = JSONDictionary()
        params = self.makeParams()
        
        // Getting Interest List
        WebServices.updateProfile(parameters: params, success: { (isSuccess) in
            if isSuccess {
                CommonClass.showToast(msg: "Your Profile Has Been Updated Successfully")

                let dictionary = UserDetails.profileDataToDic(model: self.obProfileDataModel!)
                var oldUserData = UserDetails.convertModelintoDictionary(user: AppDelegate.shared.currentuser)

                for (key, value) in dictionary {
                    oldUserData[key] = value
                }
                UserDetails.updateUserData(dic: oldUserData)
                FirebaseHelper.createUsersNode()
                
                if self.state == .exploreMore {
                    NotificationCenter.default.post(name: Notification.Name.InterestUpdated,
                                                    object: nil,
                                                    userInfo: nil)
                }
                self.delegate?.hitService()
                self.navigationController?.popViewController(animated: true)
            }
        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        })
        
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
        
        if status == .authorizedWhenInUse{
            self.pickLocation()
        }
        else if status == .denied || status == .restricted{
            if let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(settingsUrl)
            }
        } else if status == .notDetermined{
            self.pickLocation()
        }
    }
    
}


//MARK: Extension: for Opening Camera or Gallery
//==============================================
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profilePic = pickedImage
            
            let url = "\(Int(Date().timeIntervalSince1970)).png"
            let imageURL = "\(S3_BASE_URL)\(BUCKET_NAME)/\(BUCKET_DIRECTORY)/\(url)"
            
            self.obProfileDataModel?.image = imageURL
            hasImageUploaded = false

            pickedImage.uploadImageToS3(imageurl: url,success: { [weak self] (success, url) in

                guard let strongSelf = self else {
                    return
                }

                strongSelf.hasImageUploaded = true
                strongSelf.setProfileImage()
                print_debug(url)

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
        setProfileImage()
        self.editProfileTableView.reloadSections([0], with: .none)
        picker.dismiss(animated: true, completion: nil)
    }
    
}


//MARK: Extension: for moveToAddIntrestsVCDelegate Delegate
//=========================================================
extension EditProfileVC : updateOrPushToVCDelegate {
    func updateOrPush(isPush: Bool, selectedId: [String]) {
        
        EditProfileVC.selectedId = selectedId
        if isPush {
            let obAddInterestsVC = AddInterestsVC.instantiate(fromAppStoryboard: .Login)
            AddInterestsVC.selectedId = selectedId
            obAddInterestsVC.obInterestListModel = self.interestListModel
            obAddInterestsVC.selectedCricketLeagueId = self.selectedCricketId
            obAddInterestsVC.selectedFootballLeagueId = self.selectedFootballId
            obAddInterestsVC.viewStatus = .updateProfile
            self.navigationController?.pushViewController(obAddInterestsVC, animated: true)
        } else {
            self.editProfileTableView.reloadRows(at: [[0,3]], with: .none)
        }
    }
}


//MARK: Extension: for valueChangedOfEditProfile Notification
//===========================================================
extension EditProfileVC {
    
    @objc func valueChangedOfEditProfile(_ notification: Notification) {
        
        if let userInfo = notification.userInfo,
            let selectedId = userInfo["selectedId"] as? [String],
            let cricketId = userInfo["cricketId"] as? [String],
            let footballId = userInfo["footballId"] as? [String] {
            EditProfileVC.selectedId = selectedId
            self.selectedCricketId = cricketId
            self.selectedFootballId = footballId
            self.editProfileTableView.reloadData()
        }
    }
}

//MARK: Extension: for UITableView Delegate and DataSource
//========================================================
extension EditProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.obProfileDataModel != nil {
            return 6
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height : CGFloat = CGFloat.leastNonzeroMagnitude
        
        switch indexPath.row {
        case 4:
            height =  130
        case 5:
            height =  80
        default:
            height = 55
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
        //return 320
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableTopCurveHeaderFooterView") as? TableTopCurveHeaderFooterView else { fatalError("TableTopCurveHeaderFooterView not found") }

        headerCell.shareBtn.setImage(AppImages.profileCameraWhite, for: .normal)
        //headerCell.shareBtn.addTarget(self, action: #selector(cameraBtnTapped), for: .touchUpInside)
        return headerCell

        /*
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AddEventHeaderViewId") as? AddEventHeaderView else { fatalError("AddEventHeaderView not found") }
        
        if let profileimage = profilePic {
            headerView.eventsImage.image = profileimage
        } else if let img = obProfileDataModel?.image {
            headerView.eventsImage.setImage(withSDWeb: img, placeholderImage: AppImages.myprofilePlaceholder)
        }
        headerView.setForEditProfile()
        headerView.eventsImage.curvHeaderView(height: 320)
        headerView.overlayView.curvHeaderView(height: 320)
        headerView.backBtn.addTarget(self, action: #selector(self.backBtnTapped(_:)), for: .touchUpInside)
        headerView.submitImageBtn.addTarget(self,
                                            action: #selector(cameraBtnTapped(_ :)),
                                            for: .touchUpInside)
        
        return headerView
        */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 4:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InterestsCell", for: indexPath) as? InterestsCell else { fatalError("InterestsCell not found") }
            
            InterestsCell.selectedId = Array(Set(EditProfileVC.selectedId))
            cell.selectedCricketId   = self.selectedCricketId
            cell.selectedFootballId  = self.selectedFootballId
            cell.delegate = self
            cell.addInterestsCollectionView.reloadData()
            
            return cell
            
        case 5:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RoundBtnCellId", for: indexPath) as? RoundBtnCell else { fatalError("RoundBtnCell not found") }

            cell.roundBtn.setTitle("UPDATE", for: .normal)
            cell.roundBtn.titleLabel?.font = AppFonts.Comfortaa_Bold_0.withSize(15)
            cell.roundBtn.addTarget(self,
                                    action: #selector(self.submitBtnTapped(_:)),
                                    for:.touchUpInside)
            
            return cell
            
        default:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as? TextFieldCell else { fatalError("TextFieldCell not found") }
            
            //            cell.customTextField.delegate = self
            
            switch indexPath.row {
            case 0:
                
                if let fName = self.obProfileDataModel?.first_name,
                    let lName =  self.obProfileDataModel?.last_name {
                    cell.customTextField.text = fName + " " + lName
                }
                cell.customTextField.placeholder = "Name*"
                cell.customTextField.keyboardType = .namePhonePad
                cell.calendarImage.isHidden = true
                cell.customTextField.addTarget(self,
                                               action: #selector(fetchName),
                                               for: .editingChanged)
                
            case 1:
                
                cell.customTextField.text = "\(self.obProfileDataModel?.country_code ?? "")-\(self.obProfileDataModel?.phone_no ?? "")"
                cell.customTextField.placeholder = StringConstants.Phone_Number.localized
                cell.customTextField.keyboardType = .numberPad
                cell.customTextField.isEnabled = false
                cell.calendarImage.isHidden = true
                
            case 2:
                
                cell.customTextField.text = self.obProfileDataModel?.dob ?? ""
                cell.customTextField.placeholder = StringConstants.Date_Of_Birth.localized
                cell.customTextField.inputView = nil
                cell.calendarImage.isHidden = false
//                cell.customTextField.delegate = self
                // DatePicker
                let calendar            = Calendar.autoupdatingCurrent
                var minDateComponent    = calendar.dateComponents([.day,.month,.year], from: Date())
                minDateComponent.day    = 01
                minDateComponent.month  = 1
                minDateComponent.year   = 1960
                let minDate             = calendar.date(from: minDateComponent)
                let maxDate             = Calendar.current.date(byAdding: .year, value: -18, to: Date())

                DatePicker.openDatePickerIn(cell.customTextField,
                                            outPutFormate: DateFormat.showProfileDate.rawValue,
                                            mode: .date,
                                            minimumDate: minDate!,
                                            maximumDate: maxDate!,
                                            selectedDate: Date(),
                                            doneBlock: { (dateStr,date) in

                                                cell.customTextField.text = dateStr
                                                self.obProfileDataModel?.dob = dateStr
                })
                
            case 3:
                
                cell.customTextField.text = "\(self.obProfileDataModel?.location ?? "")"
                cell.customTextField.placeholder = "Location*"
                cell.calendarImage.isHidden = false
                cell.customTextField.delegate = self
                cell.calendarImage.image = AppImages.interestLocation
                
            default:
                break
            }
            //            cell.customTextField.delegate = self
            //            if self.textBaseColor == true {
            //                cell.textFieldBaseView.backgroundColor = AppColors.themeBlueColor
            //            } else if self.textBaseColor == false {
            //                cell.textFieldBaseView.backgroundColor = AppColors.textFieldBaseLine
            //            }
            return cell
        }
    }
}

//MARK: Extension: for UIScrollViewDelegate
//=========================================
extension EditProfileVC: UIScrollViewDelegate {

    // To make sure tableview do not scrolls more than screenHeight
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if (offsetY <= -screenHeight) {
            scrollView.contentOffset = CGPoint(x: 0, y: (1 - screenHeight))
        }
    }
}

//MARK:- Google Autocomplete Delegate Extension
//=============================================
extension EditProfileVC : GMSPlacePickerViewControllerDelegate {
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        
        self.obProfileDataModel?.long = "\(place.coordinate.longitude)"
        self.obProfileDataModel?.lat = "\(place.coordinate.latitude)"

        CommonClass.getCity(from: place) { [weak self] city in
            guard let strongSelf = self else {
                return
            }
            strongSelf.setCity(city)
        }
        
        viewController.dismiss(animated: true, completion: nil)
    }

    private func setCity(_ city: String) {
        self.obProfileDataModel?.location = city
        self.editProfileTableView.reloadRows(at: [[0,3]], with: .none)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        viewController.dismiss(animated: true, completion: nil)
    }
}


//MARK: Extension: for UITextFieldDelegate
//========================================
extension EditProfileVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        guard let indexPath = textField.tableViewIndexPath(tableView: self.editProfileTableView) else { return false }
        
        if indexPath.row == 3 {
            self.didSendLocation()
            return false
        }
        return true
    }
    
}


/*
//MARK: Extension: for UITextFieldDelegate
//========================================
extension EditProfileVC: UITextFieldDelegate {
    
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
 
    //
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//        guard let index = textField.tableViewIndexPath(tableView: self.editProfileTableView) else { return }
//        self.textBaseColor = true
//        //        self.editProfileTableView.reloadRows(at: [index], with: .none)
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        guard let index = textField.tableViewIndexPath(tableView: self.editProfileTableView) else { return }
//        if index.row == 0 {
//            if let text = textField.text {
//                self.name = text
//            }
//        }
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        guard let index = textField.tableViewIndexPath(tableView: self.editProfileTableView) else { return false}
//        if let text = textField.text, text.isEmpty, index.row == 0 && string.isEmpty{
//            return false
//        }
//
//        return true
//    }
//
}
 
 */


