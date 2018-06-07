//
//  FirebaseServices.swift
//  FirebaseChat
//
//  Created by appinventiv on 25/02/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import Firebase
import SwiftyJSON

let DatabaseReference = Database.database().reference()
let fireBasePassword = "bhounce_Almameter@_654321"

var msgCount:[String:UInt] = [:]

var _inboxObserver: [String:UInt] = [:]
var _msgObserver: [String:UInt] = [:]

class FirebaseHelper {
    
    deinit {
        print_debug("FirebaseHelper deinit")
    }

    private static var curUserId: String {
        return AppDelegate.shared.currentuser.user_id
    }

    private static var curUser: UserDetails {
        return AppDelegate.shared.currentuser
    }

    static let chatColors = ["#34cbd7", "#ffd454", "#88cc70", "#f26d6d", "#349fd7" , "#ff9054", "#ae85d9", "#f5c287", "#70ccb3", "#f26d89"]

    /*********************
     Authenticating anooymous user
     **********************/
    static func authenticate(completion: @escaping (Bool)->()) {

        guard let _ = AppDelegate.shared.currentuser else {
            return
        }
        
        let phoneNumber = AppDelegate.shared.currentuser.phone_no
        let email = "\(phoneNumber)@budfiemail.com"

        Auth.auth().signIn(withEmail: email, password: phoneNumber) { (user, error) in
            
            guard let _ = AppDelegate.shared.currentuser else {
                return
            }
            
            if error == nil {
                if let user = user {
                    print_debug("User ID: \(user.uid)")
                    createUsersNode()
                    createHelpAndSupportNode()
                    checkIfHelpAndSupportChatExists()
                    completion(true)
                }

            } else if let error = error as NSError? {

                if (error.code == 17009) {
                    //email exist
                    completion(false)

                } else if (error.code == 17011) {
                    //email doesn't exist
                    createUser(completion: completion)

                } else {
                    completion(false)
                }

                print_debug(error.localizedDescription)

            } else {
                print_debug( "Something went wrong. Please try again later.")
                completion(false)
            }
        }
    }

    static func checkIfHelpAndSupportChatExists() {

        let userId = AppDelegate.shared.currentuser.user_id
        let helpAndSupportId = AppDelegate.shared.helpSupport.user_id

        guard !userId.isEmpty, !helpAndSupportId.isEmpty else {
            return
        }

        DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(userId).child(helpAndSupportId).observeSingleEvent(of: .value) { (snapshot) in

            let json = JSON(snapshot.value as Any)

            if json == JSON.null {
                let chatMember = ChatMember(with: AppDelegate.shared.helpSupport)

                let name: String
                if chatMember.lastName.isEmpty {
                    name = chatMember.firstName
                } else {
                    name = "\(chatMember.firstName) \(chatMember.lastName)"
                }

                let dict = [DatabaseNode.RoomInfo.chatPic.rawValue: chatMember.profilePic,
                            DatabaseNode.RoomInfo.chatTitle.rawValue: name]
                let json = JSON(dict)

                let info = ChatRoomInfo(with: json)
                let _ = startNewChat([chatMember], info: info)
            }
        }
    }

    /*********************
     Creating the new user
     **********************/
    static func createUser(completion: @escaping (Bool)->()) {

        let phoneNumber = AppDelegate.shared.currentuser.phone_no
        let email = "\(phoneNumber)@budfiemail.com"
        
        Auth.auth().createUser(withEmail: email, password: phoneNumber) { (user, error) in
            
            if error == nil {
                
                if let user = user {
                    print_debug("FIRUSER: \(user.uid)")
                    authenticate(completion: completion)
                }

            } else if let error = error {
                
                print_debug(error.localizedDescription)
                completion(false)

            } else {
                
                print_debug("Something went wrong. Please try again later.")
                completion(false)
            }
        }
        
    }
    
