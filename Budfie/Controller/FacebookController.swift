//
//  FacebookController.swift
//  FacebookLogin
//
//  Created by on 10/08/17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Social
import Accounts
import SwiftyJSON

class FacebookController {
    
    // MARK:- VARIABLES
    //==================
    static let shared = FacebookController()
    var facebookAccount: ACAccount?
    var facebookEvnetDict: [[String : Any]] = [[:]]
    
    private init() {}
    
    // MARK:- FACEBOOK LOGIN
    //=========================
    func loginWithFacebook(fromViewController viewController: UIViewController, completion: @escaping FBSDKLoginManagerRequestTokenHandler) {
        
        if let _ = FBSDKAccessToken.current() {
            
            facebookLogout()
            
        }
        
        let permissions = ["user_about_me", "user_birthday", "email", "user_photos", "user_events", "user_friends", "user_videos", "public_profile" ]
        
        let login = FBSDKLoginManager()
        login.loginBehavior = FBSDKLoginBehavior.native
        
        login.logIn(withReadPermissions: permissions, from: viewController, handler: {
            result, error in
            
            if let res = result,res.isCancelled {
                completion(nil,error)
            }else{
                completion(result,error)
            }
            
        })
    }
    
    // MARK:- FACEBOOK LOGIN WITH SHARE PERMISSIONS
    //================================================
    func loginWithSharePermission(fromViewController viewController: UIViewController, completion: @escaping FBSDKLoginManagerRequestTokenHandler) {
        
        if let current = FBSDKAccessToken.current(), current.hasGranted("publish_actions") {
            
            let result = FBSDKLoginManagerLoginResult(token: FBSDKAccessToken.current(), isCancelled: false, grantedPermissions: nil, declinedPermissions: nil)
            
            completion(result,nil)
        } else {
            
            let login = FBSDKLoginManager()
            login.loginBehavior = FBSDKLoginBehavior.native
            
            FBSDKLoginManager().logIn(withPublishPermissions: ["publish_actions"], from: viewController, handler: { (result, error) in
                
                if let res = result,res.isCancelled {
                    completion(nil,error)
                }else{
                    completion(result,error)
                }
            })
        }
    }
    
    // MARK:- GET FACEBOOK USER INFO
    //================================
    func getFacebookUserInfo(fromViewController viewController: UIViewController,
                             success: @escaping ((FacebookModel) -> Void),
                             failure: @escaping ((Error?) -> Void)) {
        
        self.loginWithFacebook(fromViewController: viewController, completion: { (result, error) in
            
            if error == nil,let _ = result?.token {
                self.getInfo(success: { (result) in
                    success(result)
                }, failure: { (e) in
                    failure(e)
                })
                
            }
        })
    }
    
    private func getInfo(success: @escaping ((FacebookModel) -> Void),
                         failure: @escaping ((Error?) -> Void)){
        // FOR MORE PARAMETERS:- https://developers.facebook.com/docs/graph-api/reference/user
        let params = ["fields": "email, name, gender, first_name, last_name, birthday, cover, currency, devices, education, hometown, is_verified, link, locale, location, relationship_status, website, work, picture.type(large)"]
        if let request = FBSDKGraphRequest(graphPath: "me", parameters: params) {
            request.start(completionHandler: {
                connection, result, error in
                
                if let result = result as? [String : Any] {
                    success(FacebookModel(withDictionary: result))
                } else {
                    failure(error)
                }
            })
        }
        
    }
    
