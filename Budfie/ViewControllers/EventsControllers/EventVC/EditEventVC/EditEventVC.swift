//
//  EditEventVC.swift
//  Budfie
//
//  Created by appinventiv on 22/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import GooglePlacePicker
import CoreLocation
import SwiftyJSON
import RealmSwift

protocol AcceptOrReject: class {
    func acceptRejectClicked(isAccept: Bool, eventId: String)
}

enum EventPageState {
    case edit
    case view
    case invitation
}

//MARK:- EditEventVC Class
//========================
class EditEventVC: BaseVc {
    
    //MARK:- Properties
    //=================
    //    var storeFormData       = [String:String]()
    var eventDate           : Date?
    var eventType           = [String]()
    var obEventTypeModel    = [EventTypesModel]()
    var inviteDetails       : InvitationModel?
    var eventImage          : UIImage?
    var eventTimeArray      = ["30 Mins", "1 Hour", "2 Hours", "3 Hours"]
    var eventState          = EventPageState.view
    var eventDetailsModel   : EditEventDetailsModel!
    var obEventModel        : EventModel!
    var eventId             : String!
    var otherFriends        = [JSONDictionary]()
    weak var delegate       : AcceptOrReject?
    weak var delegateForPersonalEvents : HitMoviesOrConcertAPI?
    var headerView          : AddEventHeaderView!
    let recurringTypeArray  = ["Daily","Weekly","Monthly","Yearly"]
    var isRecurring         = false
    var chatRoomId          : String?

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
    @IBOutlet weak var acceptRejectViewHeight: NSLayoutConstraint!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!

    @IBOutlet weak var navBackgroundView: UIView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var eventNameLbl: UILabel!

    @IBOutlet weak var createChatBtn: UIButton!

    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()

        setupToolbar()
        self.hitEventType()
        self.setUpInitialViews()
        self.registerNibs()

