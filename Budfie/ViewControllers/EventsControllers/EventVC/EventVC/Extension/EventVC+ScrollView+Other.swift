//
//  EventVC+ScrollView+Other.swift
//  Budfie
//
//  Created by appinventiv on 15/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import WDScrollableSegmentedControl

//MARK:- Extension for WeekViewDelegate, WDScrollableSegmentedControlDelegate Delegate
//====================================================================================
extension EventVC: WDScrollableSegmentedControlDelegate {
    
    func didSelectButton(at index: Int) {
        
        //self.isHandledByWdScrollDelegate = true
        let point = CGPoint(x: CGFloat(index) * scrollViewWidth, y: 0)
        self.horizontalEventScroll.setContentOffset(point, animated: true)
        
        //        switch index {
        //        case 0:
        //            self.childVC.filterEvents(reloadSimple: false)
        //        case 1:
        ////            self.childVC1.filterEvents(reloadSimple: false)
        //            break
        //        case 2:
        //            self.childVC2.filterEvents(reloadSimple: false)
        //        case 3:
        //            self.childVC3.filterEvents(reloadSimple: false)
        //        default:
        //            self.childVC4.filterEvents(reloadSimple: false)
        //        }
        //self.hitService()
        //self.segmentedControl.selectedIndex = index
    }
    
    /*
     func weekViewSelection(weekView: WeekView, didSelectedDate: Date) {
     
     let date = didSelectedDate.toString(dateFormat: "yyyy-MM-dd")
     
     self.childVC.prevselectedDate = date
     self.childVC.filterEvents(reloadSimple: false)
     self.childVC3.prevselectedDate = date
     self.childVC3.filterEvents(reloadSimple: false)
     self.childVC2.prevselectedDate = date
     self.childVC2.filterEvents(reloadSimple: false)
     self.childVC4.prevselectedDate = date
     self.childVC4.filterEvents(reloadSimple: false)
     print_debug("Selected Date :@", didSelectedDate)
     }
     */
}

extension EventVC: EventDelegate {
    
    func eventAdded(date : String) {
        self.selectedDateString = date
        
        if let selectedDate = date.toDate(dateFormat: DateFormat.dOBServerFormat.rawValue) {
            scrollWeekCalendar(to: selectedDate)
        }
        
        self.hitGetEventDates(date: date, reloadSimple: true, loader: false, shouldGetData: true)
        self.didSelectButton(at: 0)
    }
    
}

//MARK: Extension: for hitService Notification
////============================================
//extension EventVC {
//
//    @objc func hitService(_ notification: Notification) {
//
//        if let userInfo = notification.userInfo, let state = userInfo["state"] as? CurrentStatus {
//            if state == .movies {
//                self.childVC2.hitGetMovies(page: 1, reloadSimple: true, loader: false)
//                self.didSelectButton(at: 2)
//            } else if state == .concert {
//                self.childVC3.hitGetConcert(page: 1, reloadSimple: true, loader: false)
//                self.didSelectButton(at: 3)
//            } else if state == .sports {
//                self.didSelectButton(at: 1)
//            } else if state == .personal {
//                self.childVC.getPersonelEvents(page: 1, reloadSimple: true, loader: false)
//                self.didSelectButton(at: 0)
//            }
//        }
//    }
//
//}
//


//MARK:- Extension for SendDateArrayForDots Delegate
//==================================================
extension EventVC: SendDateArrayForDots {
    
    func getDates(state: UserEventsType, eventDates: [Date]) {
        DispatchQueue.global(qos: .background).async {
            if state == .mobile {
                var dateStrings = [String]()
                for date in eventDates {
                    let dateString = date.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
                    dateStrings.append(dateString)
                }
                self.obEventDates.mobileDates = Set(dateStrings)
                self.selectedEventAray = dateStrings
                if self.segmentedControl.selectedIndex == 4 {
                    DispatchQueue.main.async {
                        self.reloadVisibleWeekViewCalendarCells()
                    }
                }
            }
        }
    }
    
    func pendingEvents(count c: Int) {
        self.pendingDot.isHidden = (c == 0) ? true : true
        eventsPendingCount = c
        //        self.childVC.getPersonelEvents(page: 1, reloadSimple: true, loader: false)
    }
}

//MARK:- Extension for GetPendingCount Delegate
//=============================================
extension EventVC : GetPendingCountDelegate {

    func resetPendingCount() {
        self.eventsPendingCount = 0
    }

    func refreshEvents(for date: String) {
        hitGetEventDates(date: date, reloadSimple: true, loader: false, shouldGetData: true)
    }

    /*
     func getPendingCount(date: String) {

     self.eventsPendingCount -= 1
     self.pendingDot.isHidden = self.eventsPendingCount > 0 ? false : true
     self.selectedDateString = date

     if let selectedDate = date.toDate(dateFormat: DateFormat.dOBServerFormat.rawValue) {
     scrollWeekCalendar(to: selectedDate)
     }

     self.hitGetEventDates(date: date, reloadSimple: true, loader: false, shouldGetData: true)
     self.didSelectButton(at: 0)
     }
     */
    
}


