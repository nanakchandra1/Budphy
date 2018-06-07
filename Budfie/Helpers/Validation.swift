//
//  Validation.swift
//  DemoApp
//
//  Created by Mohd Sultan on 15/09/17.
//  Copyright © 2017 Mohd Sultan. All rights reserved.
//

import Foundation

class Validation {
    class func blankField(name: String) -> Bool {
        
        if name.count == 0 {
            return false
        } else {
            return true
        }
    }
    
    class func validateEmail(_ email : String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if email.count == 0 {
            return false
        } else if !emailTest.evaluate(with: email) {
            return false
        } else {
            return true
        }
    }
    
    class func validateUsername(_ username : String) -> Bool {
        let usernameRegEx = "[A-Z0-9a-z]{6,12}"
        let usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        
        if username.count == 0 {
            return false
        } else if !usernameTest.evaluate(with: username) {
            return false
        } else {
            return true
        }
    }
    
    class func validatePassword(_ password : String) -> Bool {
        let passwordRegEx = "^(?=.*[!@#\\$%\\^&\\*])(?=.*[0-9])(.{6,12})$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        if password.count == 0 {
            return false
        } else if !passwordTest.evaluate(with: password) {
            return false
        }else {
            return true
        }
    }
    
    class func validateName(_ name : String) -> Bool {
        let nameRegEx = "^[a-zA-Z]{3,}(?: [a-zA-Z]+){0,2}$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        if name.count == 0 {
            return false
        } else if !nameTest.evaluate(with: name) {
            return false
        }else {
            return true
        }
    }
    
    class func validatePhoneNo(_ phoneNo : String) -> Bool {
        let phoneNoRegEx = "[1-9][0-9]{8,14}"
        let phoneNoTest = NSPredicate(format:"SELF MATCHES %@", phoneNoRegEx)
        if phoneNo.count <= 9 {
            
            return false
        } else if !phoneNoTest.evaluate(with: phoneNo) {
            print_debug("Phone number not valid")
            return false
        }else {
            return true
        }
    }
}
