//
//  EventListingModel.swift
//  Budfie
//
//  Created by appinventiv on 11/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON

class EventListingModel {
    
    var pendingEventsCount = Int()
    var next_event_date: String
    var eventModel = Set<EventModel>()

    var eventArray: [EventModel] {
        return Array(eventModel).sorted(by: { (firstEvent, secondEvent) in
            let dateFormat = DateFormat.timein12Hour.rawValue
            guard let firstEventStartTime = firstEvent.eventStartTime.toDate(dateFormat: dateFormat),
                let secondEventStartTime = secondEvent.eventStartTime.toDate(dateFormat: dateFormat) else {
                    return false
            }
            return firstEventStartTime < secondEventStartTime
        })
    }

    init(initWithEventList json: JSON) {
        
        self.pendingEventsCount = json["pending_events_count"].intValue
        self.next_event_date = json["near_event_date"].stringValue
        
        for tempOb in json["eventArr"].arrayValue {
            if let temp = tempOb.dictionaryObject {
                self.eventModel.insert(EventModel(initForEventModel: temp))
            }
        }    
    }
}
/*
{
    APICODERESULT = SUCCESS;
    CODE = 200;
    MESSAGE = "Personal events has been fetched successfully";
    VALUE =     {
        eventArr =         (
        );
        "next_event_date" = "";
        "pending_events_count" = 1;
    };
}
*/
/*
{
    eventArr =         (
        {
            "event_category" = 2;
            "event_date" = "2018-01-03";
            "event_id" = fe07cd733365318b3c2857fc18afb134;
            "event_image" = "https://lh3.googleusercontent.com/xnrmiUMOlSXZ6PF3LifCjy18odAUp83oEAK03KHZ-S26o0N0E2uoknLVShfIFKJSHVbgBv-jCcBGJ7RPXd6PJ4xd";
            "event_name" = "Product Management Certification Workshop";
            "event_time" = "09:00:00";
            "event_type" = Concert;
            "is_favourite" = 1;
            "user_id" = "";
    },
        {
            "event_category" = 2;
            "event_date" = "2018-01-04";
            "event_id" = c2359411f0e52a2eb5f92090f8ee9e68;
            "event_image" = "https://lh3.googleusercontent.com/XpjO1RsCzPvjkURFQv60rybNxIsuCkwqbckfLQ6C2A5xRUihv-m1XKz8JqES8-O36atirf-KvYP3mclqQwQi6XzRZA";
            "event_name" = "Baklava making classes in delhi";
            "event_time" = "14:00:00";
            "event_type" = Concert;
            "is_favourite" = 1;
            "user_id" = "";
    },
        {
            "event_category" = 2;
            "event_date" = "2018-01-04";
            "event_id" = 3bf5140849867092d9f6053bef7ab6e5;
            "event_image" = "https://lh3.googleusercontent.com/KsvBTepq0ykAMnHFkcXbwXZt9nP1mevjOc33CJ64Dj22nItLmeI2m8COUdL32cA1xODh-87RGIYrOeBNV3xA98hZ";
            "event_name" = "The Eighth Octave";
            "event_time" = "18:30:00";
            "event_type" = Concert;
            "is_favourite" = 1;
            "user_id" = "";
    }
    );
    "pending_events_count" = 0;
};

*/
