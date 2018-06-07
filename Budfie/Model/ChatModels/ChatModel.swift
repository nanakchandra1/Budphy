//
//  ChatModel.swift
//  FirebaseChat
//
//  Created by appinventiv on 25/02/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import SwiftyJSON
import UIKit

class ChatMessage: Equatable, Decodable {
    
    enum CodingKeys: CodingKey {
        case messageId
        case timeStamp
        case senderId
        case message
        case status
        case isBlock
        case type
        case duration
        case image
        case mediaUrl
        case isUploading
        case isUploaded
        case thumbnail
        case caption
        case failed
        case color
    }
    
    let messageId: String
    let timeStamp: TimeInterval
    let senderId: String
    let message: String
    let status: DeliveryStatus
    let isBlock: Bool
    let type: MessageType
    let duration: Float
    var image: UIImage?
    var mediaUrl: String
    var isUploading: Bool
    var isUploaded: Bool
    var thumbnail: String
    var caption: String
    var color: String
    var failed: Bool
    
    init(with json: JSON) {
        
        print_debug(json)
        
        messageId           = json[Message.messageId.rawValue].stringValue
        timeStamp           = json[Message.timestamp.rawValue].doubleValue
        senderId            = json[Message.sender.rawValue].stringValue
        message             = json[Message.message.rawValue].stringValue
        let deliveryStat    = json[Message.status.rawValue].intValue
        self.status         = (DeliveryStatus(rawValue: deliveryStat) ?? .sent)
        isBlock             = json[Message.isBlock.rawValue].boolValue
        let typeStr         = json[Message.type.rawValue].stringValue
        self.type           = (MessageType(rawValue: typeStr.lowercased()) ?? .none)
        image               = nil
        mediaUrl            = json[Message.mediaUrl.rawValue].stringValue
        thumbnail           = json[Message.thumbnail.rawValue].stringValue
        caption             = json[Message.caption.rawValue].stringValue
        duration            = json[Message.duration.rawValue].floatValue
        color               = json[Message.color.rawValue].stringValue
        
        if let failStat = json["failed"].bool {
            failed = failStat
            
        } else {
            failed = false
        }
        
        if let uploadStat = json["isUploading"].bool {
            isUploading = uploadStat
            
        } else {
            isUploading = false
        }
        
        if let uploadStat = json["isUploaded"].bool {
            isUploaded = uploadStat
            
        } else {
            isUploaded = true
        }
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.messageId = try values.decode(String.self, forKey: .messageId)
        self.timeStamp = try values.decode(TimeInterval.self, forKey: .timeStamp)
        self.senderId = try values.decode(String.self, forKey: .senderId)
        self.message = try values.decode(String.self, forKey: .message)
        self.isBlock = try values.decode(Bool.self, forKey: .isBlock)
        self.duration = try values.decode(Float.self, forKey: .duration)
        self.mediaUrl = try values.decode(String.self, forKey: .mediaUrl)
        self.isUploading = try values.decode(Bool.self, forKey: .isUploading)
        self.isUploaded = try values.decode(Bool.self, forKey: .isUploaded)
        self.thumbnail = try values.decode(String.self, forKey: .thumbnail)
        self.failed = try values.decode(Bool.self, forKey: .failed)
        self.caption = try values.decode(String.self, forKey: .caption)
        let status = try values.decode(Int.self, forKey: .status)
        self.status = (DeliveryStatus(rawValue: status) ?? .sent)
        let type = try values.decode(String.self, forKey: .type)
        self.type = MessageType(rawValue: type.lowercased()) ?? .none
        color = try values.decode(String.self, forKey: .color)
    }
    
    static func ==(left:ChatMessage, right:ChatMessage) -> Bool {
        return left.messageId == right.messageId
    }
}

extension ChatMessage: Encodable {
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(messageId, forKey: .messageId)
        try container.encode(timeStamp, forKey: .timeStamp)
        try container.encode(senderId, forKey: .senderId)
        try container.encode(message, forKey: .message)
        try container.encode(type.rawValue, forKey: .type)
        
        try container.encode(status.rawValue, forKey: .status)
        try container.encode(isBlock, forKey: .isBlock)
        try container.encode(duration, forKey: .duration)
        try container.encode(mediaUrl, forKey: .mediaUrl)
        try container.encode(isUploading, forKey: .isUploading)
        try container.encode(isUploaded, forKey: .isUploaded)
        try container.encode(thumbnail, forKey: .thumbnail)
        try container.encode(caption, forKey: .caption)
        try container.encode(color, forKey: .color)
        try container.encode(failed, forKey: .failed)
        
    }
    
    static func getMessage(from json: JSON) -> ChatMessage? {
        do {
            let messageData = try json.rawData()
            return try JSONDecoder().decode(ChatMessage.self, from: messageData)
            
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}
