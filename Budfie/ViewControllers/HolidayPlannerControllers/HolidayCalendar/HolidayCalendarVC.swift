//
//  HolidayCalendarVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 19/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import FSCalendar

protocol UpdateYearDelegate: class {
    func didChangeYear(_ yearString: String, monthHolidays: [[[Holiday]]])
}

class HolidayCalendarVC: BaseVc {

    // MARK: Public Properties
    var moveToDate: Date?
    var monthHolidays = [[[Holiday]]]()
    var selectableYears: [String] = []
    weak var delegate: UpdateYearDelegate?
    var vcType: CalendarFlowType = .holidayPlan

    // MARK: Private Properties
    fileprivate var calendarCellHeight: CGFloat = 300
    fileprivate var selectedYear = "" {
        didSet {
            yearBtn.setTitle(selectedYear, for: .normal)
        }
    }
    fileprivate var selectedMonth = 0
    fileprivate var fsCalendar: FSCalendar?

    // MARK: IBOutlets
    @IBOutlet weak var holidayCalendarTableView: UITableView!
    @IBOutlet weak var planHolidayBtn: UIButton!

    @IBOutlet weak var monthNameLbl: UILabel!
    @IBOutlet weak var yearBtn: UIButton!
    @IBOutlet weak var backgroundMonthImageView: UIImageView!
    @IBOutlet weak var holidayPlannerBtn: UIButton!
    
    // MARK: ViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        holidayCalendarTableView.dataSource = self
        holidayCalendarTableView.delegate = self
        
        holidayCalendarTableView.contentInset.bottom = 60
        holidayCalendarTableView.contentInset.top = 35
        
        self.holidayPlannerBtn.roundCommonButtonPositive(title: "PLAN A HOLIDAY")//(title: "PLAN A HOLIDAY")
        self.holidayPlannerBtn.roundCornerWith(radius: self.holidayPlannerBtn.frame.height/2)

        planHolidayBtn.addQualityShadow(ofColor: UIColor.black)

        let calendar = Calendar.current

        if let date = moveToDate {

            let yearValue = calendar.component(.year, from: date)
            let monthValue = calendar.component(.month, from: date)
            configureCalendar(for: monthValue)

            selectedYear = yearValue.toString
            selectedMonth = (monthValue - 1)

        } else {

            let currentDate = Date()
            let monthValue = calendar.component(.month, from: currentDate)
            configureCalendar(for: monthValue)
        }

