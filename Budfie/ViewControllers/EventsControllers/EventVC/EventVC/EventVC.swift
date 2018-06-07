//
//  EventVC.swift
//  Budfie
//
//  Created by yogesh singh negi on 14/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit
import WDScrollableSegmentedControl
import RealmSwift

class EventVC: BaseVc {
    
    //MARK:- Properties
    //=================
    var eventsPendingCount = 0 {
        didSet {
            pendingDot.isHidden = (eventsPendingCount == 0)
            if eventsPendingCount < 10 {
                pendingNotificationCountLbl.text = "\(eventsPendingCount)"
            } else {
                pendingNotificationCountLbl.text = "9+"
            }
        }
    }
    var widthCalendar   : CGFloat = 0
    var childVC         : ChildEventVC!
    var childVC1        : ChildEventVC!
    var childVC2        : ChildEventVC!
    var childVC3        : ChildEventVC!
    var childVC4        : ChildEventVC!
    //var calendarView    : WeekView!
    var w:CGFloat       = 0.0
    var frame           = CGRect()
    //    var personalDate    = [Date]()
    //    var moviesDate      = [Date]()
    //    var concertDate     = [Date]()
    //    var mobileDate      = [Date]()
    var obEventDates = EventDatesModel()
    var segmentedControl : WDScrollableSegmentedControl!
    //var isHandledByWdScrollDelegate = false
    var pageNumber: Int {
        return Int(ceil(self.horizontalEventScroll.contentOffset.x / scrollViewWidth))
    }

    var isFirstTime     = true
    var selectedDateString = ""
    var selectedEventAray = [String]()
    var selectedCalendarIndex: IndexPath?
    var prevHeaderMonthString: String?

    let scrollViewWidth = screenWidth - 70
    let scrollViewheight = screenHeight - 140
    
    // initial date time interval in week calendar view
    let timeIntervalOfADay: TimeInterval = (60 * 60 * 24)
    
    var calendarHeaderView: WeekCalendarDateCell!
    var hasViewAppearedOnce = false
    
    //MARK:- @IBOutlets
    //=================
    
    @IBOutlet weak var topBarScrollView: UIView!
    @IBOutlet weak var shadowView: UIView!
    //    @IBOutlet weak var sliderBar: UIView!
    //    @IBOutlet weak var mobileEventBtn: UIButton!
    //    @IBOutlet weak var sportsBtn: UIButton!
    //    @IBOutlet weak var personalBtn: UIButton!
    //    @IBOutlet weak var movieBtn: UIButton!
    //    @IBOutlet weak var sliderLeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var navigationView: CurvedNavigationView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var backBtnName: UIButton!
    //    @IBOutlet weak var topTabView: UIView!
    //@IBOutlet weak var sideCalendarView: UIView!
    @IBOutlet weak var floatCalendarBtn: UIButton!
    @IBOutlet weak var horizontalEventScroll: UIScrollView!
    @IBOutlet weak var invitaionBtn: UIButton!
    @IBOutlet weak var pendingDot: UIView!
    @IBOutlet weak var pendingNotificationCountLbl: UILabel!
    @IBOutlet weak var weekCalendarTableView: UITableView!

    //MARK:- view life cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedDateString = Date().toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
        
