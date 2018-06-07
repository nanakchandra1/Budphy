//
//  CalendarTableCell.swift
//  Budfie
//
//  Created by Aakash Srivastav on 22/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import FSCalendar

class CalendarTableCell: UITableViewCell {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var shadowView: OuterShadowView!

    override func awakeFromNib() {
        super.awakeFromNib()

        calendar.register(FSCalendarRangeSelectionCell.self, forCellReuseIdentifier: "FSCalendarRangeSelectionCell")

        calendar.placeholderType = .none
        calendar.appearance.headerMinimumDissolvedAlpha = 1
        calendar.appearance.titleFont = AppFonts.Comfortaa_Bold_0.withSize(15)
        calendar.appearance.weekdayFont = AppFonts.Funny_Cute.withSize(14)
        calendar.appearance.weekdayTextColor = .white
        calendar.appearance.headerTitleColor = .clear
        calendar.today = nil
        calendar.appearance.selectionColor = .white
        calendar.appearance.titleSelectionColor = .black
        calendar.allowsMultipleSelection = true
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.appearance.eventSelectionColor = UIColor.white
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)

        shadowView.innerView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
    }
}
