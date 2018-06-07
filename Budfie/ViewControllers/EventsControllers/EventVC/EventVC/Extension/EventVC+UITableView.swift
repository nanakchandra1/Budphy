//
//  EventVC+UITableView.swift
//  Budfie
//
//  Created by appinventiv on 15/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

extension EventVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100000
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeekCalendarDateCell", for: indexPath) as? WeekCalendarDateCell else {
            fatalError("WeekCalendarDateCell not found")
        }
        
        let dateInterval = (TimeInterval(indexPath.row) * timeIntervalOfADay)
        let date = Date(timeIntervalSince1970: dateInterval)
        let serverDateString = date.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
        let isEventSelected = selectedEventAray.contains(serverDateString)
        cell.populate(with: date, isEvent: isEventSelected)
        
        delayWithSeconds(0.2) {
            if indexPath == self.selectedCalendarIndex {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
        return cell
    }
    
}

extension EventVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeekCalendarDateCell") as? WeekCalendarDateCell else {
            fatalError("WeekCalendarDateCell not found")
        }
        cell.isHeaderCell = true
        calendarHeaderView = cell
        
        cell.monthLabel.font = AppFonts.Comfortaa_Regular_0.withSize(13)
        cell.dayLabel.font = AppFonts.Comfortaa_Regular_0.withSize(13)
        
        let date = Date()
        calendarHeaderView.date = date
        prevHeaderMonthString = calendarHeaderView.monthLabel.text
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(weekTableHeaderTapped))
        cell.contentView.addGestureRecognizer(tapGesture)
        
        cell.contentView.backgroundColor = AppColors.themeBlueColor
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return (scrollViewheight/8)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (scrollViewheight/8)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return (scrollViewheight/8)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (scrollViewheight/8)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if calendarHeaderView != nil,
            let firstVisibleCell = weekCalendarTableView.visibleCells.first as? WeekCalendarDateCell {
            calendarHeaderView.date = firstVisibleCell.date
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCalendarIndex = indexPath
        let dateInterval = (TimeInterval(indexPath.row) * timeIntervalOfADay)
        let date = Date(timeIntervalSince1970: dateInterval)
        selectedDateString = date.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
        //hitGetEventDates(date: selectedDateString)
        self.hitService(loader: true)
    }
    
    @objc private func weekTableHeaderTapped(_ gesture: UITapGestureRecognizer) {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSelectEventDate),
                                               name: Notification.Name.DidChooseDate,
                                               object: nil)
        
        let holidayCalendarScene = HolidayCalendarVC.instantiate(fromAppStoryboard: .HolidayPlanner)
        holidayCalendarScene.vcType = .eventDate
        holidayCalendarScene.moveToDate = calendarHeaderView.date
//        if let date = calendarHeaderView.date.toDate(dateFormat: DateFormat.calendarDate.rawValue) {
//            holidayCalendarScene.moveToDate = calendarHeaderView.date
//        } else {
//            holidayCalendarScene.moveToDate = Date()
//        }
        //AppDelegate.shared.sharedTabbar?.hideTabbar()
        self.navigationController?.pushViewController(holidayCalendarScene, animated: true)
    }
    
}

class WeekCalendarDateCell: UITableViewCell {
    
    @IBOutlet weak var dateContainerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var rightArrowImageView: UIImageView!

    var isHeaderCell = false {
        didSet {
            rightArrowImageView.isHidden = false
        }
    }

    private var isToday = false {
        didSet {
            if isToday {
                
                backgroundColor = AppColors.calendarEventPink
                
                if isAvailable {
                    dateLabel.textColor = AppColors.calendarEventPink
                    dateContainerView.backgroundColor = .white
                } else {
                    dateLabel.textColor = .white
                    dateContainerView.backgroundColor = .clear
                }
                
            }
        }
    }
    private var isAvailable = false
    
    var date: Date! {
        didSet {
            
            if isHeaderCell {
                dateLabel.text = date.toString(dateFormat: "yyyy")
            } else {
                dateLabel.text = date.toString(dateFormat: "dd")
            }
            
            monthLabel.text = date.toString(dateFormat: "MMM")
            
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: Date())
            
            let startDateString = startOfDay.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
            let cellDateString = date.toString(dateFormat: DateFormat.dOBServerFormat.rawValue)
            
            if isHeaderCell {
                
                monthLabel.isHidden = false
                dateContainerView.isHidden = true
                
                monthLabel.text = date.toString(dateFormat: "MMM")
                dayLabel.text = date.toString(dateFormat: "yyyy")

                monthLabel.textColor = .white
                dayLabel.textColor = .white
                
            } else if startDateString == cellDateString {
                //dayLabel.text = "Today"
                dayLabel.text = date.toString(dateFormat: "EEE")
                isToday = true

            } else {
                dayLabel.text = date.toString(dateFormat: "EEE")
                isToday = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateContainerView.layer.cornerRadius = dateContainerView.height/2
        dateContainerView.clipsToBounds = true
        backgroundColor = AppColors.themeLightBlueColor
        rightArrowImageView.image = #imageLiteral(resourceName: "phonenumberRight").withRenderingMode(.alwaysTemplate)
        
        resetCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            backgroundColor = .white
            dayLabel.textColor = .black

            if isAvailable {
                dateLabel.textColor = .white
                dateContainerView.backgroundColor = AppColors.calendarEventPink
            } else {
                dateLabel.textColor = .black
                dateContainerView.backgroundColor = .clear
            }
            
        } else {
            
            if isToday {
                
                backgroundColor = AppColors.calendarEventPink
                dayLabel.textColor = .white

                if isAvailable {
                    dateContainerView.backgroundColor = .white
                    dateLabel.textColor = AppColors.calendarEventPink
                } else {
                    dateContainerView.backgroundColor = .clear
                    dateLabel.textColor = .white
                }
                
            } else {
                
                backgroundColor = AppColors.themeLightBlueColor
                dayLabel.textColor = .black

                if isAvailable {
                    dateLabel.textColor = .white
                    dateContainerView.backgroundColor = AppColors.calendarEventPink
                } else {
                    dateLabel.textColor = .black
                    dateContainerView.backgroundColor = .clear
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    private func resetCell() {
        dateLabel.text = nil
        monthLabel.text = nil
        monthLabel.isHidden = true
        dateContainerView.isHidden = false
        dayLabel.text = "Today"
        dateContainerView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        isHeaderCell = false
        //isToday = false
        isAvailable = false
        dateLabel.textColor = .black
        backgroundColor = AppColors.themeLightBlueColor
        dayLabel.textColor = .black
        rightArrowImageView.isHidden = true
    }
    
    func populate(with date: Date, isEvent available: Bool) {
        isAvailable = available
        self.date = date

        if available {
            dateContainerView.backgroundColor = AppColors.calendarEventPink
            dateLabel.textColor = .white
            if isToday {
                dateContainerView.backgroundColor = .white
                dateLabel.textColor = AppColors.calendarEventPink
            }
        } else if isToday {
            dayLabel.textColor = .white
        }
    }
}