        self.initialSetup()
        self.setupScrollBarButtons()
        self.setupChildControllers()
        self.hitGetEventDates(date: selectedDateString, reloadSimple: false, loader: false)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.hitUpdatedInterest),
                                               name: Notification.Name.InterestUpdated,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.eventAdded(_ :)),
                                               name: Notification.Name.EventAdded,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didSelectEventDate),
                                               name: NSNotification.Name.DidChooseDate,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.performCreateEventAnimation()
        hasViewAppearedOnce = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.setUpCreateEventAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        self.addShadow()
        self.segmentedControl.frame = self.topBarScrollView.bounds
        
        if !hasViewAppearedOnce {
            scrollWeekCalendar(to: Date())
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- IBACTIONS
    //================
    @IBAction func personalBtnTapped() {
        
        self.horizontalEventScroll.setContentOffset(CGPoint(x: 0, y: 0),
                                                    animated: true)
    }
    
    @IBAction func sportsBtnTapped() {
        
        self.horizontalEventScroll.setContentOffset(CGPoint(x: scrollViewWidth, y: 0), animated: true)
    }
    
    @IBAction func moviesBtnTapped() {
        
        self.horizontalEventScroll.setContentOffset(CGPoint(x: 2*scrollViewWidth, y: 0), animated: true)
    }
    
    
    @IBAction func mobileBtnTapped() {
        
        self.horizontalEventScroll.setContentOffset(CGPoint(x: 3*scrollViewWidth, y: 0), animated: true)
    }
    
    @IBAction func landingPageBtnTapped(_ sender: UIButton) {
        //        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        //        print_debug(self.navigationController?.parent?.navigationController?.viewControllers)
//        self.navigationController?.parent?.navigationController?.popViewController(animated: true)
        //        print_debug(self.navigationController?.parent?.navigationController?.viewControllers)
    }
    
    @IBAction func floatBtnTapped(_ sender: UIButton) {
        
        let obAddEventsVC = AddEventsVC.instantiate(fromAppStoryboard: .Events)
        //AppDelegate.shared.sharedTabbar?.hideTabbar()
        obAddEventsVC.delegate = self
        self.navigationController?.pushViewController(obAddEventsVC, animated: true)
    }
    
    @IBAction func invitationBtnTapped(_ sender: UIButton) {
        //AppDelegate.shared.sharedTabbar?.hideTabbar()
        let ob = InvitationVC.instantiate(fromAppStoryboard: .Events)
//        let ob = NotificationsVC.instantiate(fromAppStoryboard: .Settings)
        ob.delegate = self
        self.navigationController?.pushViewController(ob, animated: true)
    }
    
    @objc func hitUpdatedInterest() {
        self.obEventDates.personalDates.removeAll()
        self.obEventDates.sportsDates.removeAll()
        self.obEventDates.moviesDates.removeAll()
        self.obEventDates.concertDates.removeAll()
        self.childVC.prevSelectedDate = ""
        self.childVC1.prevSelectedDate = ""
        self.childVC2.prevSelectedDate = ""
        self.childVC3.prevSelectedDate = ""
        self.hitGetEventDates(date: selectedDateString, reloadSimple: true, loader: false)
    }
    
    @objc func eventAdded(_ notification: Notification) {
        
        //        self.navigationController?.popViewController(animated: true)
        
        if let user = notification.userInfo, let eventD = user["eventDate"] as? String {
            self.selectedDateString = eventD
            
            if let selectedDate = eventD.toDate(dateFormat: DateFormat.dOBServerFormat.rawValue) {
                scrollWeekCalendar(to: selectedDate)
            }
            
            self.hitGetEventDates(date: eventD, reloadSimple: true, loader: false, shouldGetData: true)
            self.didSelectButton(at: 0)
        }
    }
    
    @objc func didSelectEventDate(_ notification: Notification) {
        
        /*
         guard let tabbar = AppDelegate.shared.sharedTabbar,
         let navCont = tabbar.navigationController else {
         return
         }
         navCont.popToViewController(tabbar, animated: true)
         */
        guard let _ = self.navigationController?.popToClass(type: TabBarVC.self)
            else {
                return
        }
        self.navigationController?.popToViewController(self, animated: true)
        
        if let userInfo = notification.userInfo, let eventDate = userInfo["eventDate"] as? Date {
            scrollWeekCalendar(to: eventDate)
            selectedDateString = eventDate.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
            hitGetEventDates(date: selectedDateString)
            self.hitService(loader: true)
            
            NotificationCenter.default.removeObserver(self,
                                                      name: Notification.Name.DidChooseDate,
                                                      object: nil)
        }
    }
}

