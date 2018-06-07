//
//  ChatMember.swift
//  FirebaseChat
//
//  Created by appinventiv on 25/02/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import SwiftyJSON

class ChatMember: Decodable, Hashable {

    let userId      : String
    let hashValue   : Int
    let firstName   : String
    let lastName    : String
    let devicetoken : String
    let deviceType  : String
    let profilePic  : String
    let avatar      : Int
    var isAdmin     = false

    var fullName: String {
        if lastName.isEmpty {
            return firstName
        }
        return "\(firstName) \(lastName)"
    }
    
    init(with json: JSON) {
        userId      = json["userId"].stringValue
        hashValue   = userId.hashValue
        firstName   = json["firstName"].string ?? json["first_name"].stringValue
        lastName    = json["lastName"].string ?? json["last_name"].stringValue
        profilePic  = json["image"].string ?? json["profile_image"].stringValue
        avatar      = json["image_avtar"].intValue
        devicetoken = json["deviceToken"].stringValue
        deviceType  = json["deviceType"].stringValue
    }

    init(with friend: PhoneContact) {
        userId      = friend.id
        hashValue   = userId.hashValue
        firstName   = friend.name
        lastName    = "" //friend.name
        profilePic  = friend.image
        devicetoken = "" //friend.name
        deviceType  = "" //friend.name
        avatar      = 0  //friend.name
    }

    init(with user: UserDetails) {
        userId      = user.user_id
        hashValue   = userId.hashValue
        firstName   = user.first_name
        lastName    = user.last_name
        profilePic  = user.image
        devicetoken = "" //friend.name
        deviceType  = "" //friend.name
        avatar      = user.avatar
    }
    
    static func ==(left:ChatMember, right:ChatMember) -> Bool {
        return left.userId == right.userId
    }
}