        switch vcType {
        case .holidayPlan, .exploreMore:
            break

        case .birthDate, .eventDate:
            planHolidayBtn.setTitle("Choose this date", for: .normal)
        }

        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(tableViewSwiped))
        rightSwipeGesture.direction = .right
        //rightSwipeGesture.cancelsTouchesInView = false
        holidayCalendarTableView.addGestureRecognizer(rightSwipeGesture)

        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(tableViewSwiped))
        leftSwipeGesture.direction = .left
        //leftSwipeGesture.cancelsTouchesInView = false
        holidayCalendarTableView.addGestureRecognizer(leftSwipeGesture)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        holidayCalendarTableView.beginUpdates()
        holidayCalendarTableView.endUpdates()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let date = moveToDate {

            fsCalendar?.setCurrentPage(date, animated: false)
            moveToDate = nil

            switch vcType {
            case .holidayPlan, .exploreMore:
                setSelectedHolidays(on: fsCalendar)

            case .birthDate, .eventDate:
                fsCalendar?.allowsMultipleSelection = false
            }
        }
    }

    // MARK: - Private functions
    private func configureVisibleCells() {

        fsCalendar?.visibleCells().forEach { (cell) in
            let date = cell.calendar.date(for: cell)
            let position = cell.calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }

    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {

        let calendarCellIndexPath = IndexPath(row: 0, section: 0)

        guard let calendarRangeSelectionCell = cell as? FSCalendarRangeSelectionCell,
            let cell = holidayCalendarTableView.cellForRow(at: calendarCellIndexPath) as? CalendarTableCell else {
                return
        }

        // Configure selection layer
        if position == .current {

            var selectionType = SelectionType.none

            if cell.calendar.selectedDates.contains(date) {

                let calendar = Calendar.current

                if cell.calendar.selectedDates.contains(date),
                    let previousDate = calendar.date(byAdding: .day, value: -1, to: date),
                    let nextDate = calendar.date(byAdding: .day, value: 1, to: date) {

                    if cell.calendar.selectedDates.contains(previousDate) && cell.calendar.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if cell.calendar.selectedDates.contains(previousDate) &&
                        cell.calendar.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    }
                    else if cell.calendar.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                calendarRangeSelectionCell.selectionLayer.isHidden = true
                return
            }
            calendarRangeSelectionCell.selectionLayer.isHidden = false
            calendarRangeSelectionCell.selectionType = selectionType

        } else {
            calendarRangeSelectionCell.selectionLayer.isHidden = true
        }
    }

    private func showChooseLongWeekendActionSheet() {

        guard let unwrappedFSCalendar = fsCalendar else {
            return
        }

        var longWeekends = [[Date]]()
        let sortedSelectedDates = unwrappedFSCalendar.selectedDates.sorted()

        let calendar = Calendar.current
        let currentCalendarDate = unwrappedFSCalendar.currentPage
        let components = calendar.dateComponents([.year, .month], from: currentCalendarDate)

        guard let startOfMonth = calendar.date(from: components),
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) else {
                return
        }

        var previousSelectedDate: Date?
        var adjacentSelectedDates = [Date]()

        for date in sortedSelectedDates {

            guard startOfMonth <= date && date <= endOfMonth  else {
                continue
            }

            if let unwrappedPrevSelDate = previousSelectedDate {
                if let nextDate = calendar.date(byAdding: .day, value: 1, to: unwrappedPrevSelDate),
                    nextDate.compare(date) == .orderedSame {

                } else {

                    if !adjacentSelectedDates.isEmpty {
                        longWeekends.append(adjacentSelectedDates)
                        adjacentSelectedDates.removeAll()
                    }
                }
            }

            adjacentSelectedDates.append(date)
            previousSelectedDate = date
        }

        if !adjacentSelectedDates.isEmpty {
            longWeekends.append(adjacentSelectedDates)
            adjacentSelectedDates.removeAll()
        }

        guard !longWeekends.isEmpty else {
            CommonClass.showToast(msg: "Select your holidays first")
            return
        }

        let actionSheet = UIAlertController(title: "Choose Dates", message: nil, preferredStyle: .actionSheet)

        for dates in longWeekends {

            guard let holidayStartDate = dates.first,
                let holidayEndDate = dates.last else {
                    continue
            }

            let dateFormat = "dd-MM-yyy"
            let currentDate = Date()
            let startDateString = holidayStartDate.toString(dateFormat: dateFormat)
            let endDateString = holidayEndDate.toString(dateFormat: dateFormat)
            let holidayActionTitle = "\(startDateString) to \(endDateString)"

            let holidayAction = UIAlertAction(title: holidayActionTitle, style: .default, handler: { _ in

                if holidayEndDate < currentDate {
                    CommonClass.showToast(msg: "Cannot plan a holiday for past dates")

                } else if holidayStartDate == holidayEndDate {
                    CommonClass.showToast(msg: "Cannot plan a holiday for one day")

                } else {
                    let createHolidayPlannerScene = CreateHolidayPlannerVC.instantiate(fromAppStoryboard: .HolidayPlanner)
                    createHolidayPlannerScene.fromDate = holidayStartDate
                    createHolidayPlannerScene.toDate = holidayEndDate
                    self.navigationController?.pushViewController(createHolidayPlannerScene, animated: true)
                }
            })
            actionSheet.addAction(holidayAction)
        }

        let cancelAction = UIAlertAction(title: StringConstants.Cancel.localized, style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)

        present(actionSheet, animated: true, completion: nil)
    }

    private func selectCalendarDate() {
        if let selectedDate = fsCalendar?.selectedDate {

            let userInfo: [AnyHashable : Any]

            switch vcType {
            case .eventDate:
                //AppDelegate.shared.sharedTabbar?.showTabbar()
                userInfo = ["eventDate": selectedDate]
            case .birthDate:
                userInfo = ["birthDate": selectedDate]
            case .holidayPlan, .exploreMore:
                return
            }
            NotificationCenter.default.post(name: NSNotification.Name.DidChooseDate,
                                            object: nil,
                                            userInfo: userInfo)

        } else {
            CommonClass.showToast(msg: "Please select a date first")
        }
    }

    @objc private func tableViewSwiped(_ gesture: UISwipeGestureRecognizer) {

        guard let fsCalendar = self.fsCalendar else {
            return
        }

        switch gesture.direction {
        case .right:
            let gregorianCalendar = Calendar.current
            let currentPage = fsCalendar.currentPage

            if let previousMonth = gregorianCalendar.date(byAdding: .month, value: -1, to: currentPage) {
                fsCalendar.setCurrentPage(previousMonth, animated: true)
            }

        case .left:
            let gregorianCalendar = Calendar.current
            let currentPage = fsCalendar.currentPage

            if let nextMonth = gregorianCalendar.date(byAdding: .month, value: 1, to: currentPage) {
                fsCalendar.setCurrentPage(nextMonth, animated: true)
            }

        default:
            break
        }
    }

    // MARK: IBActions
    @IBAction func planHolidayBtnTapped(_ sender: UIButton) {

        switch vcType {
        case .holidayPlan, .exploreMore:
            showChooseLongWeekendActionSheet()
        case .birthDate, .eventDate:
            selectCalendarDate()
        }
    }

    @IBAction func yearBtnTapped(_ sender: UIButton) {

        FTPopOverMenu.showForSender(sender: sender,
                                    with: selectableYears,
                                    done: { selectedIndex in

                                        let selectedYear = self.selectableYears[selectedIndex]

                                        guard self.selectedYear != selectedYear else {
                                            return
                                        }

                                        self.selectedYear = selectedYear
                                        sender.setTitle(selectedYear, for: .normal)

                                        switch self.vcType {
                                        case .holidayPlan, .exploreMore:
                                            self.getHolidays(for: selectedYear)
                                        case .birthDate, .eventDate:
                                            self.delegate?.didChangeYear(selectedYear, monthHolidays: self.monthHolidays)
                                        }

                                        var components = DateComponents()
                                        components.year = Int(selectedYear)
                                        components.month = (self.selectedMonth + 1)

                                        if let date = Calendar.current.date(from: components) {
                                            self.fsCalendar?.setCurrentPage(date, animated: false)
                                        }

        }, cancel: {

        })
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        if self.vcType == .eventDate {
            //AppDelegate.shared.sharedTabbar?.showTabbar()
        }
        navigationController?.popViewController(animated: true)
    }
}

