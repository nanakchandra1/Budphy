//
//  StringExtention.swift
//  WoshApp
//
//  Created by Saurabh Shukla on 19/09/17.
//  Copyright © 2017 . All rights reserved.
//


import Foundation
import UIKit

extension String {
    var numberValue: Int {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: self) as? Int ?? -1
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    func parseName() -> (String, String) {
        let components = self.split(separator: " ", maxSplits: 1).map(String.init)
        return (components.first ?? "", components.count > 1 ? components.last! :  "")
    }

    var initials: String {
        let initials = components(separatedBy: " ").reduce("", { (result, string) in
            if result.isEmpty {
                if let char = string.first {
                    return "\(result)\(char)"
                }
                return "\(result)"
            }
            if let resultChar = result.first {
                if let stringChar = string.first {
                    return "\(resultChar)\(stringChar)"
                }
                return "\(resultChar)"
            }
            return ""
        })
        return initials.uppercased()
    }

    var removingHtmlTags: String {
        let removedTags = self.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        let removedOtherContent = removedTags.replacingOccurrences(of: "&[^;]+;", with: "", options: String.CompareOptions.regularExpression, range: nil)
        return removedOtherContent
    }

    public mutating func removeHtmlTags() {
        self = removingHtmlTags
    }
}

extension String {
    
    ///Removes all spaces from the string
    var removeSpaces:String{
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    ///Returns a localized string
    var localized:String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    ///Removes leading and trailing white spaces from the string
    var byRemovingLeadingTrailingWhiteSpaces:String {
        
        let spaceSet = CharacterSet.whitespaces
        return self.trimmingCharacters(in: spaceSet)
    }
    
    ///Returns 'true' if the string is any (file, directory or remote etc) url otherwise returns 'false'
    var isAnyUrl:Bool{
        return (URL(string:self) != nil)
    }
    
    ///Returns the json object if the string can be converted into it, otherwise returns 'nil'
    var jsonObject:Any? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                print_debug(error.localizedDescription)
            }
        }
        return nil
    }
    
    ///Returns the base64Encoded string
    var base64Encoded:String {
        
        return Data(self.utf8).base64EncodedString()
    }
    
    ///Returns the string decoded from base64Encoded string
    var base64Decoded:String? {
        
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    func heightOfText(_ width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func widthOfText(_ height: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.width
    }
    
    func localizedString(lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        print_debug(path)
        let bundle = Bundle(path: path!)
        print_debug(bundle)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    ///Returns 'true' if string contains the substring, otherwise returns 'false'
    func contains(s: String) -> Bool
    {
        return self.range(of: s) != nil ? true : false
    }
    
    ///Replaces occurances of a string with the given another string
    func replace(string: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: string, with: withString, options: String.CompareOptions.literal, range: nil)
    }
    
    ///Converts the string into 'Date' if possible, based on the given date format and timezone. otherwise returns nil
    func toDate(dateFormat: String, timeZone: TimeZone = TimeZone.current) -> Date? {
        
        let frmtr = Date.dateFormatter
        objc_sync_enter(frmtr)
        defer { objc_sync_exit(frmtr) }
        frmtr.locale = Locale(identifier: "en_US_POSIX")
        frmtr.dateFormat = dateFormat
        frmtr.timeZone = timeZone
        return frmtr.date(from: self)
    }
    
    func checkIfValid(_ validityExression : ValidityExression) -> Bool {
        
        let regEx = validityExression.rawValue
        
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        
        return test.evaluate(with: self)
    }
    
    func checkIfInvalid(_ validityExression : ValidityExression) -> Bool {
        
        return !self.checkIfValid(validityExression)
    }
}

extension TimeInterval {
    
    var milliseconds: Int { return Int((truncatingRemainder(dividingBy: 1)) * 1000) }
    var seconds: Int { return Int(self) % 60 }
    var minutes: Int { return (Int(self) / 60 ) % 60 }
    var hours: Int { return (Int(self) / 3600) % 24 }
    var days: Int {return Int(Int(self) / (3600 * 24))}
    
    var stringTime: String {
        if days != 0 {
            return "\(days)d \(hours)h \(minutes)m \(seconds)s"
        } else if hours != 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else if minutes != 0 {
            return "\(minutes)m \(seconds)s"
        } else if milliseconds != 0 {
            return "\(seconds)s \(milliseconds)ms"
        } else {
            return "\(seconds)s"
        }
    }
}

enum ValidityExression : String {
    
    case userName = "^[a-zA-z]{1,}+[a-zA-z0-9!@#$%&*]{2,15}"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,}"
    case mobileNumber = "^[0-9]{6,20}$"
    case password = "^[a-zA-Z0-9!@#$%&*]{6,}"
    case name = "^[a-zA-Z]{2,15}"
    case webUrl = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"

    
    //    case Username = "[a-zA-z]+([ '-][a-zA-Z]+)*$"
    //    case Email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    //    case MobileNumber = "^[0-9]{8,10}$"
    //    case Password = "^[a-zA-Z]{6}"
    //    case Name = "[a-z A-Z]{20}$"
}