//MARK: Extension: for Registering Nibs and Setting Up SubViews
//=============================================================
extension EventVC {
    
    func setupChildControllers() {
        
        horizontalEventScroll.isPagingEnabled = true
        horizontalEventScroll.contentSize = CGSize(width: 5 * scrollViewWidth, height: 1)
        self.horizontalEventScroll.delegate = self
        
        self.childVC = ChildEventVC.instantiate(fromAppStoryboard: .Events)
        self.childVC.state = .personal
        self.childVC.delegate = self
        self.childVC.view.frame.origin = CGPoint(x: 0, y: 0)
        self.horizontalEventScroll.frame = self.childVC.view.frame
        self.horizontalEventScroll.addSubview(self.childVC.view)
        self.addChildViewController(self.childVC)
        self.childVC.didMove(toParentViewController: self)
        
        self.childVC1 = ChildEventVC.instantiate(fromAppStoryboard: .Events)
        self.childVC1.state = .sport
        self.childVC1.delegate = self
        self.childVC1.view.frame.origin = CGPoint(x: scrollViewWidth, y: 0)
        self.horizontalEventScroll.frame = self.childVC1.view.frame
        self.horizontalEventScroll.addSubview(self.childVC1.view)
        self.addChildViewController(self.childVC1)
        self.childVC1.didMove(toParentViewController: self)
        
        self.childVC2 = ChildEventVC.instantiate(fromAppStoryboard: .Events)
        self.childVC2.state = .movies
        self.childVC2.delegate = self
        self.childVC2.view.frame.origin = CGPoint(x: 2 * scrollViewWidth, y: 0)
        self.horizontalEventScroll.frame = self.childVC2.view.frame
        self.horizontalEventScroll.addSubview(self.childVC2.view)
        self.addChildViewController(self.childVC2)
        self.childVC2.didMove(toParentViewController: self)
        
        self.childVC3 = ChildEventVC.instantiate(fromAppStoryboard: .Events)
        self.childVC3.state = .concert
        self.childVC3.delegate = self
        self.childVC3.view.frame.origin = CGPoint(x: 3 * scrollViewWidth, y: 0)
        self.horizontalEventScroll.frame = self.childVC3.view.frame
        self.horizontalEventScroll.addSubview(self.childVC3.view)
        self.addChildViewController(self.childVC3)
        self.childVC3.didMove(toParentViewController: self)
        
        self.childVC4 = ChildEventVC.instantiate(fromAppStoryboard: .Events)
        self.childVC4.state = .mobile
        self.childVC4.delegate = self
        self.childVC4.view.frame.origin = CGPoint(x: 4 * scrollViewWidth, y: 0)
        self.horizontalEventScroll.frame = self.childVC4.view.frame
        self.horizontalEventScroll.addSubview(self.childVC4.view)
        self.addChildViewController(self.childVC4)
        self.childVC4.didMove(toParentViewController: self)
    }
    
    func addShadow() {
        
        self.shadowView.layer.shadowOffset = CGSize.zero
        self.shadowView.layer.shadowColor   = UIColor.black.cgColor
        self.shadowView.layer.shadowOpacity = 1.0
        self.shadowView.layer.shadowRadius  = 10.0
        self.shadowView.layer.masksToBounds = false
    }
    
    func setupScrollBarButtons() {
        
        //        self.personalBtn.setTitle("Personal", for: .normal)
        //        self.sportsBtn.setTitle("Movies", for: .normal)
        //        self.movieBtn.setTitle("Concert", for: .normal)
        //        self.mobileEventBtn.setTitle("Phone", for: .normal)
        //        self.sliderBar.backgroundColor = AppColors.themeBlueColor
        //        self.personalBtn.setTitleColor(AppColors.themeBlueColor, for: .normal)
        //        self.sportsBtn.setTitleColor(AppColors.textFieldBaseLine, for: .normal)
        //        self.movieBtn.setTitleColor(AppColors.textFieldBaseLine, for: .normal)
        //        self.mobileEventBtn.setTitleColor(AppColors.textFieldBaseLine, for: .normal)
    }
    