        if #available(iOS 11.0, *) {
//            addEventTableView.contentInsetAdjustmentBehavior = .never
//            addEventTableView.insetsContentViewsToSafeArea = false
//            addEventTableView.insetsLayoutMarginsFromSafeArea = false
            addEventTableView.contentInset = UIEdgeInsetsMake(-view.safeAreaInsets.top, 0, 0, 0)
        }

        if let headerView = addEventTableView.dequeueReusableHeaderFooterView(withIdentifier: "AddEventHeaderViewId") as? AddEventHeaderView {

            self.headerView = headerView
            cameraBtn.isHidden = false
            setupHeaderView()

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventsImageTapped))
            tapGesture.cancelsTouchesInView = false
            headerView.eventsImage.addGestureRecognizer(tapGesture)

            let headerHeight: CGFloat = 250
            let navViewHeight: CGFloat = 44

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
                //self.updateCurveViewConstraint()
            }
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didEditGreeting),
                                               name: NSNotification.Name.DidEditGreeting,
                                               object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setUpLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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

        for event in self.obEventTypeModel {
            if event.eventType == typeText {
                self.eventDetailsModel.eventType = event.id
            }
        }

        if self.eventDetailsModel.eventImage.isEmpty {
            self.headerView.eventsImage.image = getEventDetailsImage(eventName: typeText)
            cell.textFieldEndImageView.image = getEventListImage(eventName: typeText)
        }
    }
    
    //MARK:- @IBActions
    //=================
    @IBAction func backBtnTapped(_ sender: UIButton) {
        if eventState == .view || eventState == .edit {
            //AppDelegate.shared.sharedTabbar?.showTabbar()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func acceptBtnTapped(_ sender: UIButton) {
        if let id = self.inviteDetails?.eventId {
            self.delegate?.acceptRejectClicked(isAccept: true, eventId: id)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func rejectBtnTapped(_ sender: UIButton) {
        if let id = self.inviteDetails?.eventId {
            self.delegate?.acceptRejectClicked(isAccept: false, eventId: id)
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func createChatBtnTapped() {

        guard !eventDetailsModel.invitees.isEmpty else {
            CommonClass.showToast(msg: "There are no invitees to create group")
            return
        }

        let roomInfoDict = [DatabaseNode.RoomInfo.chatTitle.rawValue: obEventModel.eventName]
        let json = JSON(roomInfoDict)
        let roomInfo = ChatRoomInfo(with: json)

        let chatScene = ChatVC.instantiate(fromAppStoryboard: .Chat)

        if let roomId = chatRoomId {
            roomInfo.roomId = roomId
        } else {
            let chatMembers = eventDetailsModel.invitees.map { (attendee) -> ChatMember in
                let json = JSON(["userId": attendee.friendId])
                let chatMember = ChatMember(with: json)
                return chatMember
            }
            chatScene.chatMembers = chatMembers
        }
        chatScene.chatRoomInfo = roomInfo
        if eventState == .invitation, let event = self.inviteDetails {
            chatScene.eventId = event.eventId
        } else {
            chatScene.eventId = obEventModel.eventId
        }
        navigationController?.pushViewController(chatScene, animated: true)
    }
    
    @objc func locationBtnTapped() {
        self.didSendLocation()
    }
    
    @objc func getLocationByUser(_ sender: UITextField) {
        
        if let text = sender.text {
            self.eventDetailsModel.eventLocation = text
            self.eventDetailsModel.eventLatitude = "0"
            self.eventDetailsModel.eventLongitude = "0"
        }
    }
    
    @objc func didEditGreeting(_ notification: Notification) {
        
        /*
         guard let tabbar = AppDelegate.shared.sharedTabbar,
         let navCont = tabbar.navigationController else {
         return
         }
         navCont.popToViewController(tabbar, animated: true)
         */
        
        self.navigationController?.popToViewController(self, animated: true)
        
        if let userInfo = notification.userInfo,
            let greetingId = userInfo["greeting_id"] as? String,
            let greetingImg = userInfo["greeting_image"] as? String {
            
            eventDetailsModel.greeting_id = greetingId
            eventDetailsModel.greeting = greetingImg
            addEventTableView.reloadRows(at: [[1,0]], with: .fade)
            
            NotificationCenter.default.removeObserver(self,
                                                      name: Notification.Name.DidEditGreeting,
                                                      object: nil)
        }
    }

    //MARK:- setEventImage
    //====================
    func setEventImage() {
        if !self.eventDetailsModel.eventImage.isEmpty {
            headerView.eventsImage.setImage(withSDWeb: self.eventDetailsModel.eventImage, placeholderImage: #imageLiteral(resourceName: "myprofilePlaceholder"))
            //headerView.eventsImage.backgroundColor = AppColors.themeBlueColor
        }
    }

    func setupHeaderView() {
        
        //headerView.eventsImage.backgroundColor = AppColors.themeBlueColor
        headerView.eventsImage.image = AppImages.myprofilePlaceholder
        
        guard eventDetailsModel != nil else {
            return
        }
        setEventImage()
        
        if eventState == .view {
            headerView.setViewEvent()
            eventNameLbl.text = self.eventDetailsModel.eventName
            cameraBtn.addTarget(self,
                                action: #selector(editBtnTapped(_ :)),
                                for: .touchUpInside)
            cameraBtn.setImage(AppImages.icEdit, for: .normal)

        } else if eventState == .edit {
            headerView.setEditEvent()
            cameraBtn.addTarget(self,
                                action: #selector(cameraBtnTapped(_ :)),
                                for: .touchUpInside)
            cameraBtn.setImage(AppImages.profileCameraWhite, for: .normal)
            
        } else if eventState == .invitation {
            headerView.setViewEvent()
            eventNameLbl.text = self.eventDetailsModel.eventName
            cameraBtn.isHidden = true
        }

        if self.eventState == .view || self.eventState == .edit {
            if self.obEventModel.userId == AppDelegate.shared.currentuser.user_id {
                cameraBtn.isHidden = false
            } else {
                cameraBtn.isHidden = true
            }
        }
    }
    
    //MARK:- submitBtnTapped Button
    //=============================
    @objc private func eventsImageTapped(_ sender: UITapGestureRecognizer) {

        if let cell = addEventTableView.headerView(forSection: 0) as? TableTopCurveHeaderFooterView {

            let location = sender.location(in: cell)
            let modifiedLocation = CGPoint(x: location.x, y: -location.y)

            if cell.shareBtn.frame.contains(modifiedLocation) {
                shareBtnTapped(cell.shareBtn)
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

    @objc func submitBtnTapped(_ sender: UIButton) {
        switch eventState {
        case .edit:
            if checkForFilledData() == false {
                return
            }
            hitUpdateEvent()
        case .invitation:
            break
        case .view:
            showConfirmDeletePopUp()
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

    private func deleteEvent() {

        guard let event = obEventModel,
            let user = AppDelegate.shared.currentuser else {
                return
        }

        let parameters: JSONDictionary = ["method": "delete_event",
                                          "access_token": user.access_token,
                                          "type": "1",
                                          "event_id": event.eventId]

        WebServices.deleteEvent(parameters: parameters, success: { [weak self] hasDeleted in
            guard hasDeleted, let strongSelf = self else {
                return
            }
            strongSelf.delegateForPersonalEvents?.hitMoviesOrConcert(eventState: .none)
            strongSelf.navigationController?.popViewController(animated: true)

        }, failure: { error in
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
    //MARK:- shareBtnTapped Button
    //=============================
    @objc func shareBtnTapped(_ sender: UIButton) {
        
        if eventDetailsModel != nil {
            CommonClass.externalShare(textURL: eventDetailsModel.share_url, viewController: self)
        }
    }
    
    //MARK:- cameraBtnTapped Button
    //=============================
    @objc func cameraBtnTapped(_ sender: UIButton) {
        AppImagePicker.showImagePicker(delegateVC: self, whatToCapture: .image)
    }
    
    //MARK:- editBtnTapped Button
    //===========================
    @objc func editBtnTapped(_ sender: UIButton) {
        self.eventState = .edit
        setupHeaderView()
        if let indices = self.addEventTableView.indexPathsForVisibleRows {
            self.addEventTableView.reloadRows(at: indices, with: .none)
        }
    }
    
    //MARK:- addMoreBtnTapped Button
    //==============================
    @objc func addMoreBtnTapped(_ sender: UIButton) {
        print_debug("Add More Btn Tapped")
        let ob = InviteesVC.instantiate(fromAppStoryboard: .Events)
        ob.eventId = self.obEventModel.eventId
        ob.state = .editEvent
        self.navigationController?.pushViewController(ob, animated: true)
    }
    
    //MARK:- editGreetingBtnTapped Button
    //===================================
    @objc func editGreetingBtnTapped(_ sender: UIButton) {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didEditGreeting),
                                               name: NSNotification.Name.DidEditGreeting,
                                               object: nil)
        
        let ob = TypeOfGreetingVC.instantiate(fromAppStoryboard: .Greeting)
        
//        ob.eventDate = self.eventDetailsModel.eventDate
        ob.eventId = self.obEventModel.eventId
        ob.flowType = .events
        //AppDelegate.shared.sharedTabbar?.hideTabbar()
        self.navigationController?.pushViewController(ob, animated: true)
        //        CommonClass.showToast(msg: "Under Development")
        //        print_debug("Edit Greeting Btn Tapped")
    }
    
    //MARK:- textFieldEditingChanged method
    //=====================================
    @objc func textFieldValueChanged(_ sender: UITextField) {
        
        if let text = sender.text {
            self.eventDetailsModel.eventName = text
        }
    }
    
    //MARK:- getFriendIds method
    //==========================
    @objc func getFriendIds(_ notification: Notification) {
        
        if let userInfo = notification.userInfo,
            let friendIds = userInfo["friendIds"] as? [FriendListModel],
            let otherFriends = userInfo["otherIds"] as? [JSONDictionary] {
            
            self.otherFriends = otherFriends
            
            for newFriend in friendIds {
                self.eventDetailsModel.invitees.append(newFriend)
            }
            self.makeUniqueIds()
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
            
            let dateShow = dob.toString(dateFormat: DateFormat.calendarDate.rawValue)
            self.eventDate = dob
            self.eventDetailsModel.eventDate = dateShow
//            self.storeFormData[StringConstants.Date.localized] = dateShow
            self.addEventTableView.reloadRows(at: [[0,2]], with: .none)
        }
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.DidChooseDate,
                                                  object: nil)
    }
 */
    
}

// MARK:- GetResponse Delegate Methods
extension EditEventVC: GetResponseDelegate {

    func nowOrSkipBtnTapped(isOkBtn: Bool) {
        if isOkBtn {
            deleteEvent()
        }
    }
}


//MARK: Extension for Registering Nibs and Setting Up SubViews
//============================================================
extension EditEventVC {
    
    //MARK:- Set Up SubViews method
    //=============================
    fileprivate func setUpInitialViews() {

        pickerView.dataSource = self
        pickerView.delegate = self

        let chatImage = #imageLiteral(resourceName: "icTabChat").withRenderingMode(.alwaysTemplate)
        createChatBtn.setImage(chatImage, for: .normal)

        createChatBtn.isHidden = true
        observeEventCreation()

        self.addEventTableView.delegate         = self
        self.addEventTableView.dataSource       = self
        self.addEventTableView.backgroundColor  = AppColors.whiteColor
        self.acceptRejectViewHeight.constant    = -100
        
        self.acceptBtn.setTitle(StringConstants.K_ACCEPT.localized, for: .normal)
        self.acceptBtn.setTitleColor(AppColors.whiteColor, for: .normal)
        self.acceptBtn.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(16)
        self.acceptBtn.backgroundColor = AppColors.fillGreenColor
        
        self.rejectBtn.setTitle(StringConstants.K_REJECT.localized, for: .normal)
        self.rejectBtn.setTitleColor(AppColors.whiteColor, for: .normal)
        self.rejectBtn.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(16)
        self.rejectBtn.backgroundColor = AppColors.fillRedColor
        
        if self.eventState == .invitation, let event = self.inviteDetails {
            self.acceptRejectViewHeight.constant = 60
            self.hitEventDetails(eventId: event.eventId,
                                 eventCategory: "4",
                                 eventDate: event.eventDate)
        } else {
            self.hitEventDetails(eventId: self.obEventModel.eventId,
                                 eventCategory: self.obEventModel.eventCategory,
                                 eventDate: self.obEventModel.eventStartDate)
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.getFriendIds),
                                                   name: Notification.Name.GetFriendId,
                                                   object: nil)
        }
    }

    private func observeEventCreation() {
        
        let eventId: String
        if self.eventState == .invitation, let event = self.inviteDetails {
            eventId = event.eventId
        } else {
            eventId = self.obEventModel.eventId
        }
        DatabaseReference.child(DatabaseNode.Root.event.rawValue).child(eventId).observe(.value) { [weak self] (snapshot) in

            guard let strongSelf = self else {
                return
            }
            strongSelf.createChatBtn.isHidden = false

            guard let roomId = snapshot.value as? String else {
                return
            }
            strongSelf.chatRoomId = roomId

            //let json = JSON(value)
            //strongSelf.createChatBtn.isHidden = (json != JSON.null)
        }
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

        let eventOwnerCell = UINib(nibName: "EventOwnerCell", bundle: nil)
        self.addEventTableView.register(eventOwnerCell, forCellReuseIdentifier: "EventOwnerCell")

        let attendeeCell = UINib(nibName: "AttendeeCell", bundle: nil)
        self.addEventTableView.register(attendeeCell, forCellReuseIdentifier: "AttendeeCell")

        let moreFriendsCell = UINib(nibName: "MoreFriendsCell", bundle: nil)
        self.addEventTableView.register(moreFriendsCell, forCellReuseIdentifier: "MoreFriendsCellId")
    }
    
    func setUpLayer() {
        
        self.rejectBtn.roundCorners()
        self.acceptBtn.roundCorners()
        self.rejectBtn.layer.borderColor = AppColors.borderRedColor.cgColor
        self.acceptBtn.layer.borderColor = AppColors.borderGreenColor.cgColor
    }
    
    //MARK:- Check for the required data
    //==================================
    func checkForFilledData() -> Bool {
        
        if self.eventDetailsModel.eventName.isEmpty {
            CommonClass.showToast(msg: "Please Enter Event Name")
            return false
        }
        if self.eventDetailsModel.eventType.isEmpty {
            CommonClass.showToast(msg: "Please Select Event Type")
            return false
        }
        if self.eventDetailsModel.eventDate.isEmpty {
            CommonClass.showToast(msg: "Please Enter Event Date")
            return false
        }
        if self.eventDetailsModel.eventTime.isEmpty {
            CommonClass.showToast(msg: "Please Enter Event Time")
            return false
        }
        if isRecurring, self.eventDetailsModel.recurring_type.isEmpty {
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
        
        if self.eventDetailsModel.remindMe.isEmpty {
            return ""
        }
        var reminder = ""
        if let date = self.eventDate {
            
            let strDate = date.toString(dateFormat: DateFormat.commonDate.rawValue)
            var time = self.eventDetailsModel.eventTime
            if time.isEmpty{
                time = "00:00 AM"
            }
            let evDate = strDate + " " + time
            let ndate = evDate.toDate(dateFormat: "dd MM yyyy HH:mm:ss")
            var addInterval:TimeInterval = 0
            let interval = self.eventDetailsModel.remindMe
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
    
    //MARK:- hitEventDetails method
    //=============================
    func hitEventDetails(eventId: String, eventCategory: String, eventDate: String) {
        var params = JSONDictionary()
        
        params["method"]            = StringConstants.K_Event_Details.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["event_id"]          = eventId
        params["event_category"]    = eventCategory
        params["event_date"]        = eventDate
        
        WebServices.getEventDetails(parameters: params, success: { (obEventModel) in
            
            self.eventDetailsModel = obEventModel
            self.setReminderForUser()
            let recurringType = self.eventDetailsModel.recurring_type
            self.isRecurring = recurringType.isEmpty || recurringType == "0" ? false : true
            self.setupHeaderView()
            self.addEventTableView.reloadData()

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
        let alert = UIAlertController(title: "Budfie", message: "The owner has deleted this event!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func setReminderForUser() {
        
        if let date = self.eventDetailsModel.eventDate.toDate(dateFormat: DateFormat.calendarDate.rawValue) {
            self.eventDate = date
        }
        
        if let sTime = "\(self.eventDetailsModel.eventDate) \(self.eventDetailsModel.eventTime)".toDate(dateFormat: DateFormat.shortDate.rawValue),
            let eTime = self.eventDetailsModel.remindMe.toDate(dateFormat: DateFormat.shortDate.rawValue) {
            
            let int = sTime.timeIntervalSince(eTime)
            let days = int.days
            let hours = int.hours
            let mins = int.minutes

            if days > 1 {
                self.eventDetailsModel.remindMe = "\(days) Days"
            } else if days == 1 {
                self.eventDetailsModel.remindMe = "1 Day"
            } else {
                if hours > 1 {
                    self.eventDetailsModel.remindMe = "\(hours) Hours"
                } else if hours == 1 {
                    self.eventDetailsModel.remindMe = "1 Hour"
                } else {
                    if mins > 1 {
                        self.eventDetailsModel.remindMe = "\(mins) Mins"
                    } else if mins == 1 {
                        self.eventDetailsModel.remindMe = "1 Min"
                    } else {
                        self.eventDetailsModel.remindMe = "0 Min"
                    }
                }
            }
        }
    }
    
    //MARK:- makeFriendIds method
    //===========================
    func makeFriendIds() -> String {
        if self.eventDetailsModel.invitees.isEmpty {
            return ""
        }
        var friendDic = [JSONDictionary]()
        for temp in self.eventDetailsModel.invitees {
            var friend = JSONDictionary()
            friend["friend_id"] = temp.friendId
            friendDic.append(friend)
        }
//        for temp in friendIds {
//            friendDic.append(temp)
//        }
        return CommonClass.convertToJson(jsonDic: friendDic)
    }
    
    func makeUniqueIds() {
        
        // FILTER UNIQUE DATA
        var uniqueFriends = [FriendListModel]()
        
        if self.eventDetailsModel.invitees.count > 0 {
            uniqueFriends.append(self.eventDetailsModel.invitees[0])
        } else {
            return
        }
        
        for item in self.eventDetailsModel.invitees {
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
        self.eventDetailsModel.invitees = uniqueFriends
        self.addEventTableView.reloadRows(at: [[2,0]], with: .none)
    }
    
    //MARK:- makeParams method
    //========================
    func makeParams() -> JSONDictionary {
        
        var params = JSONDictionary()
        
        params["method"]            = "edit"
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["event_id"]          = self.obEventModel.eventId
        params["event_name"]        = self.eventDetailsModel.eventName
        params["event_type"]        = self.eventDetailsModel.eventType
        params["event_date"]        = self.eventDetailsModel.eventDate
        params["event_time"]        = self.eventDetailsModel.eventTime
        params["event_location"]    = self.eventDetailsModel.eventLocation
        params["longitude"]         = self.eventDetailsModel.eventLongitude
        params["latitude"]          = self.eventDetailsModel.eventLatitude
        params["remind_me"]         = self.getRemindmeDate()
            //self.eventDetailsModel.remindMe
        params["recurring_type"]    = isRecurring ? self.eventDetailsModel.recurring_type : "0"

        params["event_image"]       = self.eventDetailsModel.eventImage
        params["friends"]           = self.makeFriendIds()

        if self.otherFriends.isEmpty {
            params["contacts"]      = ""
        } else {
            params["contacts"]      = CommonClass.convertToJson(jsonDic: self.otherFriends)
        }
        
        for temp in self.obEventTypeModel {
            if temp.eventType == self.eventDetailsModel.eventType {
                params["event_type"] = temp.id
            }
        }
        return params
    }
    
    //MARK:- hitUpdateEvent method
    //============================
    func hitUpdateEvent() {
        
        var params = JSONDictionary()
        params = self.makeParams()
        
        // Edit Event
        WebServices.editEvent(parameters: params, success: { (isSuccess) in
            
            if isSuccess {
                CommonClass.showToast(msg: "Event Updated Successfully")
                self.delegateForPersonalEvents?.hitMoviesOrConcert(eventState: MoviesConcert.none)
            } else {
                CommonClass.showToast(msg: "Sorry!!! Error")
            }
            
            guard let nav = self.navigationController else { return }
            
            //AppDelegate.shared.sharedTabbar?.showTabbar()
            if !nav.popToClass(type: EventVC.self) {
                nav.popViewController(animated: true)//nav.popToRootViewController(animated: true)
            }
            
        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
    /*
    func acceptRejectClicked(isAccept: Bool, eventId: String) {
        
        var action = String()
        
        if isAccept {
            action = "1"
        } else {
            action = "2"
        }
        
        var params = JSONDictionary()
        
        params["method"]            = StringConstants.K_Accept_Reject.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["event_id"]          = eventId
        params["action"]            = action
        
        WebServices.acceptOrReject(parameters: params, loader: false, success: { (isSuccess) in
            
        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
            
        })
    }
    */
    
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
        }else if status == .notDetermined {
            self.pickLocation()
        }
    }
    
}


//MARK: Extension for Opening Camera or Gallery
//=============================================
extension EditEventVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.eventImage = pickedImage

            let url = "\(Int(Date().timeIntervalSince1970)).png"
            let imageURL = "\(S3_BASE_URL)\(BUCKET_NAME)/\(BUCKET_DIRECTORY)/\(url)"
            
            self.eventDetailsModel.eventImage = imageURL
            hasImageUploaded = false

            pickedImage.uploadImageToS3(imageurl: url,success: { [weak self] (success, url) in

                guard let strongSelf = self else {
                    return
                }

                strongSelf.hasImageUploaded = true
                strongSelf.eventDetailsModel.eventImage = url
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
        }

        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- AddEventsVC Delegate Extension
//=====================================
extension EditEventVC: PushToHomeScreenDelegate {
    
    func pushHomeScreen() {
        let newHomeScreenScene = NewHomeScreenVC.instantiate(fromAppStoryboard: .Login)
        self.navigationController?.pushViewController(newHomeScreenScene, animated: true)
    }
    
}


//MARK:- Google Autocomplete Delegate Extension
//=============================================
extension EditEventVC : GMSPlacePickerViewControllerDelegate {//,GMSAutocompleteViewControllerDelegate {
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {

        self.eventDetailsModel.eventLongitude = "\(place.coordinate.longitude)"
        self.eventDetailsModel.eventLatitude = "\(place.coordinate.latitude)"

        CommonClass.getCity(from: place) { [weak self] city in
            guard let strongSelf = self else {
                return
            }
            strongSelf.setCity(city)
        }
        
        viewController.dismiss(animated: true, completion: nil)
    }

    private func setCity(_ city: String) {
        self.eventDetailsModel.eventLocation = city
        self.addEventTableView.reloadRows(at: [[0,6]], with: .none)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//
//        var loc = CLLocationCoordinate2D()
//        loc = place.coordinate
//        self.eventDetailsModel.eventLongitude = "\(loc.longitude)"
//        self.eventDetailsModel.eventLatitude = "\(loc.latitude)"
//        self.eventDetailsModel.eventLocation = place.name
//
//        self.addEventTableView.reloadRows(at: [[0,3]], with: .none)
//
//        dismiss(animated: true, completion: nil)
//    }
//
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        // TODO: handle the error.
//        print_debug("Error: ", error.localizedDescription)
//    }
//
//    // User canceled the operation.
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//
//    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
    
}


//MARK: Extension: for UIScrollViewDelegate
//=========================================
extension EditEventVC: UIScrollViewDelegate {

    // To make sure tableview do not scrolls more than screenHeight
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if (offsetY <= -screenHeight) {
            scrollView.contentOffset = CGPoint(x: 0, y: (1 - screenHeight))
        }
    }
}

//MARK: Extension: for ShowFriendProfile
//======================================
extension EditEventVC: ShowFriendProfile {
    
    func getFriendId(friendId: String) {
        let scene = ProfileVC.instantiate(fromAppStoryboard: .EditProfile)
        scene.state = .otherProfile
        scene.friendId = friendId
        self.navigationController?.pushViewController(scene, animated: true)
    }
    
}

extension EditEventVC: JumpToGreeting {
    
    func goToPreviewScreen() {
        /*
        var dic = JSONDictionary()
        dic["greeting_id"] = self.eventDetailsModel.greeting_id
        dic["greeting"] = self.eventDetailsModel.greeting
        dic["share_id"] = self.eventDetailsModel.event_owner
        dic["share_time"] = self.eventDetailsModel.greeting_id
        dic["share_by"] = self.eventDetailsModel.first_name
        dic["title"] = self.eventDetailsModel.eventName
        */
        
        let sceneGreetingPreviewVC = GreetingPreviewVC.instantiate(fromAppStoryboard: .Greeting)
        sceneGreetingPreviewVC.flowType = .events

        let greetingList = GreetingListModel(initWithListModel: eventDetailsModel.json["event_details"])
        sceneGreetingPreviewVC.modelGreetingList = greetingList

        //sceneGreetingPreviewVC.modelGreetingList = GreetingListModel(initWithListModel: JSON(dic))
        self.navigationController?.pushViewController(sceneGreetingPreviewVC, animated: true)
    }
    
}

// MARK: PickerView DataSource Methods
extension EditEventVC: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eventType.count
    }
}

// MARK: PickerView Delegate Methods
extension EditEventVC: UIPickerViewDelegate {

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
