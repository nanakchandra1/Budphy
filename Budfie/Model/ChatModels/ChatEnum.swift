//
//  ChatEnum.swift
//  FirebaseChat
//
//  Created by appinventiv on 25/02/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import Foundation

enum MessageType: String {
    
    case none = "none"
    case text = "text"
    case audio = "audio"
    case video = "video"
    case image = "image"
    case left = "left"
    case added = "added"
    case created = "created"
    case changed = "changed"
    case header = "header"
    case emoji = "emoji"
    case sticker = "sticker"

    var text: String {
        switch self {
        case .image:
            return "Sent an image"
        case .video:
            return "Sent a video"
        case .sticker:
            return "Sent a sticker"
        case .emoji:
            return "Sent an emoji"
        case .audio:
            return "Sent an audio"
        default:
            return ""
        }
    }
}

enum DatabaseNode {
    
    enum Root: String {
        
        case roomInfo = "roomInfo"
        case event = "event_group"
        case rooms = "rooms"
        case inbox = "inbox"
        case messages = "messages"
        case messageInfo = "messageinfo"
        case lastMessage = "lastMessage"
        case users = "users"
        case block = "block"
        case scheduler = "scheduler"
        case badge = "badgeCount"
        case accessToken = "accessToken"
        case report
        case userBlockStatus = "users_block_status"
    }
    
    enum Rooms: String {
        
        case memberDelete = "memberDelete"
        case memberLeave = "memberLeave"
        case memberJoin = "memberJoin"
        case memberId = "memberId"
        case roomAdmin = "roomadmin"
        case memberColor = "user_color"
    }
    
    enum RoomInfo: String {
        case lastUpdates = "lastUpdates"
        case lastUpdate = "lastUpdate"
        case isTyping = "isTyping"
        case roomId = "roomId"
        case chatPic = "chat_pic"
        case chatTitle = "chat_title"
        case chatType = "chat_type"
    }
    
    enum Messages: String {
        
        case timestamp = "timestamp"
        case messageId = "messageId"
        case message = "message"
        case sender = "sender"
        case status = "message_status"
    }
    
    enum Users: String {
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "image_avtar"
        case profilePic = "profile_image"
        case mobile = "phone_number"
        case countryCode = "country_code"
        case deviceToken = "device_token"
    }
    
    enum LastMessage: String {
        case chatLastMessage = "chatLastMessage"
    }
    
}

enum Chat {
    case none
    case new
    case existing
}

enum ChatType: String {
    case none
    case single = "Single"
    case group = "Group"
}

enum DeliveryStatus: Int {
    case sent = 1
    case delivered
    case read
}

enum Message: String {
    case type = "message_type"
    case message = "message"
    case sender = "sender"
    case status = "message_status"
    case mediaUrl = "mediaUrl"
    case thumbnail = "thumbnail"
    case caption = "caption"
    case color = "color"
    case isBlock = "isBlock"
    case timestamp = "timestamp"
    case messageId = "messageId"
    case duration = "duration"
    case isReport = "report"
    
}
