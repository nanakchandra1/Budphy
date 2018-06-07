//
//  AddEventsVC.swift
//  Budfie
//
//  Created by yogesh singh negi on 07/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import ParallaxHeader
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import CoreLocation
import RealmSwift

protocol EventDelegate: class {
    func eventAdded(date : String)
}

//MARK:- AddEventsVC Class
//========================
class AddEventsVC: BaseVc {
    
    //MARK:- Properties
    //=================
    var storeFormData       = [String:String]()
    var eventDate           : Date?
    var eventType           = [String]()
    var obEventTypeModel    = [EventTypesModel]()
    var eventImage          : UIImage?
    let eventTimeArray      = ["30 Mins", "1 Hour", "2 Hours", "3 Hours", "1 Day"]
    let recurringTypeArray  = ["Daily","Weekly","Monthly","Yearly"]
    var obTopFriendListModel : TopFriendListModel!
    weak var delegate       : EventDelegate?
    var headerView          : AddEventHeaderView!
    var isRecurring         = false

    lazy var pickerView = UIPickerView()
    lazy var pickerToolbar = UIToolbar()

    fileprivate var hasImageUploaded = true {
        didSet {
            if hasImageUploaded {
                CommonClass.showToast(msg: "Pic has been uploaded")
            }
        }
    }
    
    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var addEventTableView: UITableView!
    @IBOutlet weak var navBackgroundView: UIView!
    @IBOutlet weak var cameraBtn: UIButton!
    
    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()

        setupToolbar()
        self.setUpInitialViews()
        self.registerNibs()
        
