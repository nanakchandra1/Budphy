//
//  InvitationModel.swift
//  Budfie
//
//  Created by appinventiv on 01/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

class InvitationModel {
    
    var eventName       : String
    var eventId         : String
    var eventDate       : String
    var eventTime       : String
    var eventImage      : String
    var eventType       : String
    var userId          : String
    var category        : String
    var repeatType      : String
    var invitedBy       : String
    
    init(initForInviteModel json: JSON) {
        
        self.eventImage         = json["event_image"].stringValue
        self.eventName          = json["event_name"].stringValue
        self.eventId            = json["event_id"].stringValue
        self.eventDate          = json["event_date"].stringValue
        self.eventTime          = json["event_time"].stringValue
        self.eventType          = json["event_type"].stringValue
        self.userId             = json["user_id"].stringValue
        self.category           = json["category"].stringValue
        self.repeatType         = json["repeat_type"].stringValue
        self.invitedBy          = json["invited_by"].stringValue
    }
}

/*
"event_date" = "2018-02-24";
"event_id" = 3;
"event_image" = "";
"event_name" = Party;
"event_time" = "17:00:00";
"event_type" = Party;
"user_id" = 2;
*/
/*

{
    "CODE": 200,
    "APICODERESULT": "SUCCESS",
    "MESSAGE": "Pending events has been fetched successfully",
    "VALUE": [
    {
    "event_id": "240",
    "event_image": "https://s3.amazonaws.com/appinventiv-development/iOS/1514788584.png",
    "event_name": "shshsjsj",
    "event_date": "2018-01-01",
    "event_time": "12:08:00"
    }
    ]
}

*/
/*
{
    APICODERESULT = SUCCESS;
    CODE = 200;
    MESSAGE = "Pending events has been fetched successfully";
    VALUE =     {
        eventArr =         (
            {
                category = 1;
                "event_date" = "2018-03-23";
                "event_id" = 7;
                "event_image" = "";
                "event_name" = Hjjbvghjbbhhjjjjjjijkiiiiiuiii;
                "event_time" = "06:55:00";
                "event_type" = Birthday;
                "repeat_type" = "";
                "user_id" = 9;
        },
            {
                category = 1;
                "event_date" = "2018-03-23";
                "event_id" = 8;
                "event_image" = "";
                "event_name" = My;
                "event_time" = "00:00:00";
                "event_type" = Match;
                "repeat_type" = "";
                "user_id" = 16;
        },
            {
                category = 2;
                "event_date" = "2018-03-23";
                "event_id" = 5;
                "event_image" = "";
                "event_name" = yogesh;
                "event_time" = "02:26:31";
                "event_type" = Call;
                "repeat_type" = 1;
                "user_id" = 7;
        }
        );
    };
}
*/
