//
//  Webservices+Profile.swift
//  Budfie
//
//  Created by appinventiv on 29/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

extension WebServices {
    
    //MARK:- GET INTEREST LIST
    //========================
    static func getInterestList(parameters : JSONDictionary,
                                loader : Bool = true,
                                success : @escaping (Bool,[InterestListModel],[SubCategoryModel]) -> Void,
                                failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("=============GET INTEREST LIST==============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.interest)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.interest, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            var obInterestListModel = [InterestListModel]()
            var selectedIntertestModel = [SubCategoryModel]()
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                for temp in json["VALUE"]["all_interest"].arrayValue {
                    obInterestListModel.append(InterestListModel(initForInterestList: temp))
                }
                
                for temp in json["VALUE"]["users_interest"].arrayValue {
                    selectedIntertestModel.append(SubCategoryModel(initForSubCategory: temp))
                }
                success(true, obInterestListModel, selectedIntertestModel)
            } else {
                success(false, obInterestListModel, selectedIntertestModel)
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- UPDATE PROFILE
    //=====================
    static func updateProfile(parameters : JSONDictionary,
                              loader : Bool = true,
                              success : @escaping (Bool) -> Void,
                              failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("==============UPDATE PROFILE================")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.profile)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.profile, parameters: parameters, loader: loader, success: { (json : JSON) in
            
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
    
    
    //MARK:- GET USER PROFILE DATA
    //============================
    static func getUserProfile(parameters : JSONDictionary,
                               loader : Bool = true,
                               success : @escaping (ProfileDataModel) -> Void,
                               failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("==========GET USER PROFILE DATA=============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.profile)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.profile, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                let obProfileDataModel = ProfileDataModel(initForProfileData: json["VALUE"])
                success(obProfileDataModel)
            }

        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- ADD NEW INTERESTS
    //========================
    static func addInterest(parameters : JSONDictionary,
                            loader : Bool = true,
                            success : @escaping (Bool) -> Void,
                            failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("============ADD NEW INTERESTS===============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.interest)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.interest, parameters: parameters, loader: loader, success: { (json : JSON) in
            
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
    
    
    //MARK:- GET FRIENDS PROFILE DATA
    //===============================
    static func getFriendsDetails(parameters : JSONDictionary,
                                  loader : Bool = true,
                                  success : @escaping (Int, ProfileDataModel?) -> Void,
                                  failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("=========GET FRIENDS PROFILE DATA===========")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.otherUser)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.otherUser, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                let obProfileDataModel = ProfileDataModel(initForProfileData: json["VALUE"])
                success(code, obProfileDataModel)
                
            } else if code == WSStatusCode.BLOCKED_BY_USER.rawValue {
                CommonClass.showToast(msg: json["MESSAGE"].stringValue)
                success(code, nil)
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- BLOCK-UNBLOCK USER
    //=========================
    static func blockUnBlock(parameters : JSONDictionary,
                             loader : Bool = true,
                             success : @escaping (Bool) -> Void,
                             failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("============BLOCK-UNBLOCK USER==============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.block)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.block, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                CommonClass.showToast(msg: json["MESSAGE"].stringValue)
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
    
    
    //MARK:- GET BLOCKED USERS LIST
    //=============================
    static func getBlockedUserList(parameters : JSONDictionary,
                                   loader : Bool = true,
                                   success : @escaping ([FriendListModel]) -> Void,
                                   failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("===========GET BLOCKED USERS LIST===========")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.block)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.block, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                var obFriendListModel = [FriendListModel]()
                
                for temp in json["VALUE"].arrayValue {
                    obFriendListModel.append(FriendListModel(initForFriendList: temp))
                }
                success(obFriendListModel)
            } else {
                success([FriendListModel]())
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
}