        if #available(iOS 11.0, *) {
            //            addEventTableView.contentInsetAdjustmentBehavior = .never
            //            addEventTableView.insetsContentViewsToSafeArea = false
            //            addEventTableView.insetsLayoutMarginsFromSafeArea = false
            addEventTableView.contentInset = UIEdgeInsetsMake(-view.safeAreaInsets.top, 0, 0, 0)
        }
        
        cameraBtn.isHidden = true
        
        if let headerView = addEventTableView.dequeueReusableHeaderFooterView(withIdentifier: "AddEventHeaderViewId") as? AddEventHeaderView {
            
            let headerHeight: CGFloat = 250
            let navViewHeight: CGFloat = 44
            self.headerView = headerView
            
            headerView.eventsImage.backgroundColor = AppColors.themeBlueColor
            headerView.cameraImageBtn.addTarget(self,
                                                action: #selector(cameraBtnTapped(_:)),
                                                for: .touchUpInside)
            /*
             headerView.eventsImage.curvHeaderView(height: 250)
             headerView.overlayView.curvHeaderView(height: 250)
             headerView.backBtn.addTarget(self, action: #selector(self.backBtnTapped(_:)), for: .touchUpInside)
             
             headerView.sideCameraBtn.addTarget(self,
             action: #selector(cameraBtnTapped(_ :)),
             for: .touchUpInside)
             */
            
            addEventTableView.parallaxHeader.view = headerView
            addEventTableView.parallaxHeader.height = headerHeight
            addEventTableView.parallaxHeader.minimumHeight = navViewHeight
            addEventTableView.parallaxHeader.mode = .centerFill
            navBackgroundView.backgroundColor = AppColors.themeBlueColor.withAlphaComponent(0)
            
            addEventTableView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
                
                let progress = parallaxHeader.progress
                
                let alpaComponent = max(0, min(1, ((1 - (progress)) / 0.95)))
                self.navBackgroundView.backgroundColor = AppColors.themeBlueColor.withAlphaComponent(alpaComponent)
                //headerView.overlayView.setNeedsDisplay()
                //self.updateHeaderConstraint()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
        self.hitEventType()
    }

    private func setupToolbar() {

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(pickerCancelButtonTapped))

        cancelButton.tintColor = AppColors.systemBlueColor

        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(pickerDoneButtonTapped))

        doneButton.tintColor = AppColors.systemBlueColor

        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)

        pickerToolbar.sizeToFit()
        let toolbarItems = [cancelButton, spaceButton, doneButton]
        pickerToolbar.setItems(toolbarItems, animated: true)
        pickerToolbar.backgroundColor = UIColor.lightText
    }

    @objc private func pickerCancelButtonTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }

    @objc private func pickerDoneButtonTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true)

        let eventTypeCellIndexPath = IndexPath(row: 0, section: 0)
        guard let cell = addEventTableView.cellForRow(at: eventTypeCellIndexPath) as? AddEventCell else {
            return
        }

        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let typeText = eventType[selectedRow]

        cell.eventNameTextField.text = typeText
        self.storeFormData[StringConstants.Event_Type.localized] = typeText

        if let image = self.storeFormData[StringConstants.event_image.localized], image.isEmpty {
            self.headerView.eventsImage.image = getEventDetailsImage(eventName: typeText)
            cell.textFieldEndImageView.image = getEventListImage(eventName: typeText)
            self.headerView.cameraImageBtn.isHidden = true
            self.headerView.addPhotoLabel.isHidden = true
            self.cameraBtn.isHidden = false
        }
    }
    
    //MARK:- @IBActions
    //=================
    @IBAction func backBtnTapped(_ sender: UIButton) {
        //AppDelegate.shared.sharedTabbar?.showTabbar()
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- submitBtnTapped Button
    //============================
    func setEventImage() {
        if let img = self.eventImage {
            headerView.eventsImage.image = img
            headerView.cameraImageBtn.isHidden = true
            cameraBtn.isHidden = false
            headerView.addPhotoLabel.isHidden = true
        }
    }
    
    @objc func submitBtnTapped(_ sender: UIButton) {
        if self.checkForFilledData() == false {
            return
        }
        self.hitAddEvent()
    }
    
    @objc func locationBtnTapped() {
        self.didSendLocation()
    }

    @objc func eventTypeBtnTapped(_ sender: UIButton) {
        if let cell = sender.getTableViewCell as? AddEventCell {
            cell.eventNameTextField.becomeFirstResponder()
        }
    }
    
    @objc func getLocationByUser(_ sender: UITextField) {
        
        if let text = sender.text {
            self.storeFormData[StringConstants.Location.localized] = text
            self.storeFormData[StringConstants.Longitude.localized] = "0"
            self.storeFormData[StringConstants.Latitude.localized] = "0"
        }
    }
    
    //MARK:- cameraBtnTapped Button
    //=============================
    @IBAction func cameraBtnTapped(_ sender: UIButton) {
        AppImagePicker.showImagePicker(delegateVC: self, whatToCapture: .image)
    }
    
    //MARK:- shareBtnTapped Button
    //=============================
    @objc func shareBtnTapped(_ sender: UIButton) {
        
        // text to share
        let text = BASE_URL
        
        if let url = URL(string: text) {
            let shareController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            shareController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            self.present(shareController, animated: true, completion: nil)
        } else {
            CommonClass.showToast(msg: "Please try later!!!")
        }
    }
    
    //MARK:- textFieldEditingChanged method
    //=====================================
    @objc func textFieldValueChanged(_ sender: UITextField) {
        
        if let text = sender.text {
            self.storeFormData[StringConstants.Event_Name.localized] = text
        }
    }
    
    @objc func radioRecurringBtnTapped(_ sender: UIButton) {
        
        guard let cell = sender.getTableViewCell as? RecurringEventCell else {
            fatalError("RecurringEventCell not found")
        }
        
        if cell.yesBtn === sender, self.isRecurring == false {
            self.isRecurring = true
            self.addEventTableView.reloadData()
        } else if cell.noBtn === sender, self.isRecurring == true {
            self.isRecurring = false
            self.addEventTableView.reloadData()
        }
    }
    
    /*
     @objc func getEventDate(_ notification: Notification) {
     
     self.navigationController?.popToViewController(self, animated: true)
     
     if let userInfo = notification.userInfo, let dob = userInfo["eventDate"] as? Date {
     
     let dateShow = dob.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
     self.eventDate = dob
     self.storeFormData[StringConstants.Date.localized] = dateShow
     self.addEventTableView.reloadRows(at: [[0,2]], with: .none)
     }
     NotificationCenter.default.removeObserver(self,
     name: Notification.Name.DidChooseDate,
     object: nil)
     }
     */
    
}


//MARK: Extension for Registering Nibs and Setting Up SubViews
//============================================================
extension AddEventsVC {
    
