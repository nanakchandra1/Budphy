//
//  UserDetails.swift
//  Budfie
//
//  Created by yogesh singh negi on 08/12/17.
//  Copyright © 2017 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserDetails {
    
    var user_id             : String
    var first_name          : String
    var last_name           : String
    var dob                 : String
    var image               : String
    var country_code        : String
    var phone_no            : String
    var access_token        : String
    var profileVisibility   : String
    var social_type         : String
    
    var location            : String
    var lat                 : String
    var long                : String
    
    var has_interest        : Bool
    var avatar              : Int
    var gender              : GenderMF

    var allNotificationStatus           : String
    var sportsNotificationStatus        : String
    var concertsNotificationStatus      : String
    var moviesNotificationStatus        : String
    var birthdayNotificationStatus      : String
    var fortuneCookieNotificationStatus : String
    var invitationNotificationStatus    : String

    /*
    helpSupportArr =         {
    avtar = 0;
    "country_code" = "+91";
    "first_name" = "Help & Support";
    id = 17;
    image = "https://s3.amazonaws.com/appinventiv-development/16/ANDROID/temp1521733072802.jpeg";
    "last_name" = "";
    "phone_no" = 1111111111;
    };
*/
    
    init(initForLoginData json: JSON) {
        
        self.user_id                = json["id"].string ?? json["user_id"].stringValue
        self.first_name             = json["first_name"].stringValue
        self.last_name              = json["last_name"].stringValue
        self.dob                    = json["dob"].stringValue
        self.image                  = json["image"].stringValue
        self.country_code           = json["country_code"].stringValue
        self.phone_no               = json["phone_no"].stringValue
        self.access_token           = json["access_token"].stringValue
        profileVisibility           = json["profile_visibility"].stringValue
        self.social_type            = json["social_type"].stringValue
        
        self.location               = json["location"].stringValue
        self.lat                    = json["latitude"].stringValue
        self.long                   = json["longitude"].stringValue
        
        self.has_interest           = json["has_interest"].boolValue
        self.avatar                 = json["avatar"].intValue
        self.gender                 = GenderMF(rawValue: json["gender"].stringValue) ?? .Custom

        self.allNotificationStatus              = json["notification_status"].stringValue
        self.sportsNotificationStatus           = json["sports_notification_status"].stringValue
        self.concertsNotificationStatus         = json["concerts_notification_status"].stringValue
        self.moviesNotificationStatus           = json["movies_notification_status"].stringValue
        self.birthdayNotificationStatus         = json["birthday_notification_status"].stringValue
        self.fortuneCookieNotificationStatus    = json["fortune_cookie_notification_status"].stringValue
        self.invitationNotificationStatus       = json["invitation_notification_status"].stringValue
    }
    
    static func saveUserData(dic: JSONDictionary) {
        
        var newDict = JSONDictionary()
        for key in dic.keys {
            if let val = dic[key] {
                if !"\(val)".isEmpty {
                    newDict[key] = val
                }
            }
        }
        let userDataDictionary: NSDictionary = NSDictionary(dictionary: newDict)
        AppUserDefaults.save(value: userDataDictionary, forKey: .userData)
    }

    static func saveSupportData(dic: JSONDictionary) {

        var newDict = JSONDictionary()
        for key in dic.keys {
            if let val = dic[key] {
                if !"\(val)".isEmpty {
                    newDict[key] = val
                }
            }
        }
        let userDataDictionary: NSDictionary = NSDictionary(dictionary: newDict)
        AppUserDefaults.save(value: userDataDictionary, forKey: .supportData)
    }
    
    static func profileDataToDic(model: ProfileDataModel) -> JSONDictionary {
        
        var dic = JSONDictionary()
        dic["first_name"]       = model.first_name
        dic["last_name"]        = model.last_name
        dic["dob"]              = model.dob
        dic["image"]            = model.image
        dic["country_code"]     = model.country_code
        dic["phone_no"]         = model.phone_no
        dic["avatar"]           = model.avtar
        dic["gender"]           = model.gender
        dic["location"]         = model.location
        dic["lat"]              = model.lat
        dic["long"]             = model.long
        
        return dic
    }
    
    static func updateUserData(dic:JSONDictionary) {
        
//        var newDict = JSONDictionary()
//
//        if let dic = AppUserDefaults.value(forKey: .userData).dictionaryObject {
//            newDict = dic
//        }
//        for key in dic.keys {
//            if let val = dic[key] {
//                if !"\(val)".isEmpty{
//                    newDict[key] = val
//                }
//            }
//        }
        let userDataDictionary: NSDictionary = NSDictionary(dictionary: dic)
        AppUserDefaults.save(value: userDataDictionary, forKey: .userData)
        
        let user = AppUserDefaults.value(forKey: .userData)
        let json = JSON(user)
        AppDelegate.shared.currentuser = UserDetails(initForLoginData: json)
    }
    
    static func convertModelintoDictionary(user:UserDetails) -> JSONDictionary {
        
        var json                    = [String:Any]()
        json["user_id"]             = user.user_id
        json["first_name"]          = user.first_name
        json["last_name"]           = user.last_name
        json["dob"]                 = user.dob
        json["image"]               = user.image
        json["country_code"]        = user.country_code
        json["phone_no"]            = user.phone_no
        json["access_token"]        = user.access_token
        json["profile_visibility"]  = user.profileVisibility
        json["social_type"]         = user.social_type
        json["has_interest"]        = user.has_interest
        json["avatar"]              = user.avatar
        json["gender"]              = user.gender.rawValue
        json["location"]            = user.location
        json["latitude"]            = user.lat
        json["longitude"]           = user.long

        json["notification_status"]                 = user.allNotificationStatus
        json["sports_notification_status"]          = user.sportsNotificationStatus
        json["concerts_notification_status"]        = user.concertsNotificationStatus
        json["movies_notification_status"]          = user.moviesNotificationStatus
        json["birthday_notification_status"]        = user.birthdayNotificationStatus
        json["fortune_cookie_notification_status"]  = user.fortuneCookieNotificationStatus
        json["invitation_notification_status"]      = user.invitationNotificationStatus

        return json
    }
    
}


//MARK:- Response Type
//====================
/*
 
 VALUE =     {
 "access_token" = OL9FDqAGQTaafvTmOCsWVXiGpCBtdd;
 "country_code" = "+91";
 dob = "04 Nov 2017";
 "first_name" = Yogesh;
 "has_interest" = 0;
 image = "http://budfiedev.applaurels.com/dist/index.html#/Update_profile/index_post6";
 "last_name" = Negi;
 "notification_status" = 0;
 "phone_no" = 8888888888;
 "social_type" = 3;
 "user_id" = 5;
 };
 
 */
/*
{
    APICODERESULT = SUCCESS;
    CODE = 200;
    MESSAGE = "OTP has been verified successfully";
    VALUE =     {
        helpSupportArr =         {
            avtar = 0;
            "country_code" = "+91";
            "first_name" = "Help & Support";
            id = 17;
            image = "https://s3.amazonaws.com/appinventiv-development/16/ANDROID/temp1521733072802.jpeg";
            "last_name" = "";
            "phone_no" = 1111111111;
        };
        userDetails =         {
            "access_token" = kBZodz1xugYeDzD5KOOZAvlEG048up;
            avtar = "";
            "country_code" = "+91";
            dob = "15 Mar 2018";
            "first_name" = Yogesh;
            gender = "";
            "has_interest" = 1;
            image = "";
            "last_name" = "";
            "notification_status" = 2;
            "phone_no" = 8888888888;
            "social_type" = 1;
            "user_id" = 7;
        };
    };
}
*/

