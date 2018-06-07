//
//  UserModel.swift
//  Onboarding
//
//  Created by Gurdeep Singh on 08/07/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import SwiftyJSON

enum Gender : String {
    
    case Male = "M",Female = "F" ,Other = "O"
    
    var indexOfGender : Int {
        
        switch self {
            
        case .Male :
            return 0
        case .Female :
            return 1
        case .Other :
            return 2
            
        }
    }
    
    var stringValueOfGender : String {
        
        switch self {
            
        case .Male :
            return StringConstants.Male.localized
        case .Female :
            return StringConstants.Female.localized
        case .Other :
            return StringConstants.Other.localized
            
        }
    }
    
    static let  allOption : [Gender] = [.Male,.Female,.Other]
    
}


class User {
    
    var first_name : String = ""
    var middle_name : String = ""
    var last_name : String = ""
    var username : String = ""
    var email : String = ""
    var gender : Gender?
    var dob : Date?
    var phone : String = ""
    var password : String = ""
    var confirm_password : String = ""
    var city : String = ""
    var country_code : String = ""
    var region : String = ""
    var longitude : String = ""
    var latitude : String = ""
    var postal_code : String = ""
    var biography : String = ""
    var imageUrl : String = ""
    var image : UIImage?
    var responseString : String?
    var user_id : String?
    
    init(){}
    
    init(dictionary : [String:Any]) {
        
        self.populate(dictionary)
        
    }
    
    init(json : JSON) {
        
        let dictionary = json.dictionaryObject ?? [String:AnyObject]()
        
        self.populate(dictionary)
        
    }
    
    fileprivate func populate(_ dictionary : JSONDictionary) {
        
        let json = JSON(dictionary)
        
        //password
        self.username = json["username"].stringValue
        self.first_name = json["first_name"].stringValue
        self.middle_name = json["middle_name"].stringValue
        self.last_name = json["last_name"].stringValue
        self.biography = json["biography"].stringValue
        self.phone = json["phone"].stringValue
        self.imageUrl = json["image"].stringValue
        self.email = json["email"].stringValue
        self.password = json["password"].stringValue
        self.confirm_password = json["confirm_password"].stringValue
        self.user_id = json["user_id"].stringValue

        
        if let gender = json["gender"].string,!gender.isEmpty{
            let g = gender.uppercased()
            self.gender = Gender.init(rawValue: g)
        }
        
        if let dobUNIXtimeStamp = json["dob"].double{
            
            let dob = Date(timeIntervalSince1970: dobUNIXtimeStamp)
            self.dob = dob
        }
        
        self.city = json["city"].stringValue
        self.region = json["region"].stringValue
        self.country_code = json["country_code"].stringValue
        
    }
    
