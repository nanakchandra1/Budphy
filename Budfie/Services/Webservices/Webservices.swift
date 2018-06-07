//
//  Webservices.swift
//  StarterProj
//
//  Created by Gurdeep on 16/12/16.
//  Copyright © 2016 Gurdeep. All rights reserved.
//

import Foundation
import SwiftyJSON


enum WebServices { }

extension NSError {
    
    convenience init(localizedDescription : String) {
        
        self.init(domain: "AppNetworkingError",
                  code: 0,
                  userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
    
    convenience init(code : Int, localizedDescription : String) {
        
        self.init(domain: "AppNetworkingError",
                  code: code,
                  userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
    
}



extension WebServices {

    static func refreshToken(token : String,
                             loader : Bool = false,
                             success : @escaping () -> Void,
                             failure : @escaping (Error) -> Void) {

        guard AppDelegate.shared.currentuser != nil else {
            return
        }

        let parameters: JSONDictionary = ["method": "refresh_device_token",
                                          "access_token": AppDelegate.shared.currentuser.access_token,
                                          "device_token": token,
                                          "device_type": 2]

        print_debug("")
        print_debug("==============REFRESH DEVICE TOKEN=============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.refreshToken)")
        print_debug(parameters)
        print_debug("===========================================")
        print_debug("")

        AppNetworking.POST(endPoint: WebServices.EndPoint.refreshToken, parameters: parameters, loader: loader, success: { (json : JSON) in

            let code = json["CODE"].intValue
            WebServices.handleInvalidUser(withCode: code)
        }) { (error) in

            CommonClass.showToast(msg: error.localizedDescription)
            failure(error)
        }
    }
    
    //MARK:- GET GIFTING LIST
    //=======================
    static func getGiftingList(parameters : JSONDictionary,
                               loader : Bool = true,
                               success : @escaping (Bool, [GiftingListModel]) -> Void,
                               failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("==============GET GIFTING LIST=============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.gift)")
        print_debug(parameters)
        print_debug("===========================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.gift, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            var model = [GiftingListModel]()
            
            for temp in json["VALUE"]["gifts"].arrayValue {
                model.append(GiftingListModel(initWithGiftList: temp))
            }
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                
                success(true, model)
            } else {
                
                success(false, model)
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- NOTIFICATION ON OFF
    //==========================
    static func notificationOnOff(parameters : JSONDictionary,
                                  loader : Bool = true,
                                  success : @escaping (Bool) -> Void,
                                  failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("============NOTIFICATION ON OFF============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.notificationStatus)")
        print_debug(parameters)
        print_debug("===========================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.notificationStatus, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                success(true)
            } else {
                
                success(false)
            }
        }) { (error) in
            
            CommonClass.showToast(msg: error.localizedDescription)
            failure(error)
        }
    }


    //MARK:- PROFILE VISIBILITY ON OFF
    //==========================
    static func profileVisibilityOnOff(parameters : JSONDictionary,
                                  loader : Bool = true,
                                  success : @escaping (Bool) -> Void,
                                  failure : @escaping (Error) -> Void) {

        print_debug("")
        print_debug("============PROFILE VISIBILITY ON OFF============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.profileVisibility)")
        print_debug(parameters)
        print_debug("===========================================")
        print_debug("")

        AppNetworking.POST(endPoint: WebServices.EndPoint.profileVisibility, parameters: parameters, loader: loader, success: { (json : JSON) in

            let code = json["CODE"].intValue

            WebServices.handleInvalidUser(withCode: code)

            if code == WSStatusCode.SUCCESS.rawValue {

                success(true)
            } else {

                success(false)
            }
        }) { (error) in

            CommonClass.showToast(msg: error.localizedDescription)
            failure(error)
        }
    }
    
    
    //MARK:- GET NOTIFICATION LIST
    //============================
    static func getNotificationList(parameters : JSONDictionary,
                                    loader : Bool = true,
                                    success : @escaping (Bool, [NotificationListModel]) -> Void,
                                    failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("============GET NOTIFICATION LIST==========")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.notification)")
        print_debug(parameters)
        print_debug("===========================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.notification, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            var model = [NotificationListModel]()
            
            for temp in json["VALUE"].arrayValue {
                model.append(NotificationListModel(initWithNotificationList: temp))
            }
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                success(true, model)
            } else {
                
                success(false, model)
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- DELETE NOTIFICATION
    //==========================
    static func deleteNotification(parameters : JSONDictionary,
                                  loader : Bool = true,
                                  success : @escaping (Bool) -> Void,
                                  failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("============DELETE NOTIFICATION============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.notification)")
        print_debug(parameters)
        print_debug("===========================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.notification, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                success(true)
            } else {
                
                success(false)
            }
        }) { (error) in
            
            CommonClass.showToast(msg: error.localizedDescription)
            failure(error)
        }
    }
    
    
    //MARK:- DELETE REMINDER
    //======================
    static func deleteReminder(parameters : JSONDictionary,
                                   loader : Bool = true,
                                   success : @escaping (Bool) -> Void,
                                   failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("==============DELETE REMINDER==============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.deleteReminder)")
        print_debug(parameters)
        print_debug("===========================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.deleteReminder, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                success(true)
            } else {
                
                success(false)
            }
        }) { (error) in
            
            CommonClass.showToast(msg: error.localizedDescription)
            failure(error)
        }
    }
    
    
    //MARK:- READ NOTIFICATION
    //========================
    static func readNotification(parameters : JSONDictionary,
                                 loader : Bool = false,
                                 success : @escaping (Bool) -> Void,
                                 failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("=============READ NOTIFICATION=============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.notificationRead)")
        print_debug(parameters)
        print_debug("===========================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.notificationRead, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                success(true)
            } else {
                
                success(false)
            }
        }) { (error) in
            
            CommonClass.showToast(msg: error.localizedDescription)
            failure(error)
        }
    }
    
    
    //MARK:- QUICK REMINDER
    //=====================
    static func quickReminder(parameters : JSONDictionary,
                                  loader : Bool = true,
                                  success : @escaping (Bool) -> Void,
                                  failure : @escaping (Error) -> Void) {
        

        let endpoint: WebServices.EndPoint
        print_debug("")

        if parameters["reminder_id"] == nil {
            endpoint = WebServices.EndPoint.createReminder
            print_debug("===============QUICK REMINDER==============")
            print_debug("\(BASE_URL)\(endpoint)")
        } else {
            endpoint = WebServices.EndPoint.editReminder
            print_debug("===============EDIT QUICK REMINDER==============")
            print_debug("\(BASE_URL)\(endpoint)")
        }
        print_debug(parameters)
        print_debug("===========================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: endpoint, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                success(true)
            } else {
                
                success(false)
            }
        }) { (error) in
            
            CommonClass.showToast(msg: error.localizedDescription)
            failure(error)
        }
    }

    static func reverseGeocode(parameters: JSONDictionary,
                               success : @escaping (Place) -> Void,
                               failure : @escaping (Error) -> Void) {

        let url = WebServices.EndPoint.googleReverseGeocode

        print_debug("")
        print_debug("=============READ NOTIFICATION=============")
        print_debug(url)
        print_debug(parameters)
        print_debug("===========================================")
        print_debug("")

        AppNetworking.GET(endPoint: url, parameters: parameters, loader: true, success: { json in

            if let placeJSON = json["results"].arrayValue.first {
                let place = Place(googleJSON: placeJSON)
                success(place)
            }

        }, failure: { error in
            failure(error)
        })
    }
}

