//
//  EventTypesModel.swift
//  Budfie
//
//  Created by yogesh singh negi on 13/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

class EventTypesModel {
    
    var eventType   : String
    var id          : String
    
    init(initForEventType json: JSON) {
        
        self.eventType  = json["event_type"].stringValue
        self.id         = json["id"].stringValue
    }
    
}


//MARK:- Response Type
//====================

/*
 
{
    "CODE": 200,
    "APICODERESULT": "SUCCESS",
    "MESSAGE": "Interest list fetched successfully",
    "VALUE": [
    {
    "id": "1",
    "event_type": "Birthday Event"
    },
    {
    "id": "2",
    "event_type": "Anniversary Event"
    }
    ]
}

*/