    //MARK:- Set Up SubViews method
    //=============================
    fileprivate func setUpInitialViews() {
        
        self.addEventTableView.delegate         = self
        self.addEventTableView.dataSource       = self
        self.initialStoreData()
        self.addEventTableView.backgroundColor  = AppColors.whiteColor

        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    //MARK:- Nib Register method
    //==========================
    fileprivate func registerNibs() {
        
        let tableTopCurveNib = UINib(nibName: "TableTopCurveHeaderFooterView", bundle: nil)
        self.addEventTableView.register(tableTopCurveNib, forHeaderFooterViewReuseIdentifier: "TableTopCurveHeaderFooterView")
        
        let addEventHeaderView = UINib(nibName: "AddEventHeaderView", bundle: nil)
        self.addEventTableView.register(addEventHeaderView, forHeaderFooterViewReuseIdentifier: "AddEventHeaderViewId")
        
        let addEventCell = UINib(nibName: "AddEventCell", bundle: nil)
        self.addEventTableView.register(addEventCell, forCellReuseIdentifier: "AddEventCellId")
        
        let dateTimeCell = UINib(nibName: "DateTimeCell", bundle: nil)
        self.addEventTableView.register(dateTimeCell, forCellReuseIdentifier: "DateTimeCellId")
        
        let roundBtnCell = UINib(nibName: "RoundBtnCell", bundle: nil)
        self.addEventTableView.register(roundBtnCell, forCellReuseIdentifier: "RoundBtnCellId")
    }
    
    //MARK:- initialStoreData method
    //==============================
    func initialStoreData() {
        
        self.storeFormData[StringConstants.Event_Name.localized]    = ""
        self.storeFormData[StringConstants.Event_Type.localized]    = ""
        self.storeFormData[StringConstants.Date.localized]          = ""
        self.storeFormData[StringConstants.Time.localized]          = ""
        self.storeFormData[StringConstants.Location.localized]      = ""
        self.storeFormData[StringConstants.Remind_Me.localized]     = "30 Mins"
        self.storeFormData[StringConstants.Longitude.localized]     = ""
        self.storeFormData[StringConstants.Latitude.localized]      = ""
        self.storeFormData[StringConstants.event_image.localized]   = ""
        self.storeFormData["recurringDate"]                         = ""
    }
    
    //MARK:- check for the required data
    //==================================
    func checkForFilledData() -> Bool {
        
        if let eventName = self.storeFormData[StringConstants.Event_Name.localized], eventName.isEmpty {
            CommonClass.showToast(msg: "Please Enter Event Name")
            return false
        }
        if let eventType = self.storeFormData[StringConstants.Event_Type.localized], eventType.isEmpty {
            CommonClass.showToast(msg: "Please Select Event Type")
            return false
        }
        if let eventDate = self.storeFormData[StringConstants.Date.localized], eventDate.isEmpty {
            CommonClass.showToast(msg: "Please Enter Event Date")
            return false
        }
        if let eventTime = self.storeFormData[StringConstants.Time.localized], eventTime.isEmpty {
            CommonClass.showToast(msg: "Please Enter Event Time")
            return false
        }
        if isRecurring, self.storeFormData["recurringDate"] == nil {
            CommonClass.showToast(msg: "Please Select Recurring Type")
            return false
        }
        if isRecurring, let recurringDate = self.storeFormData["recurringDate"], recurringDate.isEmpty {
            CommonClass.showToast(msg: "Please Select Recurring Type")
            return false
        }
        //        if let eventLocation = self.storeFormData[StringConstants.Location.localized], eventLocation.isEmpty {
        //            CommonClass.showToast(msg: "Please Enter Location")
        //            return false
        //        }
        //        if let remindMe = self.storeFormData[StringConstants.Remind_Me.localized], remindMe.isEmpty {
        //            CommonClass.showToast(msg: "Please Select Reminder")
        //            return false
        //        }
        //        if let image = self.storeFormData[StringConstants.event_image], image.isEmpty {
        //            CommonClass.showToast(msg: "Please Select Image")
        //            return false
        //        }
        return true
    }
    
    //MARK:- getRemindmeDate method
    //=============================
    func getRemindmeDate() -> String {
        
        if let reminder = self.storeFormData[StringConstants.Remind_Me.localized],reminder.isEmpty {
            return ""
        }
        var reminder = ""
        if let date = self.eventDate {
            
            let strDate = date.toString(dateFormat: DateFormat.commonDate.rawValue)
            var time = self.storeFormData[StringConstants.Time.localized] ?? ""
            if time.isEmpty{
                time = "00:00 AM"
            }
            let evDate = strDate + " " + time
            let ndate = evDate.toDate(dateFormat: "dd MM yyyy hh:mm a")
            var addInterval:TimeInterval = 0
            let interval = self.storeFormData[StringConstants.Remind_Me.localized] ?? "30 Min"
            if interval == self.eventTimeArray[0] {
                
                addInterval = 30 * 60
            } else if interval == self.eventTimeArray[1] {
                addInterval = 60 * 60
                
            } else if interval == self.eventTimeArray[2] {
                addInterval = 120 * 60
            } else if interval == self.eventTimeArray[3] {
                addInterval = 180 * 60
            }
            if let remindDate = ndate?.addingTimeInterval(-addInterval) {
                reminder = remindDate.toString(dateFormat: DateFormat.shortDate.rawValue)//"dd-MM-yyyy hh:mm a")
            }
        }
        return reminder
    }
    
    //MARK:- hitEventType method
    //==========================
    func hitEventType() {
        
        var params = JSONDictionary()
        
        params["method"]            = StringConstants.K_Event_Type.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        
        // Get Event Type
        //===============
        WebServices.getEventType(parameters: params, loader: false, success: { (obEventTypeModel) in
            
            self.eventType.removeAll()

            if let realm = try? Realm() {
                let eventTypes = realm.objects(RealmEventType.self)
                try? realm.write {
                    realm.delete(eventTypes)
                }
            }

            for temp in obEventTypeModel {
                self.eventType.append(temp.eventType)

                if let realm = try? Realm() {
                    let value = ["id": temp.id, "name": temp.eventType]
                    try? realm.write {
                        realm.create(RealmEventType.self, value: value)
                    }
                }
            }
            self.obEventTypeModel = obEventTypeModel
            self.addEventTableView.reloadData()

        }, failure: { (err) in

            var eventTypes = [RealmEventType]()
            self.eventType.removeAll()

            if let realm = try? Realm() {
                eventTypes = Array(realm.objects(RealmEventType.self))
            }

            if eventTypes.isEmpty {
                CommonClass.showToast(msg: err.localizedDescription)
            } else {

                self.obEventTypeModel = eventTypes.map({ realmEventType in
                    self.eventType.append(realmEventType.name)
                    return realmEventType.appEventType
                })
            }
        })
    }
    
    //MARK:- makeParams method
    //========================
    func makeParams() -> JSONDictionary {
        
        var params = JSONDictionary()
        
        params["method"]            = StringConstants.K_Create_Event.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["event_name"]        = self.storeFormData[StringConstants.Event_Name.localized]
        params["event_date"]        = self.eventDate?.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
        params["event_time"]        = self.storeFormData[StringConstants.Time.localized]
        params["event_location"]    = self.storeFormData[StringConstants.Location.localized]
        params["longitude"]         = self.storeFormData[StringConstants.Longitude.localized]
        params["latitude"]          = self.storeFormData[StringConstants.Latitude.localized]
        params["remind_me"]         = self.getRemindmeDate()
        
            //self.storeFormData[StringConstants.Remind_Me.localized]
        
        params["event_image"]       = self.storeFormData[StringConstants.event_image]
        params["recurring_type"]    = isRecurring ? self.storeFormData["recurringDate"] : "0"
        
        for temp in self.obEventTypeModel {
            if temp.eventType == self.storeFormData[StringConstants.Event_Type.localized] {
                params["event_type"] = temp.id
            }
        }
        return params
    }
    
    //MARK:- hitAddEvent method
    //=========================
    func hitAddEvent() {
        
        var params = JSONDictionary()
        params = self.makeParams()
        
        // Create Event
        WebServices.createEvent(parameters: params, success: { (obTopFriendListModel) in
            
            self.obTopFriendListModel = obTopFriendListModel
            // On Success
            
            let controller = InviteFriendsPopUpVC.instantiate(fromAppStoryboard: .Events)
            controller.delegate = self
            controller.modalPresentationStyle = .overCurrentContext
            self.present(controller, animated: false, completion: nil)
            
        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
    //MARK:- hitNewFriendList method
    //==============================
    func hitNewFriendList() {
        
        var params = JSONDictionary()
        
        params["method"]            = StringConstants.K_Get_New_Friends.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["last_sync_time"]    = AppUserDefaults.value(forKey: .timeStamp)
        params["page"]              = "1"
        
        WebServices.newFriendList(parameters: params, loader: false, success: { (isSuccess) in
            
        }, failure: { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
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

//MARK: Extension for Opening Camera or Gallery
//=============================================
extension AddEventsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.eventImage = pickedImage
            
            let url = "\(Int(Date().timeIntervalSince1970)).png"
            let imageURL = "\(S3_BASE_URL)\(BUCKET_NAME)/\(BUCKET_DIRECTORY)/\(url)"
            
            self.storeFormData[StringConstants.event_image] = imageURL
            hasImageUploaded = false
            
            pickedImage.uploadImageToS3(imageurl: url,success: { [weak self] (success, url) in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.hasImageUploaded = true
                strongSelf.setEventImage()
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
            //self.addEventTableView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- GetResponseDelegate Delegate Extension
//=============================================
extension AddEventsVC: GetResponseDelegate {
    
    func nowOrSkipBtnTapped(isOkBtn: Bool) {
        if isOkBtn {
            
            if self.obTopFriendListModel.friendListModel.isEmpty{
                
                let ob = InviteesVC.instantiate(fromAppStoryboard: .Events)
                ob.eventId = self.obTopFriendListModel.eventId
                ob.state = .addEvent
                ob.eventDate = self.eventDate
                self.navigationController?.pushViewController(ob, animated: true)
                
            }else{
                let ob = InviteFriendsVC.instantiate(fromAppStoryboard: .Events)
                ob.obTopFriendListModel = self.obTopFriendListModel
                ob.eventDate = self.eventDate
                self.navigationController?.pushViewController(ob, animated: true)
            }
        } else {
            if AppUserDefaults.value(forKey: AppUserDefaults.Key.isThankYou) == "0" {
                let controller = ThankYouVC.instantiate(fromAppStoryboard: .Login)
                controller.state = .invite
                controller.delegate = self
                //                controller.modalPresentationStyle = .overCurrentContext
                //                self.present(controller, animated: false, completion: nil)
                self.addChildViewController(controller)
                self.view.addSubview(controller.view)
                controller.didMove(toParentViewController: self)
            } else {
                self.pushHomeScreen()
            }
        }
    }
    
}


//MARK:- AddEventsVC Delegate Extension
//=====================================
extension AddEventsVC: PushToHomeScreenDelegate {
    
    func pushHomeScreen() {
        
        guard let nav = self.navigationController else { return }
        
        //AppDelegate.shared.sharedTabbar?.showTabbar()
        if nav.popToClass(type: TabBarVC.self) {
            if let eventDateStr = self.storeFormData[StringConstants.Date.localized],
                let eventDate = eventDateStr.toDate(dateFormat: DateFormat.showDateFormat.rawValue) {
                self.delegate?.eventAdded(date: eventDate.toString(dateFormat: DateFormat.dOBServerFormat.rawValue))
            }
//            nav.popToRootViewController(animated: true)
        }
    }
}


//MARK:- Google Autocomplete Delegate Extension
//=============================================
extension AddEventsVC : GMSPlacePickerViewControllerDelegate {
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {

        self.storeFormData[StringConstants.Longitude.localized] = "\(place.coordinate.longitude)"
        self.storeFormData[StringConstants.Latitude.localized] = "\(place.coordinate.latitude)"

        CommonClass.getCity(from: place) { [weak self] city in
            guard let strongSelf = self else {
                return
            }
            strongSelf.setCity(city)
        }

        viewController.dismiss(animated: true, completion: nil)
    }

    private func setCity(_ city: String) {
        self.storeFormData[StringConstants.Location.localized] = city
        self.addEventTableView.reloadRows(at: [[0,6]], with: .none)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        viewController.dismiss(animated: true, completion: nil)
    }
}


//MARK: Extension: for UITextFieldDelegate
//========================================
extension AddEventsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            if string == " " {
                return false
            }
            return true
        }
        
        if text.isEmpty, string == " " {
            return false
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        guard let indexPath = textField.tableViewIndexPath(tableView: self.addEventTableView) else { return false }

        if indexPath.row == 2 {
            guard let cell = textField.getTableViewCell as? DateTimeCell else { return false }
            
            if textField == cell.dateTextField {
                
                //                NotificationCenter.default.addObserver(self,
                //                                                       selector: #selector(self.getEventDate),
                //                                                       name: Notification.Name.DidChooseDate,
                //                                                       object: nil)
                //
                //                let scene = HolidayCalendarVC.instantiate(fromAppStoryboard: .HolidayPlanner)
                //                scene.vcType = .eventDate
                //                scene.moveToDate = eventDate ?? Date()
                //                self.navigationController?.pushViewController(scene, animated: true)
                //                return false
                
            } else if textField == cell.timeTextField {
                
                if let text = cell.dateTextField.text, text.isEmpty {
                    CommonClass.showToast(msg: "Please Select Date First")
                    return false
                }
            }
        } else if indexPath.row == 6 {
            self.didSendLocation()
            return false
        }
        return true
    }
    
}

// MARK: PickerView DataSource Methods
extension AddEventsVC: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eventType.count
    }
}

// MARK: PickerView Delegate Methods
extension AddEventsVC: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let eventTypeView: EventTypePickerView

        if let typeView = view as? EventTypePickerView {
            eventTypeView = typeView
        } else {
            eventTypeView = EventTypePickerView()
        }

        let typeText = eventType[row]
        eventTypeView.pickerlabel.text = typeText
        eventTypeView.pickerImage.image = getEventListImage(eventName: typeText)

        return eventTypeView
    }
}
