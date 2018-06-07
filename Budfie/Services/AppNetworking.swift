//
//  AppNetworking.swift
//  StarterProj
//
//  Created by Gurdeep on 16/12/16.
//  Copyright © 2016 Gurdeep. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

typealias JSONDictionary = [String: Any]
typealias JSONDictionaryArray = [JSONDictionary]
typealias SuccessResponse = (_ json: JSON) -> ()
typealias FailureResponse = (Error) -> (Void)
//typealias UserControllerSuccess = (_ user: User) -> ()

class Connectivity {
    class var isConnectedToInternet: Bool {
        if let reachabilityManager = NetworkReachabilityManager() {
            return reachabilityManager.isReachable
        }
        return false
    }
}

extension Notification.Name {
    
    static let NotConnectedToInternet    = Notification.Name("NotConnectedToInternet")
    static let ValueChangedOfEditProfile = Notification.Name("ValueChangedOfEditProfile")
    static let InterestUpdated           = Notification.Name("InterestUpdated")
    static let EventAdded                = Notification.Name("EventAdded")
    static let GetFriendId               = Notification.Name("GetFriendId")
    static let DidChooseDate             = Notification.Name("DidChooseDate")
    static let DidEditGreeting           = Notification.Name("DidEditGreeting")
}

enum AppNetworking {
    
    //    static let USER = "admin"
    //    static let PASSWORD = "mypass"
    //    static let REALM = "8AC74BD0018D507238924D65D0184E93"
    //    static let NONCE = "12345"
    //    static let QOP = "auth"
    //    static let NONCE_COUNT = "12345"
    //    static let CNONCE = "123"
    
    static let username = "admin"
    static let password = "12345"
    fileprivate static var alamofireManager: SessionManager!
    
