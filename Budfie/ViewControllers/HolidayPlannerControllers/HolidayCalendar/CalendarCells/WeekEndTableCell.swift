//
//  WeekEndTableCell.swift
//  Budfie
//
//  Created by Aakash Srivastav on 22/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

class WeekEndTableCell: UITableViewCell {

    static let cellHeight = 30

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func populate(with holiday: Holiday) {
        dayLabel.text = holiday.description
        dateLabel.text = dayWithSuffix(from: holiday.date)
    }

    // This could also be done by ordinal formatting
    // using number formatter
    private func dayWithSuffix(from date: Date) -> String {

        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: date)

        let suffix: String
        switch dayOfMonth {
        case 1, 21, 31:
            suffix = "st"
        case 2, 22:
            suffix = "nd"
        case 3, 23:
            suffix = "rd"
        default:
            suffix = "th"
        }

        return "\(dayOfMonth)\(suffix)"
    }
}
