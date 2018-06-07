//
//  SportListModel.swift
//  Budfie
//
//  Created by Aishwarya Rastogi on 14/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//
/*
import SwiftyJSON

class SportListModel {
    
    var next_event_date: String
    var eventModel = [SportDetail]()
    
    init(initWithEventList json: JSON) {
        
        self.next_event_date = json["next_event_date"].stringValue
        
        for tempOb in json["eventArr"].arrayValue {
//                self.eventModel.append(EventModel(initForEventModel: temp))
        }
    }
}
*/

/*
{
    APICODERESULT = SUCCESS;
    CODE = 200;
    MESSAGE = "Sports List has been fetched successfully";
    VALUE =     {
        eventArr =         (
            {
                id = "afgzim_2018_t20_02";
                "is_favourite" = 1;
                "match_date" = "2018-02-06";
                "match_time" = "";
                name = "Afghanistan vs Zimbabwe";
                sport = 1;
        },
            {
                id = 1871852;
                "is_favourite" = 0;
                "match_date" = "2018-02-06";
                "match_time" = "19:45:00";
                name = "Motherwell vs St. Johnstone";
                sport = 2;
        }
        );
        "next_event_date" = "2018-02-09";
    };
}
*/
