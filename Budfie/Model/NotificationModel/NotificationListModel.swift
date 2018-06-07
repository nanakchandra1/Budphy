//
//  NotificationListModel.swift
//  Budfie
//
//  Created by appinventiv on 12/03/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON

class NotificationListModel {
    
    let sender_id           : String
    let sender_name         : String
    let sender_image        : String
    
    let event_name          : String
    let event_id            : String
    let event_image         : String
    let event_date          : String
    
    let category            : Int
    let notification_type   : Int
    let notification_time   : String
    let notification_id     : String
    var read_status         : String
    
    //type 1=Event Invitation,2= Accept Event Invitation, 3= Received Greeting, 4= User Birthday, 5= Friend's  Birthday,6=Event Notification,7= Event_reminder,8=Chat Push,9=Call,10=Health,11=BillPay
    
    //category; // 1 for single 2 for group 1 for personal 2 for concert 3 for movies 4 cricket 5 for footbal 6 badminton 7 tennis
    
    init(initWithNotificationList json: JSON) {
        
        sender_id           = json["sender_id"].stringValue
        sender_name         = json["sender_name"].stringValue
        sender_image        = json["sender_image"].stringValue
        
        notification_type   = json["notification_type"].intValue
        notification_id     = json["notification_id"].stringValue
        read_status         = json["read_status"].stringValue
        notification_time   = json["notification_date"].stringValue
        event_date          = json["event_date"].stringValue
        
        category            = json["category"].intValue
        event_name          = json["title"].stringValue
        event_id            = json["type_id"].stringValue
        event_image         = json["image"].stringValue

        /*
        if let id = json["greeting_id"].string, !id.isEmpty {
            eventOrGreeting = "2"
            event_name      = json["greeting_title"].stringValue
            event_id        = json["greeting_id"].stringValue
            event_image     = json["greeting"].stringValue
        } else {
            eventOrGreeting = "1"
            event_name      = json["event_name"].stringValue
            event_id        = json["event_id"].stringValue
            event_image     = json["event_image"].stringValue
        }
        */
    }
    
}

/*
"notification_id": "113",
"read_status": "1",
"sender_id": "17",
"sender_image": "",
"sender_name": "yogehsfkfj",
"category": "0",
"notification_type": "1",
"notification_date": "2018-03-14 05:49:03",
"title": "kight",
"type_id": "73",
"event_date": "2018-03-16",
"image": ""
*/

/*
{
    "CODE": 200,
    "APICODERESULT": "SUCCESS",
    "MESSAGE": "Notification List fetched successfully",
    "VALUE": [
    {
    "sender_id": "17",
    "sender_image": "",
    "sender_name": "yogehsfkfj",
    "event_name": "gygg",
    "event_id": "53",
    "event_image": "",
    "greeting_title": "",
    "greeting_id": "",
    "greeting": "",
    "notification_type": "1"
    },
    {
    "sender_id": "1",
    "sender_image": "",
    "sender_name": "Ronit Roy",
    "event_name": "Hchmn",
    "event_id": "50",
    "event_image": "",
    "greeting_title": "",
    "greeting_id": "",
    "greeting": "",
    "notification_type": "1"
    }
    ]
}
*/

