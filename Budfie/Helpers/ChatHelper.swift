//
//  ChatHelper.swift
//  Bhounce
//
//  Created by ATUL on 19/07/17.
//  Copyright 2018 Budfie. All rights reserved.
//

import Firebase
import SwiftyJSON

class ChatHelper {

//    static func getCurrentChatMember()->ChatMember{
//
//        var curdata:[String:Any] = [:]
//
//        curdata["userId"] = CurrentUser.userId ?? ""
//        curdata["userName"] = CurrentUser.userName ?? ""
//        curdata["firstName"] = CurrentUser.firstNAME ?? ""
//        curdata["lastName"] = CurrentUser.lastNAME ?? ""
//        curdata["image"] = CurrentUser.profileImage ?? ""
//        curdata["deviceToken"] = ""
//        curdata["deviceType"] = ""
//
//        let currentMember = ChatMember(withJSON: JSON(curdata))
//        return currentMember
//    }

    /*
     static let chatColors = ["#34cbd7", "#ffd454", "#88cc70", "#f26d6d", "#349fd7" , "#ff9054", "#ae85d9", "#f5c287", "#70ccb3", "#f26d89"]

     static var randomColor: String {
     let chatColors = ["#34cbd7", "#ffd454", "#88cc70", "#f26d6d", "#349fd7" , "#ff9054", "#ae85d9", "#f5c287", "#70ccb3", "#f26d89"]
     let randomIndex = Int(arc4random_uniform(UInt32(chatColors.count)))
     return chatColors[randomIndex]
     }
     */

    static func validate(_ text: String)->String?{

        let messageStr = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if messageStr.isEmpty{

            //CommonFunctions.showFailureToastWithMessage(message: "Please enter text")
            return nil
        }

        return messageStr
    }

    static func composeTextMessage(_ messageStr: String, _ roomId: String, _ isBlock: Bool) -> ChatMessage? {

        let senderId = AppDelegate.shared.currentuser.user_id
        let messageId = FirebaseHelper.getMessageId(forRoom: roomId)
        var message = JSONDictionary()

        message[Message.type.rawValue]          = MessageType.text.rawValue.uppercased()
        message[Message.message.rawValue]       = messageStr
        message[Message.sender.rawValue]        = senderId
        message[Message.status.rawValue]        = DeliveryStatus.sent.rawValue
        message[Message.mediaUrl.rawValue]      = ""
        message[Message.thumbnail.rawValue]     = ""
        message[Message.caption.rawValue]       = ""
        //message[Message.color.rawValue]         = randomColor
        message[Message.timestamp.rawValue]     = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        message[Message.messageId.rawValue]     = messageId

        if isBlock {
            message[Message.isBlock.rawValue] = 1
        } else {
            message[Message.isBlock.rawValue] = 0
        }

        let json = JSON(message)
        let chatMessage: ChatMessage = ChatMessage(with: json)

        return chatMessage
    }

    static func composeImageMessage(_ image: UIImage, _ roomId: String, _ isBlock: Bool, _ timeStamp: Double?) -> ChatMessage? {

        let senderId = AppDelegate.shared.currentuser.user_id
        let messageId = FirebaseHelper.getMessageId(forRoom: roomId)
        var message = JSONDictionary()

        message[Message.type.rawValue] = MessageType.image.rawValue.uppercased()
        message[Message.message.rawValue] = "Sent an image"
        message[Message.sender.rawValue] = senderId
        message[Message.status.rawValue] = DeliveryStatus.sent.rawValue
        message[Message.mediaUrl.rawValue] = ""
        //message[Message.thumbnail.rawValue] = ""
        //message[Message.caption.rawValue] = ""
        message[Message.timestamp.rawValue] = timeStamp ?? ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        message[Message.messageId.rawValue] = messageId
        //message[Message.color.rawValue]     = randomColor

        if isBlock {
            message[Message.isBlock.rawValue] = 1
        } else {
            message[Message.isBlock.rawValue] = 0
        }

        let chatMessage: ChatMessage = ChatMessage(with: JSON(message))
        chatMessage.image = image

        return chatMessage
    }

