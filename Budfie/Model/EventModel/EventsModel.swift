//
//  EventsModel.swift
//  Budfie
//
//  Created by yogesh singh negi on 16/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

class EventModel: Hashable {

    var hashValue: Int
    var eventName       : String
    var eventType       : String
    var eventId         : String
    var eventStartDate  : String
    var eventStartTime  : String
    var eventEndDate    : String
    var eventEndTime    : String
    var eventImage      : String
    var location        : String
    var eventCategory   : String
    var isFavourite     : String
    var userId          : String
    var league          : String
    var sportType       : String

    var realmEvent: RealmEvent {
        let event           = RealmEvent()
        event.id            = eventId
        event.name          = eventName
        event.type          = eventType
        event.startDate     = eventStartDate
        event.startTime     = eventStartTime
        event.endDate       = eventEndDate
        event.endTime       = eventEndTime
        event.category      = eventCategory
        event.image         = eventImage
        event.location      = location
        event.isFavourite   = (isFavourite == "0" ? false:true)
        event.userId        = userId
        event.league        = league
        event.sportType     = sportType
        return event
    }
    
    init(initForEventModel json: JSONDictionary) {
        
        self.eventName      = json["event_name"] as? String ?? ""
        self.eventType      = json["event_type"] as? String ?? ""
        self.eventId        = (json["event_id"] as? String) ?? (json["soccer_id"] as? String) ?? ""
        hashValue           = eventId.hashValue
        self.eventImage     = json["event_image"] as? String ?? ""
        self.eventStartTime = (json["event_start_time"] as? String) ?? (json["soccer_time"] as? String) ?? (json["event_time"] as? String) ?? ""
        self.eventEndDate   = (json["event_end_date"] as? String) ?? (json["soccer_date"] as? String) ?? ""
        self.eventEndTime   = json["event_end_time"] as? String ?? ""
        self.location       = json["event_location"] as? String ?? ""
        self.eventCategory  = json["event_category"] as? String ?? ""
        self.isFavourite    = json["is_favourite"] as? String ?? ""
        self.userId         = json["user_id"] as? String ?? ""
        self.league         = json["league"] as? String ?? ""
        self.sportType      = json["sport"] as? String ?? ""
        
        if self.eventType == "1" {
            
            self.eventStartDate = json["event_start_date"] as? String ?? ""
            self.eventStartTime = convertTo12Time(time: json["event_start_time"] as? String)
            //json["event_start_time"] as? String ?? ""
            self.eventEndDate   = json["event_end_date"] as? String ?? ""
            self.eventEndTime   = convertTo12Time(time: json["event_end_time"] as? String)
            //json["event_end_time"] as? String ?? ""
            self.location       = json["event_location"] as? String ?? ""
            
        } else {
            
            self.location       = json["event_location"] as? String ?? ""
            self.eventImage     = json["event_image"] as? String ?? ""
            self.eventStartDate = json["event_date"] as? String ?? json["event_start_date"] as? String ?? ""
            self.eventStartTime = convertTo12Time(time: json["event_time"] as? String ?? json["event_start_time"] as? String)
        }
        
        if let sportType = json["sport"] as? String,
            !sportType.isEmpty, self.eventCategory.isEmpty,
            sportType == "1" || sportType == "2" || sportType == "3" || sportType == "4" {
            
            self.sportType = sportType
            self.eventId = json["id"] as? String ?? ""
            self.isFavourite = json["is_favourite"] as? String ?? ""
            self.eventStartDate = json["match_date"] as? String ?? ""
            self.eventStartTime = convertTo12Time(time: json["match_time"] as? String)
            //json["match_time"] as? String ?? ""
            self.eventName = json["name"] as? String ?? ""
        }
    }
    
    private func convertTo12Time(time: String?) -> String {
        
        if let eventtime = time, !eventtime.isEmpty {
            let convertTime = eventtime.toDate(dateFormat: "HH:mm:ss")
            if let strtime = convertTime?.toString(dateFormat: "hh:mm a") {
                return strtime
            }
        }
        return time ?? ""
    }

    static func ==(lhs: EventModel, rhs: EventModel) -> Bool {
        return (lhs.eventId == rhs.eventId)
    }
    
}

// Soccer
/*
{
    APICODERESULT = SUCCESS;
    CODE = 200;
    MESSAGE = 0;
    VALUE =     (
        {
            id = 1871897;
            "is_favourite" = 0;
            "match_date" = "2018-01-25";
            "match_time" = "00:00:00";
            name = "Kilmarnock vs St. Johnstone";
            sport = 2;    // 2 soccer, 1  cricket
        }
    );
}
*/


// PERSONAL
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

{
    "event_category" = 1;
    "event_date" = "2018-01-18";
    "event_id" = 1;
    "event_image" = "";
    "event_name" = abc;
    "event_time" = "00:00:00";
    "event_type" = Bollywood;
    "is_favourite" = 0;
    "user_id" = "";
}
*/

//MOVIES
/*
{
    "event_date" = "2018-01-18";
    "event_id" = 1;
    "event_image" = "";
    "event_name" = abc;
    "event_type" = Bollywood;
    "is_favourite" = 0;
}
*/

// CONCERT
/*
{
    "event_date" = "2018-01-06";
    "event_id" = 55e863408e617337375f66555e13baf4;
    "event_image" = "https://lh3.googleusercontent.com/Ntif-ibxHC6ptA2kgno52MvkuDpT1Jwq_fcewLLrSCN6rnBaFaWqlw2OwRT656N1zFl24kVplfNv2khahio-PUEM";
    "event_name" = "Youth Basketball Championship";
    "event_time" = "10:00:00";
    "is_favourite" = 0;
},

*/


// Google Events
/*
GTLRCalendar_Event 0x17465fe60: {
    "hangoutLink":"https://plus.google.com/hangouts/_/appinventiv.com/rajat-dhasmana?hceid=cmFqYXQuZGhhc21hbmFAYXBwaW52ZW50aXYuY29t.2c66n6pkb2asf7maf4ukjgilc4",
    "location":"Appinventiv, H-23, 2nd Floor, Sector 63, H Block, Sector 62, Noida, Uttar Pradesh 201301, India",
    "reminders":{useDefault},
    "status":"confirmed",
    "creator":{email},
    "summary":"iOS Team meeting",
    "attendees":[37],
    "kind":"calendar#event",
    "organizer":{email},
    "originalStartTime":{dateTime},
    "updated":"2018-02-01T11:20:11.574Z",
    "conferenceData"?:{entryPoints,conferenceId,signature,conferenceSolution,createRequest},
    "htmlLink":"https://www.google.com/calendar/event?eid=MmM2Nm42cGtiMmFzZjdtYWY0dWtqZ2lsYzRfMjAxODAyMDhUMTEzMDAwWiB5b2dlc2gubmVnaUBhcHBpbnZlbnRpdi5jb20",
    "id":"2c66n6pkb2asf7maf4ukjgilc4_20180208T113000Z",
    "end":{dateTime},
    "recurringEventId":"2c66n6pkb2asf7maf4ukjgilc4",
    "etag":""3034968023148000"",
    "start":{dateTime},
    "iCalUID":"2c66n6pkb2asf7maf4ukjgilc4@google.com",
    "created":"2017-11-29T09:15:03.000Z",
    "sequence":1
}
*/
