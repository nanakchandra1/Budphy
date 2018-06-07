//
//  FriendListModel.swift
//  Budfie
//
//  Created by yogesh singh negi on 14/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

class FriendListModel {
    
    let firstName   : String
    let lastName    : String
    let friendId    : String
    let image       : String
    let avtar       : String

    var fullName: String {
        if lastName.isEmpty {
            return firstName
        }
        return "\(firstName) \(lastName)"
    }
    
    init(initForFriendList json: JSON) {
        
        self.firstName  = json["first_name"].stringValue
        self.lastName   = json["last_name"].stringValue
        self.friendId   = json["friend_id"].stringValue
        self.image      = json["image"].stringValue
        self.avtar      = json["avtar"].stringValue
    }
    
    init(initWithEventDetails json: JSON) {
        
        self.avtar       = json["avtar"].stringValue
        self.friendId    = json["event_owner"].stringValue
        self.firstName   = json["first_name"].stringValue
        self.lastName    = json["last_name"].stringValue
        self.image       = json["image"].stringValue
    }
    
}


//MARK:- Response Type
//====================

// Block User
/*
{
    "CODE": 200,
    "APICODERESULT": "SUCCESS",
    "MESSAGE": "User's details has been fetched successfully",
    "VALUE": [
    {
    "friend_id": "1",
    "first_name": "Aakash Srivastav",
    "image": "https://s3.amazonaws.com/appinventiv-development/iOS/1516729887.png"
    }
    ]
}
*/

// Friend List
/*
 
{
    "CODE": 200,
    "APICODERESULT": "SUCCESS",
    "MESSAGE": "Friends list fetched successfully",
    "VALUE": [
    {
    "friend_id": "13",
    "first_name": "RaviRavi",
    "last_name": "RaviRavi",
    "image": "http://budfiedev.applaurels.com/dist/index.html#/Update_profile/index_post6"
    }
    ]
}
 
 {
 "CODE": 200,
 "APICODERESULT": "SUCCESS",
 "MESSAGE": "Friends list fetched successfully",
 "VALUE": [
 {
 "friend_id": "2",
 "first_name": "",
 "last_name": "",
 "image": ""
 },
 {
 "friend_id": "1",
 "first_name": "",
 "last_name": "",
 "image": ""
 },
 {
 "friend_id": "4",
 "first_name": "dasd",
 "last_name": "",
 "image": "sadasd"
 }
 ]
 }
 
 */

