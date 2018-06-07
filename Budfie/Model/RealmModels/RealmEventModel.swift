//
//  AppEventModel.swift
//  Budfie
//
//  Created by Aakash Srivastav on 05/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import RealmSwift

class RealmEvent: Object {

    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var startDate = ""
    @objc dynamic var startTime = ""
    @objc dynamic var endDate = ""
    @objc dynamic var endTime = ""
    @objc dynamic var category = ""
    @objc dynamic var type = ""
    @objc dynamic var image = ""
    @objc dynamic var location = ""
    @objc dynamic var isFavourite = false
    @objc dynamic var userId = ""
    @objc dynamic var league = ""
    @objc dynamic var sportType = ""

    var appEvent: EventModel {
        let emptyDict           = JSONDictionary()
        let event               = EventModel(initForEventModel: emptyDict)
        event.eventId           = id
        event.eventName         = name
        event.eventType         = type
        event.eventStartDate    = startDate
        event.eventStartTime    = startTime
        event.eventEndDate      = endDate
        event.eventEndTime      = endTime
        event.eventCategory     = category
        event.eventImage        = image
        event.location          = location
        event.isFavourite       = (isFavourite ? "1":"0")
        event.userId            = userId
        event.league            = league
        event.sportType         = sportType
        return event
    }

    override class func primaryKey() -> String? {
        return "id"
    }
}
