//
//  ChildEventVC.swift
//  Budfie
//
//  Created by yogesh singh negi on 14/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import EmptyDataSet_Swift
import RealmSwift

enum UserEventsType {
    case personal
    case movies
    case sport
    case mobile
    case concert
    case none
}

protocol SendDateArrayForDots: class {
    func getDates(state: UserEventsType, eventDates: [Date])
    func pendingEvents(count c: Int)
}

class ChildEventVC: BaseVc {

    //MARK: Enum
    enum ApiState {
        case failed
        case noData(Bool, String?)
        case loading
    }

    //MARK:- Properties
    //=================
    var store                   = EKEventStore()
    var state                   = UserEventsType.none
    var calenderEventDict       = [EventModel]()
    var AllcalenderEventDict    = [EventModel]()
    var googleEvents            = [EventModel]()
    //    var obConcertModel          = [ConcertModel]()
    //    var AllConcertModel         = [ConcertModel]()
    //    var obMoviesSeriesModel     = [MoviesSeriesModel]()
    //    var allMoviesSeriesModel    = [MoviesSeriesModel]()
    var selectedcurDate: String {
        if let eventScene = self.parent as? EventVC {
            return eventScene.selectedDateString
        }
        return Date().toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
    }

    var apiState: ApiState = .loading {
        didSet {
            eventTableView.reloadEmptyDataSet()
        }
    }

    var prevSelectedDate = ""
    var selectedDate            : Date?
    weak var delegate           : SendDateArrayForDots?
    var indexPath               : IndexPath?
    fileprivate var hasFetchedPhoneEvents = false
    fileprivate let refreshControl = UIRefreshControl()

    //MARK:- @IBOutlets
    //=================
    @IBOutlet weak var eventTableView       : UITableView!
    @IBOutlet weak var lineView             : UIView!
    @IBOutlet weak var noRecordFoundLabel   : UILabel!
    @IBOutlet weak var underDevelopmentLabel: UILabel!
    @IBOutlet weak var addInterestBtn       : UIButton!
    @IBOutlet weak var noDataFoundImage     : UIImageView!
    
    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedDate = Date()
//        self.serviceHits()
        
        self.initialSetup()
        self.registerNibs()
        self.setUpPullToRefresh()
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        refreshData()
    }

    fileprivate func refreshData() {
        self.prevSelectedDate = ""
        apiState = .loading

        switch state {
        case .personal:
            getPersonelEvents(page: 1, reloadSimple: false)
        case .movies:
            hitGetMovies(page: 1, reloadSimple: false)
        case .sport:
            hitGetSports(page: 1, reloadSimple: false)
        case .mobile:
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        case .concert:
            hitGetConcert(page: 1, reloadSimple: false)
        case .none:
            break
        }
    }
    
    //MARK:- @IBActions
    //=================
    @IBAction func addInterestBtnTapped() {
        
        let ob = AddInterestsVC.instantiate(fromAppStoryboard: .Login)
        if self.state == .concert {
            ob.viewStatus = .concert
        } else if self.state == .movies {
            ob.viewStatus = .movies
        } else if self.state == .sport {
            ob.viewStatus = .sports
        }
        ob.hitInterestList(loader: true)
        //AppDelegate.shared.sharedTabbar?.hideTabbar()
        self.navigationController?.pushViewController(ob, animated: true)
    }
    
    @objc func editBtnTapped(_ sender: UIButton) {
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.eventTableView) else { return }
        
        if self.state == .personal {

            let event = self.calenderEventDict[indexPath.row]

            if event.eventCategory == "4" {
                //AppDelegate.shared.sharedTabbar?.hideTabbar()

                if event.eventType == "Holiday" {

                    let holidayPlannerEventScene = HolidayPlannerEventVC.instantiate(fromAppStoryboard: .HolidayPlanner)
                    holidayPlannerEventScene.plannerEvent = event
                    holidayPlannerEventScene.vcState = .editing
                    self.navigationController?.pushViewController(holidayPlannerEventScene, animated: true)

                } else {
                    let ob = EditEventVC.instantiate(fromAppStoryboard: .Events)
                    ob.obEventModel = event
                    ob.eventState = .edit
                    ob.delegateForPersonalEvents = self
                    self.navigationController?.pushViewController(ob, animated: true)
                }

            } else {
                self.unFavBtnTapped(sender)
            }
        }
    }
    
    @objc func unFavBtnTapped(_ sender: UIButton) {
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.eventTableView) else { return }
        self.indexPath = indexPath
        
        if self.calenderEventDict[indexPath.row].isFavourite == "1" {
            let controller = InviteFriendsPopUpVC.instantiate(fromAppStoryboard: .Events)
            controller.pageState = .favUnFav
            controller.delegate = self
            controller.modalPresentationStyle = .overCurrentContext
            present(controller, animated: false, completion: nil)
        } else {
            self.favUnFav()
        }
    }
}


