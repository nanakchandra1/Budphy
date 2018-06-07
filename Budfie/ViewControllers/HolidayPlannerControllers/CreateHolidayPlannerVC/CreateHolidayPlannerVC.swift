//
//  CreateHolidayPlannerVC.swift
//  Budfie
//
//  Created by appinventiv on 31/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import GoogleMaps
import GooglePlaces
import GooglePlacePicker

enum HolidayStayType : String {
    case hotels = "Hotels"
    case homeStay = "Home Stay"
}

class CreateHolidayPlannerVC: BaseVc {
    
    //MARK:- Properties
    //=================
    var storeHolidayModel = HolidayPlannerModel()
    var fromDate = Date()
    var toDate = Date()
    var stayState : HolidayStayType = .hotels

    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var navigationView   : CurvedNavigationView!
    @IBOutlet weak var topNavBar        : UIView!
    @IBOutlet weak var backBtn          : UIButton!
    @IBOutlet weak var navigationTitle  : UILabel!
    @IBOutlet weak var createHolidayTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialSetup()
        self.registerNib()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func submitBtnTapped(_ sender: UIButton) {
        if !self.checkForEmpty() {
            return
        }
        self.makeFromToDates()
        askIfToSaveInPlanner()
        //self.hitCreateHoliday()
    }
    
    @objc func radioBtnClicked(_ sender: UIButton) {
        
        guard let cell = sender.getTableViewCell as? SelectStayCell else {return}
        
        if cell.hotelBtn === sender {
            self.storeHolidayModel.stay = "1"
            self.stayState = .hotels
        } else {
            self.storeHolidayModel.stay = "2"
            self.stayState = .homeStay
        }
        self.createHolidayTableView.reloadRows(at: [[0,6],[0,7]], with: .none)
    }
    
    @objc func adultKidsBtnClicked(_ sender: UIButton) {
        
        guard let cell = sender.getTableViewCell as? AdultsKidsCell else {return}

        if cell.adultBtn === sender {
            self.adultKidsPopUp(sender, isAdult: true)
        } else {
            self.adultKidsPopUp(sender, isAdult: false)
        }
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.createHolidayTableView) else {
            return
        }

        if let text = sender.text {
            
            if indexPath.row == 1 {
                self.storeHolidayModel.origin = text
            } else {
                self.storeHolidayModel.destination = text
            }
        }
    }
    
}


//MARK:- Private Extension
//========================
extension CreateHolidayPlannerVC {
    
    private func initialSetup() {
        
        self.createHolidayTableView.delegate = self
        self.createHolidayTableView.dataSource = self
        self.createHolidayTableView.backgroundColor = UIColor.clear
        
        self.navigationView.backgroundColor = UIColor.clear
        self.topNavBar.backgroundColor = AppColors.themeBlueColor
        
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.text = StringConstants.K_Holiday_Planner.localized
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        
        self.backBtn.setImage(AppImages.phonenumberBackicon, for: .normal)
        
        self.storeHolidayModel.fromDate = self.fromDate.toString(dateFormat: DateFormat.dateWithSlash.rawValue)
        self.storeHolidayModel.toDate = self.toDate.toString(dateFormat: DateFormat.dateWithSlash.rawValue)
        
        self.storeHolidayModel.stay = "1"
        self.storeHolidayModel.rating = "1"
    }
    