//MARK:- Extension for ScrollView Delegate
//========================================
extension EventVC : UIScrollViewDelegate {

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if weekCalendarTableView === scrollView {
            return false
        }
        return true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if weekCalendarTableView === scrollView,
            calendarHeaderView != nil {
            
            if let prevString = prevHeaderMonthString {
                if calendarHeaderView.monthLabel.text != prevString {
                    prevHeaderMonthString = calendarHeaderView.monthLabel.text
                    hitGetEventDates(date: calendarHeaderView.date.toString(dateFormat: DateFormat.dOBServerFormat.rawValue))
                }
                
            } else {
                prevHeaderMonthString = calendarHeaderView.monthLabel.text
                hitGetEventDates(date: calendarHeaderView.date.toString(dateFormat: DateFormat.dOBServerFormat.rawValue))
            }
            
        } else if horizontalEventScroll === scrollView {
            /*
             if !isHandledByWdScrollDelegate {
             
             let index = scrollView.contentOffset.x/scrollViewWidth
             self.segmentedControl.selectedIndex = Int(index)
             }
             */
            
            let offsetX = scrollView.contentOffset.x
            let scrolledIndex = offsetX/scrollViewWidth
            
            if (scrolledIndex.truncatingRemainder(dividingBy: 1) == 0) {
                let index = scrolledIndex
                self.segmentedControl.selectedIndex = Int(index)
                self.setEvents()
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        //self.isHandledByWdScrollDelegate = false
    }
    
    func setEvents(with service: Bool = true) {
        
        switch self.segmentedControl.selectedIndex {
        case 0 :
            selectedEventAray = Array(obEventDates.personalDates)
            if service {
                childVC.serviceHits()
            }
        case 1 :
            selectedEventAray = Array(obEventDates.sportsDates)
            if service {
                childVC1.serviceHits()
            }
        case 2 :
            selectedEventAray = Array(obEventDates.moviesDates)
            if service {
                childVC2.serviceHits()
            }
        case 3 :
            selectedEventAray = Array(obEventDates.concertDates)
            if service {
                childVC3.serviceHits()
            }
        case 4 :
            selectedEventAray = Array(obEventDates.mobileDates)
            if service {
                childVC4.serviceHits()
            }
        default:
            return
        }
        reloadVisibleWeekViewCalendarCells()
    }
    
    func reloadVisibleWeekViewCalendarCells() {
        /*
         if let indices = weekCalendarTableView.indexPathsForVisibleRows {
         weekCalendarTableView.reloadRows(at: indices, with: .none)
         }
         */
        
        for cell in weekCalendarTableView.visibleCells {
            if let weekCalendarCell = cell as? WeekCalendarDateCell,
                let indexPath = weekCalendarTableView.indexPath(for: cell) {
                
                let dateInterval = (TimeInterval(indexPath.row) * timeIntervalOfADay)
                let date = Date(timeIntervalSince1970: dateInterval)
                let serverDateString = date.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
                let isEventSelected = selectedEventAray.contains(serverDateString)
                
                //let isToday = weekCalendarCell.isToday
                weekCalendarCell.prepareForReuse()
                //weekCalendarCell.isToday = isToday
                weekCalendarCell.populate(with: date, isEvent: isEventSelected)
                
                if indexPath == selectedCalendarIndex {
                    weekCalendarTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            }
        }
        
        //weekCalendarTableView.reloadData()
    }
    
    //    fileprivate func setButtonColor(){
    //
    //        if self.horizontalEventScroll.contentOffset.x <= scrollViewWidth / 2 {
    //            self.personalBtn.setTitleColor(AppColors.themeBlueColor, for: .normal)
    //            self.sportsBtn.setTitleColor(AppColors.textFieldBaseLine, for: .normal)
    //            self.movieBtn.setTitleColor(AppColors.textFieldBaseLine, for: .normal)
    //            self.mobileEventBtn.setTitleColor(AppColors.textFieldBaseLine, for: .normal)
    //
    //        } else if self.horizontalEventScroll.contentOffset.x <= 3 * scrollViewWidth / 2 {
    //
    //            self.personalBtn.setTitleColor(AppColors.textFieldBaseLine, for: .normal)
    //            self.sportsBtn.setTitleColor(AppColors.themeBlueColor, for: .normal)
    //            self.movieBtn.setTitleColor(AppColors.textFieldBaseLine, for: .normal)
    //            self.mobileEventBtn.setTitleColor(AppColors.textFieldBaseLine, for: .normal)
    //
    //        } else if self.horizontalEventScroll.contentOffset.x <= 4 * scrollViewWidth / 2 {
    //
    //            self.personalBtn.setTitleColor(AppColors.textFieldBaseLine, for: .normal)
    //            self.sportsBtn.setTitleColor(AppColors.textFieldBaseLine, for: .normal)
    //            self.movieBtn.setTitleColor(AppColors.themeBlueColor, for: .normal)
    //            self.mobileEventBtn.setTitleColor(AppColors.textFieldBaseLine, for: .normal)
    //
    //        } else {
    //            self.personalBtn.setTitleColor(AppColors.textFieldBaseLine, for: .normal)
    //            self.sportsBtn.setTitleColor(AppColors.textFieldBaseLine, for: .normal)
    //            self.movieBtn.setTitleColor(AppColors.textFieldBaseLine, for: .normal)
    //            self.mobileEventBtn.setTitleColor(AppColors.themeBlueColor, for: .normal)
    //        }
    //    }
}


