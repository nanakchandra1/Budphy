//
//  UserModel.swift
//  ContactSyncing
//
//  Created by yogesh singh negi on 08/09/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ContactModel {

    let code        : String
    let id          : String
    let name        : String
    let phone       : String
    let image       : String
    let isBlocked   : Bool
    
    convenience init(name: String, code: String, phone: String) {
        let json = JSON(["first_name": name, "code": code, "phone": phone])
        self.init(with: json)
    }
    
    init(with json: JSON) {

        code            = json["country_code"].stringValue
        id              = json["friend_id"].stringValue
        image           = json["image"].stringValue

        if let firstName = json["first_name"].string {
            if let lastName = json["last_name"].string {
                name    = "\(firstName) \(lastName)"
            } else {
                name    = firstName
            }
        } else {
            name = ""
        }

        phone           = json["phone_no"].stringValue
        isBlocked       = json["block_status"].boolValue
    }
    
}
