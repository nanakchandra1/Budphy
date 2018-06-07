//
//  Webservices+ContactList.swift
//  Budfie
//
//  Created by appinventiv on 29/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

extension WebServices {
    
    //MARK:- CONTACT SYNCING
    //======================
    static func contactSync(parameters : JSONDictionary,
                            loader : Bool = true,
                            success : @escaping (Bool, [ContactModel]) -> Void,
                            failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("==============CONTACT SYNCING===============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.contact)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.contact, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            var contact = [ContactModel]()
            if code == WSStatusCode.SUCCESS.rawValue {
                
                guard let app_users = json["VALUE"]["app_users"].array else {
                    success(false, contact)
                    return
                }
                
                for val in app_users {
                    let model = ContactModel(with: val)
                    contact.append(model)
                }
                
                if let timeStamp = json["VALUE"]["current_time"].string {
                    AppUserDefaults.save(value: timeStamp, forKey: AppUserDefaults.Key.timeStamp)
                }
                
                success(true, contact)

            } else {
                success(false, contact)
            }

        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- NEW FRIEND HIT
    //=====================
    static func newFriendList(parameters : JSONDictionary,
                              loader : Bool = true,
                              success : @escaping (Bool) -> Void,
                              failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("===============NEW FRIEND HIT===============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.contact)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.contact, parameters: parameters, loader: loader, success: { json in

            let code = json["CODE"].intValue
            WebServices.handleInvalidUser(withCode: code)

            var contacts = [ContactModel]()

            if code == WSStatusCode.SUCCESS.rawValue {
                
                guard let appUsers = json["VALUE"]["app_users"].array else{ success(false)
                    return
                }
                
                for val in appUsers {
                    let model = ContactModel(with: val)
                    contacts.append(model)
                }
                
                ContactsController.shared.updateContacts(contacts)
                
                if let timeStamp = json["VALUE"]["current_time"].string {
                    AppUserDefaults.save(value: timeStamp, forKey: AppUserDefaults.Key.timeStamp)
                }
                success(true)
            }

        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET FRIEND LIST
    //======================
    static func getFriendList(parameters : JSONDictionary,
                              loader : Bool = true,
                              success : @escaping ([FriendListModel]) -> Void,
                              failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("==============GET FRIEND LIST===============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.friend)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.friend, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                var obFriendListModel = [FriendListModel]()
                
                for temp in json["VALUE"].arrayValue {
                    obFriendListModel.append(FriendListModel(initForFriendList: temp))
                }
                
                // FILTER UNIQUE DATA
                var friend = [FriendListModel]()
                obFriendListModel.forEach({ (item) in
                    let index = friend.index{ $0.friendId == item.friendId }
                    if (index == nil){
                        friend.append(item)
                    }
                })
                success(friend)
                
            } else if code == WSStatusCode.NO_RECORD_FOUND.rawValue {
                success([FriendListModel]())
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- INVITE FRIENDS
    //=====================
    static func inviteFriends(parameters : JSONDictionary,
                              loader : Bool = true,
                              success : @escaping (Bool) -> Void,
                              failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("===============INVITE FRIENDS===============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.friend)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.friend, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
//            CommonClass.showToast(msg: json["MESSAGE"].stringValue)

            if code == WSStatusCode.SUCCESS.rawValue {
                
                success(true)
            } else {
                
                success(false)
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET PENDING INVITATIONS
    //==============================
    static func getPendingInvites(parameters : JSONDictionary,
                                  loader : Bool = true,
                                  success : @escaping ([InvitationModel]) -> Void,
                                  failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("===========GET PENDING INVITATIONS==========")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.pendingEvents)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.pendingEvents, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            var eventsModel = [InvitationModel]()
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                guard let events = json["VALUE"]["eventArr"].array else{return}
                
                for event in events {
                    eventsModel.append(InvitationModel(initForInviteModel: event))
                }
                
                success(eventsModel)
            } else{
                success(eventsModel)
                //                let msg = json["msg"].stringValue
                //                CommonClass.showToast(msg: msg)
                //            let error = Error(
                
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- ACCEPT OR REJECT
    //=======================
    static func acceptOrReject(parameters : JSONDictionary,
                               loader : Bool = true,
                               success : @escaping (Bool) -> Void,
                               failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("==============ACCEPT OR REJECT==============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.eventInvitation)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.eventInvitation, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                success(true)
            } else {
                
                success(false)
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
}
