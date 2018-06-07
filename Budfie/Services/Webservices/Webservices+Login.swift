//
//  Webservices+Login.swift
//  Budfie
//
//  Created by appinventiv on 29/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

extension WebServices {
    
    //MARK:- SOCIAL CHECK
    //===================
    static func socialCheck(parameters : JSONDictionary,
                            loader : Bool = true,
                            success : @escaping (Bool, String?) -> Void,
                            failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("===============SOCIAL CHECK=================")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.signup)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.signup, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                if let data = json["VALUE"]["userDetails"].dictionaryObject {
                    UserDetails.saveUserData(dic: data)
                }

                if let data = json["VALUE"]["helpSupportDetails"].dictionaryObject {
                    UserDetails.saveSupportData(dic: data)
                }
                
                AppDelegate.shared.helpSupport = UserDetails(initForLoginData: json["VALUE"]["helpSupportDetails"])
                
                let user = UserDetails(initForLoginData: json["VALUE"]["userDetails"])
                AppDelegate.shared.currentuser = user
//                AppUserDefaults.save(value: user.access_token, forKey: AppUserDefaults.Key.Accesstoken)
                
                success(true, nil)
                
            } else if code == WSStatusCode.OTP_NOT_VERIFIED.rawValue {
                success(true, json["VALUE"]["userDetails"]["phone_no"].stringValue)

            } else if code == WSStatusCode.NO_RECORD_FOUND.rawValue {
                success(false, nil)

            } else {
                return
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- LOGIN
    //============
    static func logInAPI(parameters : JSONDictionary,
                         loader : Bool = true,
                         success : @escaping (Bool, UserDetails,_ data:JSONDictionary) -> Void,
                         failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("===================LOGIN====================")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.login)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.login, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            let data = json["VALUE"]["userDetails"].dictionaryObject
            
            AppDelegate.shared.helpSupport = UserDetails(initForLoginData: json["VALUE"]["helpSupportDetails"])
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                success(true, UserDetails(initForLoginData: json["VALUE"]["userDetails"]), data ?? [:])
            } else {
                
                success(false, UserDetails(initForLoginData: json["VALUE"]), [:])
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- SEND OTP
    //===============
    static func sendOtp(parameters : JSONDictionary,
                        loader : Bool = true,
                        success : @escaping (Bool, UserDetails,_ data:JSONDictionary) -> Void,
                        failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("==================SEND OTP=================")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.otp)")
        print_debug(parameters)
        print_debug("===========================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.otp, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)

            if let data = json["VALUE"]["helpSupportDetails"].dictionaryObject {
                UserDetails.saveSupportData(dic: data)
            }
            
            let data = json["VALUE"]["userDetails"].dictionaryObject
            
            AppDelegate.shared.helpSupport = UserDetails(initForLoginData: json["VALUE"]["helpSupportDetails"])
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                success(true, UserDetails(initForLoginData: json["VALUE"]["userDetails"]), data ?? [:])
            } else {
                
                success(false, UserDetails(initForLoginData: json["VALUE"]), [:])
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- RESEND OTP
    //=================
    static func reSendOtp(parameters : JSONDictionary,
                          loader : Bool = true,
                          success : @escaping (Bool) -> Void,
                          failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("================RESEND OTP=================")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.otp)")
        print_debug(parameters)
        print_debug("===========================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.otp, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                success(true)
            } else {
                
                CommonClass.showToast(msg: json["MESSAGE"].stringValue)

                success(false)
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- SEND OTP CHANGE NUMBER
    //===============================
    static func verifyOtpForChangeNumber(parameters : JSONDictionary,
                                         loader : Bool = true,
                                         success : @escaping (Bool) -> Void,
                                         failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("=========RESEND OTP CHANGE NUMBER==========")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.changeNumber)")
        print_debug(parameters)
        print_debug("===========================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.changeNumber, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                CommonClass.showToast(msg: "Phone number has been changed successfully")
                success(true)
            } else {
                
                CommonClass.showToast(msg: json["MESSAGE"].stringValue)
                success(false)
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- CHANGE NUMBER
    //====================
    static func changeNumber(parameters : JSONDictionary,
                             loader : Bool = true,
                             success : @escaping (Bool) -> Void,
                             failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("================CHANGE NUMBER===============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.changeNumber)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.changeNumber, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
//                CommonClass.showToast(msg: json["MESSAGE"].stringValue)
                success(true)
                
            } else if code == WSStatusCode.NUMBER_ALREADY_TAKEN.rawValue {
                
                CommonClass.showToast(msg: json["MESSAGE"].stringValue)
                success(false)
                
            } else {
                
                CommonClass.showToast(msg: json["MESSAGE"].stringValue)
                success(false)
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- LOGOUT
    //=============
    static func logout(parameters : JSONDictionary,
                       loader : Bool = true,
                       success : @escaping (Bool) -> Void,
                       failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("===================LOGOUT==================")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.logout)")
        print_debug(parameters)
        print_debug("===========================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.logout, parameters: parameters, loader: loader, success: { (json : JSON) in
            
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
    
}