    static func composeStickerMessage(type: MessageType, _ mediaUrl: String, _ roomId: String, _ isBlock: Bool, _ timeStamp: Double?) -> ChatMessage? {

        let senderId = AppDelegate.shared.currentuser.user_id
        let messageId = FirebaseHelper.getMessageId(forRoom: roomId)
        var message = JSONDictionary()

        message[Message.type.rawValue] = type.rawValue.uppercased()
        message[Message.message.rawValue] = type.text
        message[Message.sender.rawValue] = senderId
        message[Message.status.rawValue] = DeliveryStatus.sent.rawValue
        message[Message.mediaUrl.rawValue] = mediaUrl
        //message[Message.thumbnail.rawValue] = ""
        //message[Message.caption.rawValue] = ""
        message[Message.timestamp.rawValue] = timeStamp ?? ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        message[Message.messageId.rawValue] = messageId
        //message[Message.color.rawValue]     = randomColor

        if isBlock {
            message[Message.isBlock.rawValue] = 1
        } else {
            message[Message.isBlock.rawValue] = 0
        }

        let chatMessage: ChatMessage = ChatMessage(with: JSON(message))
        return chatMessage
    }

    static func composeVideoMessage(_ mediaUrl: String, thumbnail: String, _ roomId: String, _ isBlock: Bool, _ timeStamp: Double?) -> ChatMessage? {

        let senderId = AppDelegate.shared.currentuser.user_id
        let messageId = FirebaseHelper.getMessageId(forRoom: roomId)
        var message = JSONDictionary()

        message[Message.type.rawValue] = MessageType.video.rawValue.uppercased()
        message[Message.message.rawValue] = "Sent a video"
        message[Message.sender.rawValue] = senderId
        message[Message.status.rawValue] = DeliveryStatus.sent.rawValue
        message[Message.mediaUrl.rawValue] = mediaUrl
        message[Message.thumbnail.rawValue] = thumbnail
        //message[Message.caption.rawValue] = ""
        message[Message.timestamp.rawValue] = timeStamp ?? ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        message[Message.messageId.rawValue] = messageId
        //message[Message.color.rawValue]     = randomColor

        if isBlock {
            message[Message.isBlock.rawValue] = 1
        } else {
            message[Message.isBlock.rawValue] = 0
        }

        let chatMessage: ChatMessage = ChatMessage(with: JSON(message))
        return chatMessage
    }

    static func composeAudioMessage(_ mediaUrl: String, duration: Float64, _ roomId: String, _ isBlock: Bool, _ timeStamp: Double?) -> ChatMessage? {

        let senderId = AppDelegate.shared.currentuser.user_id
        let messageId = FirebaseHelper.getMessageId(forRoom: roomId)
        var message = JSONDictionary()

        message[Message.type.rawValue] = MessageType.audio.rawValue
        message[Message.message.rawValue] = "Sent an audio"
        message[Message.sender.rawValue] = senderId
        message[Message.status.rawValue] = DeliveryStatus.sent.rawValue
        message[Message.mediaUrl.rawValue] = mediaUrl
        //message[Message.thumbnail.rawValue] = ""
        //message[Message.caption.rawValue] = ""
        message[Message.timestamp.rawValue] = timeStamp ?? ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        message[Message.messageId.rawValue] = messageId
        //message[Message.color.rawValue]     = randomColor
        message[Message.duration.rawValue]  = duration

        if isBlock {
            message[Message.isBlock.rawValue] = 1
        } else {
            message[Message.isBlock.rawValue] = 0
        }

        let chatMessage: ChatMessage = ChatMessage(with: JSON(message))
        return chatMessage
    }

    static func composeHeaderMessage(message: String, roomId: String) -> ChatMessage? {

        let senderId = AppDelegate.shared.currentuser.user_id
        let messageId = FirebaseHelper.getMessageId(forRoom: roomId)

        var messageDict = JSONDictionary()

        messageDict[Message.type.rawValue]          = MessageType.header.rawValue.uppercased()
        messageDict[Message.message.rawValue]       = message
        messageDict[Message.sender.rawValue]        = senderId
        messageDict[Message.status.rawValue]        = DeliveryStatus.sent.rawValue
        messageDict[Message.mediaUrl.rawValue]      = ""
        //message[Message.thumbnail.rawValue]     = ""
        //message[Message.caption.rawValue]       = ""
        messageDict[Message.timestamp.rawValue]     = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        messageDict[Message.messageId.rawValue]     = messageId
        messageDict[Message.isBlock.rawValue]       = 0
        //messageDict[Message.color.rawValue]         = randomColor

        let chatMessage: ChatMessage = ChatMessage(with: JSON(messageDict))
        return chatMessage
    }

