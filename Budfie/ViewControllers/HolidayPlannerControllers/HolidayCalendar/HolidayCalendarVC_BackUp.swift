//
//  HolidayCalendarVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 19/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import FSCalendar

class HolidayCalendarVC: BaseVc {

    fileprivate var calendarCellHeight: CGFloat = 300

    @IBOutlet weak var holidayCalendarTableView: UITableView!
    @IBOutlet weak var planHolidayBtn: UIButton!

    @IBOutlet weak var monthNameLbl: UILabel!
    @IBOutlet weak var yearBtn: UIButton!
    @IBOutlet weak var backgroundMonthImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        holidayCalendarTableView.dataSource = self
        holidayCalendarTableView.delegate = self

        planHolidayBtn.addQualityShadow(ofColor: UIColor.black)
        configureCalendar(for: Date())
    }

    // MARK: - Private functions
    private func configureVisibleCells() {

        let calendarCellIndexPath = IndexPath(row: 0, section: 0)
        guard let cell = holidayCalendarTableView.cellForRow(at: calendarCellIndexPath) as? CalendarTableCell else {
            return
        }

        cell.calendar.visibleCells().forEach { (cell) in
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

    @IBAction func planHolidayBtnTapped(_ sender: UIButton) {

    }

    @IBAction func yearBtnTapped(_ sender: UIButton) {

    }

    @IBAction func backBtnTapped(_ sender: UIButton) {

    }
}

extension HolidayCalendarVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === holidayCalendarTableView {
            return 3
        }
        let numberOfHolidays = 3
        return (numberOfHolidays + 2)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView === holidayCalendarTableView {

            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableCell", for: indexPath) as? CalendarTableCell else {
                    fatalError("CalendarTableCell not found")
                }

                cell.calendar.dataSource = self
                cell.calendar.delegate = self
                return cell
            }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LongWeekEndTableCell", for: indexPath) as? LongWeekEndTableCell else {
                fatalError("LongWeekEndTableCell not found")
            }

            cell.longWeekEndTableView.dataSource = self
            cell.longWeekEndTableView.delegate = self
            cell.longWeekEndTableView.reloadData()
            return cell
        }

        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeekEndTopDecorationTableCell", for: indexPath) as? WeekEndTopDecorationTableCell else {
                fatalError("WeekEndTopDecorationTableCell not found")
            }

            return cell
        }

        let numberOfHolidays = 3
        if indexPath.row == (numberOfHolidays + 1) {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeekEndBottomDecorationTableCell", for: indexPath) as? WeekEndBottomDecorationTableCell else {
                fatalError("WeekEndBottomDecorationTableCell not found")
            }

            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeekEndTableCell", for: indexPath) as? WeekEndTableCell else {
            fatalError("WeekEndTableCell not found")
        }

        return cell
    }
}

extension HolidayCalendarVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return height(of: tableView, forRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height(of: tableView, forRowAt: indexPath)
    }

    private func height(of tableView: UITableView, forRowAt indexPath: IndexPath) -> CGFloat {

        let numberOfHolidays = 3

        if tableView === holidayCalendarTableView {

            if indexPath.row == 0 {
                let tableTopBottonPadding: CGFloat = 20
                let calendarHeaderHeight: CGFloat = 36
                return (calendarCellHeight + tableTopBottonPadding - calendarHeaderHeight)
            }

            let heightForHolidayCell = WeekEndTableCell.cellHeight
            let numberOfDecorations = 2
            let heightForDecorationCell = WeekEndTopDecorationTableCell.cellHeight
            let tableTopBottonPadding = 20
            return CGFloat((numberOfHolidays * heightForHolidayCell) + (numberOfDecorations * heightForDecorationCell) + tableTopBottonPadding)

        } else {
            
            if [0, (numberOfHolidays + 1)].contains(indexPath.row) {
                return CGFloat(WeekEndTopDecorationTableCell.cellHeight)
            }
            return CGFloat(WeekEndTableCell.cellHeight)
        }
    }
}

extension HolidayCalendarVC: FSCalendarDataSource {

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
        holidayCalendarTableView.beginUpdates()
        holidayCalendarTableView.endUpdates()
    }

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }

    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureVisibleCells()
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        self.configureVisibleCells()
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        configureCalendar(for: calendar.currentPage)
    }

    private func configureCalendar(for date: Date) {
        let monthValue = Calendar.current.component(.month, from: date)
        if let month = Month(rawValue: monthValue) {
            monthNameLbl.text = month.name
            backgroundMonthImageView.image = month.image
        }
    }
}

extension HolidayCalendarVC: FSCalendarDelegateAppearance {

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: 3)
    }
}
