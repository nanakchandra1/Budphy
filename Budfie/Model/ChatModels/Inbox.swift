//
//  Inbox.swift
//  FirebaseChat
//
//  Created by appinventiv on 25/02/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import SwiftyJSON

class Inbox: Hashable {

    var senderId    : String?
    let roomId      : String
    var type        : ChatType
    var avatar      : Int
    var pic         : URL?
    var name        : String
    let isTyping    : Bool
    var lastMessage : ChatMessage?
    let hashValue   : Int

    deinit {
        print_debug("Inbox deinit")
    }
    
    init(with json: JSON) {
        roomId                  = json[DatabaseNode.RoomInfo.roomId.rawValue].stringValue
        hashValue               = roomId.hashValue

        if let picStr = json["pic"].string,
            let url = URL(string: picStr) {
            pic                 = url
        } else {
            pic                 = nil
        }

        name                    = json["name"].stringValue
        avatar                  = json[DatabaseNode.Users.avatar.rawValue].intValue

        isTyping                = json[DatabaseNode.RoomInfo.isTyping.rawValue].boolValue
        lastMessage             = ChatMessage(with: json)

        let typeString          = json[DatabaseNode.RoomInfo.chatType.rawValue].stringValue
        type                    = ChatType(rawValue: typeString.capitalized) ?? .none
    }

    convenience init(with roomId: String) {
        let json = JSON([DatabaseNode.RoomInfo.roomId.rawValue: roomId])
        self.init(with: json)
    }
    
    static func ==(left: Inbox, right: Inbox) -> Bool {
        return left.hashValue == right.hashValue
    }
}
