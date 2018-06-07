

import Foundation
import SwiftyJSON
//import ObjectMapper

//TODO : Create enum for status code from services

enum WSStatusCode : Int {
    
    case SUCCESS = 200
    case NO_RECORD_FOUND = 204
    case PARAMETERS_MISSING = 100
    case BLOCKED_BY_ADMIN = 301
    case DELETED_BY_ADMIN = 302
    case FAILURE = 400
    case AccessTokenMismatch = 304
    case NOINTEREST = 209
    case BLOCKED_BY_USER = 305
    case NUMBER_ALREADY_TAKEN = 207
    
    case OTP_NOT_VERIFIED = 201
    
    case SOCIAL_ACCOUNT_NOT_AVALIABLE = 206
    
    case VALIDATIONS = 414
    
    case UNAUTHORISED_ACCESS_TOKEN = 406
    case INACTIVE_ACCOUNT = 415
    case BLOCKED_ACCOUNT = 416
    case ALREADY_REGISTERED_USER = 417

    case EVENT_DELETED = 210
    
    static func isSuccessCode(code : Int) -> Bool {
        
        switch code {
            
        case SUCCESS.rawValue,
             NO_RECORD_FOUND.rawValue,
             SOCIAL_ACCOUNT_NOT_AVALIABLE.rawValue :
            return true
            
        default: return false
            
        }
    }
    
    static func isInvalidUser(code : Int) -> Bool {
        
        switch code {
            
        case INACTIVE_ACCOUNT.rawValue,
             BLOCKED_ACCOUNT.rawValue,
             UNAUTHORISED_ACCESS_TOKEN.rawValue :
            
            return true
            
        default: return false
            
        }
    }
}


extension WebServices {
    
    
    static func pauseAllVideos(){
        
        // guard let home = BkTabBarControllar.sharedInstance.getHomeVC() else { return }
        
    }
    
    static func handleInvalidUser(withCode code: Int) {
        
        //        if WSStatusCode.isInvalidUser(code: code) {
        //
        //            if code == WSStatusCode.UNAUTHORISED_ACCESS_TOKEN.rawValue{
        //
        //                let popupScene = PopupVC.instantiate(fromAppStoryboard: .Main)
        //            popupScene.modalPresentationStyle = .overCurrentContext
        //            popupScene.vcType = .SessionExpire
        //            //popupScene.commonDelegate = self
        //            AppDelegate.shared.window?.rootViewController?.present(popupScene, animated: false, completion: nil)
        //            }
        //
        //            if code != 406 {
        //               // showToastMessage(json["response_message"].stringValue)
        //            }
        //        }
    }
    
    //    static func getHtmlApi(pageType : TypeOfHtmlPage, success : @escaping (String?) -> Void, failure : @escaping (Error) -> Void) {
    //
    //        var url = ""
    //        if pageType == .aboutBK{
    //
    //            url = EndPoint.about.url
    //        }else if pageType == .helpAndSupport{
    //            url = EndPoint.helpAndSupport.url
    //
    //        }else if pageType == .privacyPolicy{
    //            url = EndPoint.privacy.url
    //
    //
    //        }else if pageType == .termsOfService{
    //            url = EndPoint.terms.url
    //
    //
    //        }
    
    //        AppNetworking.GET(endPoint: url, success: { (json) in
    //
    //            print_debug(json)
    //
    //            let code = json["code"].intValue
    //
    //            WebServices.handleInvalidUser(withCode: code)
    //
    //            if code == WSStatusCode.SUCCESS.rawValue {
    //
    //                success(json["response_data"].stringValue)
    //
    //            }else{
    //
    //                let e = NSError(localizedDescription: json["response_message"].string ?? AppMessages.errorMessage)
    //
    //                failure(e)
    //
    //            }
    //
    //        }) { (error) in
    //            failure(error)
    //
    //            print_debug(error)
    //
    //        }
    //
    //    }
    //
    
    
}