    private func registerNib() {
        
        let addEventCell = UINib(nibName: "AddEventCell", bundle: nil)
        self.createHolidayTableView.register(addEventCell, forCellReuseIdentifier: "AddEventCellId")
        
        let dateTimeCell = UINib(nibName: "DateTimeCell", bundle: nil)
        self.createHolidayTableView.register(dateTimeCell, forCellReuseIdentifier: "DateTimeCellId")
        
        let roundBtnCell = UINib(nibName: "RoundBtnCell", bundle: nil)
        self.createHolidayTableView.register(roundBtnCell, forCellReuseIdentifier: "RoundBtnCellId")

        let adultsKidsCell = UINib(nibName: "AdultsKidsCell", bundle: nil)
        self.createHolidayTableView.register(adultsKidsCell, forCellReuseIdentifier: "AdultsKidsCell")

        let selectStayCell = UINib(nibName: "SelectStayCell", bundle: nil)
        self.createHolidayTableView.register(selectStayCell, forCellReuseIdentifier: "SelectStayCell")

        let rateHotelCell = UINib(nibName: "RateHotelCell", bundle: nil)
        self.createHolidayTableView.register(rateHotelCell, forCellReuseIdentifier: "RateHotelCell")

        let trendingDestinationCell = UINib(nibName: "TrendingDestinationCell", bundle: nil)
        self.createHolidayTableView.register(trendingDestinationCell, forCellReuseIdentifier: "TrendingDestinationCell")
    }
    
    func adultKidsPopUp (_ sender: UIButton, isAdult: Bool) {
        
        AppDelegate.shared.configuration.menuWidth = 100.0
        AppDelegate.shared.configuration.menuSeparatorInset = UIEdgeInsets(top: 0.0, left: -10.0, bottom: 0.0, right: -10.0)
        
        var numberOfPerson = [String]()
        
        if isAdult {
            numberOfPerson = ["1","2","3","4"]
        } else {
            numberOfPerson = ["1","2","3"]
        }
        
        FTPopOverMenu.showForSender(sender: sender,
                                    with: numberOfPerson,
                                    done: { (index) in
                                        
                                        if isAdult {
                                            self.storeHolidayModel.adult = "\(index+1)"
                                        } else {
                                            self.storeHolidayModel.kids = "\(index+1)"
                                        }
                                        
                                        self.createHolidayTableView.reloadRows(at: [[0,5]], with: .none)
        }, cancel: {

        })
    }

    // Asks user if the holidays are to be save into the planner
    func askIfToSaveInPlanner() {
        let inviteFriendsPopUpScene = InviteFriendsPopUpVC.instantiate(fromAppStoryboard: .Events)
        inviteFriendsPopUpScene.delegate = self
        inviteFriendsPopUpScene.pageState = .holidayPlanner
        addChildViewController(inviteFriendsPopUpScene)
        view.addSubview(inviteFriendsPopUpScene.view)
        inviteFriendsPopUpScene.didMove(toParentViewController: self)
    }
    
    func checkForEmpty() -> Bool {
        
        if self.storeHolidayModel.origin.isEmpty {
            CommonClass.showToast(msg: "Please enter Origin")
            return false
        } else if self.storeHolidayModel.destination.isEmpty {
            CommonClass.showToast(msg: "Please select Destination")
            return false
        } else if self.storeHolidayModel.adult.isEmpty {
            CommonClass.showToast(msg: "Please select number of adult(s)")
            return false
        }
        return true
    }
    
    func makeFromToDates() {
        if let fromDate = self.storeHolidayModel.fromDate.toDate(dateFormat: DateFormat.dOBServerFormat.rawValue),
            let toDate = self.storeHolidayModel.toDate.toDate(dateFormat: DateFormat.dOBServerFormat.rawValue) {
            self.storeHolidayModel.fromDate = fromDate.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
            self.storeHolidayModel.toDate = toDate.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
        }
    }
    /*
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
    */
}

/*
//MARK:- Google Autocomplete Delegate Extension
//=============================================
extension CreateHolidayPlannerVC : GMSPlacePickerViewControllerDelegate {
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        
//        var loc = CLLocationCoordinate2D()
//        loc = place.coordinate
//        self.storeHolidayModel.long = "\(loc.longitude)"
//        self.storeHolidayModel.lat = "\(loc.latitude)"
        
        if self.storeHolidayModel.isOrigin {
            
            self.storeHolidayModel.origin = place.name
            self.createHolidayTableView.reloadRows(at: [[0,1]], with: .none)

        } else {
            self.storeHolidayModel.destination = place.name

            if let add = place.formattedAddress?.lowercased(), add.contains(s: "india") {
                self.storeHolidayModel.isHomeStayHidden = false
            } else {
                self.storeHolidayModel.isHomeStayHidden = true
            }
            self.createHolidayTableView.reloadRows(at: [[0,2],[0,6]], with: .none)
        }
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}
*/

