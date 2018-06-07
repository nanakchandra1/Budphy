//
//  Webservices+Greetings.swift
//  Budfie
//
//  Created by Aishwarya Rastogi on 06/02/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import SwiftyJSON

extension WebServices {
    
    
    //MARK:- CREATE GREETING
    //======================
    static func createGreeting(parameters : JSONDictionary,
                               loader : Bool = true,
                               success : @escaping (String) -> Void,
                               failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("===============CREATE GREETING==============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.greeting)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.greeting, parameters: parameters, loader: false, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                success(json["VALUE"].stringValue)
            } else {
                let error = NSError(localizedDescription: json["MESSAGE"].stringValue)
                failure(error)
            }

        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET GREETING DETAILS
    //===========================
    static func getGreetingDetails(parameters : JSONDictionary,
                                   loader : Bool = true,
                                   success : @escaping ([GreetingDetailsModel]) -> Void,
                                   failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("============GET GREETING DETAILS============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.greetingDetails)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.greetingDetails, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            var model = [GreetingDetailsModel]()
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                for value in json["VALUE"].arrayValue {
                    model.append(GreetingDetailsModel(initWithGreetingDetails: value))
                }
                success(model)
            } else {
                success(model)
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET GREETING LIST
    //========================
    static func getGreetingList(parameters : JSONDictionary,
                                loader : Bool = true,
                                success : @escaping ([GreetingListModel]) -> Void,
                                failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("==============GET GREETING LIST=============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.greeting)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.greeting, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            var model = [GreetingListModel]()
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                for value in json["VALUE"].arrayValue {
                    model.append(GreetingListModel(initWithListModel: value))
                }
                
                success(model)
                
            } else {
                success(model)
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }

    static func getGreetingCount(success : @escaping (Int, Int) -> Void,
                               failure : @escaping (Error) -> Void) {

        let parameters: JSONDictionary = ["method": "count",
                                          "access_token": AppDelegate.shared.currentuser.access_token]

        print_debug("")
        print_debug("==============Get Greeting Count=============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.greetingCount)")
        print_debug(parameters)
        print_debug("===========================================")
        print_debug("")

        AppNetworking.GET(endPoint: WebServices.EndPoint.greetingCount, parameters: parameters, loader: false, success: { (json : JSON) in

            let code = json["CODE"].intValue

            WebServices.handleInvalidUser(withCode: code)

            if code == WSStatusCode.SUCCESS.rawValue {
                let sentGreetingCount     = json["VALUE"]["sent_count"].intValue
                let receivedGreetingCount = json["VALUE"]["received_count"].intValue
                success(sentGreetingCount, receivedGreetingCount)
            }

        }, failure: { (error) in

            failure(error)
            print_debug(error)
        })
    }
    
    
    //MARK:- GET GREETING CARDS LIST
    //==============================
    static func getGreetingCardList(parameters : JSONDictionary,
                            loader : Bool = true,
                            success : @escaping (Bool,[NewsListModel]) -> Void,
                            failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("==========GET GREETING CARDS LIST===========")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.greetingCards)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.greetingCards, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                var newsList = [NewsListModel]()
                
                for news in json["VALUE"]["cards"].arrayValue {
                    newsList.append(NewsListModel(initWithNewsList: news))
                }
                success(true,newsList)
            } else {
                success(false, [NewsListModel]())
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- SHARE GREETING
    //=====================
    static func shareGreeting(parameters : JSONDictionary,
                              loader : Bool = true,
                              success : @escaping (Bool) -> Void,
                              failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("===============SHARE GREETING===============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.shareGreeting)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.shareGreeting, parameters: parameters, loader: loader, success: { (json : JSON) in
            
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
    
    
    //MARK:- DELETE GREETING
    //======================
    static func deleteGreeting(parameters : JSONDictionary,
                               loader : Bool = true,
                               success : @escaping (Bool) -> Void,
                               failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("==============DELETE GREETING===============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.deleteGreeting)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.deleteGreeting, parameters: parameters, loader: loader, success: { (json : JSON) in
            
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