extension HolidayCalendarVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        switch vcType {
        case .holidayPlan, .exploreMore:
            return 2
        case .birthDate, .eventDate:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if monthHolidays.isEmpty {
            return 0
        }
        return monthHolidays[selectedMonth].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableCell", for: indexPath) as? CalendarTableCell else {
                fatalError("CalendarTableCell not found")
            }
            
            cell.calendar.dataSource = self
            cell.calendar.delegate = self
            fsCalendar = cell.calendar
            
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LongWeekEndTableCell", for: indexPath) as? LongWeekEndTableCell else {
            fatalError("LongWeekEndTableCell not found")
        }

        let holidays = monthHolidays[selectedMonth][indexPath.row]
        cell.holidays = holidays

        return cell
    }
}

extension HolidayCalendarVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200//height(forRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height(forRowAt: indexPath)
    }

    private func height(forRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let tableTopBottonPadding: CGFloat = 20
            let calendarHeaderHeight: CGFloat = 36
            return (calendarCellHeight + tableTopBottonPadding - calendarHeaderHeight)
        }
        let numberOfHolidays = monthHolidays[selectedMonth][indexPath.row].count
        let heightForHolidayCell = WeekEndTableCell.cellHeight
        let numberOfDecorations = 2
        let heightForDecorationCell = WeekEndTopDecorationTableCell.cellHeight
        let tableTopBottonPadding = 20
        return CGFloat((numberOfHolidays * heightForHolidayCell) + (numberOfDecorations * heightForDecorationCell) + tableTopBottonPadding)
    }
}

extension HolidayCalendarVC: FSCalendarDataSource {
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        
        let gregorianCalendar = Calendar.current
        var dateComponents = DateComponents()
        let currentDate = Date()
        
