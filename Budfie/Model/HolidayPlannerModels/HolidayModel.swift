//
//  HolidayModel.swift
//  Budfie
//
//  Created by Aakash Srivastav on 31/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON

class Holiday {

    let id: String
    let date: Date
    let description: String

    required init?(with json: JSON) {

        let planId = json["plan_id"].stringValue
        let holidayDateString = json["holiday_date"].stringValue

        guard !planId.isEmpty,
            let holidayDate = holidayDateString.toDate(dateFormat: "yyyy-MM-dd") else {
                return nil
        }
        id = planId
        date = holidayDate
        description = json["description"].stringValue
    }
}
