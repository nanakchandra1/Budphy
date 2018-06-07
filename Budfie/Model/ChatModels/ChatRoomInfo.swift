//
//  ChatRoomInfo.swift
//  FirebaseChat
//
//  Created by appinventiv on 25/02/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import SwiftyJSON

class ChatRoomInfo: Hashable {

    let hashValue               : Int
    var roomId                  : String
    let chatPic                 : String
    let avatar                  : Int
    var chatTitle               : String
    var chatType                : ChatType
    let lastUpdate              : Double
    var lastUpdates             : [UserUpdates]
    let currentUserLastUpdate   : Double
    
    deinit {
        print("ChatRoomInfo deinit")
    }
    
    init(with json: JSON) {

        roomId                  = json[DatabaseNode.RoomInfo.roomId.rawValue].stringValue
        hashValue               = roomId.hashValue
        chatPic                 = json[DatabaseNode.RoomInfo.chatPic.rawValue].stringValue
        chatTitle               = json[DatabaseNode.RoomInfo.chatTitle.rawValue].stringValue
        lastUpdate              = json[DatabaseNode.RoomInfo.lastUpdate.rawValue].doubleValue
        currentUserLastUpdate   = json[DatabaseNode.RoomInfo.lastUpdates.rawValue][AppDelegate.shared.currentuser.user_id].doubleValue
        avatar                  = json[DatabaseNode.Users.avatar.rawValue].intValue

        let typeString          = json[DatabaseNode.RoomInfo.chatType.rawValue].stringValue
        chatType                = ChatType(rawValue: typeString.capitalized) ?? .none
        lastUpdates             = UserUpdates.models(from: json[DatabaseNode.RoomInfo.lastUpdates.rawValue].dictionaryValue)
    }

    static func ==(lhs: ChatRoomInfo, rhs: ChatRoomInfo) -> Bool {
        return (lhs.roomId == rhs.roomId)
    }
}

class UserUpdates {

    let id          : String
    let updatedAt   : Double

    init(id: String, updatedAt: Double) {
        self.id          = id
        self.updatedAt   = updatedAt
    }

    static func models(from dictionary: [String: JSON]) -> [UserUpdates] {
        var updates = [UserUpdates]()
        for (key, value) in dictionary {
            let update = UserUpdates(id: key, updatedAt: value.doubleValue)
            updates.append(update)
        }
        return updates
    }
}
