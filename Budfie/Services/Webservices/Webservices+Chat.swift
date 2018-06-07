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
    static func chatPush(parameters : JSONDictionary) {
        
        print_debug("")
        print_debug("===============CHAT PUSH==============")
        print_debug("\(BASE_URL)\(WebServices.EndPoint.chatPush)")
        print_debug(parameters)
        print_debug("============================================")
        print_debug("")
        
        AppNetworking.POST(endPoint: WebServices.EndPoint.chatPush, parameters: parameters, loader: false, success: { _ in

        }) { _ in

        }
    }
    
}