    // MARK:- GET IMAGE FROM FACEBOOK
    //=================================
    func getProfilePicFromFacebook(userId:String,_ completionBlock:@escaping (UIImage?)->Void){
        
        guard let url = URL(string:"https://graph.facebook.com/\(userId)/picture?type=large") else {
            return
        }
        let request = SLRequest(forServiceType: SLServiceTypeFacebook, requestMethod: SLRequestMethod.GET, url: url, parameters: nil)
        request?.account = self.facebookAccount
        
        request?.perform(handler: { (responseData: Data?, _, error: Error?) in
            if let data = responseData{
                let userImage=UIImage(data: data)
                completionBlock(userImage)
            }
        })
    }
    
    
    // MARK:- SHARE WITH FACEBOOK
    //=============================
    func shareMessageOnFacebook(withViewController vc : UIViewController,
                                _ message: String,
                                success: @escaping (([String:Any]) -> Void),
                                failure: @escaping ((Error?) -> Void)) {
        
        self.loginWithSharePermission(fromViewController: vc, completion: { (result, error) in
            
            if error == nil,let token = result?.token,let tokenString = token.tokenString {
                let param: [String:Any] = ["message" : message, "access_token" : tokenString]
                
                FBSDKGraphRequest(graphPath: "me/feed", parameters: param, httpMethod: "POST").start(completionHandler: { (connection, result, error) -> Void in
                    if let error = error {
                        failure(error)
                    } else {
                        if let result = result as? [String : Any] {
                            success(result)
                        }else{
                            let err = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Something went wrong"])
                            failure(err)
                        }
                    }
                })
            }else{
                failure(error)
            }
        })
    }
    
    func shareImageWithCaptionOnFacebook(withViewController vc : UIViewController,
                                         _ imageUrl: String,
                                         _ captionText: String,
                                         success: @escaping (([String:Any]) -> Void),
                                         failure: @escaping ((Error?) -> Void)) {
        
        self.loginWithSharePermission(fromViewController: vc, completion: { (result, error) in
            
            if error == nil,let token = result?.token,let tokenString = token.tokenString {
                let param: [String:Any] = [ "url" : imageUrl, "caption" : captionText, "access_token" : tokenString]
                
                FBSDKGraphRequest(graphPath: "me/photos", parameters: param, httpMethod: "POST").start(completionHandler: { (connection, result, error) -> Void in
                    if let error = error {
                        failure(error)
                    } else {
                        if let result = result as? [String : Any] {
                            success(result)
                        }else{
                            let err = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Something went wrong"])
                            failure(err)
                        }
                    }
                })
            }else{
                failure(error)
            }
        })
    }
    
    func shareVideoWithCaptionOnFacebook(withViewController vc : UIViewController,
                                         _ videoUrl: String,
                                         _ captionText: String,
                                         success: @escaping (([String:Any]) -> Void),
                                         failure: @escaping ((Error?) -> Void)) {
        
        self.loginWithSharePermission(fromViewController: vc, completion: { (result, error) in
            
            if error == nil,let token = result?.token,let tokenString = token.tokenString {
                let param: [String:Any] = [ "url" : videoUrl, "caption" : captionText, "access_token" : tokenString]
                
                FBSDKGraphRequest(graphPath: "me/videos", parameters: param, httpMethod: "POST").start(completionHandler: { (connection, result, error) -> Void in
                    if let error = error {
                        failure(error)
                    } else {
                        if let result = result as? [String : Any] {
                            success(result)
                        }else{
                            let err = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Something went wrong"])
                            failure(err)
                        }
                    }
                })
            }else{
                failure(error)
            }
        })
    }
    
    
    // MARK:- FACEBOOK FRIENDS
    //==========================
    func fetchFacebookFriendsUsingThisAPP(withViewController vc: UIViewController,success: @escaping (([String:Any]) -> Void),
                                          failure: @escaping ((Error?) -> Void)){
        
        self.loginWithFacebook(fromViewController: vc, completion: { (result, err) in
            
            self.fetchFriends(success: { (result) in
                
                success(result)
                
            }, failure: { (err) in
                
                failure(err)
                
            })
            
        })
    }
    