//MARK: Extension: for Registering Nibs and Setting Up SubViews
//=============================================================
extension ChildEventVC {
    
    private func initialSetup() {
        
        self.eventTableView.delegate        = self
        self.eventTableView.dataSource      = self
        self.eventTableView.contentInset.top = 10
        
        //Empty Data Set
        self.eventTableView.emptyDataSetSource = self
        self.eventTableView.emptyDataSetDelegate = self
        //self.settingEmptyDataSet(nextDate: "")
        
        self.underDevelopmentLabel.isHidden = true
        self.lineView.isHidden              = true
        self.noRecordFoundLabel.isHidden    = true
        self.noDataFoundImage.isHidden      = true//false
        self.lineView.backgroundColor       = AppColors.lineColor
        self.noRecordFoundLabel.textColor   = AppColors.textFieldBaseLine
        self.noRecordFoundLabel.font        = AppFonts.Comfortaa_Bold_0.withSize(20)
        self.addInterestBtn.isHidden        = true
        
        if AppUserDefaults.value(forKey: AppUserDefaults.Key.googleEvent) == "1" || AppUserDefaults.value(forKey: AppUserDefaults.Key.facebookEvent) == "1" {
            EventsCoreDataController.fetchAllEventsFromLocalDB({ (obEvent) in
                self.googleEvents = obEvent
            })
        }
    }
    
    private func registerNibs() {
        
        let cell = UINib(nibName: "ShowEventCell", bundle: nil)
        self.eventTableView.register(cell, forCellReuseIdentifier: "ShowEventCellId")
    }
    