    private func initialSetup() {

        weekCalendarTableView.dataSource = self
        weekCalendarTableView.delegate = self
        weekCalendarTableView.backgroundColor = .clear
        weekCalendarTableView.isPagingEnabled = false
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = weekCalendarTableView.bounds
        print_debug("weekCalendarTableView.bounds: \(weekCalendarTableView.bounds)")
        gradient.colors = [AppColors.themeBlueColor.cgColor, AppColors.themeLightBlueColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        weekCalendarTableView.layer.insertSublayer(gradient, at: 0)
        
        // set header view.
        self.navigationView.backgroundColor = AppColors.whiteColor//UIColor.clear
        self.statusBar.backgroundColor = AppColors.themeBlueColor
        self.navigationTitle.textColor = AppColors.whiteColor
        self.navigationTitle.text = StringConstants.K_Planner.localized
        self.navigationTitle.font = AppFonts.AvenirNext_Medium.withSize(20)
        self.backBtnName.setImage(AppImages.eventsHomeLogo, for: .normal)
        
        //        self.personalBtn.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(13,
        //                                                                                  iphone6: 14,
        //                                                                                  iphone6p: 15)
        //        self.sportsBtn.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(13,
        //                                                                                iphone6: 14,
        //                                                                                iphone6p: 15)
        //        self.movieBtn.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(13,
        //                                                                               iphone6: 14,
        //                                                                               iphone6p: 15)
        //        self.mobileEventBtn.titleLabel?.font = AppFonts.Comfortaa_Regular_0.withSize(13,
        //                                                                                     iphone6: 14,
        //                                                                                     iphone6p: 15)
        //
        self.pendingDot.isHidden = true
        self.pendingDot.round()
        self.pendingDot.backgroundColor = AppColors.calendarEventPink
        self.floatCalendarBtn.setImage(AppImages.icCalander, for: .normal)
        self.floatCalendarBtn.backgroundColor = AppColors.themeBlueColor
        self.floatCalendarBtn.roundCornerWith(radius: self.floatCalendarBtn.frame.width/2)
        self.floatCalendarBtn.dropShadow(width: 5.0, shadow: AppColors.floatBtnShadow)
        self.shadowView.dropShadow(width: 3, shadow: AppColors.shadowViewColor)
        
        self.setUpCreateEventAnimation()
        //self.addCalenderView()
        self.instantiateSegmentControl()
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.hitService(_:)), name: NSNotification.Name("hitCommonService"), object: nil)
    }
    
    func instantiateSegmentControl() {
        
        self.segmentedControl = WDScrollableSegmentedControl(frame: self.topBarScrollView.bounds)
        self.topBarScrollView.addSubview(segmentedControl)
        
        self.segmentedControl.buttons = ["Favorites", "Sports", "Movies", "Events", "Phone"]
        self.segmentedControl.font = AppFonts.Comfortaa_Bold_0.withSize(16,
                                                                        iphone6: 17,
                                                                        iphone6p: 17)
        //        self.segmentedControl.buttonColor = AppColors.blackColor
        self.segmentedControl.setButtonColor(AppColors.themeBlueColor, for: .highlighted)
        self.segmentedControl.setButtonColor(AppColors.themeBlueColor, for: .selected)
        self.segmentedControl.indicatorColor = AppColors.themeBlueColor
        self.segmentedControl.indicatorHeight = 5.0
        self.segmentedControl.setButtonColor(AppColors.menuBarColor, for: .normal)
        
        self.segmentedControl.delegate = self
    }
    
    func scrollWeekCalendar(to date: Date) {
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        var dateComponents = DateComponents()
        dateComponents.year = 1970
        
        if let initialDate = calendar.date(from: dateComponents) {
            let components = calendar.dateComponents([.day], from: initialDate, to: startOfDay)
            
            if let noOfDays = components.day {
                let indexPath = IndexPath(row: noOfDays, section: 0)
                weekCalendarTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                selectedCalendarIndex = indexPath
            }
        }
    }
    
    //func addCalenderView() {
    
    //        if screenWidth > 376{
    //            calendarView = WeekView(frame: CGRect(x: 0, y: 0, width: self.sideCalendarView.width, height: screenHeight - 120))
    //        }else{
    //
    //        calendarView = WeekView(frame: CGRect(x: 0, y: 0, width: self.sideCalendarView.width, height: screenHeight - 130))
    //        //   }
    //        calendarView.weekStartDate = Date()
    //        calendarView.backgroundColor = UIColor.groupTableViewBackground
    //        calendarView.delegate = self
    //        let date = Date().toString(dateFormat: "yyyy-MM-dd")
    //        self.childVC.selectedcurDate = date
    //        self.childVC3.selectedcurDate = date
    //        self.childVC3.filterEvents()
    //        self.childVC.filterEvents()
    //        self.childVC.eventTableView.reloadData()
    //        self.childVC3.eventTableView.reloadData()
    //        self.sideCalendarView.addSubview(calendarView)
    //}
    
    //MARK:- hitGetEventDates method
    //==============================
    func hitGetEventDates(date: String, reloadSimple: Bool = true, loader: Bool = false, shouldGetData: Bool = true) {
        
        var params = JSONDictionary()
        params["method"]            = StringConstants.K_Get_Event_Dates.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token
        params["event_month"]       = date
        
        WebServices.getEventDates(parameters: params, loader: loader, success: { obEventDateModel in
            
            let mobileDates = self.obEventDates.mobileDates

            self.obEventDates.personalDates.formUnion(obEventDateModel.personalDates)
            self.obEventDates.moviesDates.formUnion(obEventDateModel.moviesDates)
            self.obEventDates.concertDates.formUnion(obEventDateModel.concertDates)
            self.obEventDates.sportsDates.formUnion(obEventDateModel.sportsDates)

            self.obEventDates.mobileDates = mobileDates
            //self.reloadVisibleWeekViewCalendarCells()

            if shouldGetData {
                self.setEvents()
            } else {
                self.setEvents(with: (!self.hasViewAppearedOnce))
            }

        }, failure: { (error) in

            if let realm = try? Realm() {
                let dates = realm.objects(RealmEvent.self).map({ event -> String in
                    if let date = event.startDate.toDate(dateFormat: DateFormat.calendarDate.rawValue) {
                        return date.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
                    } else {
                        return event.startDate
                    }
                })
                self.obEventDates.personalDates.formUnion(Set(dates))
            }

            if shouldGetData {
                self.setEvents()
            } else {
                self.setEvents(with: (!self.hasViewAppearedOnce))
            }
            //CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
    func hitService(loader: Bool = false) {
        
        switch self.segmentedControl.selectedIndex {
        case 0:
            self.childVC.getPersonelEvents(page: 1, reloadSimple: false, loader: loader)
        case 1:
            self.childVC1.hitGetSports(page: 1, reloadSimple: false, loader: loader)
        case 2:
            self.childVC2.hitGetMovies(page: 1, reloadSimple: false, loader: loader)
        case 3:
            self.childVC3.hitGetConcert(page: 1, reloadSimple: false, loader: loader)
        default:
            self.childVC4.filterEvents(reloadSimple: loader)
            //fetchEventsForMobileCalender()
            //self.childVC4.getPersonelEvents(page: 1, reloadSimple: false, loader: false)
            break
        }
    }
    
    func setUpCreateEventAnimation() {
        floatCalendarBtn.transform = CGAffineTransform(scaleX: 0.02, y: 0.02)
    }
    
    func performCreateEventAnimation() {
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.5,
                       options: .curveEaseInOut,
                       animations: {
                        self.floatCalendarBtn.transform = .identity
        }, completion: nil)
    }
    
}

