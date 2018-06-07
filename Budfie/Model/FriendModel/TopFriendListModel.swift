//
//  TopFriendListModel.swift
//  Budfie
//
//  Created by appinventiv on 20/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

class TopFriendListModel {
    
    var eventId         : String
    var friendListModel : [FriendListModel]
    
    init(initForTopFriendList json: JSON) {
        
        self.friendListModel    = [FriendListModel]()
        self.eventId            = json["event_id"].stringValue
        
        for value in json["top_friends"].arrayValue {
            self.friendListModel.append(FriendListModel(initForFriendList: value))
        }
    }
    
}

//MARK:- Response Type
//====================

/*

APICODERESULT = SUCCESS;
CODE = 200;
MESSAGE = "Event has been created successfully";
VALUE =     {
    "event_id" = 131;
    "top_friends" =         (
        {
            "first_name" = RaviRavi;
            "friend_id" = 13;
            image = "http://budfiedev.applaurels.com/dist/index.html#/Update_profile/index_post6";
            "last_name" = RaviRavi;
        }
    );
};

*/