    /*********************
     Authenticating the user
     **********************/
    static func authenticate(withEmail email: String, password: String, completion: @escaping (Bool)->()){
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error == nil{
                
                if let user = user{
                    
                    print("FIRUSER: \(user.uid)")
                    completion(true)
                }
            }else if let error = error{
                
                print( error.localizedDescription)
                completion(false)
            }else{
                
                print( "Something went wrong. Please try again later.")
                completion(false)
            }
            
        }
    }
    
    /*********************
     Createing the new user
     **********************/
    static func createUsersNode() {
        
        let user: JSONDictionary = [DatabaseNode.Users.firstName.rawValue: self.curUser.first_name,
                                     DatabaseNode.Users.lastName.rawValue: self.curUser.last_name,
                                     DatabaseNode.Users.profilePic.rawValue: self.curUser.image,
                                     DatabaseNode.Users.avatar.rawValue: self.curUser.avatar,
                                     //DatabaseNode.Users.userId.rawValue:self.curUser.user_id,
            //DatabaseNode.Users.isDelete.rawValue:false,
            DatabaseNode.Users.mobile.rawValue: self.curUser.phone_no,
            DatabaseNode.Users.countryCode.rawValue: self.curUser.country_code,
            //DatabaseNode.Users.deviceType.rawValue: "2",
            DatabaseNode.Users.deviceToken.rawValue: deviceToken
        ]
        
        DatabaseReference.child(DatabaseNode.Root.users.rawValue).child(self.curUser.user_id).setValue(user) { (error, _) in
            if let err = error {
                CommonClass.showToast(msg: err.localizedDescription)
            }
        }
        //self.updateDeviceToken(deviceToken, self.curUser.user_id)
    }

    static func createHelpAndSupportNode() {

        guard let helpAndSupport = AppDelegate.shared.helpSupport,
            !helpAndSupport.user_id.isEmpty else {
                return
        }

        let user: JSONDictionary = [DatabaseNode.Users.firstName.rawValue: helpAndSupport.first_name,
                                    DatabaseNode.Users.lastName.rawValue: helpAndSupport.last_name,
                                    DatabaseNode.Users.profilePic.rawValue: helpAndSupport.image,
                                    DatabaseNode.Users.avatar.rawValue: helpAndSupport.avatar,
                                    //DatabaseNode.Users.userId.rawValue:self.curUser.user_id,
            //DatabaseNode.Users.isDelete.rawValue:false,
            DatabaseNode.Users.mobile.rawValue: helpAndSupport.phone_no,
            DatabaseNode.Users.countryCode.rawValue: helpAndSupport.country_code,
            //DatabaseNode.Users.deviceType.rawValue: "2",
            DatabaseNode.Users.deviceToken.rawValue: deviceToken
        ]

        DatabaseReference.child(DatabaseNode.Root.users.rawValue).child(helpAndSupport.user_id).setValue(user) { (error, _) in
            if let err = error {
                CommonClass.showToast(msg: err.localizedDescription)
            }
        }
        //self.updateDeviceToken(deviceToken, self.curUser.user_id)
    }

    /*********************
     Updating the device token
     **********************/
    static func updateDeviceToken(_ deviceToken: String, _ userId: String) {
        
        guard !deviceToken.isEmpty else { return }
        guard !userId.isEmpty else { return }
        DatabaseReference.child(DatabaseNode.Root.users.rawValue).child(userId).updateChildValues([DatabaseNode.Users.deviceToken.rawValue:deviceToken])
    }
    
    /*********************
     Deleting the user
     **********************/
    /*
    static func deleteUser(_ userId: String){
        
        guard !userId.isEmpty else { return }
        
        DatabaseReference.child(DatabaseNode.Root.users.rawValue).child(userId).child(DatabaseNode.Users.isDelete.rawValue).setValue(true)
    }
    */
    
    /*********************
     returning the messageid
     **********************/
    static func getMessageId(forRoom roomId: String) -> String {
        
        let messageId = DatabaseReference.child(DatabaseNode.Root.messages.rawValue).child(roomId).childByAutoId().key
        
        return messageId
    }
    
    /*********************
     returning the roomid
     **********************/
    static func getRoomId() -> String {
        
        let roomId = DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).childByAutoId().key
        
        return roomId
    }
    
    /*********************
     Checking for user exist or not
     **********************/
    static func checkUserExists(_ userId: String, _ curUserId: String ,_ completion: @escaping ( _ exists: Bool, _ roomId: String?)->()){
        
        guard !userId.isEmpty else { return }
        guard !curUserId.isEmpty else { return }
        
        DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(curUserId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? [String:Any], let roomId = value[userId] as? String{
                
                completion(true,roomId)
                
            }else{
                
                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(userId).observeSingleEvent(of: .value, with: { (snap) in
                    
                    if let value = snap.value as? [String:Any], let roomId = value[curUserId] as? String{
                        
                        completion(true,roomId)
                        
                    }else{
                        
                        completion(false, nil)
                    }
                })
            }
        })
    }
    
    /*********************
     Checking for exixtence of room
     **********************/
    static func checkRoomExists(_ postId: String, _ userId: String ,_ completion: @escaping ( _ exists: Bool, _ roomId: String?)->()){
        
        DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(self.curUserId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? [String:Any], let roomId = value[postId] as? String{
                
                completion(true,roomId)
                
            }else{
                
                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(userId).observeSingleEvent(of: .value, with: { (snap) in
                    
                    if let value = snap.value as? [String:Any], let roomId = value[postId] as? String{
                        
                        completion(true,roomId)
                        
                    }else{
                        
                        completion(false, nil)
                    }
                })
            }
        })
    }
    
    /*********************
     getting the message dictinary from message object
     **********************/
    private static func getMessageDict(_ chatMessage: ChatMessage) -> JSONDictionary {
        
        var message = JSONDictionary()
        
        message[Message.type.rawValue] = chatMessage.type.rawValue.uppercased()
        message[Message.message.rawValue] = chatMessage.message
        message[Message.sender.rawValue] = chatMessage.senderId
        message[Message.status.rawValue] = chatMessage.status.rawValue
        message[Message.mediaUrl.rawValue] = chatMessage.mediaUrl
        message[Message.thumbnail.rawValue] = chatMessage.thumbnail
        message[Message.caption.rawValue] = chatMessage.caption
        message[Message.color.rawValue] = chatMessage.color
        message[Message.isBlock.rawValue] = chatMessage.isBlock
        message[Message.timestamp.rawValue] = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        message[Message.messageId.rawValue] = chatMessage.messageId
        message[Message.duration.rawValue] = chatMessage.duration
        
        return message
    }
    
    /*********************
     Sending the message in room
     **********************/
    static func sendMessage(_ chatMessage: ChatMessage, _ roomId: String, _ node: DatabaseNode.Root) {
        
        guard !roomId.isEmpty else { return }
        let message: JSONDictionary = getMessageDict(chatMessage)

        switch node {
            
        case .messages:
            DatabaseReference.child(node.rawValue).child(roomId).child(chatMessage.messageId).setValue(message)
            
        case .lastMessage:
            DatabaseReference.child(node.rawValue).child(roomId).setValue(message)
            
        default:
            return
        }
    }

    static func createMessageInfo(messageId: String, users: [UserUpdates]) {
        guard !messageId.isEmpty else { return }
        for user in users {
            let status: DeliveryStatus
            if user.id == curUserId {
                status = .read
            } else {
                status = .sent
            }
            DatabaseReference.child(DatabaseNode.Root.messageInfo.rawValue).child(messageId).child(user.id).setValue(status.rawValue)
        }
    }
    
    /*********************
     Setting the group left message
     **********************/
    static func setGroupLeftLastMessage(_ chatMessage: ChatMessage, _ roomId: String) {
        
        guard !roomId.isEmpty else { return }
        
        let message: [String:Any] = getMessageDict(chatMessage)
        
        DatabaseReference.child(DatabaseNode.Root.lastMessage.rawValue).child(roomId).child(self.curUserId).child(DatabaseNode.LastMessage.chatLastMessage.rawValue).setValue(message)
    }
    
    /*********************
     Setting the last user update
     **********************/
    static func setUserLastUpdates(_ roomId: String, _ userId: String) {
        
        guard !roomId.isEmpty else { return }
        guard !userId.isEmpty else { return }
        
        /*userId: Current user id*/
        
        let timeStamp = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.lastUpdates.rawValue).child(userId).setValue(timeStamp)
        
    }
    /*********************
     Setting the last update for room
     **********************/
    static func setLastUpdates( roomId: String,  userId: String) {
        
        guard !roomId.isEmpty else { return }
        guard !userId.isEmpty else { return }
        
        /*userId: Current user id*/
        
        let timeStamp = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.lastUpdate.rawValue).setValue(timeStamp)
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.lastUpdates.rawValue).child(userId).setValue(timeStamp)
        
    }
    /*********************
     starting the new chat
     **********************/
    static func startNewChat(_ groupMembers: [ChatMember], info: ChatRoomInfo) -> String {
        let chatType: ChatType
        if groupMembers.count == 1 {
            chatType = .single
        } else {
            chatType = .group
        }
        return createRoomInfo(groupMembers, chatType, info: info)
    }
    
    /*********************
     Creating the room info
     **********************/
    private static func createRoomInfo(_ groupMembers: [ChatMember], _ chatType: ChatType, info: ChatRoomInfo) -> String {
        
        let roomId = getRoomId()
        let firebaseTimeStamp = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        
        let roomInfoReference = DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId)

        roomInfoReference.child(DatabaseNode.RoomInfo.chatPic.rawValue).setValue(info.chatPic)
        roomInfoReference.child(DatabaseNode.RoomInfo.chatTitle.rawValue).setValue(info.chatTitle)
        roomInfoReference.child(DatabaseNode.RoomInfo.chatType.rawValue).setValue(chatType.rawValue)
        roomInfoReference.child(DatabaseNode.RoomInfo.lastUpdate.rawValue).setValue(firebaseTimeStamp)
        roomInfoReference.child(DatabaseNode.RoomInfo.roomId.rawValue).setValue(roomId)
        
        for eachContact in groupMembers {
            roomInfoReference.child(DatabaseNode.RoomInfo.lastUpdates.rawValue).child(eachContact.userId).setValue(0)
        }
        
        createRoom(roomId, groupMembers, chatType)
        return roomId
    }
    
    /*********************
     Creating the room for group chat
     **********************/
    private static func createRoom(_ roomId: String, _ groupMembers: [ChatMember],_  chatType: ChatType) {
        
        guard !roomId.isEmpty else { return }
        guard groupMembers.count > 0 else { print("Empty group members");return }
        
        let timeStamp = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        var unusedChatColors: [String] = []

        var randomColor: String {
            if unusedChatColors.isEmpty {
                unusedChatColors = chatColors
            }
            let randomIndex = Int(arc4random_uniform(UInt32(unusedChatColors.count)))
            let color = unusedChatColors[randomIndex]
            unusedChatColors.remove(at: randomIndex)
            return color
        }
        
        for participant in groupMembers {
            
            var room = JSONDictionary()
            room[DatabaseNode.Rooms.memberId.rawValue] = participant.userId
            room[DatabaseNode.Rooms.memberJoin.rawValue] = timeStamp
            room[DatabaseNode.Rooms.memberDelete.rawValue] = timeStamp
            room[DatabaseNode.Rooms.memberLeave.rawValue] = 0
            room[DatabaseNode.Rooms.roomAdmin.rawValue] = 0
            room[DatabaseNode.Rooms.memberColor.rawValue] = randomColor
            
            DatabaseReference.child(DatabaseNode.Root.rooms.rawValue).child(roomId).child(participant.userId).setValue(room)
        }
        
        var room = JSONDictionary()
        room[DatabaseNode.Rooms.memberId.rawValue] = self.curUserId
        room[DatabaseNode.Rooms.memberJoin.rawValue] = timeStamp
        room[DatabaseNode.Rooms.memberDelete.rawValue] = timeStamp
        room[DatabaseNode.Rooms.memberLeave.rawValue] = 0
        room[DatabaseNode.Rooms.roomAdmin.rawValue] = 1
        room[DatabaseNode.Rooms.memberColor.rawValue] = randomColor
        
        DatabaseReference.child(DatabaseNode.Root.rooms.rawValue).child(roomId).child(self.curUserId).setValue(room)
        createInbox(roomId, groupMembers, chatType)
    }
    
    /*********************
     Creating the inbox for group chat
     **********************/
    static func createInbox(_ roomId: String, _ groupMembers: [ChatMember],_  chatType: ChatType) {
        
        guard !roomId.isEmpty else { return }
        
        if chatType == .single {
            
            guard !groupMembers.isEmpty else {
                
                print_debug("FirebaseHelper CreateInbox :\(groupMembers.count)")
                return
            }
            
            DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(groupMembers[0].userId).child(self.curUserId).setValue(roomId)
            
            DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(self.curUserId).child(groupMembers[0].userId).setValue(roomId)
            
        } else {
            
            for eachContact in groupMembers {
                
                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(eachContact.userId).child(roomId).setValue(roomId)
            }
            
            DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(self.curUserId).child(roomId).setValue(roomId)
        }
    }
    
    /*********************
     Creating the inbox for post
     **********************/
    static func createInboxForPost(_ key: String, _ roomId: String, _ groupMembers: [ChatMember],_  chatType: ChatType) {
        
        guard !roomId.isEmpty else { return }
        
        guard groupMembers.count > 0 else {
            
            print("FirebaseHelper CreateInbox :\(groupMembers.count)")
            return
        }
        
        DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(groupMembers[0].userId).child(key).setValue(roomId)
        
        DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(self.curUserId).child(key).setValue(roomId)
        
    }
    
    /*********************
     Getting the old messages by passing the roomid and delete time
     **********************/
    static  func getOldMessages(_ roomId: String, _ deleteStamp: Int) {
        
        let firebaseTimeStamp = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)
        
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.lastUpdates.rawValue).child(self.curUserId).setValue(firebaseTimeStamp)
        
        DatabaseReference.child(DatabaseNode.Root.rooms.rawValue).child(roomId).child(self.curUserId).child(DatabaseNode.Rooms.memberDelete.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value{
                
                let deletestamp = JSON(value).intValue
                //getLast25Messages(roomId, deletestamp: deletestamp)
            }
        })
    }
    
    
    /*********************
     Getting the room info info by passing the roomid
     **********************/
    static func getRoomInfo(_ roomId: String, completion: @escaping (_ roomInfo: ChatRoomInfo)->()) {
        
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value {
                
                print_debug(value)
                let roomInfo = ChatRoomInfo(with: JSON(value))
                completion(roomInfo)
            }
        })
    }
    
    /*********************
     Getting the chat member info by passing the userid
     **********************/
    static func getChatMemberInfo(_ userId: String, _ completion: @escaping (_ member:ChatMember?)->()) {
        
        guard !userId.isEmpty else { return }
        
        
        DatabaseReference.child(DatabaseNode.Root.users.rawValue).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value {
                
                do {
                    let memberData = try JSON(value).rawData()
                    
                    let member = try JSONDecoder().decode(ChatMember.self, from: memberData)
                    completion(member)
                } catch let error {
                    print(error.localizedDescription)
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        })
    }

    static func getExistingMembers(roomId: String, completion: @escaping ([RoomMember]) -> Void) {
        DatabaseReference.child(DatabaseNode.Root.rooms.rawValue).child(roomId).observeSingleEvent(of: .value) { (snapshot) in

            guard let value = snapshot.value else {
                return
            }
            let json = JSON(value)
            let members = RoomMember.models(from: json.arrayValue)
            completion(members)
        }
    }
    
    /*********************
     Adding the user in group chat by passing the roomid
     **********************/
    static func addNewMembers(newMembers: [ChatMember], to roomId: String ) {

        guard !roomId.isEmpty else { return }

        getExistingMembers(roomId: roomId) { members in

            let usedColors = Set(members.map({$0.chatColor}))
            var unusedChatColors = Array(Set(chatColors).symmetricDifference(usedColors))

            var randomColor: String {
                if unusedChatColors.isEmpty {
                    unusedChatColors = chatColors
                }
                let randomIndex = Int(arc4random_uniform(UInt32(unusedChatColors.count)))
                let color = unusedChatColors[randomIndex]
                unusedChatColors.remove(at: randomIndex)
                return color
            }

            let timeStamp = ServerValue.timestamp() //(Date().timeIntervalSince1970 * 1000)

            for eachMember in newMembers {

                DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.lastUpdates.rawValue).child(eachMember.userId).setValue(0)

                var room = JSONDictionary()
                room[DatabaseNode.Rooms.memberId.rawValue] = eachMember.userId
                room[DatabaseNode.Rooms.memberJoin.rawValue] = timeStamp
                room[DatabaseNode.Rooms.memberDelete.rawValue] = timeStamp
                room[DatabaseNode.Rooms.memberLeave.rawValue] = 0
                room[DatabaseNode.Rooms.memberColor.rawValue] = randomColor

                DatabaseReference.child(DatabaseNode.Root.rooms.rawValue).child(roomId).child(eachMember.userId).setValue(room)
                DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(eachMember.userId).child(roomId).setValue(roomId)
                DatabaseReference.child(DatabaseNode.Root.lastMessage.rawValue).child(roomId).child(eachMember.userId).removeValue()
                DatabaseReference.child(DatabaseNode.Root.lastMessage.rawValue).child(roomId).child(eachMember.userId).removeValue()

                //            sendTextMessage(eachMember.userId, type: .added, {_,_ in
                //                print_Debug("sent")
                //            })
            }
            //createInbox(roomId, groupMembers, chatType)
        }
    }

    /*********************
     getting the user detail by passing the userid
     **********************/
    static func getUserDetail(_ userId: String, completion: @escaping (_ chatMember: ChatMember?)->()) {
        
        guard !userId.isEmpty else { return }
        
        DatabaseReference.child(DatabaseNode.Root.users.rawValue).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in

            guard let value = snapshot.value as? JSONDictionary else {
                return
            }
            print_debug(value)
            let memberJSON = JSON(value)
            let member = ChatMember(with: memberJSON)
            completion(member)
        })
    }
    /*********************
     getting the messages as pagination
     **********************/
    static func getPaginatedData(_ roomId: String, _ lastKey: String, _ deleteStamp: Double, _ completion: @escaping (_ messages: [ChatMessage]) -> ()) {
        
        DatabaseReference.child(DatabaseNode.Root.messages.rawValue).child(roomId).queryOrderedByKey().queryEnding(atValue: lastKey).queryLimited(toLast: 25).observeSingleEvent(of: .value, with: { (snapshot) in

            guard let value = snapshot.value as? JSONDictionary else {
                return
            }
            
            print_debug(value)
            var messages: [ChatMessage] = []

            for (_, val) in value {

                let json = JSON(val)
                let msg = ChatMessage(with: json)

                guard msg.messageId != lastKey && msg.timeStamp > deleteStamp else {
                    continue
                }

                if msg.senderId != self.curUserId && msg.isBlock {
                    print_debug("Blocked")

                } else {
                    messages.append(msg)
                }
            }
            completion(messages)
        })
    }
    /*********************
     Blocking the user by passing the userid and roomid
     **********************/
    static func blockUser(_ userId: String, _ roomId: String,_ message: ChatMessage) {
        
        var lastMessage = JSONDictionary()
        
        lastMessage[Message.messageId.rawValue] = message.messageId
        lastMessage[Message.message.rawValue] = message.message
        lastMessage[Message.timestamp.rawValue] = message.timeStamp
        lastMessage[Message.sender.rawValue] = message.senderId
        lastMessage[Message.status.rawValue] = message.status.rawValue
        lastMessage[Message.type.rawValue] = message.type.rawValue
        lastMessage[Message.isBlock.rawValue] = message.isBlock
        
        DatabaseReference.child(DatabaseNode.Root.lastMessage.rawValue).child(roomId).child(self.curUserId).child(DatabaseNode.LastMessage.chatLastMessage.rawValue).setValue(lastMessage)
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.isTyping.rawValue).child(self.curUserId).setValue(false)
        
        DatabaseReference.child(DatabaseNode.Root.block.rawValue).child(self.curUserId).child(userId).setValue(ServerValue.timestamp()) //(Date().timeIntervalSince1970 * 1000)
        
    }
    /*********************
     Blocking the user from anywhere in app by passing the userid
     **********************/
    static func blockUserFromAnywhere(_ userId: String){
        
        self.checkUserExists(userId, self.curUserId) { (exists, roomId) in
            
            if exists{
                
                self.getLastMessage(userId, roomId!, completion: { (lastMessage) in
                    
                    if let lastMessage = lastMessage{
                        self.blockUser(userId, roomId!, lastMessage)
                    }
                })
                
            }else{
                DatabaseReference.child(DatabaseNode.Root.block.rawValue).child(self.curUserId).child(userId).setValue(ServerValue.timestamp()) //(Date().timeIntervalSince1970 * 1000)
            }
        }
    }
    
    /*********************
     Reporting the user by passing the userid
     **********************/
    static func reportUser(_ userId: String){
        
        self.checkUserExists(userId, self.curUserId) { (exists, roomId) in
            
            if exists{
                
                self.getLastMessage(userId, roomId!, completion: { (lastMessage) in
                    if let lastMessage = lastMessage{
                        self.blockUser(userId, roomId!, lastMessage)
                    }
                })
            }
            DatabaseReference.child(DatabaseNode.Root.report.rawValue).child(self.curUserId).child(userId).setValue(ServerValue.timestamp()) //(Date().timeIntervalSince1970 * 1000)
        }
        
    }
    
    /*********************
     Blocking the user by passing the userid and roomid
     **********************/
    static func blockUser(_ userId: String, _ roomId: String, inbox message: Inbox){
        
        var lastMessage: [String:Any] = [:]

        /*
        lastMessage[Message.messageId.rawValue] = message.messageId
        lastMessage[Message.message.rawValue] = message.message
        lastMessage[Message.timestamp.rawValue] = message.timeStamp
        lastMessage[Message.sender.rawValue] = message.senderId
        lastMessage[Message.status.rawValue] = message.status.rawValue
        */
        lastMessage[Message.type.rawValue] = message.type.rawValue
        lastMessage[Message.isBlock.rawValue] = 0
        
        DatabaseReference.child(DatabaseNode.Root.lastMessage.rawValue).child(roomId).child(self.curUserId).child(DatabaseNode.LastMessage.chatLastMessage.rawValue).setValue(lastMessage)
        DatabaseReference.child(DatabaseNode.Root.roomInfo.rawValue).child(roomId).child(DatabaseNode.RoomInfo.isTyping.rawValue).child(self.curUserId).setValue(false)
        
        DatabaseReference.child(DatabaseNode.Root.block.rawValue).child(self.curUserId).child(userId).setValue(ServerValue.timestamp()) //(Date().timeIntervalSince1970 * 1000)
        
    }
    
    /*********************
     Getting the last message for user by passing the userid and roomid
     **********************/
    static func getLastMessage(_ userId: String, _ roomId: String, completion: @escaping (_ lastMessage: ChatMessage?)->()){
        
        guard !roomId.isEmpty else { return }
        
        DatabaseReference.child(DatabaseNode.Root.lastMessage.rawValue).child(roomId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let value = snapshot.value as? [String:Any]{
                
                if snapshot.hasChild(self.curUserId){
                    
                    if let userLastMessageDict = value[self.curUserId] as? [String:Any]{
                        
                        let lastMsg = JSON(userLastMessageDict)
                        
                        let chatLastMsg = ChatMessage.getMessage(from: lastMsg)
                        
                        completion(chatLastMsg)
                    }
                    
                }else{
                    
                    let chatLastMsg = ChatMessage.getMessage(from: JSON(value))
                    completion(chatLastMsg)
                }
            }
        })
    }

    /*********************
     setting the message info status
     **********************/
    static func setMessageInfoStatus(_ message: ChatMessage, status: DeliveryStatus) {
        let userId = AppDelegate.shared.currentuser.user_id

        guard message.status != .read,
            message.status != status,
            !message.messageId.isEmpty,
            !message.isBlock,
            !userId.isEmpty else { return }

        DatabaseReference.child(DatabaseNode.Root.messageInfo.rawValue).child(message.messageId).child(userId).setValue(status.rawValue)
    }
    
    /*********************
     setting the message read status
     **********************/
    static func setMessageStatus(_ message: ChatMessage, roomId: String, status: DeliveryStatus) {
        let userId = AppDelegate.shared.currentuser.user_id

        guard message.status != .read,
            message.status != status,
            !message.messageId.isEmpty,
            !roomId.isEmpty,
            !message.isBlock,
            !userId.isEmpty else {
                return
        }

        DatabaseReference.child(DatabaseNode.Root.messages.rawValue).child(roomId).child(message.messageId).child(DatabaseNode.Messages.status.rawValue).setValue(status.rawValue)

        DatabaseReference.child(DatabaseNode.Root.lastMessage.rawValue).child(roomId).child(DatabaseNode.Messages.status.rawValue).setValue(status.rawValue)
    }
    
    /*********************
     logout the user session
     **********************/
    static func logOut() {
        
        do{
            try Auth.auth().signOut()
        } catch let error {
            print_debug(error)
        }
    }
    /*********************
     updating the password for user
     **********************/
    static func updateUserPassword(password: String, completion: @escaping (Bool)->()) {
        Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
            
            if error == nil{
                completion(true)
            } else {
                completion(false)
            }
        })
        
        
        
    }
    
    /*********************
     sending the password on email
     **********************/
    static func resendPassword(email: String,  completion: @escaping (Bool)->()) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil{
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
//Get Unread Messages count
//=======================================
extension FirebaseHelper {

    /*********************
     setting observer for getting the unread message count for inbox
     **********************/
    static func getUnreadMessageCount() {
        
        _inboxObserver["un_inbox"] = DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(self.curUserId).observe(.childAdded, with: { (snapshot) in
            
            if let value = snapshot.value as? String{
                
                
                msgCount = [:]
                self.getDeleteStamp(value)
            }
            
        })
        
        _inboxObserver["un_inbox_del"] = DatabaseReference.child(DatabaseNode.Root.inbox.rawValue).child(self.curUserId).observe(.childRemoved, with: { (snapshot) in
            
            if let value = snapshot.value as? String{
                
                msgCount = [:]
                self.getDeleteStamp(value)
                
            }
            
        })
    }
    
    
    /*********************
     Getting the delete time stamp
     **********************/
    private static func getDeleteStamp(_ roomId: String) {
        
        guard !roomId.isEmpty, !DatabaseNode.Root.rooms.rawValue.isEmpty,!self.curUserId.isEmpty,!DatabaseNode.Rooms.memberDelete.rawValue.isEmpty else { return }
        
        DatabaseReference.child(DatabaseNode.Root.rooms.rawValue).child(roomId).child(self.curUserId).child(DatabaseNode.Rooms.memberDelete.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value{
                
                let deletestamp = JSON(value).intValue
                self.getLeaveStamp(roomId, deleteStamp: deletestamp)
            }
        })
        
    }
    
    /*********************
     Getting the leave time stamp
     **********************/
    private static func getLeaveStamp(_ roomId: String, deleteStamp: Int) {
        
        guard !roomId.isEmpty,!DatabaseNode.Root.rooms.rawValue.isEmpty,!self.curUserId.isEmpty,!DatabaseNode.Rooms.memberLeave.rawValue.isEmpty else { return }
        
        DatabaseReference.child(DatabaseNode.Root.rooms.rawValue).child(roomId).child(self.curUserId).child(DatabaseNode.Rooms.memberLeave.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value {
                
                let leavestamp = JSON(value).intValue
                //self.getCount(roomId, deleteStamp: deleteStamp,leaveStamp: leavestamp)
            }
        })
    }
}
