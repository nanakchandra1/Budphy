//
//  HolidayPlannerEventVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 10/04/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class HolidayPlannerEventVC: BaseVc {

    // MARK: Private Enum
    enum VCState {
        case viewing
        case editing
    }

    // MARK: Public Properties
    var plannerEvent: EventModel!
    var vcState: VCState = .viewing {
        didSet {
            if isViewLoaded {
                holidayPlannerTableView.reloadData()
            }
        }
    }
    weak var delegate: HitMoviesOrConcertAPI?

    // MARK: Private Properties
    private var storeHolidayModel = HolidayPlannerModel()
    private var stayState: HolidayStayType = .hotels
    private var plannerDetail: EditEventDetailsModel!

    private var toDate = Date()
    private var fromDate = Date()

    // MARK: IBOutlets
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var editBtn: UIButton!

    @IBOutlet weak var holidayPlannerTableView: UITableView!

    // MARK: View Controllers Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        holidayPlannerTableView.dataSource = self
        holidayPlannerTableView.delegate = self
        holidayPlannerTableView.backgroundColor = .clear

        if #available(iOS 11.0, *) {
            holidayPlannerTableView.contentInset = UIEdgeInsetsMake(-view.safeAreaInsets.top, 0, 0, 0)
        }

        registerNib()
        addParallaxHeader()
        plannerEventDetails(eventId: plannerEvent.eventId)

        switch vcState {
        case .viewing:
            editBtn.alpha = 1
        case .editing:
            editBtn.alpha = 0
        }

        navigationView.backgroundColor = .clear

        navigationTitle.textColor = AppColors.whiteColor
        navigationTitle.text = StringConstants.K_Holiday_Planner.localized
        navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)

        storeHolidayModel.toDate = toDate.toString(dateFormat: DateFormat.dateWithSlash.rawValue)
        storeHolidayModel.fromDate = fromDate.toString(dateFormat: DateFormat.dateWithSlash.rawValue)

        storeHolidayModel.stay = "1"
        storeHolidayModel.rating = "1"

        NotificationCenter.default.addObserver(self, selector: #selector(self.getFriendIds), name: Notification.Name.GetFriendId, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Private Methods
    private func registerNib() {

        let tableTopCurveNib = UINib(nibName: "TableTopCurveHeaderFooterView", bundle: nil)
        holidayPlannerTableView.register(tableTopCurveNib, forHeaderFooterViewReuseIdentifier: "TableTopCurveHeaderFooterView")

        let addEventHeaderView = UINib(nibName: "AddEventHeaderView", bundle: nil)
        holidayPlannerTableView.register(addEventHeaderView, forHeaderFooterViewReuseIdentifier: "AddEventHeaderViewId")

        let addEventCell = UINib(nibName: "AddEventCell", bundle: nil)
        holidayPlannerTableView.register(addEventCell, forCellReuseIdentifier: "AddEventCellId")

        let dateTimeCell = UINib(nibName: "DateTimeCell", bundle: nil)
        holidayPlannerTableView.register(dateTimeCell, forCellReuseIdentifier: "DateTimeCellId")

        let adultsKidsCell = UINib(nibName: "AdultsKidsCell", bundle: nil)
        holidayPlannerTableView.register(adultsKidsCell, forCellReuseIdentifier: "AdultsKidsCell")

        let selectStayCell = UINib(nibName: "SelectStayCell", bundle: nil)
        holidayPlannerTableView.register(selectStayCell, forCellReuseIdentifier: "SelectStayCell")

        let rateHotelCell = UINib(nibName: "RateHotelCell", bundle: nil)
        holidayPlannerTableView.register(rateHotelCell, forCellReuseIdentifier: "RateHotelCell")

        let eventOwnerCell = UINib(nibName: "EventOwnerCell", bundle: nil)
        holidayPlannerTableView.register(eventOwnerCell, forCellReuseIdentifier: "EventOwnerCell")

        let attendeeCell = UINib(nibName: "AttendeeCell", bundle: nil)
        holidayPlannerTableView.register(attendeeCell, forCellReuseIdentifier: "AttendeeCell")

        let moreFriendsCell = UINib(nibName: "MoreFriendsCell", bundle: nil)
        holidayPlannerTableView.register(moreFriendsCell, forCellReuseIdentifier: "MoreFriendsCellId")

        let roundBtnCell = UINib(nibName: "RoundBtnCell", bundle: nil)
        holidayPlannerTableView.register(roundBtnCell, forCellReuseIdentifier: "RoundBtnCellId")
    }

    private func addParallaxHeader() {
        guard let headerView = holidayPlannerTableView.dequeueReusableHeaderFooterView(withIdentifier: "AddEventHeaderViewId") as? AddEventHeaderView else {
            return
        }

        headerView.eventsImage.image = #imageLiteral(resourceName: "icHolidayPlaceholderImage")
        headerView.cameraImageBtn.isHidden = true
        headerView.addPhotoLabel.isHidden = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(shareHolidayEventTapped))
        tapGesture.cancelsTouchesInView = false
        headerView.eventsImage.addGestureRecognizer(tapGesture)

        let headerHeight: CGFloat = 250
        let navViewHeight: CGFloat = 44

        holidayPlannerTableView.parallaxHeader.view = headerView
        holidayPlannerTableView.parallaxHeader.height = headerHeight
        holidayPlannerTableView.parallaxHeader.minimumHeight = navViewHeight
        holidayPlannerTableView.parallaxHeader.mode = .centerFill

        navigationView.backgroundColor = AppColors.themeBlueColor.withAlphaComponent(0)

        holidayPlannerTableView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in

            let progress = parallaxHeader.progress
            let alpaComponent = max(0, min(1, ((1 - (progress)) / 0.95)))

            self.navigationView.backgroundColor = AppColors.themeBlueColor.withAlphaComponent(alpaComponent)
        }
    }

    @objc private func shareHolidayEventTapped(_ gesture: UITapGestureRecognizer) {

        guard let cell = holidayPlannerTableView.headerView(forSection: 0) as? TableTopCurveHeaderFooterView else {
            return
        }

        let location = gesture.location(in: cell)
        let modifiedLocation = CGPoint(x: location.x, y: -location.y)

        if cell.shareBtn.frame.contains(modifiedLocation),
            plannerDetail != nil {
            CommonClass.externalShare(textURL: plannerDetail.share_url, viewController: self)
        }
    }

    private func plannerEventDetails(eventId: String) {

        var params = JSONDictionary()
        params["method"]            = "event_details"
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["event_id"]          = eventId
        params["event_category"]    = "8"
        params["event_date"]        = ""

        WebServices.getEventDetails(parameters: params, success: { [weak self] eventDetail in

            guard let strongSelf = self else {
                return
            }
            strongSelf.plannerDetail = eventDetail

            let json = eventDetail.json["event_details"]
            let serverFromDate = json["from_date"].stringValue
            let serverToDate = json["to_date"].stringValue

            if let fromDate = serverFromDate.toDate(dateFormat: DateFormat.calendarDate.rawValue) {
                strongSelf.fromDate                     = fromDate
                strongSelf.storeHolidayModel.fromDate   = fromDate.toString(dateFormat: DateFormat.dateWithSlash.rawValue)
            }

            if let toDate = serverToDate.toDate(dateFormat: DateFormat.calendarDate.rawValue) {
                strongSelf.toDate                       = toDate
                strongSelf.storeHolidayModel.toDate     = toDate.toString(dateFormat: DateFormat.dateWithSlash.rawValue)
            }

            strongSelf.storeHolidayModel.origin         = json["origin"].stringValue
            strongSelf.storeHolidayModel.destination    = json["destination"].stringValue
            strongSelf.storeHolidayModel.adult          = json["adults"].stringValue
            strongSelf.storeHolidayModel.kids           = json["kids"].stringValue
            strongSelf.storeHolidayModel.rating         = json["star_rate"].stringValue

            let stayTypeValue                           = json["stay_type"].stringValue
            strongSelf.storeHolidayModel.stay           = stayTypeValue

            if stayTypeValue == "1" {
                strongSelf.stayState = .hotels
            } else {
                strongSelf.stayState = .homeStay
            }

            strongSelf.holidayPlannerTableView.reloadData()

            }, failure: { [weak self] (error) in
                if (error as NSError).code == 210 {
                    self?.showEventDeletedAlert()
                } else {
                    CommonClass.showToast(msg: error.localizedDescription)
                    self?.navigationController?.popViewController(animated: true)
                }
        })
    }

    private func showEventDeletedAlert() {
        let alert = UIAlertController(title: "Budfie", message: "The owner has deleted this holiday plan!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    private func updateHolidayEvent() {

        var params = JSONDictionary()
        params = self.makeParams()

        WebServices.editHolidayPlannerEvent(parameters: params, success: { [weak self] isSuccess in

            guard let strongSelf = self else {
                return
            }

            if isSuccess, let fromDate = strongSelf.storeHolidayModel.fromDate.toDate(dateFormat: DateFormat.dateWithSlash.rawValue) {

                let dateString = fromDate.toString(dateFormat: DateFormat.calendarDate.rawValue)
                NotificationCenter.default.post(name: Notification.Name.EventAdded, object: nil, userInfo: ["eventDate": dateString])

                CommonClass.showToast(msg: "Event Updated Successfully")

            } else {
                CommonClass.showToast(msg: "Sorry!!! Error")
            }

            guard let navCont = strongSelf.navigationController else {
                return
            }

            if !navCont.popToClass(type: TabBarVC.self) {
                navCont.popViewController(animated: true)
            }

        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }

    private func makeParams() -> JSONDictionary {

        var params = JSONDictionary()
        let dateFormat = DateFormat.dateWithSlash.rawValue

        guard let fromDate = storeHolidayModel.fromDate.toDate(dateFormat: dateFormat),
            let toDate = storeHolidayModel.toDate.toDate(dateFormat: dateFormat) else {
                return params
        }

        params["method"]        = "edit"
        params["id"]            = plannerEvent.eventId
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["from_date"]     = fromDate.toString(dateFormat: DateFormat.calendarDate.rawValue)
        params["to_date"]       = toDate.toString(dateFormat: DateFormat.calendarDate.rawValue)
        params["origin"]        = storeHolidayModel.origin
        params["destination"]   = storeHolidayModel.destination
        params["adults"]        = storeHolidayModel.adult
        params["kids"]          = storeHolidayModel.kids
        params["star_rate"]     = storeHolidayModel.rating
        params["stay_type"]     = storeHolidayModel.stay
        params["friends"]       = makeFriendIds()

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

    private func makeFriendIds() -> String {

        if plannerDetail.invitees.isEmpty {
            return ""
        }

        var friendDic = [JSONDictionary]()
        for temp in plannerDetail.invitees {
            var friend = JSONDictionary()
            friend["friend_id"] = temp.friendId
            friendDic.append(friend)
        }
        return CommonClass.convertToJson(jsonDic: friendDic)
    }

    private func deletePlannerEvent() {

        guard let event = plannerEvent,
            let user = AppDelegate.shared.currentuser else {
                return
        }

        let parameters: JSONDictionary = ["method": "delete_event",
                                          "access_token": user.access_token,
                                          "type": "2",
                                          "event_id": event.eventId]

        WebServices.deleteEvent(parameters: parameters, success: { [weak self] hasDeleted in
            guard hasDeleted, let strongSelf = self else {
                return
            }
            strongSelf.delegate?.hitMoviesOrConcert(eventState: .none)
            strongSelf.navigationController?.popViewController(animated: true)

            }, failure: { error in
                CommonClass.showToast(msg: error.localizedDescription)
        })
    }

    // MARK: IBActions
    @IBAction func backBtnTapped(_ sender: UIButton) {
        pop()
    }

    @IBAction func editBtnTapped(_ sender: UIButton) {
        switch vcState {
        case .viewing:
            vcState = .editing
            sender.alpha = 0
        case .editing:
            break
        }
    }
}

// MARK: TableView DataSource Methods
extension HolidayPlannerEventVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if plannerDetail == nil {
            return 1
        }
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if plannerDetail == nil {
            return 0
        }
        if section == 0 {
            return 6
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {

        case 0:
            switch indexPath.row {

            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "DateTimeCellId") as? DateTimeCell else {
                    fatalError("DateTimeCell not found")
                }

                cell.setHolidayPlannerEventView()

                cell.dateTextField.text = storeHolidayModel.fromDate
                cell.timeTextField.text = storeHolidayModel.toDate

                //cell.dateTextField.delegate = self
                //cell.timeTextField.delegate = self

                let dateFormat = DateFormat.dateWithSlash.rawValue
                let selectedToDate = storeHolidayModel.toDate.toDate(dateFormat: dateFormat) ?? toDate
                let selectedFromDate = storeHolidayModel.fromDate.toDate(dateFormat: dateFormat) ?? fromDate

                DatePicker.openDatePickerIn(cell.dateTextField,
                                            outPutFormate: dateFormat,
                                            mode: .date,
                                            minimumDate: Date(),
                                            maximumDate: nil,
                                            selectedDate: selectedFromDate,
                                            doneBlock: { (dateString, date) in

                                                if date > self.toDate {
                                                    self.toDate = Date()
                                                    self.storeHolidayModel.toDate = ""
                                                }

                                                self.fromDate = date
                                                self.storeHolidayModel.fromDate = dateString
                                                self.holidayPlannerTableView.reloadRows(at: [[0, 0]], with: .none)
                })

                DatePicker.openDatePickerIn(cell.timeTextField,
                                            outPutFormate: dateFormat,
                                            mode: .date,
                                            minimumDate: fromDate,
                                            maximumDate: nil,
                                            selectedDate: selectedToDate,
                                            doneBlock: { (dateString, date) in

                                                if date < self.fromDate {
                                                    CommonClass.showToast(msg: "From Date cannot be less than To Date")

                                                } else {
                                                    self.toDate = date
                                                    self.storeHolidayModel.toDate = dateString
                                                    self.holidayPlannerTableView.reloadRows(at: [[0, 0]], with: .none)
                                                }
                })

                return cell

            case 1, 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddEventCellId") as? AddEventCell else {
                    fatalError("AddEventCell not found")
                }

                cell.eventNameTextField.textColor = AppColors.blackColor
                cell.textFieldEndImageView.isHidden = false
                cell.textFieldEndImageView.image = AppImages.icAddeventLocation
                cell.eventNameTextField.tintColor = UIColor.black
                cell.eventNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
                cell.isUserInteractionEnabled = (vcState == .editing)

                if indexPath.row == 1 {
                    cell.eventNameTextField.text = storeHolidayModel.origin
                    cell.eventNameTextField.placeholder = "Origin"
                } else {
                    cell.eventNameTextField.text = storeHolidayModel.destination
                    cell.eventNameTextField.placeholder = "Destination"
                }
                return cell

            case 3:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdultsKidsCell", for: indexPath) as? AdultsKidsCell else {
                    fatalError("AdultsKidsCell not found")
                }

                if !storeHolidayModel.adult.isEmpty {
                    cell.adultBtn.setTitle(storeHolidayModel.adult, for: .normal)
                }
                if !storeHolidayModel.kids.isEmpty {
                    cell.kidsBtn.setTitle(storeHolidayModel.kids, for: .normal)
                }

                cell.adultBtn.addTarget(self, action: #selector(adultKidsBtnClicked), for: .touchUpInside)
                cell.kidsBtn.addTarget(self, action: #selector(adultKidsBtnClicked), for: .touchUpInside)
                cell.isUserInteractionEnabled = (vcState == .editing)

                return cell

            case 4:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectStayCell", for: indexPath) as? SelectStayCell else {
                    fatalError("SelectStayCell not found")
                }

                if storeHolidayModel.isHomeStayHidden {
                    cell.radioHomeOnOff.isHidden = true
                    cell.homeBtn.isHidden = true
                    cell.stayHomeImage.isHidden = true
                    cell.stayHomeLabel.isHidden = true
                    stayState = HolidayStayType.hotels

                } else {
                    cell.radioHomeOnOff.isHidden = false
                    cell.homeBtn.isHidden = false
                    cell.stayHomeImage.isHidden = false
                    cell.stayHomeLabel.isHidden = false
                }

                if stayState == HolidayStayType.hotels {
                    cell.radioHotelOnOff.image = AppImages.icChooseMusicRadioOn
                    cell.radioHomeOnOff.image = AppImages.icChooseMusicRadioOff
                } else if stayState == HolidayStayType.homeStay {
                    cell.radioHotelOnOff.image = AppImages.icChooseMusicRadioOff
                    cell.radioHomeOnOff.image = AppImages.icChooseMusicRadioOn
                } else {
                    cell.radioHotelOnOff.image = AppImages.icChooseMusicRadioOff
                    cell.radioHomeOnOff.image = AppImages.icChooseMusicRadioOff
                }

                cell.hotelBtn.addTarget(self, action: #selector(radioBtnClicked), for: .touchUpInside)
                cell.homeBtn.addTarget(self, action: #selector(radioBtnClicked), for: .touchUpInside)
                cell.isUserInteractionEnabled = (vcState == .editing)

                return cell

            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "RateHotelCell", for: indexPath) as? RateHotelCell else {
                    fatalError("RateHotelCell not found")
                }

                switch stayState {
                case .hotels:
                    cell.hotelArrow.isHidden = false
                    cell.homeArrow.isHidden = true
                case .homeStay:
                    cell.hotelArrow.isHidden = true
                    cell.homeArrow.isHidden = false
                }

                if storeHolidayModel.isHomeStayHidden {
                    stayState = HolidayStayType.hotels
                }

                switch storeHolidayModel.rating {
                case "1":
                    cell.firstStarTapped()
                case "2":
                    cell.secondStarTapped()
                case "3":
                    cell.thirdStarTapped()
                case "4":
                    cell.forthStarTapped()
                default:
                    cell.fifthStarTapped()
                }

                cell.delegate = self
                cell.isUserInteractionEnabled = (vcState == .editing)

                return cell
            }

        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoreFriendsCellId") as? MoreFriendsCell else {
                fatalError("MoreFriendsCell not found")
            }

            if vcState == .viewing {
                cell.addMoreBtn.isHidden = true
            } else {
                cell.addMoreBtn.isHidden = false
            }

            if vcState == .viewing, plannerEvent != nil,
                (plannerEvent.userId == AppDelegate.shared.currentuser.user_id) {

                cell.friendList = plannerDetail.invitees
                cell.inviteFriendLabel.text = "Invited Friends"
                cell.delegate = self
                cell.moreFriendsView.dataSource = cell
                cell.moreFriendsView.reloadData()

            } else if vcState == .viewing {

                cell.friendList = plannerDetail.eventOwner
                cell.inviteFriendLabel.text = "Invited By"
                cell.delegate = self
                cell.moreFriendsView.dataSource = cell
                cell.moreFriendsView.reloadData()

            } else {

                cell.friendList = plannerDetail.invitees
                cell.inviteFriendLabel.text = "Invited Friends"
                cell.delegate = self
                cell.moreFriendsView.dataSource = cell
                cell.moreFriendsView.reloadData()
                cell.addMoreBtn.addTarget(self, action: #selector(addMoreBtnTapped), for: .touchUpInside)
            }

            return cell

        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AttendeeCell") as? AttendeeCell else {
                fatalError("AttendeeCell not found")
            }

            if (plannerEvent.userId != AppDelegate.shared.currentuser.user_id) {
                cell.inviteFriendLabel.text = "Attending"
            } else {
                cell.inviteFriendLabel.text = "Attendees"
            }
            cell.friendList = plannerDetail.attendees
            cell.delegate = self
            cell.moreFriendsView.reloadData()

            return cell

        default:
            guard let roundBtnCell = tableView.dequeueReusableCell(withIdentifier: "RoundBtnCellId") as? RoundBtnCell else {
                fatalError("RoundBtnCell not found")
            }
            let btnText = ((vcState == .viewing) ? "DELETE" : "UPDATE")
            roundBtnCell.roundBtn.setTitle(btnText, for: .normal)
            roundBtnCell.roundBtn.addTarget(self, action: #selector(updateBtnTapped), for: .touchUpInside)
            return roundBtnCell
        }
    }

    @objc private func updateBtnTapped(_ sender: UIButton) {
        switch vcState {
        case .viewing:
            showConfirmDeletePopUp()
        case .editing:
            if !self.checkForEmpty() {
                return
            }
            updateHolidayEvent()
        }
    }

    func showConfirmDeletePopUp() {
        let inviteFriendsPopUpScene = InviteFriendsPopUpVC.instantiate(fromAppStoryboard: .Events)
        inviteFriendsPopUpScene.delegate = self
        inviteFriendsPopUpScene.pageState = .deleteEvent
        addChildViewController(inviteFriendsPopUpScene)
        view.addSubview(inviteFriendsPopUpScene.view)
        inviteFriendsPopUpScene.didMove(toParentViewController: self)
    }

    private func checkForEmpty() -> Bool {
        if storeHolidayModel.origin.isEmpty {
            CommonClass.showToast(msg: "Please select To Date")
        } else if storeHolidayModel.origin.isEmpty {
            CommonClass.showToast(msg: "Please enter Origin")
        } else if storeHolidayModel.destination.isEmpty {
            CommonClass.showToast(msg: "Please enter Destination")
        } else if storeHolidayModel.adult.isEmpty {
            CommonClass.showToast(msg: "Please select number of adult(s)")
        } else {
            return true
        }
        return false
    }

    @objc func textFieldDidChange(_ sender: UITextField) {

        guard let indexPath = sender.tableViewIndexPath(tableView: holidayPlannerTableView),
            let text = sender.text else {
                return
        }

        if indexPath.row == 1 {
            storeHolidayModel.origin = text
        } else {
            storeHolidayModel.destination = text
        }
    }

    @objc func radioBtnClicked(_ sender: UIButton) {

        guard let cell = sender.getTableViewCell as? SelectStayCell else {
            return
        }

        if cell.hotelBtn === sender {
            storeHolidayModel.stay = "1"
            stayState = .hotels
        } else {
            storeHolidayModel.stay = "2"
            stayState = .homeStay
        }
        holidayPlannerTableView.reloadRows(at: [[0, 4], [0, 5]], with: .none)
    }

    @objc func adultKidsBtnClicked(_ sender: UIButton) {

        guard let cell = sender.getTableViewCell as? AdultsKidsCell else {
            return
        }

        let isAdult = (cell.adultBtn === sender)
        adultKidsPopUp(sender, isAdult: isAdult)
    }

    func adultKidsPopUp (_ sender: UIButton, isAdult: Bool) {

        AppDelegate.shared.configuration.menuWidth = 100.0
        AppDelegate.shared.configuration.menuSeparatorInset = UIEdgeInsets(top: 0.0, left: -10.0, bottom: 0.0, right: -10.0)

        let numberOfPerson: [String]

        if isAdult {
            numberOfPerson = ["1","2","3","4"]
        } else {
            numberOfPerson = ["1","2","3"]
        }

        FTPopOverMenu.showForSender(sender: sender, with: numberOfPerson, done: { (index) in

            if isAdult {
                self.storeHolidayModel.adult = "\(index+1)"
            } else {
                self.storeHolidayModel.kids = "\(index+1)"
            }
            self.holidayPlannerTableView.reloadRows(at: [[0, 3]], with: .none)

        }, cancel: {

        })
    }

    @objc private func addMoreBtnTapped(_ sender: UIButton) {
        let inviteesScene = InviteesVC.instantiate(fromAppStoryboard: .Events)
        inviteesScene.eventId = plannerEvent.eventId
        inviteesScene.state = .editEvent
        self.navigationController?.pushViewController(inviteesScene, animated: true)
    }

    @objc func getFriendIds(_ notification: Notification) {

        guard let userInfo = notification.userInfo,
            let friendIds = userInfo["friendIds"] as? [FriendListModel] else {
                return
        }

        for newFriend in friendIds {
            plannerDetail.invitees.append(newFriend)
        }
        makeUniqueIds()
    }

    private func makeUniqueIds() {

        // FILTER UNIQUE DATA
        var uniqueFriends = [FriendListModel]()

        if plannerDetail.invitees.count > 0 {
            uniqueFriends.append(plannerDetail.invitees[0])
        } else {
            return
        }

        for item in self.plannerDetail.invitees {
            var phoneCount = 0
            for friend in uniqueFriends {
                if friend.friendId == item.friendId {
                    phoneCount = 1
                }
            }
            if phoneCount == 0 {
                uniqueFriends.append(item)
            }
        }
        plannerDetail.invitees = uniqueFriends
        holidayPlannerTableView.reloadRows(at: [[2, 0]], with: .none)
    }
}

// MARK:- GetResponse Delegate Methods
extension HolidayPlannerEventVC: GetResponseDelegate {

    func nowOrSkipBtnTapped(isOkBtn: Bool) {
        if isOkBtn {
            deletePlannerEvent()
        }
    }
}

// MARK: Show Friend Profile Methods
extension HolidayPlannerEventVC: ShowFriendProfile {

    func getFriendId(friendId : String) {
        let scene = ProfileVC.instantiate(fromAppStoryboard: .EditProfile)
        scene.state = .otherProfile
        scene.friendId = friendId
        navigationController?.pushViewController(scene, animated: true)
    }
}

// MARK: TableView Delegate Methods
extension HolidayPlannerEventVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == 0 {

            guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableTopCurveHeaderFooterView") as? TableTopCurveHeaderFooterView else {
                fatalError("TableTopCurveHeaderFooterView not found")
            }

            headerCell.shareBtn.isHidden = false
            return headerCell

        } else {
            return UIView()
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = AppColors.eventSaperator
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.section {

        case 0:
            switch indexPath.row {

            case 0, 1, 2:
                if screenWidth < 322 {
                    return 65
                }
                return 70

            case 3, 4:
                if screenWidth < 322 {
                    return 100
                }
                return 100

            default:
                if screenWidth < 322 {
                    return 135
                }
                return 135
            }

        case 1:
            if plannerEvent != nil,
                plannerEvent.userId == AppDelegate.shared.currentuser.user_id {

                if plannerDetail.invitees.count == 0 {
                    if vcState == .editing {
                        return 70.0
                    } else {
                        return CGFloat.leastNonzeroMagnitude
                    }
                } else {
                    return 100.0
                }

            } else {
                return 100.0
            }

        case 2:
            if vcState == .editing {
                return CGFloat.leastNonzeroMagnitude
            } else if plannerDetail.attendees.count == 0 {
                return CGFloat.leastNonzeroMagnitude
            } else {
                return 100.0
            }

        case 3:
            if let user = AppDelegate.shared.currentuser,
                let event = plannerDetail,
                event.event_owner != user.user_id {
                return CGFloat.leastNonzeroMagnitude
            } else {
                return 100.0
            }
            /*
             if vcState == .editing {
             return 100.0
             }
             fallthrough
             */

        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        if plannerDetail == nil {
            return CGFloat.leastNonzeroMagnitude
        }

        switch section {
        case 0:
            return 5

        case 1:
            if plannerEvent != nil,
                plannerEvent.userId == AppDelegate.shared.currentuser.user_id {

                if plannerDetail.invitees.count == 0 {
                    if vcState == .editing {
                        return 5
                    } else {
                        return CGFloat.leastNonzeroMagnitude
                    }
                } else {
                    return 5
                }

            } else {
                return 5
            }

        case 2:
            if vcState == .editing {
                return CGFloat.leastNonzeroMagnitude
            } else if plannerDetail.attendees.count == 0 {
                return CGFloat.leastNonzeroMagnitude
            } else {
                return 5
            }

        case 3:
            return CGFloat.leastNonzeroMagnitude
            /*
             if let user = AppDelegate.shared.currentuser,
             let event = plannerDetail,
             event.event_owner != user.user_id {
             return CGFloat.leastNonzeroMagnitude
             } else {
             return 5
             }
             */
            /*
             if vcState == .editing {
             return 5
             }
             fallthrough
             */

        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
}

// MARK: RateStar Protocol Methods
extension HolidayPlannerEventVC: RateStarProtocol {

    func starSelected(index: String) {
        storeHolidayModel.rating = index
    }
}
// MARK: ScrollView Delegate Methods
extension HolidayPlannerEventVC: UIScrollViewDelegate {

    // To make sure tableview do not scrolls more than screenHeight
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if (offsetY <= -screenHeight) {
            scrollView.contentOffset = CGPoint(x: 0, y: (1 - screenHeight))
        }
    }
}
