//
//  EventDatesModel.swift
//  Budfie
//
//  Created by appinventiv on 17/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON

class EventDatesModel {

    var personalDates       = Set<String>()
    var moviesDates         = Set<String>()
    var concertDates        = Set<String>()
    var sportsDates         = Set<String>()
    var mobileDates         = Set<String>()

    init() {
        
    }

    init(initWithDates json: JSON) {
        
        for perDates in json["personal_events"].arrayValue {
            let dateString = perDates.stringValue
            var components = dateString.split(separator: "-")
            components.reverse()
            let reversedDateString = components.joined(separator: "-")
            self.personalDates.insert(reversedDateString)
        }
        for movDates in json["movies"].arrayValue {
            let dateString = movDates.stringValue
            var components = dateString.split(separator: "-")
            components.reverse()
            let reversedDateString = components.joined(separator: "-")
            self.moviesDates.insert(reversedDateString)
        }
        for conDates in json["concerts"].arrayValue {
            let dateString = conDates.stringValue
            var components = dateString.split(separator: "-")
            components.reverse()
            let reversedDateString = components.joined(separator: "-")
            self.concertDates.insert(reversedDateString)
        }
        for spoDates in json["sport"].arrayValue {
            let dateString = spoDates.stringValue
            var components = dateString.split(separator: "-")
            components.reverse()
            let reversedDateString = components.joined(separator: "-")
            self.sportsDates.insert(reversedDateString)
        }
        
        if AppUserDefaults.value(forKey: AppUserDefaults.Key.googleEvent) == "1" {
            EventsCoreDataController.fetchAllEventsFromLocalDB({ (obEvent) in
                
                for event in obEvent {
//                    let dateString = event.eventStartDate
//                    var components = dateString.split(separator: "-")
//                    components.reverse()
//                    let reversedDateString = components.joined(separator: "-")
                    self.personalDates.insert(event.eventStartDate)
                }
            })
        }
    }

}


/*

{
    APICODERESULT = SUCCESS;
    CODE = 200;
    MESSAGE = "Event Dates fetched successfully";
    VALUE =     {
        concerts =         (
            "2018-01-30",
            "2018-01-23",
            "2018-01-31",
            "2018-01-29",
            "2018-01-27",
            "2018-01-28",
            "2018-01-26",
            "2018-01-24",
            "2018-01-22",
            "2018-01-25"
        );
        movies =         (
            "2018-01-24",
            "2018-01-25",
            "2018-01-26"
        );
        "personal_events" =         (
            "2018-01-23",
            "2018-01-24",
            "2018-01-30"
        );
        sport =         (
            "2018-01-18",
            "2018-01-12",
            "2018-01-08",
            "2018-01-05",
            "2018-01-03",
            "2018-01-31",
            "2018-01-28",
            "2018-01-27",
            "2018-01-26",
            "2018-01-25",
            "2018-01-24",
            "2018-01-23",
            "2018-01-22",
            "2018-01-21",
            "2018-01-20",
            "2018-01-19",
            "2018-01-17",
            "2018-01-16",
            "2018-01-15",
            "2018-01-14",
            "2018-01-13",
            "2018-01-11",
            "2018-01-10",
            "2018-01-09",
            "2018-01-07",
            "2018-01-06",
            "2018-01-04",
            "2018-01-02",
            "2018-01-01",
            "2018-01-31",
            "2018-01-30",
            "2018-01-28",
            "2018-01-27",
            "2018-01-24",
            "2018-01-25",
            "2018-01-23"
        );
    };
}

*/