    static func configureAlamofire() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 40 // seconds
        configuration.timeoutIntervalForResource = 40
        self.alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }

    static func cancelAllRequests() {
        alamofireManager?.session.getAllTasks { (tasks) in
            tasks.forEach{ $0.cancel() }
        }
    }
    
    static func POST(endPoint : WebServices.EndPoint,
                     parameters : JSONDictionary = [:],
                     headers : HTTPHeaders = [:],
                     loader : Bool = true,
                     success : @escaping (JSON) -> Void,
                     failure : @escaping (Error) -> Void) {
        
        
        request(URLString: endPoint.path,
                httpMethod: .post,
                parameters: parameters,
                headers: headers,
                loader: loader,
                success: success,
                failure: failure)
    }
    
    static func POSTWithImage(endPoint : WebServices.EndPoint,
                              parameters : [String : Any] = [:],
                              image : [String:UIImage]? = [:],
                              headers : HTTPHeaders = [:],
                              loader : Bool = true,
                              success : @escaping (JSON) -> Void,
                              failure : @escaping (Error) -> Void) {
        
        upload(URLString: endPoint.path,
               httpMethod: .post,
               parameters: parameters,
               image: image,
               headers: headers,
               loader: loader,
               success: success,
               failure: failure )
    }
    
    
    static func GET(endPoint : WebServices.EndPoint,
                    parameters : JSONDictionary = [:],
                    headers : HTTPHeaders = [:],
                    loader : Bool = true,
                    success : @escaping (JSON) -> Void,
                    failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint.path,
                httpMethod: .get,
                parameters: parameters,
                encoding: URLEncoding.queryString,
                headers: headers,
                loader: loader,
                success: success,
                failure: failure)
    }
    
    
    static func PUT(endPoint : WebServices.EndPoint,
                    parameters : JSONDictionary = [:],
                    headers : HTTPHeaders = [:],
                    loader : Bool = true,
                    success : @escaping (JSON) -> Void,
                    failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint.path,
                httpMethod: .put,
                parameters: parameters,
                headers: headers,
                loader: loader,
                success: success,
                failure: failure)
    }
    
    
    static func DELETE(endPoint : WebServices.EndPoint,
                       parameters : JSONDictionary = [:],
                       headers : HTTPHeaders = [:],
                       loader : Bool = true,
                       success : @escaping (JSON) -> Void,
                       failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint.path,
                httpMethod: .delete,
                parameters: parameters,
                headers: headers,
                loader: loader,
                success: success,
                failure: failure)
    }
    
    
    private static func request(URLString : String,
                                httpMethod : HTTPMethod,
                                parameters : JSONDictionary = [:],
                                encoding: URLEncoding = .httpBody,
                                headers : HTTPHeaders = [:],
                                loader : Bool = true,
                                success : @escaping (JSON) -> Void,
                                failure : @escaping (Error) -> Void) {
        
        if loader { showLoader() }
        
        var header = HTTPHeaders()
        header["Authorization"] = "Basic \(basicTextCode)"
        header["content-type"] = "application/x-www-form-urlencoded"
        
        alamofireManager.request(URLString,
                                 method: httpMethod,
                                 parameters: parameters,
                                 encoding: encoding,
                                 headers: header).responseJSON { (response:DataResponse<Any>) in
                                    
                                    print_debug(headers)
                                    
                                    if loader { hideLoader() }
                                    
                                    let decodedStr = NSString(data: (response.data! as Data), encoding: 4)
                                    
                                    print_debug("responseObject=======\(String(describing: decodedStr))")
                                    
                                    switch(response.result) {
                                        
                                    case .success(let value):
                                        let code = JSON(value)["CODE"].intValue

                                        let expireSessionCodes = [WSStatusCode.DELETED_BY_ADMIN.rawValue,
                                        WSStatusCode.AccessTokenMismatch.rawValue,
                                        WSStatusCode.BLOCKED_BY_ADMIN.rawValue]

                                        if expireSessionCodes.contains(code) && AppDelegate.shared.currentuser != nil  {
                                            CommonClass.showToast(msg: "Your Login Session Expired : Please login again")
                                            AppDelegate.shared.currentuser = nil
                                            AppUserDefaults.removeAllValues()
                                            AppNetworking.cancelAllRequests()
                                            CommonClass.gotoUserDetails()
                                        }
                                        
                                        print_debug(value)
                                        
                                        success(JSON(value))
                                        
                                    case .failure(let e):

                                        if [4, -6006].contains((e as NSError).code) {

                                            let error = NSError(localizedDescription: "Something went wrong, please try again.")
                                            failure(error)
                                            return

                                        } else if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                                            
                                            // Handle Internet Not available UI
                                            if loader { hideLoader() }
                                            
                                            NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                                        }
                                        
                                        failure(e)
                                    }
        }
    }
    
    
    private static func upload(URLString : String,
                               httpMethod : HTTPMethod,
                               parameters : JSONDictionary = [:],
                               image : [String:UIImage]? = [:],
                               headers : HTTPHeaders = [:],
                               loader : Bool = true,
                               success : @escaping (JSON) -> Void,
                               failure : @escaping (Error) -> Void) {
        
        if loader { showLoader() }
        
        var header : HTTPHeaders = ["content-type": "application/x-www-form-urlencoded"]
        
        if JSON(AppDelegate.shared.currentuser.access_token) != JSON.null {
            
            header["Accesstoken"] = AppDelegate.shared.currentuser.access_token
            
        }
        
        let url = try! URLRequest(url: URLString, method: httpMethod, headers: header)
        
        alamofireManager.upload(multipartFormData: { (multipartFormData) in
            if let image = image {
                for (key , value) in image{
                    //                    print_debug("key = \(key) value = \(value)")
                    if let img = UIImageJPEGRepresentation(value, 0.6){
                        //                        print_debug(img)
                        multipartFormData.append(img, withName: key, fileName: "image.jpg", mimeType: "image/jpg")
                    }
                }
            }
            
            for (key , value) in parameters{
                
                multipartFormData.append((value as AnyObject).data(using : String.Encoding.utf8.rawValue)!, withName: key)
            }
        },
                                with: url, encodingCompletion: { encodingResult in
                                    
                                    switch encodingResult{
                                    case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                                        
                                        upload.responseJSON(completionHandler: { (response:DataResponse<Any>) in
                                            
                                            
                                            let decodedStr = NSString(data: (response.data! as Data), encoding: 4)
                                            
                                            
                                            print_debug("responseObject=======\(String(describing: decodedStr))")
                                            switch response.result{
                                            case .success(let value):
                                                if loader { hideLoader() }
                                                
                                                
                                                print_debug(value)
                                                success(JSON(value))
                                                
                                            case .failure(let e):
                                                if loader { hideLoader() }
                                                
                                                
                                                if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                                                    NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                                                }
                                                failure(e)
                                            }
                                        })
                                        
                                    case .failure(let e):
                                        //                if loader { hideLoader() }
                                        
                                        
                                        if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                                            NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                                        }
                                        
                                        failure(e)
                                    }
        })
        
    }
    
    //    private static func getDigestHeader(method : String, uri : String) -> String
    //    {
    //
    //        let a1 = getMD5Hex(md5Data: MD5(string: (USER + ":" + REALM + ":" + PASSWORD)))
    //        let a2 = getMD5Hex(md5Data: MD5(string: (method + ":" + uri)))
    //        let response = getMD5Hex(md5Data: MD5(string: (a1 + ":" + NONCE + ":" + NONCE_COUNT + ":" + CNONCE + ":" + QOP + ":" + a2)))
    //
    //        let digestHeader = "Digest username=\"\(USER)\", realm=\"\(REALM)\", nonce=\"\(NONCE)\", uri=\"\(uri)\", qop=\(QOP), nc=\(NONCE_COUNT), cnonce=\"\(CNONCE)\", response=\"\(response)\", opaque=\"\(12)\""
    //
    //        return digestHeader
    //    }
    //
    //    private static func MD5(string: String) -> Data? {
    //        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil }
    //        var digestData = Data(count: Int(16))
    //
    //        _ = digestData.withUnsafeMutableBytes {digestBytes in
    //            messageData.withUnsafeBytes {messageBytes in
    //                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
    //            }
    //        }
    //
    //        return digestData
    //    }
    //
    //    private static func getMD5Hex(md5Data : Data?) -> String
    //    {
    //        if md5Data == nil
    //        {
    //            return ""
    //        }
    //
    //        return md5Data!.map { String(format: "%02hhx", $0) }.joined()
    //    }
}