    private func fetchFriends(success: @escaping (([String:Any]) -> Void),
                              failure: @escaping ((Error?) -> Void)){
        
        let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields": "email, name, gender, first_name, last_name, birthday, cover, currency, devices, education, hometown, is_verified, link, locale, location, relationship_status, website, work, picture.type(large)"])
        
        request.start { (connection: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
            
            if let result = result as? [String:Any] {
                success(result)
            } else {
                failure(error)
            }
        }
        
    }
    
    func fetchFacebookFriendsNotUsingThisAPP(viewController : UIViewController, success: @escaping (([String:Any]) -> Void),
                                             failure: @escaping ((Error?) -> Void)){
        
        FBSDKLoginManager().logIn(withPublishPermissions: ["taggable_friends"], from: viewController, handler: { (result, error) in
            
            if let res = result,res.isCancelled {
                failure(error)
            }else{
                if error == nil {
                    let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: ["fields": "name"])
                    
                    request.start { (connection: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
                        
                        if let result = result as? [String:Any] {
                            success(result)
                        } else {
                            failure(error)
                        }
                    }
                }else{
                    failure(error)
                }
            }
        })
        
    }
    
    
    //FACEBOOK EVENTS FETCH
    //=====================
    func getFacebookEvents(_ loader:Bool, fromViewController viewController: UIViewController, completion: @escaping ([FacebookEvent]?, Error?) -> Void) {
        
        if FBSDKAccessToken.current() != nil {

            if loader {
                AppNetworking.showLoader()
            }
            
            let request = FBSDKGraphRequest(graphPath: "me/events", parameters: nil, httpMethod: "GET")
            _ = request?.start(completionHandler: { (connection, result, error) in

                if loader {
                    AppNetworking.hideLoader()
                }

                if error == nil,
                    let res = result {

                    let json = JSON(res)
                    print_debug(json)

                    let events = FacebookEvent.models(from: json["data"].arrayValue)
                    completion(events, error)

                } else {
                    completion(nil, error)
                }
                
            })

        } else {
            
            FacebookController.shared.loginWithFacebook(fromViewController: viewController, completion: { (result, error) -> Void in

                if let e = error {
                    completion(nil, e)
                } else if result == nil {
                    let error = NSError(localizedDescription: "Cancelled")
                    completion(nil, error)
                } else if error == nil {
                    self.getFacebookEvents(loader, fromViewController: viewController, completion: completion)
                }
            })
        }
    }
    
    // MARK:- FACEBOOK LOGOUT
    //=========================
    func facebookLogout() {
        FBSDKAccessToken.current()
        FBSDKLoginManager().logOut()
        let cooki  : HTTPCookieStorage! = HTTPCookieStorage.shared
        if let strorage = HTTPCookieStorage.shared.cookies{
            for cookie in strorage{
                cooki.deleteCookie(cookie)
            }
        }
    }
    
}

// MARK: FACEBOOK MODEL
//=======================
struct FacebookModel {

    var dictionary : [String:Any]!
    var id = ""
    var email = ""
    var name = ""
    var first_name = ""
    var last_name = ""
    var currency = ""
    var link = ""
    var gender = ""
    var verified = ""
    var cover: URL?
    var picture: URL?
    var is_verified : Bool
    
    //    init(withJSON json: JSON) {
    //        self.id = json["id"].stringValue
    //        self.name = json["name"].stringValue
    //        self.first_name = json["first_name"].stringValue
    //        self.currency = json["currency"]["user_currency"].stringValue
    //        self.email = json["email"].stringValue
    //        self.gender = json["gender"].stringValue
    //        self.picture = URL(string: json["picture"]["data"]["url"].stringValue)
    //        self.cover = URL(string: json["cover"]["source"].stringValue)
    //        self.link = json["link"].stringValue
    //        self.last_name = json["last_name"].stringValue
    //        self.is_verified = json["is_verified"].stringValue
    //    }
    
