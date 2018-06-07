//
//  Webservices+TimeOut.swift
//  Budfie
//
//  Created by appinventiv on 29/01/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import Foundation
import SwiftyJSON

extension WebServices {
    
    //MARK:- GET MOODS LIST
    //=====================
    static func getMoodsList(parameters : JSONDictionary,
                             loader : Bool = true,
                             success : @escaping (Bool,[Int]) -> Void,
                             failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("================GET MOODS LIST==============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.moodList)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.moodList, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                var moodListArray = [Int]()
                
                for moods in json["VALUE"].arrayValue {
                    moodListArray.append(moods.intValue)
                }
                success(true,moodListArray)
            } else {
                success(false, [Int]())
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET TIME OUT MOVIES
    //==========================
    static func getTimeOutMovies(parameters : JSONDictionary,
                                 loader : Bool = true,
                                 success : @escaping (Bool,[VideosMoviesGifsListModel]) -> Void,
                                 failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("==============GET TIME OUT MOVIES===========")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.timeOutMovies)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.timeOutMovies, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                var commonData = [VideosMoviesGifsListModel]()
                
                for data in json["VALUE"].arrayValue {
                    commonData.append(VideosMoviesGifsListModel(initWithList: data))
                }
                success(true,commonData)
            } else {
                success(false, [VideosMoviesGifsListModel]())
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET GIFS LIST
    //====================
    static func getGifsList(parameters : JSONDictionary,
                            loader : Bool = true,
                            success : @escaping (Bool,[VideosMoviesGifsListModel]) -> Void,
                            failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("================GET GIFS LIST===============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.gifs)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.gifs, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                var commonData = [VideosMoviesGifsListModel]()
                
                for data in json["VALUE"].arrayValue {
                    commonData.append(VideosMoviesGifsListModel(initWithList: data))
                }
                success(true,commonData)
            } else {
                success(false, [VideosMoviesGifsListModel]())
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET VIDEOS LIST
    //======================
    static func getVideosList(parameters : JSONDictionary,
                              loader : Bool = true,
                              success : @escaping (Bool,[VideosMoviesGifsListModel]) -> Void,
                              failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("===============GET VIDEOS LIST==============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.videos)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.videos, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                var commonData = [VideosMoviesGifsListModel]()
                
                for data in json["VALUE"].arrayValue {
                    commonData.append(VideosMoviesGifsListModel(initWithList: data))
                }
                success(true,commonData)
            } else {
                success(false, [VideosMoviesGifsListModel]())
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET NEWS LIST
    //====================
    static func getNewsList(parameters : JSONDictionary,
                            loader : Bool = true,
                            success : @escaping (Bool,[NewsListModel]) -> Void,
                            failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("================GET NEWS LIST===============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.news)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.news, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                var newsList = [NewsListModel]()
                
                for news in json["VALUE"].arrayValue {
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
    
    
    //MARK:- GET GIFS VIDEOS LIST
    //===========================
    static func getGifsVideosList(parameters : JSONDictionary,
                                  loader : Bool = true,
                                  success : @escaping (Bool,[GifsVideosModel]) -> Void,
                                  failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("=============GET GIFS VIDEOS LIST===========")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.clips)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.clips, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            var commonData = [GifsVideosModel]()

            if code == WSStatusCode.SUCCESS.rawValue {
                
                
                for data in json["VALUE"].arrayValue {
                    commonData.append(GifsVideosModel(initWithList: data))
                }
                success(true,commonData)
            } else {
                success(false, commonData)
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET THOUGHTS LIST
    //========================
    static func getThoughtsList(parameters : JSONDictionary,
                                loader : Bool = true,
                                success : @escaping (Bool,[String]) -> Void,
                                failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("==============GET THOUGHTS LIST=============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.thoughts)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.thoughts, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                var newsList = [String]()
                
                for news in json["VALUE"].arrayValue {
                    newsList.append(news["thought"].stringValue)
                }
                success(true,newsList)
            } else {
                success(false, [String]())
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
    //MARK:- GET JOKES LIST
    //=====================
    static func getJokesList(parameters : JSONDictionary,
                             loader : Bool = true,
                             success : @escaping (Bool,[String]) -> Void,
                             failure : @escaping (Error) -> Void) {
        
        print_debug("")
        print_debug("================GET JOKES LIST==============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.jokes)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.jokes, parameters: parameters, loader: loader, success: { (json : JSON) in
            
            let code = json["CODE"].intValue
            
            WebServices.handleInvalidUser(withCode: code)
            
            if code == WSStatusCode.SUCCESS.rawValue {
                
                var newsList = [String]()
                
                for news in json["VALUE"].arrayValue {
                    newsList.append(news["joke"].stringValue)
                }
                success(true,newsList)
            } else {
                success(false, [String]())
            }
        }) { (error) in
            
            failure(error)
            print_debug(error)
        }
    }
    
    
}
