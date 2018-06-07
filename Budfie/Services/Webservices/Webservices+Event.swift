//
//  Webservices+Event.swift
//  Budfie
//
//  Created by appinventiv on 29/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

extension WebServices {
    
    //MARK:- CREATE NEW EVENTS
    //========================
    static func createEvent(parameters : JSONDictionary,
                            loader : Bool = true,
                            success : @escaping (TopFriendListModel) -> Void,
                            failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("=============CREATE NEW EVENTS==============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.event)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.event, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                let obTopFriendListModel = TopFriendListModel(initForTopFriendList: json["VALUE"])
                
                success(obTopFriendListModel)
            } else {
                //                CommonClass.showToast(msg: json["MESSAGE"].stringValue)
            }
        }) { (error) in
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET EVENT TYPE
    //=====================
    static func getEventType(parameters : JSONDictionary,
                             loader : Bool = true,
                             success : @escaping ([EventTypesModel]) -> Void,
                             failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("==============GET EVENT TYPE================")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.event)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.event, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                var obEventTypesModel = [EventTypesModel]()
                
                for temp in json["VALUE"].arrayValue {
                    obEventTypesModel.append(EventTypesModel(initForEventType: temp))
                }
                success(obEventTypesModel)
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET EVENT DATES
    //======================
    static func getEventDates(parameters : JSONDictionary,
                              loader : Bool = true,
                              success : @escaping (EventDatesModel) -> Void,
                              failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("==============GET EVENT DATES===============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.eventDates)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.eventDates, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                success(EventDatesModel(initWithDates: json["VALUE"]))
            }
            
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET PERSONAL EVENT
    //=========================
    static func getPersonalEvent(parameters : JSONDictionary,
                                 loader : Bool = true,
                                 success : @escaping (Bool,EventListingModel) -> Void,
                                 failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("=============GET PERSONAL EVENT=============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.personalEvent)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.personalEvent, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                let events = json["VALUE"]
                
                let eventsModel = EventListingModel(initWithEventList: events)
                
                success(true, eventsModel)
            } else {
                success(false, EventListingModel(initWithEventList: JSON.null))
            }
            
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET EVENT DETAILS
    //========================
    static func getEventDetails(parameters : JSONDictionary,
                                loader : Bool = true,
                                success : @escaping (EditEventDetailsModel) -> Void,
                                failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("==============GET EVENT DETAILS=============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.eventDetails)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.eventDetails, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                if let eventDetails = json["VALUE"].dictionary {
                    let obEditEventDetailsModel = EditEventDetailsModel(initForEventModel: JSON(eventDetails))
                    success(obEditEventDetailsModel)
                }
            } else {
                let error = NSError(code: code, localizedDescription: json["MESSAGE"].stringValue)
                failure(error)
            }

        }, failure: { (error) in
            
            failure(error)
            print_debug(error)
        })
    }
    
    
    //MARK:- GET SPORTS DETAILS
    //=========================
    static func getSportDetails(parameters: JSONDictionary,
                                loader : Bool = true,
                                success : @escaping (SportDetail) -> Void,
                                failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("=============GET SPORTS DETAILS=============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.eventDetails)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.eventDetails, parameters: parameters, loader: loader, success: { json in
            
            let code = json["CODE"].intValue
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                if let sportDetail = SportDetail(with: json["VALUE"]["event_details"]) {
                    success(sportDetail)
                }
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET CRICKET DETAILS
    //==========================
    static func getCricketDetails(parameters: JSONDictionary,
                                  loader : Bool = true,
                                  success : @escaping (CricketDetailsModel) -> Void,
                                  failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("=============GET CRICKET DETAILS============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.eventDetails)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.eventDetails, parameters: parameters, loader: loader, success: { json in
            
            let code = json["CODE"].intValue
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {

                let model = CricketDetailsModel(initWithInnings: json["VALUE"]["event_details"])

                if model.match_status == "2" && model.innings.count == 1 {
                    model.innings.append(InningsModel())
                }

                success(model)
            } else {
                CommonClass.showToast(msg: json["MESSAGE"].stringValue)
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET TENNIS DETAILS
    //=========================
    static func getTennisDetails(parameters: JSONDictionary,
                                  loader : Bool = true,
                                  success : @escaping (TennisBadmintonModel) -> Void,
                                  failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("==============GET TENNIS DETAILS============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.eventDetails)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.eventDetails, parameters: parameters, loader: loader, success: { json in
            
            let code = json["CODE"].intValue
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                success(TennisBadmintonModel(initWithModel: json["VALUE"]["event_details"]))
            } else {
                CommonClass.showToast(msg: json["MESSAGE"].stringValue)
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET BADMINTON DETAILS
    //============================
    static func getBadmintonDetails(parameters: JSONDictionary,
                                 loader : Bool = true,
                                 success : @escaping (TennisBadmintonModel) -> Void,
                                 failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("=============GET BADMINTON DETAILS==========")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.eventDetails)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.eventDetails, parameters: parameters, loader: loader, success: { json in
            
            let code = json["CODE"].intValue
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                success(TennisBadmintonModel(initWithModel: json["VALUE"]["event_details"]))
            } else {
                CommonClass.showToast(msg: json["MESSAGE"].stringValue)
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- EDIT EVENT
    //=================
    static func editEvent(parameters : JSONDictionary,
                          loader : Bool = true,
                          success : @escaping (Bool) -> Void,
                          failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("=================EDIT EVENT=================")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.editEvent)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.editEvent, parameters: parameters, loader: loader, success: { (json : JSON) in
            
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

    static func editHolidayPlannerEvent(parameters : JSONDictionary,
                                        loader : Bool = true,
                                        success : @escaping (Bool) -> Void,
                                        failure : @escaping (Error) -> Void) {

        print_debug("")
        print_debug("=================EDIT HOLIDAY PLANNER EVENT=================")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.editHoliday)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")

        AppNetworking.POST(endPoint: WebServices.EndPoint.editHoliday, parameters: parameters, loader: loader, success: { (json : JSON) in

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
    
    
    //MARK:- GET CONCERT DETAILS
    //==========================
    static func getConcert(parameters : JSONDictionary,
                           loader : Bool = true,
                           success : @escaping (Bool,EventListingModel) -> Void,
                           failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("=============GET CONCERT DETAILS============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.concerts)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.concerts, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.NOINTEREST.rawValue {
                
                success(false, EventListingModel(initWithEventList: JSON.null))
                
            } else if code == WSStatusCode.NO_RECORD_FOUND.rawValue || code == WSStatusCode.SUCCESS.rawValue {
                
                let events = json["VALUE"]
                
                if events.isEmpty {
                    success(false, EventListingModel(initWithEventList: JSON.null))
                    
                } else {
                    success(true, EventListingModel(initWithEventList: events))
                }
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET SPORTS DETAILS
    //=========================
    static func getSports(parameters : JSONDictionary,
                          loader : Bool = true,
                          success : @escaping (Bool,EventListingModel) -> Void,
                          failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("==============GET SPORTS DETAILS============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.sports)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.sports, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.NOINTEREST.rawValue {
                
                success(false, EventListingModel(initWithEventList: JSON.null))
                
            } else if code == WSStatusCode.NO_RECORD_FOUND.rawValue || code == WSStatusCode.SUCCESS.rawValue {
                
                let events = json["VALUE"]
                
                if events.isEmpty {
                    success(false, EventListingModel(initWithEventList: JSON.null))
                    
                } else {
                    success(true, EventListingModel(initWithEventList: events))
                }
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET MOVIES DETAILS
    //=========================
    static func getMovies(parameters : JSONDictionary,
                          loader : Bool = true,
                          success : @escaping (Bool,EventListingModel) -> Void,
                          failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("=============GET MOVIES DETAILS============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.movies)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.movies, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.NOINTEREST.rawValue {
                
                success(false, EventListingModel(initWithEventList: JSON.null))
                
            } else if code == WSStatusCode.NO_RECORD_FOUND.rawValue || code == WSStatusCode.SUCCESS.rawValue {
                
                let events = json["VALUE"]
                
                if events.isEmpty {
                    success(false, EventListingModel(initWithEventList: JSON.null))
                    
                } else {
                    success(true, EventListingModel(initWithEventList: events))
                }
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- ADD FAVOURITE
    //====================
    static func addFavourite(parameters : JSONDictionary,
                             loader : Bool = true,
                             success : @escaping (Bool) -> Void,
                             failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("================ADD FAVOURITE===============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.favourite)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.favourite, parameters: parameters, loader: loader, success: { (json : JSON) in
            
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

    //MARK:- DELETE EVENT
    //===================
    static func deleteEvent(parameters : JSONDictionary,
                           loader : Bool = true,
                           success : @escaping (Bool) -> Void,
                           failure : @escaping (Error) -> Void) {

        print_debug("")
        print_debug("=============DELETE EVENT============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.deleteEvent)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")

        AppNetworking.POST(endPoint: WebServices.EndPoint.deleteEvent, parameters: parameters, loader: loader, success: { (json : JSON) in

            let code = json["CODE"].intValue

            WebServices.handleInvalidUser(withCode: code)

            if code == WSStatusCode.SUCCESS.rawValue {
                success(true)
            }

        }) { (error) in

            failure(error)
            print_debug(error)
        }
    }
    
    
}