    func dictionary() -> [String:Any]{
        
        var details = [String:Any]()
        
        details["first_name"] = first_name
        details["middle_name"] = middle_name
        details["last_name"] = last_name
        details["username"] = username
        details["email"] = email
        details["user_id"] = user_id

        if let gender = self.gender {
            details["gender"] = gender.rawValue
        }
        
        details["dob"] = dob?.toString(dateFormat: "MM/dd/yyyy")
        details["phone"] = phone
        details["password"] = password
        details["confirm_password"] = confirm_password
        details["city"] = city
        details["country_code"] = country_code
        details["region"] = region
        details["longitude"] = longitude
        details["latitude"] = latitude
        details["postal_code"] = postal_code
        details["biography"] = biography
        
        return details
    }
    
    
    var checkValidity : CredentialsValidity {
        
        // Comment out the check you want to skip
        
        
        if !first_name.isEmpty {
            if first_name.count<3 {
                //last name must be 3 character long
                return .invalid(StringConstants.First_Name_Invalid_Length.localized)
            }
            
            if first_name.checkIfInvalid(ValidityExression.name) {
                
                return .invalid(StringConstants.Invalid_First_Name.localized)
                
            }
        } else {
            
            return .invalid(StringConstants.Enter_First_Name.localized)
            
        }
        
        
        if !middle_name.isEmpty {
            
            if middle_name.checkIfInvalid(ValidityExression.name) {
                
                return .invalid(StringConstants.Invalid_Middle_Name.localized)
            }
        } else {
            
            return .invalid(StringConstants.Enter_Middle_Name.localized)
            
        }
        
        
        
        if !last_name.isEmpty {
            
            if last_name.checkIfInvalid(ValidityExression.name) {
                
                return .invalid(StringConstants.Invalid_Last_Name.localized)
            }
            
            if last_name.count<3 {
                //last name must be 3 character long
                return .invalid(StringConstants.Last_Name_Invalid_Length.localized)
            }
        } else {
            return .invalid(StringConstants.Enter_Last_Name.localized)
            
        }
        
        
        if !username.isEmpty {
            if username.count<6 {
                //last name must be 3 character long
                return .invalid(StringConstants.User_Name_Invalid_Length.localized)
            }
            
            if username.checkIfInvalid(.userName) {
                
                return .invalid(StringConstants.Invalid_Username.localized)
                
            }
        }
        
        
        if email.isEmpty {
            
            return .invalid(StringConstants.Enter_Email.localized)
            
        } else {
            if email.checkIfInvalid(.email) {
                
                return .invalid(StringConstants.Invalid_Email.localized)
            }
        }
        
        if let d_o_b = self.dob {
            
            if d_o_b.calculateAge() < 18 {
                
                return .invalid(StringConstants.Minimum_Age_limit.localized)
                
            } else if d_o_b.calculateAge() > 130 {
                
                return .invalid(StringConstants.Maximum_Age_limit.localized)
                
            } else {
                
            }
        }
        
        
        
        if !phone.isEmpty {
            if phone.checkIfInvalid(ValidityExression.mobileNumber) {
                
                return .invalid(StringConstants.Invalid_Phone.localized)
                
            }
        } else {
            
            return .invalid(StringConstants.Enter_Mobile.localized)
            
        }
        
        
        if !self.password.isEmpty {
            
            if password.checkIfInvalid(ValidityExression.password) {
                
                return .invalid(StringConstants.Invalid_Password.localized)
            }
        } else {
            
            return .invalid(StringConstants.Enter_Password.localized)
        }
        
        
        
        if !self.confirm_password.isEmpty {
            
            if !self.password.isEmpty {
                
                if password != confirm_password {
                    return .invalid(StringConstants.Confirm_Password_Wrong.localized)
                }
                
            } else {
                return .invalid(StringConstants.Enter_Password.localized)
            }
            
        } else {
            
            return .invalid(StringConstants.Enter_Confirm_Password.localized)
        }
        
        
        if !city.isEmpty {
            
            if city.checkIfInvalid(ValidityExression.name) {
                
                return .invalid(StringConstants.Invalid_City_Name.localized)
            }
            
            if city.count<3 {
                //last name must be 3 character long
                return .invalid(StringConstants.City_Name_Invalid_Length.localized)
            }
            
        } else {
            return .invalid(StringConstants.Enter_City_name.localized)
            
        }
        
        if !country_code.isEmpty {
            
        } else {
            
            return .invalid(StringConstants.Enter_Country_code.localized)
            
        }

        if !region.isEmpty {
            
            if region.checkIfInvalid(ValidityExression.name) {
                
                return .invalid(StringConstants.Invalid_Region_Name.localized)
            }
            
            if region.count<3 {
                //last name must be 3 character long
                return .invalid(StringConstants.Region_Name_Invalid_Length.localized)
            }
            
        } else {
            
            return .invalid(StringConstants.Enter_Region_name.localized)
            
        }
        
        
        if !biography.isEmpty {
            
            if biography.count<3 {
                //last name must be 3 character long
                return .invalid(StringConstants.Biography_Invalid_Length.localized)
            }
            
        } else {
            return .invalid(StringConstants.Enter_Biography.localized)
            
        }
        
        
        return .valid
    }
        
}

extension User: Swift.CustomStringConvertible, Swift.CustomDebugStringConvertible {
    
    var description: String {
        
        var str = "<User : \(Unmanaged.passUnretained(self).toOpaque())> {"
        
        str.append("username : \(username), ")
        str.append("emailId : \(email)")
        
        str.append("}")
        return str
    }
    
    var debugDescription: String {
        return description
    }
}