    static func composeMemberAddedMessage(_ roomId: String, _ messageStr: String) -> ChatMessage? {

        let senderId = AppDelegate.shared.currentuser.user_id
        let messageId = FirebaseHelper.getMessageId(forRoom: roomId)
        var message = JSONDictionary()

        message[Message.type.rawValue] = MessageType.added.rawValue.uppercased()
        message[Message.message.rawValue] = messageStr//MessageType.added.rawValue // nitin change
        message[Message.sender.rawValue] = senderId
        message[Message.status.rawValue] = DeliveryStatus.sent.rawValue
        message[Message.mediaUrl.rawValue] = ""
        //message[Message.thumbnail.rawValue] = ""
        //message[Message.caption.rawValue] = ""
        message[Message.timestamp.rawValue] = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        message[Message.messageId.rawValue] = messageId

        message[Message.isBlock.rawValue] = 0

        let chatMessage: ChatMessage = ChatMessage(with: JSON(message))

        return chatMessage
    }

    static func composeGroupLeftMessage(_ roomId: String) -> ChatMessage? {

        let senderId = AppDelegate.shared.currentuser.user_id
        let messageId = FirebaseHelper.getMessageId(forRoom: roomId)
        var message = JSONDictionary()

        message[Message.type.rawValue] = MessageType.left.rawValue.uppercased()
        message[Message.message.rawValue] = MessageType.left.rawValue
        message[Message.sender.rawValue] = senderId
        message[Message.status.rawValue] = DeliveryStatus.sent.rawValue
        message[Message.mediaUrl.rawValue] = ""
        //message[Message.thumbnail.rawValue] = ""
        //message[Message.caption.rawValue] = ""
        message[Message.timestamp.rawValue] = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        message[Message.messageId.rawValue] = messageId
        message[Message.isBlock.rawValue] = 0

        let chatMessage: ChatMessage = ChatMessage(with: JSON(message))
        return chatMessage
    }

    static func composeGroupNameChangedMessage(_ roomId: String, _ name: String) -> ChatMessage? {

        let senderId = AppDelegate.shared.currentuser.user_id
        let messageId = FirebaseHelper.getMessageId(forRoom: roomId)
        var message = JSONDictionary()

        message[Message.type.rawValue] = MessageType.changed.rawValue.uppercased()
        message[Message.message.rawValue] = "changed group name to \(name)"
        message[Message.sender.rawValue] = senderId
        message[Message.status.rawValue] = DeliveryStatus.sent.rawValue
        message[Message.mediaUrl.rawValue] = ""
        //message[Message.thumbnail.rawValue] = ""
        //message[Message.caption.rawValue] = ""
        message[Message.timestamp.rawValue] = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        message[Message.messageId.rawValue] = messageId
        message[Message.isBlock.rawValue] = 0

        let chatMessage: ChatMessage = ChatMessage(with: JSON(message))
        return chatMessage
    }

    static func upload(_ image: UIImage, completion: @escaping (_ status: Bool, _ url: String)->()){

//        WebServices.uploadImageToS3(image: image, success: { (status, imageUrl) in
//            printlnDebug(imageUrl)
//
//            completion(status, imageUrl)
//
//        }, progress: { (progress) in
//
//            printlnDebug(progress)
//
//        }, failure: { (error) in
//
//            printlnDebug(error)
//        })
    }

    static func formatTime(timestamp: Double)->String{

        let dateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current

        let date = Date(timeIntervalSince1970: timestamp)

        return dateFormatter.string(from: date)

    }

    static func getUnsentMediaMessages(_ receiverId: String)->[ChatMessage]{

        //let mediaFiles = SQLiteManager.getMediaFiles(receiverId: receiverId)

        return []//mediaFiles
    }

    }

/*
    If user has blocked someone or,
    user is blocked by someone
 */
struct BlockStatus {

    var isBlocked: Bool
    var hasBlocked: Bool

    init() {

        isBlocked = false
        hasBlocked = false
    }
}

/*
 If user has reported someone or,
 user is reported by someone
 */

struct ReportStatus {

    var isReported: Bool = false
    var hasReported: Bool = false
}

/*

 Read receipt

 */
struct ReadReceipt {

    var timeStamp: Double = 0.0
    var enable: Bool = false
}

/*

 User has left group

 */

struct LeaveStatus {

    var hasLeft = false
    var leaveStamp = 0.0
}