        if let firstYearString = selectableYears.first {
            dateComponents.year = Int(firstYearString)
            
        } else {
            let yearString = currentDate.toString(dateFormat: "yyyy")
            dateComponents.year = Int(yearString)
        }
        
        if let minDate = gregorianCalendar.date(from: dateComponents) {
            return minDate
        }
        return currentDate
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        
        let gregorianCalendar = Calendar.current
        var dateComponents = DateComponents()
        let currentDate = Date()
        
        if let lastYearString = selectableYears.last {
            dateComponents.month = 12
            dateComponents.year = Int(lastYearString)
            
        } else {
            let yearString = currentDate.toString(dateFormat: "yyyy")
            dateComponents.month = 12
            dateComponents.year = Int(yearString)
        }
        
        if let maxDate = gregorianCalendar.date(from: dateComponents),
            let range = gregorianCalendar.range(of: .day, in: .month, for: maxDate) {
            dateComponents.day = range.upperBound - 1
            if let monthLastDate = gregorianCalendar.date(from: dateComponents) {
                return monthLastDate
            }
            return maxDate
        }
        return currentDate
    }

    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "FSCalendarRangeSelectionCell", for: date, at: position)
        return cell
    }

    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }

    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return nil
    }
}

extension HolidayCalendarVC: FSCalendarDelegate {

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarCellHeight = bounds.height
        print_debug("bounds.height: \(bounds.height)")
        holidayCalendarTableView.beginUpdates()
        holidayCalendarTableView.endUpdates()
    }

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {

        let calendar = Calendar.current
        let currentDate = Date()
        let startOfCurrentDate = calendar.startOfDay(for: currentDate)
        let startOfShouldSelectDate = calendar.startOfDay(for: date)

        switch vcType {
        case .holidayPlan:
            return (monthPosition == .current) && (startOfShouldSelectDate >= startOfCurrentDate)
        case .birthDate, .eventDate, .exploreMore:
            return (monthPosition == .current)
        }
    }

    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {

        /*
         switch vcType {
         case .holidayPlan, .exploreMore:
         return false
         case .birthDate, .eventDate:
         return (monthPosition == .current)
         }
         */

        return (monthPosition == .current)
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureVisibleCells()
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        self.configureVisibleCells()
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {

        let calendarDate = calendar.currentPage

        let year = Calendar.current.component(.year, from: calendarDate)
        let yearString = year.toString

        let monthValue = Calendar.current.component(.month, from: calendarDate)
        selectedMonth = (monthValue - 1)
        configureCalendar(for: monthValue)

        switch vcType {
        case .holidayPlan, .exploreMore:
            holidayCalendarTableView.reloadSections([1], with: .fade)
        case .birthDate, .eventDate:
            break
        }

        if selectedYear != yearString {

            switch vcType {
            case .holidayPlan, .exploreMore:
                getHolidays(for: yearString)
            case .birthDate, .eventDate:
                selectedYear = yearString
            }

            delegate?.didChangeYear(yearString, monthHolidays: monthHolidays)

        } else {
            //holidayCalendarTableView.reloadSections([1], with: .fade)
        }
    }

    private func configureCalendar(for monthValue: Int) {
        if let month = Month(rawValue: monthValue) {
            monthNameLbl.text = month.name
            backgroundMonthImageView.image = month.largeImage
        }
    }

    private func getHolidays(for year: String) {

        WebServices.getHolidays(for: year, success: { [weak self] holidays in

            guard let strongSelf = self else {
                return
            }

            strongSelf.monthHolidays = holidays
            strongSelf.selectedYear = year
            strongSelf.setSelectedHolidays(on: strongSelf.fsCalendar)
            strongSelf.delegate?.didChangeYear(year, monthHolidays: holidays)

        }, failure: { error in

            CommonClass.showToast(msg: error.localizedDescription)
        })
    }

    private func setSelectedHolidays(on calendar: FSCalendar?) {

        for monthHoliday in monthHolidays {
            for longHoliday in monthHoliday {
                for holiday in longHoliday {
                    calendar?.select(holiday.date, scrollToDate: false)
                }
            }
        }
        calendar?.reloadData()
        holidayCalendarTableView.reloadSections([1], with: .fade)
    }
}

extension HolidayCalendarVC: FSCalendarDelegateAppearance {

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: 3)
    }
}