    init(withDictionary dict: [String:Any]) {
        
//        let json = JSON(dict)
        
        self.dictionary = dict
        
//        self.id             = json["id"].stringValue
//        self.name           = json["name"].stringValue
//        self.first_name     = json["first_name"].stringValue
//        self.last_name      = json["last_name"].stringValue
//        self.email          = json["email"].stringValue
//        self.gender         = json["gender"].stringValue
//        self.picture        = json["picture"]["data"]["url"].stringValue
//
        
        self.id = "\(dict["id"] ?? "")"
        self.name = "\(dict["name"] ?? "")"
        self.first_name = "\(dict["first_name"] ?? "")"
        self.email = "\(dict["email"] ?? "")"
        self.gender = "\(dict["gender"] ?? "")"
        
        if let currencyDict = dict["currency"] as? [String:Any] {
            
            self.currency = "\(currencyDict["user_currency"] ?? "")"
            
        }
        if let picture = dict["picture"] as? [String:Any],let data = picture["data"] as? [String:Any] {
            
            self.picture = URL(string: "\(data["url"] ?? "")")
            
        }
        if let cover = dict["cover"] as? [String:Any] {
            
            self.cover = URL(string: "\(cover["source"] ?? "")")
            
        }
        self.link = "\(dict["link"] ?? "")"
        self.last_name = "\(dict["last_name"] ?? "")"
        self.is_verified = "\(dict["is_verified"] ?? "")" == "0" ? false : true
        
    }
    
}

/*   //RESPONSE - JSON
{
    "name" : "Yogesh Singh Negi",
    "email" : "yogeshnegi33@gmail.com",
    "gender" : "male",
    "devices" : [
    {
    "os" : "Android"
    }
    ],
    "locale" : "en_GB",
    "picture" : {
        "data" : {
            "height" : 200,
            "is_silhouette" : false,
            "url" : "https:\/\/scontent.xx.fbcdn.net\/v\/t1.0-1\/c0.29.200.200\/p200x200\/26239161_1523519271070889_6266295206697384784_n.jpg?oh=59fda2f474e2695f019379ef69dd2596&oe=5AF15234",
            "width" : 200
        }
    },
    "link" : "https:\/\/www.facebook.com\/app_scoped_user_id\/1487976991291784\/",
    "last_name" : "Negi",
    "id" : "1487976991291784",
    "currency" : {
        "currency_offset" : 100,
        "user_currency" : "INR",
        "usd_exchange" : 0.015434099999999999,
        "usd_exchange_inverse" : 64.791597825599993
    },
    "first_name" : "Yogesh",
    "is_verified" : false,
    "cover" : {
        "offset_x" : 0,
        "source" : "https:\/\/scontent.xx.fbcdn.net\/v\/t31.0-0\/p180x540\/12794695_932178523538303_3550168321831691686_o.jpg?oh=407355d901c410e75856761ba00d2521&oe=5ADB4B64",
        "id" : "932178523538303",
        "offset_y" : 50
    }
}
*/

//RESPONSE - JSONDICTION
/*
 
["name": Yogesh Singh Negi, "email": yogeshnegi33@gmail.com, "gender": male, "devices": <__NSSingleObjectArrayI 0x60000001d1a0>(
    {
    os = Android;
    }
    )
    , "locale": en_GB, "picture": {
        data =     {
            height = 200;
            "is_silhouette" = 0;
            url = "https://scontent.xx.fbcdn.net/v/t1.0-1/c0.29.200.200/p200x200/26239161_1523519271070889_6266295206697384784_n.jpg?oh=59fda2f474e2695f019379ef69dd2596&oe=5AF15234";
            width = 200;
        };
    }, "link": https://www.facebook.com/app_scoped_user_id/1487976991291784/, "last_name": Negi, "id": 1487976991291784, "currency": {
    "currency_offset" = 100;
    "usd_exchange" = "0.0154341";
    "usd_exchange_inverse" = "64.79159782559999";
    "user_currency" = INR;
}, "first_name": Yogesh, "is_verified": 0, "cover": {
    id = 932178523538303;
    "offset_x" = 0;
    "offset_y" = 50;
    source = "https://scontent.xx.fbcdn.net/v/t31.0-0/p180x540/12794695_932178523538303_3550168321831691686_o.jpg?oh=407355d901c410e75856761ba00d2521&oe=5ADB4B64";
}]

*/

class FacebookEvent {
    let id          : String
    let name        : String
    let status      : String
    let startTime   : String
    let endTime     : String

    init(with json: JSON) {
        id          = json["id"].stringValue
        name        = json["name"].stringValue
        status      = json["rsvp_status"].stringValue
        startTime   = json["start_time"].stringValue
        endTime     = json["end_time"].stringValue
    }

    final class func models(from jsonArray: [JSON]) -> [FacebookEvent] {
        var events: [FacebookEvent] = []
        for json in jsonArray {
            let event = FacebookEvent(with: json)
            events.append(event)
            EventsCoreDataController.saveToLocalDB(facebookEvent: event)
        }
        return events
    }
}

