//
//  RoomMember.swift
//  FirebaseChat
//
//  Created by appinventiv on 25/02/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import SwiftyJSON

/*
 For getting details of chat room
 */
class RoomMember {

    let id: String
    let isAdmin: Bool
    let chatColor: String

    let chatJoinTimeStamp: TimeInterval
    let chatDeleteTimeStamp: TimeInterval
    let chatLeaveTimeStamp: TimeInterval

    init?(with json: JSON) {
        guard let memberId = json[DatabaseNode.Rooms.memberId.rawValue].string else {
            return nil
        }
        id                      = memberId
        isAdmin                 = json[DatabaseNode.Rooms.roomAdmin.rawValue].boolValue
        chatColor               = json[DatabaseNode.Rooms.memberColor.rawValue].stringValue

        chatJoinTimeStamp       = json[DatabaseNode.Rooms.memberJoin.rawValue].doubleValue
        chatDeleteTimeStamp     = json[DatabaseNode.Rooms.memberDelete.rawValue].doubleValue
        chatLeaveTimeStamp      = json[DatabaseNode.Rooms.memberLeave.rawValue].doubleValue
    }

    class func models(from jsonArray: [JSON]) -> [RoomMember] {
        var models: [RoomMember] = []
        for json in jsonArray {
            if let member = RoomMember(with: json) {
                models.append(member)
            }
        }
        return models
    }
}