//MARK: Extension: for RateStarProtocol
//=====================================
extension CreateHolidayPlannerVC: RateStarProtocol {
    
    func starSelected(index: String) {
        self.storeHolidayModel.rating = index
    }
    
}


//MARK: Extension: for TrendingDestinationLocationDelegate
//========================================================
extension CreateHolidayPlannerVC: TrendingDestinationLocationDelegate {
    
    func getLocation(isNational: Bool, placeName: String) {
        self.storeHolidayModel.isHomeStayHidden = !isNational
        self.storeHolidayModel.destination = placeName
        self.createHolidayTableView.reloadData()
    }
}

// MARK: GetResponse Delegate Methods
extension CreateHolidayPlannerVC: GetResponseDelegate {

    func nowOrSkipBtnTapped(isOkBtn: Bool) {

        var params = JSONDictionary()
        params = self.makeParams()

        if isOkBtn {
            params["is_planner"] = 1
        }

        WebServices.createHolidayPlan(parameters: params, success: { (isSuccess) in

            if isSuccess {
                CommonClass.showToast(msg: "Message sent to Holiday Planners")

                if isOkBtn, let fromDate = self.storeHolidayModel.fromDate.toDate(dateFormat: DateFormat.dateWithSlash.rawValue) {

                    let dateString = fromDate.toString(dateFormat: DateFormat.calendarDate.rawValue)
                    NotificationCenter.default.post(name: Notification.Name.EventAdded, object: nil, userInfo: ["eventDate": dateString])
                }
                self.navigationController?.popViewController(animated: true)
            }

        }, failure: { (err) in
            CommonClass.showToast(msg: err.localizedDescription)
        })
    }

    func makeParams() -> JSONDictionary {

        var params = JSONDictionary()
        let dateFormat = DateFormat.dateWithSlash.rawValue

        guard let fromDate = storeHolidayModel.fromDate.toDate(dateFormat: dateFormat),
            let toDate = storeHolidayModel.toDate.toDate(dateFormat: dateFormat) else {
                return params
        }

        params["method"]        = StringConstants.K_Create_Holiday_Plan.localized
        params["access_token"]  = AppDelegate.shared.currentuser.access_token//AppDelegate.shared.currentuser.access_token
        params["from_date"]     = fromDate.toString(dateFormat: DateFormat.calendarDate.rawValue)
        params["to_date"]       = toDate.toString(dateFormat: DateFormat.calendarDate.rawValue)
        params["origin"]        = self.storeHolidayModel.origin
        params["destination"]   = self.storeHolidayModel.destination
        params["adults"]        = self.storeHolidayModel.adult
        params["kids"]          = self.storeHolidayModel.kids
        params["star_rate"]     = self.storeHolidayModel.rating
        params["stay_type"]     = self.storeHolidayModel.stay

        /*
         params["method"]        = StringConstants.K_Create_Holiday_Plan.localized
         params["access_token"]  = AppDelegate.shared.currentuser.access_token
         params["from_date"]     = self.storeHolidayModel.fromDate
         params["to_date"]       = self.storeHolidayModel.toDate
         params["place"]         = "Noida"
         params["longitude"]     = "232424.24"
         params["latitude"]      = "2343424.423"
         params["min_budget"]    = "10000"
         params["max_budget"]    = "20000"
         params["person"]        = "2"
         params["stay_type"]     = "2"
         */

        return params
    }
}

//MARK: Extension: for UITextFieldDelegate
//========================================
extension CreateHolidayPlannerVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        guard let cell = textField.tableViewCell as? AddEventCell else { return false }
        
        guard let indexPath = cell.tableViewIndexPath(self.createHolidayTableView) else { return false }
        
        if indexPath.row == 1 {
            self.storeHolidayModel.isOrigin = true
        } else {
            self.storeHolidayModel.isOrigin = false
        }
//        self.didSendLocation()
        return false
    }
}