//
//// MARK: - Methods
//extension WebServices {
//
//    static func jsonToTypes<T: Mappable>(_ jsonArr: [JSON]) -> [T] {
//
//        var types: [T] = []
//
//        jsonArr.forEach({ (type) in
//
//            if let obj = type.dictionaryObject, let t = T(JSON: obj) {
//                types.append(t)
//            }
//
//        })
//
//        return types
//    }
//
//
//    static func getHistory(parameters : JSONDictionary,loader : Bool ,
//                           allDates:[String]?,
//                           storedData:[String : [HistoryModel]]?,
//                           success : @escaping (_ success : Bool,  [String : [HistoryModel]]?, [String], Int?, Int?) -> Void,
//                           failure : @escaping (Error) -> Void) {
//
//
//        AppNetworking.GET(endPoint: EndPoint.history.url, parameters: parameters, loader: loader, success: { (json) in
//
//            let code = json["code"].intValue
//            WebServices.handleInvalidUser(withCode: code)
//
//            if code == WSStatusCode.SUCCESS.rawValue {
//
//                if let data = json.dictionaryObject{
//
//                    var date_set = [String]()
//                    var total_count = 0
//
//                    if let datesArray = data["date_set"] as? [String] {
//
//                        date_set = datesArray
//                    }
//
//                    if let count = data["total_count"] as? Int{
//
//                        total_count = count
//                    }
//
//                    guard let next_page = data["next_page"] as? Int else{
//
//                        return
//                    }
//
//                    var value : [String : [HistoryModel]] = [:]
//
//                    if let sd = storedData {
//                        value = sd
//                    }
//
//                    if let his = data["response_data"] as? JSONDictionary {
//
//                        for item in date_set {
//
//                            var historyModelArray = [HistoryModel]()
//
//                            if let ar = his[item] as? JSONDictionaryArray {
//
//                                _ =  ar.map({ (element) in
//
//                                    let historyElemrnt = HistoryModel(history: element)
//
//                                    historyModelArray.append(historyElemrnt)
//
//                                })
//
//                            }
//
//                            if (allDates?.contains(item))!{
//
//                                var oldData =  value[item]
//
//                                oldData?.append(contentsOf: historyModelArray)
//
//                                value[item] = oldData
//
//                            }else{
//                                value[item] = historyModelArray
//
//                            }
//
//                        }
//
//                    }
//
//                    success(true, value, date_set,total_count,next_page)
//
//                }else{
//                    success(false,nil, [], 0,nil)
//                }
//
//            }else{
//
//             //   showToastMessage(json["response_message"].stringValue)
//                success(false,nil, [], 0, nil)
//            }
//
//
//        }) { (error) in
//
//            failure(error)
//            print_debug(error.localizedDescription)
//
//        }
//    }
//    static func getNotificationListApi(parameters : JSONDictionary,allDates:[String]?,loader:Bool,storedData:[String : [HistoryModel]]?, success : @escaping (_ success : Bool,  [String : [HistoryModel]]?, [String], Int?,Int?) -> Void, failure : @escaping (Error) -> Void) {
//
//        AppNetworking.GET(endPoint: EndPoint.notificationList
//            .url, parameters: parameters,loader:loader,success: { (json) in
//
//                let code = json["code"].intValue
//
//                WebServices.handleInvalidUser(withCode: code)
//
//                if code == 200{
//
//                    if let data = json.dictionaryObject{
//
//                        var date_set = [String]()
//                        var total_count = 0
//
//                        if let datesArray = data["date_set"] as? [String]{
//
//                            date_set = datesArray
//                        }
//
//                        if let count = data["total_count"] as? Int{
//
//                            total_count = count
//                        }
//
//
//                        guard let next_page = data["next_page"] as? Int else{
//
//                            return
//                        }
//
//                        var value : [String : [HistoryModel]] = [:]
//
//                        if let _ = storedData{
//                            value = storedData!
//
//                        }
//
//                        if let his = data["response_data"] as? JSONDictionary{
//
//                            for item in date_set {
//
//                                var historyModelArray = [HistoryModel]()
//
//
//                                if let ar = his[item] as? JSONDictionaryArray{
//
//
//                                    _ =  ar.map({ (element) in
//
//
//                                        let historyElemrnt = HistoryModel(history: element)
//
//                                        historyModelArray.append(historyElemrnt)
//
//                                    })
//
//                                }
//
//                                if (allDates?.contains(item))!{
//
//                                    var oldData =  value[item]
//
//                                    oldData?.append(contentsOf: historyModelArray)
//
//                                    value[item] = oldData
//
//                                }else{
//                                    value[item] = historyModelArray
//
//                                }
//
//                            }
//
//                        }
//
//                        success(true, value, date_set,total_count,next_page)
//
//                    }else{
//                        success(false,nil, [], 0,nil)
//                    }
//
//                } else{
//
//              //      showToastMessage(json["response_message"].stringValue)
//                    success(false,nil, [], 0, nil)
//                }
//
//        }) { (error) in
//
//            failure(error)
//            print_debug(error.localizedDescription)
//        }
//    }
//
//
//    static func readNotificationListApi(parameters : JSONDictionary,showLoader : Bool, success : @escaping (_ success : Bool) -> Void, failure : @escaping (Error) -> Void) {
//
//        AppNetworking.PUT(endPoint: EndPoint.notificationList
//            .url, parameters: parameters,loader: showLoader,success: { (json) in
//
//                let code = json["code"].intValue
//
//                if code == 200{
//
//                    guard let user =  User.currentUser else { return }
//
//                    user.notificationUnreadCount = user.notificationUnreadCount - 1
//
//                    success(true)
//
//                } else{
//
//                    //showToastMessage(json["response_message"].stringValue)
//                    success(false)
//                }
//        }) { (error) in
//
//            failure(error)
//            print_debug(error.localizedDescription)
//
//        }
//    }
//
//    static func logoutService() {
//
//        let params = [String:String]()
//
//        WebServices.logoutApi(parameters: params, success: { (success) in
//
//            CommonFunctions.afterLogout()
//
//        }) { (error) in
//
//            CommonFunctions.afterLogout()
//
//            print_debug("logout error")
//        }
//    }
//
//    static func deletePostApi(postId :String, Success : @escaping (Bool) -> Void){
//
//        let params = ["post_id" : postId]
//
//        WebServices.deletePost(parameters: params, showLoader:false, success: { (success) in
//
//            Success(success)
//
//        }) { (error) in
//
//            Success(false)
//
//            print_debug(error.localizedDescription)
//        }
//
//    }
//
//}
//
// extension WebServices {
//
//    static func logoutApi(parameters : JSONDictionary, success : @escaping (Bool) -> Void, failure : @escaping (Error) -> Void) {
//
//        AppNetworking.GET(endPoint: EndPoint.logout.url, success: { (json) in
//
//            print_debug(json)
//            success(true)
//        }) { (error) in
//
//            print_debug(error)
//            failure(error)
//        }
//    }
//
//    static func deletePost(parameters : JSONDictionary,showLoader : Bool, success : @escaping (Bool) -> Void, failure : @escaping (Error) -> Void) {
//
//        print_debug(parameters)
//
//        AppNetworking.PUT(endPoint: EndPoint.makePost.url, parameters: parameters,  loader: showLoader, success: { (json) in
//
//            let code = json["code"].intValue
//
//            WebServices.handleInvalidUser(withCode: code)
//
//            if code == WSStatusCode.SUCCESS.rawValue {
//
//                success(true)
//
//            } else {
//
//                //showToastMessage(json["response_message"].stringValue)
//                success(false)
//
//            }
//        }) { (error) in
//
//            failure(error)
//            print_debug(error)
//        }
//
//    }
//
//}

//extension WebServices:CommonProtocol{
//    
//    func okTapped(type: PopupVCType) {
//        
//        WebServices.logoutService()
//
//    }
//    
//    func yesTapped(type: PopupVCType) {
//        
//        
//    }
//    
//    func noTapped(type: PopupVCType) {
//        
//    }
//    
//}

//extension NSError {
//    
//    convenience init(localizedDescription : String) {
//        
//        self.init(domain: "AppNetworkingError", code: 0, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
//    }
//    
//    convenience init(code : Int, localizedDescription : String) {
//        
//        self.init(domain: "AppNetworkingError", code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
//    }
//}