    func setUpPullToRefresh() {
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self,
                                 action: #selector(self.refresh(refreshControl:)),
                                 for: UIControlEvents.valueChanged)
        self.eventTableView.addSubview(refreshControl)
    }
    
    func serviceHits() {
        
        self.prevSelectedDate = (self.selectedDate?.toString(dateFormat: DateFormat.calendarDate.rawValue)) ?? ""
        let shouldReloadSimple = (eventTableView.numberOfRows(inSection: 0) > 0)

        if self.state == .personal {
            self.getPersonelEvents(page: 1, reloadSimple: shouldReloadSimple)
        } else if self.state == .mobile {
            self.fetchEventsForMobileCalender()
        } else if self.state == .concert {
            self.hitGetConcert(page: 1, reloadSimple: shouldReloadSimple)
        } else if self.state == .movies {
            self.hitGetMovies(page: 1, reloadSimple: shouldReloadSimple)
        } else if self.state == .sport {
            self.hitGetSports(page: 1, reloadSimple: shouldReloadSimple)
        }
    }
    
    func getPersonelEvents(page: Int, reloadSimple: Bool, loader: Bool = false) {

        let currentSelectedDate = self.selectedcurDate
        if currentSelectedDate == self.prevSelectedDate {
            return
        }
        self.prevSelectedDate = currentSelectedDate

        var params = JSONDictionary()
        params["method"]        = StringConstants.K_Fetch_Personal_Events.localized
        params["access_token"]  = AppDelegate.shared.currentuser.access_token
        params["page"]          = String(page)
        params["event_date"]    = currentSelectedDate

//        if let date = self.selectedDate {
//            params["event_date"] = date.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
//        }
        WebServices.getPersonalEvent(parameters: params, loader: loader, success: { (success, events) in

            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }

            //self.settingEmptyDataSet(isLoading: "2", nextDate: events.next_event_date)
            self.apiState = .noData(true, events.next_event_date)

//            if page == 1 {
                self.calenderEventDict = events.eventArray
//            } else {
               // self.calenderEventDict.append(contentsOf: events.eventModel)
            //}

            self.calenderEventDict.forEach({ event in

                guard let userId = AppDelegate.shared.currentuser?.user_id else {
                    return
                }
                let shouldSaveEvent = (event.isFavourite == "1") || (userId == event.userId)

                if shouldSaveEvent, let realm = try? Realm() {
                    try? realm.write {
                        realm.add(event.realmEvent, update: true)
                    }
                }
            })


            if self.googleEvents.isEmpty {
                let shouldReloadSimple = (reloadSimple || events.eventArray.isEmpty)
                self.AllcalenderEventDict = self.calenderEventDict
                self.showHideNoData(reloadSimple: shouldReloadSimple)
            } else {
                self.calenderEventDict.append(contentsOf: self.googleEvents)
                self.AllcalenderEventDict = self.calenderEventDict
                self.filterGoogleEvents(reloadSimple: true)
            }
//            self.calenderEventDict.append(contentsOf: self.googleEvents)
//            self.AllcalenderEventDict = self.calenderEventDict
//            self.showHideNoData(reloadSimple: reloadSimple)
//            self.filterGoogleEvents(reloadSimple: true)

            if let vc = self.parent as? EventVC {
                vc.eventsPendingCount = events.pendingEventsCount
            }
            self.delegate?.pendingEvents(count: events.pendingEventsCount)

        }) { (error) in

            if let realm = try? Realm() {
                self.AllcalenderEventDict = realm.objects(RealmEvent.self).map({ event in
                    return event.appEvent
                })
                self.filterGoogleEvents(reloadSimple: true)
            }
            self.apiState = .failed

            //CommonClass.showToast(msg: error.localizedDescription)
        }
    }
    
    func filterEvents(reloadSimple: Bool) {
        
        var nextDate = ""
        
        var currentSelectedDate = self.selectedcurDate
        if currentSelectedDate == self.prevSelectedDate {
            return
        }
        self.prevSelectedDate = currentSelectedDate
        
        self.calenderEventDict = self.AllcalenderEventDict.filter { event in
            
            let dateString = event.eventStartDate
            var components = dateString.split(separator: "-")
            components.reverse()
            let reversedDateString = components.joined(separator: "-")
            
            return currentSelectedDate == reversedDateString
        }
        
        if self.AllcalenderEventDict.count > 0 {
            
            var datesArray = [Date]()
            
            for temp in self.AllcalenderEventDict {
                if let date = temp.eventStartDate.toDate(dateFormat: DateFormat.calendarDate.rawValue) {
                    datesArray.append(date)
                }
            }
            let dateSet = Set(datesArray)
            self.delegate?.getDates(state: self.state, eventDates: Array(dateSet))
            
            var components = currentSelectedDate.split(separator: "-")
            components.reverse()
            currentSelectedDate = components.joined(separator: "-")
            
            guard let currDate = currentSelectedDate.toDate(dateFormat: DateFormat.calendarDate.rawValue) else {
                return
            }
            
            /*
            let dateArray = Array(dateSet).sorted()
            var minDate = dateArray[0]
            var maxDate = dateArray[0]
            
            for index in 0..<dateArray.count {
                if dateArray[index] < currDate {
                    minDate = dateArray[index]
                }
            }
            */
            
            var dateArray = [Date]()
            
            for date in Array(dateSet) {
                let str = date.toString(dateFormat: DateFormat.calendarDate.rawValue)
                if let dstr = str.toDate(dateFormat: DateFormat.calendarDate.rawValue) {
                    dateArray.append(dstr)
                }
            }
            dateArray = dateArray.filter { $0 > currDate }
            dateArray = dateArray.sorted()
            if let firstElement = dateArray.first {
                nextDate = firstElement.toString(dateFormat: DateFormat.calendarDate.rawValue)
            }
        }

        DispatchQueue.main.async {
            AppNetworking.hideLoader()

            if self.calenderEventDict.isEmpty {
                self.lineView.isHidden = true
                //            self.noRecordFoundLabel.isHidden = false
                //            self.noDataFoundImage.isHidden = true//false
            } else {
                self.lineView.isHidden = false
                //            self.noRecordFoundLabel.isHidden = true
                //            self.noDataFoundImage.isHidden = true//true
            }

            //self.settingEmptyDataSet(isLoading: "2", nextDate: nextDate)
            self.apiState = .noData(true, nextDate)

            if reloadSimple {
                self.eventTableView.reloadData()
            } else {
                self.eventTableView.reloadEmptyDataSet()
                self.eventTableView.reloadSections([0], with: .left)
            }
        }
    }
    
    func filterGoogleEvents(reloadSimple : Bool) {
        
        var components = self.selectedcurDate.split(separator: "-")
        components.reverse()
        let reversedDateString = components.joined(separator: "-")
        
        self.calenderEventDict = self.AllcalenderEventDict.filter { event in
            
            return (event.eventStartDate == reversedDateString) || (event.eventStartDate == self.selectedcurDate)
        }
        
        if calenderEventDict.isEmpty {
            self.lineView.isHidden = true
            //            self.noRecordFoundLabel.isHidden = false
            //            self.noDataFoundImage.isHidden = true//false
        } else {
            self.lineView.isHidden = false
            //            self.noRecordFoundLabel.isHidden = true
            //            self.noDataFoundImage.isHidden = true//true
        }

        //self.settingEmptyDataSet(isLoading: "2", nextDate: "")
        self.apiState = .noData(true, nil)

        if reloadSimple {
            self.eventTableView.reloadData()
        } else {
            self.eventTableView.reloadEmptyDataSet()
            self.eventTableView.reloadSections([0], with: .left)
        }
        
    }
    
    func showHideNoData(reloadSimple : Bool) {

        let shouldReloadSimple = (reloadSimple && !calenderEventDict.isEmpty)

        if calenderEventDict.isEmpty {
            self.lineView.isHidden = true
//            self.noRecordFoundLabel.isHidden = false
//            self.noDataFoundImage.isHidden = true//false
        } else {
            self.lineView.isHidden = false
//            self.noRecordFoundLabel.isHidden = true
//            self.noDataFoundImage.isHidden = true
        }
        if shouldReloadSimple {
            self.eventTableView.reloadData()
        } else {
            self.eventTableView.reloadEmptyDataSet()
            self.eventTableView.reloadSections([0], with: .left)
        }
        //self.eventTableView.reloadData()
    }
    
    //    func filterEventsConcert() {
    //
    //        if  self.selectedcurDate.isEmpty {
    //            return
    //        }
    //        self.obConcertModel = self.AllConcertModel.filter {
    //            self.selectedcurDate == $0.concertDate
    //        }
    //        if self.obConcertModel.isEmpty {
    //            self.lineView.isHidden = true
    //            self.noRecordFoundLabel.isHidden = false
    //        } else {
    //            self.lineView.isHidden = false
    //            self.noRecordFoundLabel.isHidden = true
    //        }
    //        self.eventTableView.reloadSections([0], with: .left)
    //    }
    
    //    func filterEventsMovies() {
    //
    //        if  self.selectedcurDate.isEmpty {
    //            return
    //        }
    ////        self.obMoviesSeriesModel = self.allMoviesSeriesModel.filter {
    ////            self.selectedcurDate == $0.moviesReleaseDate
    ////        }
    //        self.obMoviesSeriesModel = self.allMoviesSeriesModel
    //        if self.obMoviesSeriesModel.isEmpty {
    //            self.lineView.isHidden = true
    //            self.noRecordFoundLabel.isHidden = false
    //        } else {
    //            self.lineView.isHidden = false
    //            self.noRecordFoundLabel.isHidden = true
    //        }
    //        self.eventTableView.reloadSections([0], with: .left)
    //    }
    
    //MARK:- hitGetConcert method
    //===========================
    func hitGetConcert(page: Int, reloadSimple: Bool, loader: Bool = false) {

        let currentSelectedDate = self.selectedcurDate
        if currentSelectedDate == self.prevSelectedDate {
            return
        }
        self.prevSelectedDate = currentSelectedDate

        var params = JSONDictionary()
        params["method"]            = StringConstants.K_Get_Concerts.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token//AppDelegate.shared.currentuser.access_token
        params["page"]              = String(page)
        params["city"]              = ""
        params["event_date"]        = currentSelectedDate

//        if let date = self.selectedDate {
//            params["event_date"] = date.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
//        }

//        self.selectedcurDate = ""

        // Get Concert
        WebServices.getConcert(parameters: params, loader: loader, success: { (isData, obConcertModel) in

            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }

            if isData {

                //self.settingEmptyDataSet(isLoading: "2", nextDate: obConcertModel.next_event_date)
                self.apiState = .noData(true, obConcertModel.next_event_date)

                //if page == 1 {
                    self.calenderEventDict = obConcertModel.eventArray
//                } else {
//                    self.calenderEventDict.append(contentsOf: obConcertModel)
//                }
                self.AllcalenderEventDict = self.calenderEventDict
                self.showHideNoData(reloadSimple: reloadSimple)
//                self.eventTableView.reloadData()

//                self.filterEvents(reloadSimple: reloadSimple)
            }
            else {
                //self.settingEmptyDataSet(isLoading: "3", nextDate: obConcertModel.next_event_date)
                self.apiState = .noData(false, obConcertModel.next_event_date)

                self.emptyTableData()
                self.interestNotSelected()
            }
        }, failure: { (error) in
            self.apiState = .failed
            //CommonClass.showToast(msg: error.localizedDescription)
        })
        
    }
    
    //MARK:- hitGetSports method
    //==========================
    func hitGetSports(page: Int, reloadSimple: Bool, loader: Bool = false) {
        
        let currentSelectedDate = self.selectedcurDate
        if currentSelectedDate == self.prevSelectedDate {
            return
        }
        self.prevSelectedDate = currentSelectedDate
        
        var params = JSONDictionary()
        params["method"]            = StringConstants.K_Get_Soccer_Data.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token//AppDelegate.shared.currentuser.access_token
        params["page"]              = String(page)
        params["event_date"]        = currentSelectedDate
        
        //        if let date = self.selectedDate {
        //            params["event_date"] = date.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
        //        }
        
        //        self.selectedcurDate = ""
        
        // Get sports
        WebServices.getSports(parameters: params, loader: loader, success: { (isData, obSportsModel) in

            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }

            if isData {

                //self.settingEmptyDataSet(isLoading: "2", nextDate: obSportsModel.next_event_date)
                self.apiState = .noData(true, obSportsModel.next_event_date)

                //if page == 1 {
                self.calenderEventDict = obSportsModel.eventArray
                //                } else {
                //                    self.calenderEventDict.append(contentsOf: obConcertModel)
                //                }
                self.AllcalenderEventDict = self.calenderEventDict
                self.showHideNoData(reloadSimple: reloadSimple)
            }
            else {

                //self.settingEmptyDataSet(isLoading: "3", nextDate: obSportsModel.next_event_date)
                self.apiState = .noData(false, obSportsModel.next_event_date)

                self.emptyTableData()
            }
        }, failure: { (error) in
            self.apiState = .failed
            //CommonClass.showToast(msg: error.localizedDescription)
        })
        
    }
    
    func interestNotSelected() {
        
//        self.addInterestBtn.isHidden = false
//        self.noRecordFoundLabel.text = "You have'nt selected this Interest yet"
//        self.noRecordFoundLabel.font = AppFonts.Comfortaa_Bold_0.withSize(12)
//        self.noRecordFoundLabel.isHidden = false
//        self.noDataFoundImage.isHidden = true
    }
    
    //MARK:- hitGetMovies method
    //==========================
    func hitGetMovies(page: Int, reloadSimple: Bool, loader: Bool = false) {

        let currentSelectedDate = self.selectedcurDate
        if currentSelectedDate == self.prevSelectedDate {
            return
        }
        self.prevSelectedDate = currentSelectedDate

        var params = JSONDictionary()
        params["method"]            = StringConstants.K_Get_Movies.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token//AppDelegate.shared.currentuser.access_token
        params["page"]              = String(page)
        params["event_date"]        = currentSelectedDate

//        if let date = self.selectedDate {
//            params["event_date"] = date.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
//        }

        // Get Movies
        WebServices.getMovies(parameters: params, loader: loader, success: { (isData, obMoviesSeriesModel) in
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }

            if isData {

                //self.settingEmptyDataSet(isLoading: "2", nextDate: obMoviesSeriesModel.next_event_date)
                self.apiState = .noData(true, obMoviesSeriesModel.next_event_date)

               // if page == 1 {
                    self.calenderEventDict = obMoviesSeriesModel.eventArray
//                } else {
//                    self.calenderEventDict.append(contentsOf: obMoviesSeriesModel)
//                }
                self.AllcalenderEventDict = self.calenderEventDict
                self.showHideNoData(reloadSimple: reloadSimple)
//                self.filterEvents(reloadSimple: reloadSimple)
            } else {

                //self.settingEmptyDataSet(isLoading: "3", nextDate: obMoviesSeriesModel.next_event_date)
                self.apiState = .noData(false, obMoviesSeriesModel.next_event_date)

                self.emptyTableData()
                self.interestNotSelected()
            }
            
        }, failure: { (error) in
            self.apiState = .failed
            //CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
    func emptyTableData() {
        self.AllcalenderEventDict.removeAll()
        self.calenderEventDict.removeAll()
        self.eventTableView.reloadData()
    }
    
    //MARK:- hitFavourite method
    //==========================
    func hitFavourite(action: String, type: String, event: EventModel) {
        
        var params = JSONDictionary()
        params["method"]            = StringConstants.K_Add_Remove_Favourite.localized
        params["access_token"]      = AppDelegate.shared.currentuser.access_token//AppDelegate.shared.currentuser.access_token
        params["action"]            = action
        params["type"]              = type
        params["type_id"]           = event.eventId
        
        WebServices.addFavourite(parameters: params, loader: false, success: { (isSuccess) in

            if let realm = try? Realm() {
                if action == "1" { // 1 denotes has to make favourite

                    let realmEvent = event.realmEvent
                    try? realm.write {
                        realm.add(realmEvent, update: true)
                    }

                } else if action == "2" { // 2 denotes has to remove from favourite

                    try? realm.write {
                        realm.delete(realm.objects(RealmEvent.self).filter("id=%@",event.eventId))
                    }
                }
            }

            if type == "1" {
//                self.hitGetMovies(page: 1, reloadSimple: true)
            } else if type == "2" {
//                self.hitGetConcert(page: 1, reloadSimple: true)
            }
            //self.getPersonelEvents(page: 1, reloadSimple: true)
            if let vc = self.parent as? EventVC {
                vc.hitGetEventDates(date: self.selectedcurDate, reloadSimple: true, loader: false)
                vc.childVC.prevSelectedDate = ""
                vc.childVC.getPersonelEvents(page: 1, reloadSimple: true)
            }
            self.eventTableView.reloadData()

        }, failure: { (error) in
            CommonClass.showToast(msg: error.localizedDescription)
        })
    }
    
    func favUnFav() {

        guard Connectivity.isConnectedToInternet else {
            CommonClass.showToast(msg: StringConstants.INTERNET_NOT_CONNECTED.localized)
            return
        }

        guard let indexPath = self.indexPath else { return }
        let row = indexPath.row
        
        var movieOrConcert = "0"
        var action = "0"
        let model = self.calenderEventDict[row]
        
        if model.isFavourite == "0" {
            action = "1"
            model.isFavourite = "1"
        } else {
            action = "2"
            model.isFavourite = "0"
        }
        if self.state == .movies {
            movieOrConcert = "1"
        } else if self.state == .concert {
            movieOrConcert = "2"
        } else if self.state == .sport {
            
            if model.sportType == "1" {
                movieOrConcert = "4"
            } else if model.sportType == "2" {
                movieOrConcert = "3"
            } else if model.sportType == "3" {
                movieOrConcert = "5"
            } else if model.sportType == "4" {
                movieOrConcert = "6"
            }
        } else {
            movieOrConcert = model.eventCategory
            if model.sportType == "1" {
                movieOrConcert = "4"
            } else if model.sportType == "2" {
                movieOrConcert = "3"
            } else if model.sportType == "3" {
                movieOrConcert = "5"
            } else if model.sportType == "4" {
                movieOrConcert = "6"
            }
        }
        self.calenderEventDict[row] = model
        self.hitFavourite(action: action, type: movieOrConcert, event: model)
    }
}

//MARK:- GetResponseDelegate Delegate Extension
//=============================================
extension ChildEventVC: GetResponseDelegate {
    
    func nowOrSkipBtnTapped(isOkBtn: Bool) {
        if isOkBtn {
            self.favUnFav()
        } else {
            return
        }
    }
    
}


extension ChildEventVC: HitMoviesOrConcertAPI {
    
    func hitMoviesOrConcert(eventState: MoviesConcert) {
        prevSelectedDate = ""
        if eventState == .movies {
            self.hitGetMovies(page: 1, reloadSimple: false)
        } else if eventState == .concert {
            self.hitGetConcert(page: 1, reloadSimple: false)
        } else if eventState == .sports {
            self.hitGetSports(page: 1, reloadSimple: false)
        }
//        self.getPersonelEvents(page: 1, reloadSimple: true, eventState: eventState)
        if let vc = self.parent as? EventVC {
            vc.childVC.getPersonelEvents(page: 1, reloadSimple: true)
            vc.obEventDates.personalDates.removeAll()
            vc.hitGetEventDates(date: vc.selectedDateString, reloadSimple: true, loader: false)
        }
    }
    
}

//MARK:- Extension for EmptyDataSetSource, EmptyDataSetDelegate
//=============================================================
extension ChildEventVC : EmptyDataSetSource, EmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {

        let title: String

        switch apiState {
        case .failed:
            title = "Wake Up Your Connection"

        case .noData(let isInterested, _):
            if isInterested {
                switch state {
                case .personal:
                    title = "Oops..No Favourites Found"
                case .movies:
                    title = "Oops..No Movies Found"
                case .sport:
                    title = "Oops..No Sports Found"
                case .mobile:
                    title = "Oops..No Phone Events Found"
                case .concert:
                    title = "Oops..No Events Found"
                case .none:
                    title = StringConstants.K_No_Events_Interest.localized
                }
            } else {
                title = StringConstants.K_No_Events_Interest.localized
            }

        case .loading:
            //title = StringConstants.K_Loading_Your_Favourites.localized
            return nil
        }

        let attributes: [NSAttributedStringKey: Any] = [.foregroundColor: UIColor.black,
                                                        .font: AppFonts.AvenirNext_Regular.withSize(17)]
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        return attributedString
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {

        let description: String

        switch apiState {
        case .failed:
            description = "Your internet seems too slow to reach our server."

        case .noData(let isInterested, let nextDate):
            if isInterested {

                if let dateString = nextDate,
                    let date = dateString.toDate(dateFormat: DateFormat.calendarDate.rawValue) {

                    let nextDateString = date.toString(dateFormat: DateFormat.showProfileDate.rawValue)
                    description = StringConstants.K_Near_Event.localized + "\n" + nextDateString

                } else {
                    switch state {

                    case .personal:
                        description = StringConstants.K_No_Personal_Events.localized
                    case .concert:
                        description = StringConstants.K_No_Concert_Events.localized
                    case .sport:
                        description = StringConstants.K_No_Sports_Events.localized
                    case .movies:
                        description = StringConstants.K_No_Movies_Events.localized
                    case .mobile:
                        description = StringConstants.K_No_Mobile_Events.localized
                    default:
                        description = StringConstants.K_No_Data.localized
                    }
                }

            } else {
                description = StringConstants.K_Click_Add_Interest.localized
            }

        case .loading:
            switch state {
            case .personal:
                description = "Loading all your favorites"
            case .movies:
                description = "Loading all your movies"
            case .sport:
                description = "Loading all your sports"
            case .mobile:
                description = "Loading all your phone events"
            case .concert:
                description = "Loading all your events"
            case .none:
                description = StringConstants.K_Loading_Your_Favourites.localized
            }
        }

        let attributes: [NSAttributedStringKey: Any] = [.foregroundColor: AppColors.textGrayColor,
                                                        .font: AppFonts.Comfortaa_Regular_0.withSize(15)]
        let attributedString = NSAttributedString(string: description, attributes: attributes)
        return attributedString
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        switch apiState {
        case .failed:
            return #imageLiteral(resourceName: "icWakeupConnection")
        case .noData(_):
            return #imageLiteral(resourceName: "icNoResultFound")
            /*
             case .noData(let isInterested, _):
             if isInterested {
             return #imageLiteral(resourceName: "icNoResultFound")
             }
             return nil
             */
        case .loading:
            return nil
        }
    }

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {

        let buttonTitle: String

        switch apiState {
        case .failed:
            buttonTitle = "Try Again"

        case .noData(let isInterested, _):
            if isInterested {
                //buttonTitle = "Okay, Thanks"
                return nil
            } else {
                buttonTitle = "Add Interests"
            }

        case .loading:
            return nil
        }

        let attributes: [NSAttributedStringKey: Any] = [.foregroundColor: AppColors.themeBlueColor,
                                                        .font: AppFonts.AvenirNext_Regular.withSize(17)]
        let attributedString = NSAttributedString(string: buttonTitle, attributes: attributes)
        return attributedString
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        switch apiState {
        case .failed:
            refreshData()
        case .noData(let interested, _):
            if !interested {
                addInterestBtnTapped()
            }
        case .loading:
            break
        }
    }

    /*MARK:- settingEmptyDataSet method
    //=================================
    func settingEmptyDataSet(isLoading: String = "1", nextDate: String) {

        var placeholder = ""
        var dec = ""
        var nextDate = nextDate

        if let date = nextDate.toDate(dateFormat: DateFormat.calendarDate.rawValue) {
            nextDate = date.toString(dateFormat: DateFormat.showProfileDate.rawValue)
        }

        if isLoading == "1" {
            placeholder = StringConstants.K_Loading_Your_Favourites.localized//"Loading..."
        } else if isLoading == "2" {

            if !nextDate.isEmpty {
                //                nextDate = "Next Event is on \(nextDate)"
                placeholder = StringConstants.K_Near_Event.localized
            } else {

            }
        } else {
            placeholder = StringConstants.K_No_Events_Interest.localized
            dec = StringConstants.K_Click_Add_Interest.localized
        }

        let myAttribute = [NSAttributedStringKey.font: AppFonts.Comfortaa_Bold_0.withSize(18),
                           NSAttributedStringKey.foregroundColor: AppColors.noDataFound]
        let stringPlaceholder = NSAttributedString(string: placeholder, attributes: myAttribute)

        let myAttribute3 = [NSAttributedStringKey.font: AppFonts.Comfortaa_Bold_0.withSize(15),
                            NSAttributedStringKey.foregroundColor: AppColors.noDataFound]
        let stringNextDate = NSAttributedString(string: nextDate, attributes: myAttribute3)

        let myAttribute2 = [NSAttributedStringKey.font: AppFonts.Comfortaa_Bold_0.withSize(16),
                            NSAttributedStringKey.foregroundColor: AppColors.themeBlueColor]
        let stringdec = NSAttributedString(string: dec, attributes: myAttribute2)

        self.eventTableView.emptyDataSetView { view in
            view.titleLabelString(stringPlaceholder)
                .detailLabelString(stringNextDate)
                //                .image(AppImages.icNodata)
                //                .imageAnimation(imageAnimation)
                .buttonTitle(stringdec, for: .normal)
                .buttonTitle(stringdec, for: .highlighted)
                //                .buttonBackgroundImage(buttonBackgroundImage, for: .normal)
                //                .buttonBackgroundImage(buttonBackgroundImage, for: .highlighted)
                //                .dataSetBackgroundColor(backgroundColor)
                //                .verticalOffset(verticalOffset)
                //                .verticalSpace(spaceHeight)
                //                .shouldDisplay(true, view: tableView)
                //                .shouldFadeIn(true)
                //                .isTouchAllowed(true)
                //                .isScrollAllowed(true)
                .isImageViewAnimateAllowed(true)
                .didTapDataButton {
                    // Do something
                    self.addInterestBtnTapped()
                }
                .didTapContentView {
                    // Do something
            }
        }
    }
    */
}

//MARK: Extension: for Fetch events for mobile(iOS) calender
//==========================================================
extension ChildEventVC {
    
    //MARK:-Fetch events for mobile(iOS) calender
    //:-
     func fetchEventsForMobileCalender() {

        guard !hasFetchedPhoneEvents else {
            return
        }
        print_debug("--------Fetch Events for mobile iOS calender-------")

        store.requestAccess(to: EKEntityType.event) { [weak self] ( granted, error ) in
            guard let strongSelf = self else {
                return
            }

            if granted {
                AppNetworking.showLoader()
            }

            let currentDate = Date()
            strongSelf.hasFetchedPhoneEvents = true

            if let startDate = Calendar.current.date(byAdding: .year, value: -2, to: currentDate),
                let endDate = Calendar.current.date(byAdding: .year, value: 2, to: currentDate) {

                let predicate = strongSelf.store.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
                let events = strongSelf.store.events(matching: predicate)

                DispatchQueue.global(qos: .background).async {
                    strongSelf.setEventsData(events)
                }
            }
        }
    }
    
    func setEventsData(_ events: [EKEvent]) {
        
        self.calenderEventDict.removeAll()
        for event in events {

            guard let eventStartDate = event.startDate,
                let eventEnddate = event.endDate else {
                    continue
            }

            let calendarDateFormat = DateFormat.calendarDate.rawValue
            let shortTimeFormat = DateFormat.fullTime.rawValue

            let sdate = eventStartDate.toString(dateFormat: calendarDateFormat)
            let stime = eventStartDate.toString(dateFormat: shortTimeFormat)
            let edate = eventEnddate.toString(dateFormat: calendarDateFormat)
            let etime = eventEnddate.toString(dateFormat: shortTimeFormat)

            let eventsList: JSONDictionary = [
                
                "event_type": "1",
                "event_start_date": sdate,
                "evetn_end_date": edate,
                "event_start_time": stime,
                "event_end_time": etime,
                "type": "2",
                "event_name": (event.title ?? ""),
                "event_details": (event.notes ?? ""),
                "event_location":(event.location ?? "")
            ]
            let model = EventModel(initForEventModel: eventsList)
            self.calenderEventDict.append(model)
        }

        self.AllcalenderEventDict = self.calenderEventDict

        self.filterEvents(reloadSimple: true)
        //self.eventTableView.reloadSections([0], with: .left)
    }
}

